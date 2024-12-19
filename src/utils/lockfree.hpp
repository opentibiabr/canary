/**
 * Lock-free Memory Management Implementation
 * ----------------------------------------
 *
 * This implementation provides a high-performance, lock-free memory management system
 * optimized for multi-threaded environments. It uses a combination of thread-local
 * caching and lock-free queues to minimize contention and maximize throughput.
 *
 * Key Features:
 * - Lock-free operations using atomic queues
 * - Thread-local caching for fast allocation/deallocation
 * - Memory prefetching for improved performance
 * - Cache-line alignment to prevent false sharing
 * - Batch operations for efficient memory management
 *
 * Flow:
 * 1. Allocation:
 *    - First tries to get memory from thread-local cache
 *    - If local cache is empty, refills it from the global free list
 *    - If global free list is empty, triggers growth
 *
 * 2. Deallocation:
 *    - First attempts to store in thread-local cache
 *    - If local cache is full, flushes half to global free list
 *    - Maintains balance between local and global storage
 *
 * Usage Examples:
 *
 * 1. Basic Raw Pointer Usage:
 * @code
 *     // Define a lock-free pool for MyClass with capacity 1000
 *     using MyPool = LockfreeFreeList<MyClass, 1000>;
 *
 *     // Pre-allocate some objects
 *     MyPool::preallocate(100);
 *
 *     // Allocate an object
 *     MyClass* obj = MyPool::fast_allocate();
 *     if (obj) {
 *         // Use the object
 *         // ...
 *
 *         // Deallocate when done
 *         MyPool::fast_deallocate(obj);
 *     }
 * @endcode
 *
 * 2. Integration with Smart Pointers and Allocators:
 * @code
 *     // Define custom allocator using the lock-free pool
 *     template<typename T>
 *     class PoolAllocator : public std::pmr::memory_resource {
 *         void* do_allocate(size_t bytes, size_t alignment) override {
 *             return LockfreeFreeList<T, 1000>::fast_allocate();
 *         }
 *         void do_deallocate(void* p, size_t bytes, size_t alignment) override {
 *             LockfreeFreeList<T, 1000>::fast_deallocate(static_cast<T*>(p));
 *         }
 *     };
 *
 *     // Create an allocator
 *     PoolAllocator<Message> messageAllocator;
 *
 *     // Use with shared_ptr
 *     Message_ptr getMessage() {
 *         return std::allocate_shared<Message>(messageAllocator);
 *     }
 * @endcode
 *
 * 3. Using with Custom Memory Resource:
 * @code
 *     // Create a custom memory resource
 *     class CustomResource : public std::pmr::memory_resource {
 *         using Pool = LockfreeFreeList<char, 1000>;
 *
 *         void* do_allocate(size_t bytes, size_t alignment) override {
 *             return Pool::fast_allocate();
 *         }
 *         void do_deallocate(void* p, size_t, size_t) override {
 *             Pool::fast_deallocate(static_cast<char*>(p));
 *         }
 *     };
 *
 *     // Use with polymorphic allocator
 *     std::pmr::polymorphic_allocator<Message> polyAlloc{&customResource};
 *     auto msg = std::allocate_shared<Message>(polyAlloc);
 * @endcode
 *
 * Performance Considerations:
 * - Uses CACHE_LINE_SIZE alignment to prevent false sharing
 * - Implements prefetching for better cache utilization
 * - Batch operations reduce contention on the global free list
 * - Thread-local caching minimizes inter-thread synchronization
 *
 * Memory Management:
 * - DEFAULT_BATCH_SIZE controls the size of thread-local caches
 * - STATIC_PREALLOCATION_SIZE sets initial pool size
 * - Memory is aligned to prevent cache-line sharing
 * - Uses std::pmr for flexible memory resource management
 */

#pragma once

#include <atomic_queue/atomic_queue.h>
#include <memory_resource>

// Cache line size to avoid false sharing
#define CACHE_LINE_SIZE 64

// Prefetch optimization
#ifdef _MSC_VER
	#include <intrin.h>
	#define PREFETCH(addr) _mm_prefetch((const char*)(addr), _MM_HINT_T0)
#else
	#define PREFETCH(addr) __builtin_prefetch(addr)
#endif

// Compiler optimizations
#if defined(__GNUC__) || defined(__clang__)
	#define LIKELY(x) __builtin_expect(!!(x), 1)
	#define UNLIKELY(x) __builtin_expect(!!(x), 0)
#else
	#define LIKELY(x) (x)
	#define UNLIKELY(x) (x)
#endif

constexpr size_t STATIC_PREALLOCATION_SIZE = 500;

template <typename T, size_t CAPACITY>
struct LockfreeFreeList {
	using FreeList = atomic_queue::AtomicQueue2<T*, CAPACITY>;

	// Increased for better cache utilization
	static constexpr size_t DEFAULT_BATCH_SIZE = 128;
	static constexpr size_t PREFETCH_DISTANCE = 4;

	// Aligned structure to avoid false sharing
	struct alignas(CACHE_LINE_SIZE) AlignedCounters {
		std::atomic<size_t> count;
		char padding[CACHE_LINE_SIZE - sizeof(std::atomic<size_t>)];

		AlignedCounters() :
			count(0) { }
	};

	static AlignedCounters allocated_count;
	static AlignedCounters failed_allocations;

	// Thread-local memory pool
	static thread_local std::array<T*, DEFAULT_BATCH_SIZE> local_cache;
	static thread_local size_t local_cache_size;

	[[nodiscard]] static FreeList &get() noexcept {
		static FreeList freeList;
		return freeList;
	}

	static void preallocate(const size_t count, std::pmr::memory_resource* resource = std::pmr::get_default_resource()) noexcept {
		auto &freeList = get();
		T* batch[DEFAULT_BATCH_SIZE];
		size_t successful = 0;

		for (size_t i = 0; i < count; i += DEFAULT_BATCH_SIZE) {
			const size_t batchSize = std::min(DEFAULT_BATCH_SIZE, count - i);

			// Pre-allocate with prefetch
			for (size_t j = 0; j < batchSize; ++j) {
				if (j + PREFETCH_DISTANCE < batchSize) {
					PREFETCH(&batch[j + PREFETCH_DISTANCE]);
				}
				batch[j] = static_cast<T*>(resource->allocate(sizeof(T), alignof(T)));
			}

			// Optimized insertion
			for (size_t j = 0; j < batchSize; ++j) {
				if (UNLIKELY(!freeList.try_push(batch[j]))) {
					for (size_t k = j; k < batchSize; ++k) {
						resource->deallocate(batch[k], sizeof(T), alignof(T));
					}
					failed_allocations.count.fetch_add(1, std::memory_order_relaxed);
					return;
				}
				++successful;
			}
		}
		allocated_count.count.fetch_add(successful, std::memory_order_release);
	}

	// Thread-local cache
	[[nodiscard]] static T* fast_allocate() noexcept {
		if (LIKELY(local_cache_size > 0)) {
			return local_cache[--local_cache_size];
		}

		// Refill local cache
		auto &freeList = get();
		size_t fetched = 0;
		while (fetched < DEFAULT_BATCH_SIZE) {
			T* ptr;
			if (!freeList.try_pop(ptr)) {
				break;
			}
			local_cache[fetched++] = ptr;
		}

		local_cache_size = fetched;
		return (fetched > 0) ? local_cache[--local_cache_size] : nullptr;
	}

	static bool fast_deallocate(T* ptr) noexcept {
		if (LIKELY(local_cache_size < DEFAULT_BATCH_SIZE)) {
			local_cache[local_cache_size++] = ptr;
			return true;
		}

		// Local cache full, try to empty half
		auto &freeList = get();
		const size_t half = DEFAULT_BATCH_SIZE / 2;
		for (size_t i = 0; i < half; ++i) {
			if (!freeList.try_push(local_cache[i])) {
				return false;
			}
		}

		// Move the other half to the beginning
		std::move(local_cache.begin() + half, local_cache.begin() + DEFAULT_BATCH_SIZE, local_cache.begin());
		local_cache_size = half;
		local_cache[local_cache_size++] = ptr;
		return true;
	}

	[[nodiscard]] static size_t get_allocated_count() noexcept {
		return allocated_count.count.load(std::memory_order_relaxed);
	}

	static void try_grow() noexcept {
		const size_t current = get_allocated_count();
		if (LIKELY(CAPACITY - current >= DEFAULT_BATCH_SIZE)) {
			preallocate(DEFAULT_BATCH_SIZE);
		}
	}
};

template <typename T, size_t CAPACITY>
typename LockfreeFreeList<T, CAPACITY>::AlignedCounters LockfreeFreeList<T, CAPACITY>::allocated_count;

template <typename T, size_t CAPACITY>
typename LockfreeFreeList<T, CAPACITY>::AlignedCounters LockfreeFreeList<T, CAPACITY>::failed_allocations;

template <typename T, size_t CAPACITY>
thread_local std::array<T*, LockfreeFreeList<T, CAPACITY>::DEFAULT_BATCH_SIZE> LockfreeFreeList<T, CAPACITY>::local_cache;

template <typename T, size_t CAPACITY>
thread_local size_t LockfreeFreeList<T, CAPACITY>::local_cache_size = 0;

template <typename T, size_t CAPACITY>
class LockfreePoolingAllocator {
public:
	using value_type = T;

	template <typename U>
	struct rebind {
		using other = LockfreePoolingAllocator<U, CAPACITY>;
	};

	LockfreePoolingAllocator() noexcept {
		preallocateOnce();
	}

	template <typename U>
	explicit LockfreePoolingAllocator(const LockfreePoolingAllocator<U, CAPACITY> &) noexcept { }

	[[nodiscard]] T* allocate(std::size_t n) {
		if (LIKELY(n == 1)) {
			if (T* p = LockfreeFreeList<T, CAPACITY>::fast_allocate()) {
				return p;
			}

			LockfreeFreeList<T, CAPACITY>::try_grow();
			if (T* p = LockfreeFreeList<T, CAPACITY>::fast_allocate()) {
				return p;
			}
		}
		return static_cast<T*>(std::pmr::get_default_resource()->allocate(n * sizeof(T), alignof(T)));
	}

	void deallocate(T* p, std::size_t n) noexcept {
		if (LIKELY(n == 1)) {
			if (LockfreeFreeList<T, CAPACITY>::fast_deallocate(p)) {
				return;
			}
		}
		std::pmr::get_default_resource()->deallocate(p, n * sizeof(T), alignof(T));
	}

private:
	static void preallocateOnce() {
		std::call_once(preallocationFlag, []() {
			LockfreeFreeList<T, CAPACITY>::preallocate(STATIC_PREALLOCATION_SIZE);
		});
	}

	static std::once_flag preallocationFlag;
};

template <typename T, size_t CAPACITY>
std::once_flag LockfreePoolingAllocator<T, CAPACITY>::preallocationFlag;
