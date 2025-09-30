/**
 * LockFree Object Pool - A high-performance, thread-safe object pool implementation
 * Copyright (©) 2025 Daniel
 * Repository: https://github.com/beats-dh/lockfree
 * License: https://github.com/beats-dh/lockfree/blob/main/LICENSE
 * Contributors: https://github.com/beats-dh/lockfree/graphs/contributors
 */

#pragma once

#include "atomic_queue/atomic_queue.h"
#include "lib/thread/thread_pool.hpp"
#include "parallel_hashmap/phmap.h"

#include <span>
#include <chrono>
#include <memory_resource>
#include <expected>
#include <atomic>
#include <array>
#include <thread>
#include <cstring>
#include <tuple>
#include <type_traits>
#include <algorithm>

#ifdef _MSC_VER
    #pragma warning(push)
    #pragma warning(disable : 4996) // Deprecated functions
    #pragma warning(disable : 4324) // Structure padded due to alignment specifier

    #ifndef LOCKFREE_GNU_ATTRIBUTES_DEFINED
        #define LOCKFREE_GNU_ATTRIBUTES_DEFINED
        #define GNUHOT
        #define GNUCOLD
        #define GNUALWAYSINLINE inline
        #define GNUFLATTEN
        #define GNUNOINLINE __declspec(noinline)
    #endif

    #if _MSC_VER >= 1929
        #define LOCKFREE_NO_UNIQUE_ADDRESS [[msvc::no_unique_address]]
    #else
        #define LOCKFREE_NO_UNIQUE_ADDRESS
    #endif
#else
    #define GNUHOT [[gnu::hot]]
    #define GNUCOLD [[gnu::cold]]
    #define GNUALWAYSINLINE [[gnu::always_inline]] inline
    #define GNUFLATTEN [[gnu::flatten]]
    #define GNUNOINLINE [[gnu::noinline]]

    #if __has_cpp_attribute(no_unique_address) >= 201803L
        #define LOCKFREE_NO_UNIQUE_ADDRESS [[no_unique_address]]
    #else
        #define LOCKFREE_NO_UNIQUE_ADDRESS
    #endif
#endif

#if defined(__AVX2__) || defined(_MSC_VER)
    #include <immintrin.h>
#endif

#ifdef __cpp_lib_hardware_interference_size
constexpr size_t CACHE_LINE_SIZE = std::hardware_destructive_interference_size;
constexpr size_t CACHE_LINE_PADDING = std::hardware_constructive_interference_size;
#else
constexpr size_t CACHE_LINE_SIZE = 64;
constexpr size_t CACHE_LINE_PADDING = 64;
#endif

namespace lockfree_config {
    using namespace std::chrono_literals;
    constexpr size_t DEFAULT_POOL_SIZE = 1024;
    constexpr size_t DEFAULT_LOCAL_CACHE_SIZE = 32;
    constexpr size_t PREWARM_BATCH_SIZE = 32;
    constexpr size_t CLEANUP_BATCH_SIZE = 64;

    constexpr bool is_power_of_two(size_t n) noexcept {
        return n > 0 && (n & (n - 1)) == 0;
    }

    constexpr size_t next_power_of_two(size_t n) noexcept {
        if (n <= 1) return 1;
        --n;
        n |= n >> 1;
        n |= n >> 2;
        n |= n >> 4;
        n |= n >> 8;
        n |= n >> 16;
        if constexpr (sizeof(size_t) > 4) n |= n >> 32;
        return ++n;
    }

    template <size_t Size>
    constexpr size_t adjust_pool_size() noexcept {
        return is_power_of_two(Size) ? Size : next_power_of_two(Size);
    }
}

// ---------- Concepts ----------
template <typename T, typename... Args>
concept HasReset = requires(T t, Args... args) {
    { t.reset(args...) } -> std::same_as<void>;
};

template <typename T, typename... Args>
concept HasBuild = requires(T t, Args... args) {
    { t.build(args...) } -> std::same_as<void>;
};

template <typename T>
concept HasDestroy = requires(T t) {
    { t.destroy() } -> std::same_as<void>;
};

template <typename T>
concept HasThreadId = requires(T t) {
    { static_cast<const decltype(t)&>(t).threadId } -> std::convertible_to<int16_t>;
};

template <typename T>
concept Poolable = std::is_default_constructible_v<T> || HasReset<T> || HasBuild<T>;

// ---------- Error handling ----------
using ErrorHandler = void(*)(const std::exception_ptr&);
inline void default_error_handler(const std::exception_ptr&) noexcept {}
inline ErrorHandler g_error_handler = default_error_handler;
inline void set_error_handler(ErrorHandler handler) noexcept {
    g_error_handler = handler ? handler : default_error_handler;
}

// ---------- PoolError enum ----------
enum class PoolError {
    Shutdown,
    AllocationFailed
};

// ============================================================================
//                               OptimizedObjectPool
// ============================================================================
template <
    typename T,
    size_t PoolSize = lockfree_config::DEFAULT_POOL_SIZE,
    bool EnableStats = false,
    typename Allocator = std::pmr::polymorphic_allocator<T>,
    size_t LocalCacheSize = lockfree_config::DEFAULT_LOCAL_CACHE_SIZE>
class OptimizedObjectPool {
public:
    using pointer = T*;
    using PoolResult = std::expected<pointer, PoolError>;

    // API estática visível
    static constexpr size_t effective_pool_size() noexcept { return AdjustedPoolSize; }
    static constexpr size_t effective_cache_size() noexcept { return AdjustedLocalCacheSize; }

    struct alignas(CACHE_LINE_SIZE) PoolStatistics {
        size_t acquires = 0, releases = 0, creates = 0, cross_thread_ops = 0,
               same_thread_hits = 0, in_use = 0, current_pool_size = 0,
               cache_hits = 0, batch_operations = 0;
    };

    OptimizedObjectPool()
        : OptimizedObjectPool(Allocator(std::pmr::get_default_resource())) {}

    explicit OptimizedObjectPool(const Allocator& alloc)
        : m_allocator(alloc), m_shutdown_flag(false), m_queue() {
        get_active_instances().emplace(this, std::chrono::steady_clock::now());
        if constexpr (std::is_default_constructible_v<T>) {
            prewarm(AdjustedPoolSize / 2uz);
        }
    }

    ~OptimizedObjectPool() {
        // 1) Sinaliza shutdown para novas operações
        m_shutdown_flag.store(true, std::memory_order_release);

        // 2) Remove da lista de instâncias ativas (mantemos phmap)
        get_active_instances().erase(this);

        // 3) Espera todas as operações em andamento
        while (m_active_ops.load(std::memory_order_acquire) > 0) {
            std::this_thread::yield();
        }

        // 4) Limpeza final
        cleanup_all_caches();
        cleanup_global_queue();
    }

    // ----------------------------------- API --------------------------------

    bool safe_return_to_global(pointer obj) noexcept {
        if (m_shutdown_flag.load(std::memory_order_relaxed)) [[unlikely]] return false;
        return m_queue.try_push(obj);
    }

    void safe_destroy_and_deallocate(pointer obj) noexcept {
        if (!obj) return;
        try {
            if constexpr (!std::is_trivially_destructible_v<T>) std::destroy_at(obj);
            m_allocator.deallocate(obj, 1);
        } catch (...) {
            g_error_handler(std::current_exception());
        }
    }

    void batch_return_to_global(std::span<pointer> objects) noexcept {
        if (objects.empty()) return;

        if (m_shutdown_flag.load(std::memory_order_relaxed)) {
            for (auto obj : objects) safe_destroy_and_deallocate(obj);
            return;
        }

        if constexpr (EnableStats) {
            m_stats.batch_operations.fetch_add(1, std::memory_order_relaxed);
        }

        std::array<pointer, 64> failed_objects{};
        size_t failed_count = 0;

        for (auto obj : objects) {
            if (!obj) continue;
            if (!m_queue.try_push(obj)) {
                if (failed_count < failed_objects.size()) {
                    failed_objects[failed_count++] = obj;
                } else {
                    safe_destroy_and_deallocate(obj);
                }
            }
        }

        for (size_t i = 0; i < failed_count; ++i) {
            safe_destroy_and_deallocate(failed_objects[i]);
        }
    }

    template <typename... Args>
    [[nodiscard]] GNUHOT PoolResult acquire(Args&&... args) {
        if (m_shutdown_flag.load(std::memory_order_acquire)) [[unlikely]] {
            return std::unexpected(PoolError::Shutdown);
        }

        m_active_ops.fetch_add(1, std::memory_order_acq_rel);

        if constexpr (EnableStats) {
            m_stats.acquires.fetch_add(1, std::memory_order_relaxed);
            m_stats.in_use.fetch_add(1, std::memory_order_acq_rel);
        }

        // 1) Cache local (LIFO)
        auto& cache = local_cache();
        if (cache.size > 0uz && cache.is_valid()) {
            pointer obj = cache.data[--cache.size];

            if constexpr (EnableStats) {
                m_stats.same_thread_hits.fetch_add(1, std::memory_order_relaxed);
                m_stats.cache_hits.fetch_add(1, std::memory_order_relaxed);
            }

            construct_or_reset(obj, std::forward<Args>(args)...);
            m_active_ops.fetch_sub(1, std::memory_order_acq_rel);
            return obj;
        }

        // 2) Fila global
        pointer obj = nullptr;
        if (m_queue.try_pop(obj)) {
            if constexpr (EnableStats) {
                m_stats.cross_thread_ops.fetch_add(1, std::memory_order_relaxed);
            }
            construct_or_reset(obj, std::forward<Args>(args)...);
            m_active_ops.fetch_sub(1, std::memory_order_acq_rel);
            return obj;
        }

        // 3) Criar novo
        auto result = create_new(std::forward<Args>(args)...);
        if (!result) {
            if constexpr (EnableStats) {
                m_stats.in_use.fetch_sub(1, std::memory_order_acq_rel);
            }
        }
        m_active_ops.fetch_sub(1, std::memory_order_acq_rel);
        return result;
    }

    GNUHOT void release(pointer obj) noexcept {
        if (!obj) {
            // release pode ser chamado de caminhos que contam como op. ativa: garanta decremento
            m_active_ops.fetch_sub(1, std::memory_order_acq_rel);
            return;
        }

        if constexpr (EnableStats) {
            m_stats.releases.fetch_add(1, std::memory_order_relaxed);
            m_stats.in_use.fetch_sub(1, std::memory_order_acq_rel);
        }

        bool same_thread = true;
        if constexpr (HasThreadId<T>) {
            same_thread = obj->threadId == ThreadPool::getThreadId();
        }

        cleanup_object_optimized(obj);

        if (same_thread && !m_shutdown_flag.load(std::memory_order_relaxed)) {
            auto& cache = local_cache();
            if (cache.is_valid() && cache.size < AdjustedLocalCacheSize) {
                cache.data[cache.size++] = obj;
                m_active_ops.fetch_sub(1, std::memory_order_acq_rel);
                return;
            }
        }

        if (!safe_return_to_global(obj)) {
            safe_destroy_and_deallocate(obj);
        }

        if constexpr (EnableStats) {
            if (!same_thread) {
                m_stats.cross_thread_ops.fetch_add(1, std::memory_order_relaxed);
            }
        }

        m_active_ops.fetch_sub(1, std::memory_order_acq_rel);
    }

    void prewarm(size_t count) {
        if (m_shutdown_flag.load(std::memory_order_acquire)) return;

        const size_t free_slots = AdjustedPoolSize - m_queue.was_size();
        count = std::min(count, free_slots);
        if (count == 0uz) return;

        std::array<pointer, lockfree_config::PREWARM_BATCH_SIZE> batch{};
        while (count > 0uz) {
            const size_t n = std::min(count, batch.size());
            size_t allocated = 0;
            for (size_t i = 0; i < n; ++i) {
                if ((batch[i] = allocate_and_construct())) ++allocated; else break;
            }
            if (allocated == 0uz) return;

            for (size_t i = 0; i < allocated; ++i) {
                if (!m_queue.try_push(batch[i])) {
                    for (size_t j = i; j < allocated; ++j) {
                        safe_destroy_and_deallocate(batch[j]);
                    }
                    return;
                }
            }
            count -= allocated;
        }
    }

    void flush_local_cache() noexcept {
        auto& cache = local_cache();
        if (cache.size > 0uz) {
            batch_return_to_global(std::span(cache.data).first(cache.size));
            cache.size = 0;
        }
    }

    [[nodiscard]] size_t shrink(size_t max = AdjustedPoolSize) {
        flush_local_cache();
        size_t released = 0;
        constexpr size_t BATCH_SIZE = 32;
        std::array<pointer, BATCH_SIZE> batch{};

        while (released < max) {
            size_t batch_count = 0;
            const size_t target = std::min(max - released, BATCH_SIZE);

            for (size_t i = 0; i < target && m_queue.try_pop(batch[i]); ++i) {
                if (batch[i]) ++batch_count;
            }
            if (batch_count == 0) break;

            for (size_t i = 0; i < batch_count; ++i) {
                safe_destroy_and_deallocate(batch[i]);
            }
            released += batch_count;
        }
        return released;
    }

    [[nodiscard]] PoolStatistics get_stats() const {
        PoolStatistics stats{};
        if constexpr (EnableStats) {
            stats.acquires = m_stats.acquires.load(std::memory_order_relaxed);
            stats.releases = m_stats.releases.load(std::memory_order_relaxed);
            stats.creates  = m_stats.creates.load(std::memory_order_relaxed);
            stats.cross_thread_ops = m_stats.cross_thread_ops.load(std::memory_order_relaxed);
            stats.same_thread_hits = m_stats.same_thread_hits.load(std::memory_order_relaxed);
            stats.in_use = m_stats.in_use.load(std::memory_order_acquire);
            stats.current_pool_size = m_queue.was_size();
            stats.cache_hits = m_stats.cache_hits.load(std::memory_order_relaxed);
            stats.batch_operations = m_stats.batch_operations.load(std::memory_order_relaxed);
        }
        return stats;
    }

    [[nodiscard]] static constexpr size_t capacity() noexcept { return AdjustedPoolSize; }

private:
    // --------------------------------- Internals --------------------------------

    static constexpr size_t AdjustedPoolSize       = lockfree_config::adjust_pool_size<PoolSize>();
    static constexpr size_t AdjustedLocalCacheSize = lockfree_config::adjust_pool_size<LocalCacheSize>();

    LOCKFREE_NO_UNIQUE_ADDRESS Allocator m_allocator;
    std::atomic<bool>   m_shutdown_flag {false};
    std::atomic<size_t> m_active_ops    {0};

    struct alignas(CACHE_LINE_SIZE) StatsBlock {
        std::atomic<size_t> acquires{0}, releases{0}, creates{0}, cross_thread_ops{0},
                            same_thread_hits{0}, in_use{0}, cache_hits{0}, batch_operations{0};
    };
    LOCKFREE_NO_UNIQUE_ADDRESS std::conditional_t<EnableStats, StatsBlock, std::monostate> m_stats;

    alignas(CACHE_LINE_SIZE) atomic_queue::AtomicQueue<pointer, AdjustedPoolSize> m_queue;

    static auto& get_active_instances() {
        static phmap::parallel_flat_hash_map_m<OptimizedObjectPool*, std::chrono::steady_clock::time_point> instances;
        return instances;
    }

    struct alignas(CACHE_LINE_SIZE) ThreadCache {
        OptimizedObjectPool* owner = nullptr;
        size_t size = 0;
        std::atomic<bool> valid {true};
        char padding[CACHE_LINE_PADDING - sizeof(size_t) - sizeof(std::atomic<bool>) - sizeof(void*)]{};
        alignas(CACHE_LINE_SIZE) pointer data[AdjustedLocalCacheSize];

        bool is_valid() const noexcept { return valid.load(std::memory_order_acquire); }
        void invalidate() noexcept     { valid.store(false, std::memory_order_release); }
        ~ThreadCache() noexcept;
    };

    static thread_local ThreadCache thread_cache;

    ThreadCache& local_cache() {
        thread_cache.owner = this; // marca a pool de origem
        return thread_cache;
    }

    static void cleanup_all_caches() {
        // não há um registro central de todos os TLS; yielding reduz pressão
        std::this_thread::yield();
    }

    void cleanup_global_queue() noexcept {
        constexpr size_t BATCH_SIZE = lockfree_config::CLEANUP_BATCH_SIZE;
        std::array<pointer, BATCH_SIZE> batch{};
        while (true) {
            size_t batch_count = 0;
            for (size_t i = 0; i < BATCH_SIZE && m_queue.try_pop(batch[i]); ++i) {
                ++batch_count;
            }
            if (batch_count == 0) break;
            for (auto obj : std::span(batch).first(batch_count)) {
                safe_destroy_and_deallocate(obj);
            }
        }
    }

    template <typename... Args>
    GNUCOLD GNUNOINLINE PoolResult create_new(Args&&... args) {
        if constexpr (EnableStats) {
            m_stats.creates.fetch_add(1, std::memory_order_relaxed);
        }

        pointer obj = nullptr;
        try {
            obj = m_allocator.allocate(1);
            if (!obj) {
                return std::unexpected(PoolError::AllocationFailed);
            }

            try {
                if constexpr (HasBuild<T, Args...>) {
                    std::construct_at(obj);
                    obj->build(std::forward<Args>(args)...);
                } else {
                    std::construct_at(obj, std::forward<Args>(args)...);
                }
                if constexpr (HasThreadId<T>) {
                    obj->threadId = ThreadPool::getThreadId();
                }
                return obj;
            } catch (...) {
                m_allocator.deallocate(obj, 1);
                g_error_handler(std::current_exception());
                return std::unexpected(PoolError::AllocationFailed);
            }
        } catch (...) {
            g_error_handler(std::current_exception());
            return std::unexpected(PoolError::AllocationFailed);
        }
    }

    GNUHOT GNUALWAYSINLINE void cleanup_object_optimized(pointer obj) noexcept {
        if (!obj) return;
        try {
            if constexpr (HasReset<T>) {
                obj->reset();
            } else if constexpr (HasDestroy<T>) {
                obj->destroy();
            }
        } catch (...) {
            g_error_handler(std::current_exception());
        }
    }

    template <typename... Args>
    GNUHOT GNUALWAYSINLINE void construct_or_reset(pointer obj, Args&&... args) noexcept {
        if (!obj) return;

        // Preferir reset/build se disponíveis
        try {
            if constexpr (HasReset<T, Args...>) {
                obj->reset(std::forward<Args>(args)...);
                return;
            }
            if constexpr (HasBuild<T, Args...>) {
                obj->build(std::forward<Args>(args)...);
                return;
            }
        } catch (...) {
            g_error_handler(std::current_exception());
        }

        // Otimização de cópia para tipos triviais quando o primeiro argumento é T
        if constexpr (std::is_trivially_copyable_v<T> && sizeof...(Args) == 1) {
            using FirstArg = std::decay_t<std::tuple_element_t<0, std::tuple<Args...>>>;
            if constexpr (std::is_same_v<FirstArg, T>) {
                const T& src = std::get<0>(std::forward_as_tuple(args...));
#if defined(__AVX512F__)
                if constexpr (sizeof(T) == 64) {
                    _mm512_storeu_si512(reinterpret_cast<__m512i*>(obj),
                                        _mm512_loadu_si512(reinterpret_cast<const __m512i*>(&src)));
                    return;
                }
#endif
#if defined(__AVX2__) || (defined(_MSC_VER) && defined(_M_X64))
                if constexpr (sizeof(T) == 32) {
                    _mm256_storeu_si256(reinterpret_cast<__m256i*>(obj),
                                        _mm256_loadu_si256(reinterpret_cast<const __m256i*>(&src)));
                    return;
                } else if constexpr (sizeof(T) == 64) {
                    _mm256_storeu_si256(reinterpret_cast<__m256i*>(obj),
                                        _mm256_loadu_si256(reinterpret_cast<const __m256i*>(&src)));
                    _mm256_storeu_si256(reinterpret_cast<__m256i*>(obj) + 1,
                                        _mm256_loadu_si256(reinterpret_cast<const __m256i*>(&src) + 1));
                    return;
                }
#endif
#if defined(__SSE2__) || (defined(_MSC_VER) && defined(_M_X64))
                if constexpr (sizeof(T) == 16) {
                    _mm_storeu_si128(reinterpret_cast<__m128i*>(obj),
                                     _mm_loadu_si128(reinterpret_cast<const __m128i*>(&src)));
                    return;
                }
#endif
                // Fallback geral
                std::memcpy(obj, &src, sizeof(T));
                return;
            }
        }

        // Reconstrução padrão se necessário
        if constexpr (!std::is_trivially_destructible_v<T> || sizeof...(Args) > 0) {
            try {
                if constexpr (!std::is_trivially_destructible_v<T>) {
                    std::destroy_at(obj);
                }
                std::construct_at(obj, std::forward<Args>(args)...);
            } catch (...) {
                g_error_handler(std::current_exception());
            }
        }
    }

    GNUALWAYSINLINE pointer allocate_and_construct() noexcept {
        try {
            pointer obj = m_allocator.allocate(1);
            if (!obj) return nullptr;
            std::construct_at(obj);
            if constexpr (HasThreadId<T>) {
                obj->threadId = ThreadPool::getThreadId();
            }
            return obj;
        } catch (...) {
            return nullptr;
        }
    }
};

// thread_local cache definição
template <typename T, size_t P, bool E, typename A, size_t L>
thread_local typename OptimizedObjectPool<T, P, E, A, L>::ThreadCache
    OptimizedObjectPool<T, P, E, A, L>::thread_cache;

// ThreadCache dtor devolve somente para a pool de origem
template <typename T, size_t P, bool E, typename A, size_t L>
OptimizedObjectPool<T, P, E, A, L>::ThreadCache::~ThreadCache() noexcept {
    invalidate();
    if (size == 0 || !owner) return;

    std::array<pointer, L> local_objects{};
    const size_t local_size = std::min(size, L);
    std::copy_n(data, local_size, local_objects.begin());
    size = 0;

    try {
        if (!owner->m_shutdown_flag.load(std::memory_order_relaxed)) {
            owner->batch_return_to_global(std::span(local_objects).first(local_size));
        }
    } catch (...) {
        // Em último caso, preferimos leak a corromper memória
    }
}

// ============================================================================
//                         SharedOptimizedObjectPool
// ============================================================================
template <
    typename T,
    size_t PoolSize = lockfree_config::DEFAULT_POOL_SIZE,
    bool EnableStats = false,
    typename Allocator = std::pmr::polymorphic_allocator<T>,
    size_t LocalCacheSize = lockfree_config::DEFAULT_LOCAL_CACHE_SIZE>
class SharedOptimizedObjectPool {
public:
    using PoolResult = std::expected<std::shared_ptr<T>, PoolError>;

    SharedOptimizedObjectPool()
        : m_pool(Allocator(std::pmr::get_default_resource())) {}

    explicit SharedOptimizedObjectPool(const Allocator& allocator)
        : m_pool(allocator) {}

    template <typename... Args>
    [[nodiscard]] PoolResult acquire(Args&&... args) {
        auto result = m_pool.acquire(std::forward<Args>(args)...);
        if (!result) return std::unexpected(result.error());
        return std::shared_ptr<T>(result.value(), [this](T* ptr) noexcept {
            if (ptr) m_pool.release(ptr);
        });
    }

    void prewarm(size_t count) { m_pool.prewarm(count); }
    void flush_local_cache()   { m_pool.flush_local_cache(); }
    [[nodiscard]] size_t shrink(size_t max = OptimizedObjectPool<T, PoolSize, EnableStats, Allocator, LocalCacheSize>::effective_pool_size()) {
        return m_pool.shrink(max);
    }
    [[nodiscard]] auto get_stats() const { return m_pool.get_stats(); }
    [[nodiscard]] static constexpr size_t capacity() noexcept {
        return OptimizedObjectPool<T, PoolSize, EnableStats, Allocator, LocalCacheSize>::effective_pool_size();
    }

private:
    OptimizedObjectPool<T, PoolSize, EnableStats, Allocator, LocalCacheSize> m_pool;
};
