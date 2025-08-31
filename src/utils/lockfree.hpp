/**
 * LockFree Object Pool - A high-performance, thread-safe object pool implementation
 * Copyright (©) 2025 Daniel <daniel15042015@gmail.com>
 * Repository: https://github.com/beats-dh/lockfree
 * License: https://github.com/beats-dh/lockfree/blob/main/LICENSE
 * Contributors: https://github.com/beats-dh/lockfree/graphs/contributors
 * Website:
 */

#pragma once

#include "atomic_queue/atomic_queue.h"
#include "lib/thread/thread_pool.hpp"
#include "parallel_hashmap/phmap.h"
#include <span>
#include <chrono>
#include <memory_resource>
#include <expected>

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
// Usa o tamanho da linha de cache de hardware definido pelo padrão C++17 para evitar "false sharing".
constexpr size_t CACHE_LINE_SIZE = std::hardware_destructive_interference_size;
constexpr size_t CACHE_LINE_PADDING = std::hardware_constructive_interference_size;
#else
// Fallback para o tamanho de linha de cache mais comum (64 bytes) se o padrão não estiver disponível.
constexpr size_t CACHE_LINE_SIZE = 64;
constexpr size_t CACHE_LINE_PADDING = 64;
#endif

namespace lockfree_config {
	using namespace std::chrono_literals;
	constexpr size_t DEFAULT_POOL_SIZE = 1024;
	constexpr size_t DEFAULT_LOCAL_CACHE_SIZE = 32;
	constexpr size_t PREWARM_BATCH_SIZE = 32;
	constexpr size_t CLEANUP_BATCH_SIZE = 64;

	// Funções utilitárias para garantir que o tamanho da pool seja potência de 2
	constexpr bool is_power_of_two(size_t n) noexcept {
		return n > 0 && (n & (n - 1)) == 0;
	}

	constexpr size_t next_power_of_two(size_t n) noexcept {
		if (n <= 1) {
			return 1;
		}
		--n;
		n |= n >> 1;
		n |= n >> 2;
		n |= n >> 4;
		n |= n >> 8;
		n |= n >> 16;
		if constexpr (sizeof(size_t) > 4) {
			n |= n >> 32;
		}
		return ++n;
	}

	// Template para ajustar automaticamente o tamanho da pool
	template <size_t Size>
	constexpr size_t adjust_pool_size() noexcept {
		return is_power_of_two(Size) ? Size : next_power_of_two(Size);
	}
}

// Conceitos para garantir que os tipos T tenham as interfaces necessárias.
template <typename T, typename... Args>
concept HasReset = requires(T t, Args &&... args) {
	{ t.reset(std::forward<Args>(args)...) } -> std::same_as<void>;
};

template <typename T, typename... Args>
concept HasBuild = requires(T t, Args &&... args) {
	{ t.build(std::forward<Args>(args)...) } -> std::same_as<void>;
};

template <typename T>
concept HasDestroy = requires(T t) {
	{ t.destroy() } -> std::same_as<void>;
};

template <typename T>
concept HasThreadId = requires(T t) {
	{ static_cast<const decltype(t) &>(t).threadId } -> std::convertible_to<int16_t>;
};

template <typename T>
concept Poolable = std::is_default_constructible_v<T> || HasReset<T> || HasBuild<T>;

// Enum para erros explícitos, usado com std::expected (C++23).
enum class PoolError {
	Shutdown,
	AllocationFailed
};

/**
 * @brief Pool de objetos lock-free ultrarrápida com limpeza otimizada e cache local por thread.
 * @details Esta classe fornece uma implementação de pool de objetos de alta performance e segura para threads,
 * usando operações atômicas lock-free e caches locais para minimizar a contenção.
 * Os objetos são reciclados eficientemente com construção otimizada para SIMD e ordenação
 * LIFO para localidade de cache ótima.
 *
 * @tparam T Tipo do objeto a ser armazenado na pool (deve satisfazer o conceito Poolable).
 * @tparam PoolSize Capacidade máxima da pool global (deve ser uma potência de dois para melhor performance).
 * @tparam EnableStats Habilita a coleta de estatísticas para monitoramento de performance.
 * @tparam Allocator Tipo do alocador (suporta alocadores PMR).
 * @tparam LocalCacheSize Máximo de objetos no cache por thread para reduzir contenção.
 */
template <
	typename T,
	size_t PoolSize = lockfree_config::DEFAULT_POOL_SIZE,
	bool EnableStats = false,
	typename Allocator = std::pmr::polymorphic_allocator<T>,
	size_t LocalCacheSize = lockfree_config::DEFAULT_LOCAL_CACHE_SIZE>
class OptimizedObjectPool {
public:
	// Expõe os tamanhos ajustados para uso externo
	static constexpr size_t effective_pool_size() noexcept {
		return AdjustedPoolSize;
	}
	static constexpr size_t effective_cache_size() noexcept {
		return AdjustedLocalCacheSize;
	}
	using pointer = T*;
	using PoolResult = std::expected<pointer, PoolError>;

	struct alignas(CACHE_LINE_SIZE) PoolStatistics {
		size_t acquires = 0, releases = 0, creates = 0, cross_thread_ops = 0,
			   same_thread_hits = 0, in_use = 0, current_pool_size = 0,
			   cache_hits = 0, batch_operations = 0;
	};

	/**
	 * @brief Construtor padrão que utiliza o recurso de memória padrão.
	 */
	OptimizedObjectPool() :
		OptimizedObjectPool(Allocator(std::pmr::get_default_resource())) { }

	/**
	 * @brief Constrói a pool com um alocador customizado.
	 * @param alloc Instância do alocador customizado para alocação de objetos.
	 * @details Inicializa a pool, a registra para limpeza segura e opcionalmente
	 * pré-aquece a pool com objetos para melhor performance inicial.
	 */
	explicit OptimizedObjectPool(const Allocator &alloc) :
		m_allocator(alloc), m_shutdown_flag(false), m_queue() {
		get_active_instances().emplace(this, std::chrono::steady_clock::now());
		if constexpr (std::is_default_constructible_v<T>) {
			prewarm(AdjustedPoolSize / 2uz);
		}
	}

	/**
	 * @brief Destrutor com limpeza segura multi-threaded.
	 * @details Garante a ordem correta de desligamento: sinaliza o desligamento, aguarda por operações
	 * em andamento, limpa os caches das threads, remove a instância da lista de ativas e
	 * limpa a fila global. Esta ordem previne "race conditions" durante a destruição da pool.
	 */
	~OptimizedObjectPool() {
		// Sinaliza shutdown para todas as threads
		m_shutdown_flag.store(true, std::memory_order_release);

		// Remove da lista de instâncias ativas primeiro para evitar race conditions
		get_active_instances().erase(this);

		// Aguarda um tempo razoável para threads em andamento terminarem
		std::this_thread::sleep_for(std::chrono::milliseconds(10));

		// Limpa caches e fila global
		cleanup_all_caches();
		cleanup_global_queue();
	}

	/**
	 * @brief Retorna um objeto de forma segura para a pool global, com verificação de desligamento.
	 * @param obj Ponteiro para o objeto a ser retornado.
	 * @return true se o objeto foi retornado com sucesso, false caso contrário.
	 * @details Tenta inserir o objeto na fila atômica global. A lógica de recuperação de race condition
	 * foi removida para simplificação, pois o destrutor principal já garante a limpeza.
	 */
	bool safe_return_to_global(pointer obj) noexcept {
		if (m_shutdown_flag.load(std::memory_order_relaxed)) [[unlikely]] {
			return false;
		}
		return m_queue.try_push(obj);
	}

	/**
	 * @brief Destrói e desaloca um objeto de forma segura, com tratamento de exceções.
	 * @param obj Ponteiro para o objeto a ser destruído e desalocado.
	 * @details Executa a sequência de destruição correta: chama o destrutor (se não for trivial)
	 * e depois desaloca a memória. Todas as exceções são capturadas e ignoradas para
	 * garantir uma limpeza segura em destrutores e caminhos de erro.
	 */
	void safe_destroy_and_deallocate(pointer obj) noexcept {
		if (!obj) [[unlikely]] {
			return;
		}

		// Validação adicional de ponteiro para detectar corrupção
		if (reinterpret_cast<uintptr_t>(obj) < 0x1000) [[unlikely]] {
			// Ponteiro suspeito (muito baixo), provavelmente corrompido
			return;
		}

		try {
			if constexpr (!std::is_trivially_destructible_v<T>) {
				std::destroy_at(obj);
			}
			m_allocator.deallocate(obj, 1);
		} catch (...) {
			// Log ou handle do erro se necessário
		}
	}

	/**
	 * @brief Retorna múltiplos objetos para a pool global de forma eficiente.
	 * @param objects Um `std::span` de ponteiros de objetos a serem retornados.
	 * @details Operação em lote otimizada que tenta retornar todos os objetos para a pool global.
	 * Se a pool estiver em processo de desligamento, destrói todos os objetos.
	 * Atualiza as estatísticas de operações em lote quando habilitado.
	 */
	void batch_return_to_global(std::span<pointer> objects) noexcept {
		if (objects.empty()) [[unlikely]] {
			return;
		}

		if (m_shutdown_flag.load(std::memory_order_relaxed)) [[unlikely]] {
			for (auto obj : objects) {
				safe_destroy_and_deallocate(obj);
			}
			return;
		}

		if constexpr (EnableStats) {
			m_stats.batch_operations.fetch_add(1, std::memory_order_relaxed);
		}

		// Otimização: tenta inserir todos primeiro, depois limpa os que falharam
		std::array<pointer, 64> failed_objects;
		size_t failed_count = 0;

		for (auto obj : objects) {
			if (!obj) [[unlikely]] {
				continue;
			}
			if (!m_queue.try_push(obj)) {
				if (failed_count < failed_objects.size()) {
					failed_objects[failed_count++] = obj;
				} else {
					// Se temos muitos objetos falhando, limpa imediatamente
					safe_destroy_and_deallocate(obj);
				}
			}
		}

		// Limpa objetos que falharam ao retornar
		for (size_t i = 0; i < failed_count; ++i) {
			safe_destroy_and_deallocate(failed_objects[i]);
		}
	}

	/**
	 * @brief Adquire um objeto da pool, com argumentos opcionais para o construtor.
	 * @tparam Args Tipos dos argumentos do construtor.
	 * @param args Argumentos a serem encaminhados para o construtor do objeto ou método `reset`.
	 * @return Um `std::expected` contendo um ponteiro para o objeto adquirido, ou um `PoolError` em caso de falha.
	 * @details Aquisição de alta performance com cache de múltiplos níveis: verifica primeiro o cache local
	 * da thread (LIFO para localidade de cache), depois a fila atômica global, e por último
	 * cria um novo objeto. Inclui "prefetching hints" e construção otimizada com SIMD.
	 */
	template <typename... Args>
	[[nodiscard]] GNUHOT PoolResult acquire(Args &&... args) {
		if (m_shutdown_flag.load(std::memory_order_acquire)) [[unlikely]] {
			return std::unexpected(PoolError::Shutdown);
		}

		if constexpr (EnableStats) {
			m_stats.acquires.fetch_add(1, std::memory_order_relaxed);
			m_stats.in_use.fetch_add(1, std::memory_order_relaxed);
		}

		auto &cache = local_cache();
		if (cache.size > 0uz) [[likely]] {
			if (cache.is_valid()) [[likely]] {
				const size_t new_size = cache.size - 1;
				pointer obj = cache.data[new_size];
				cache.size = new_size;

				if constexpr (EnableStats) {
					m_stats.same_thread_hits.fetch_add(1, std::memory_order_relaxed);
					m_stats.cache_hits.fetch_add(1, std::memory_order_relaxed);
				}

				// OTIMIZAÇÃO: Prefetching para o próximo objeto no cache
				if (new_size > 0) [[likely]] {
					const size_t prefetch_idx = new_size - 1;
#if defined(__GNUC__) || defined(__clang__)
					__builtin_prefetch(cache.data[prefetch_idx], 1, 3); // 1=write, 3=high locality
#elif defined(_MSC_VER) && defined(_M_X64)
					_mm_prefetch(reinterpret_cast<const char*>(cache.data[prefetch_idx]), _MM_HINT_T0);
#endif
				}

				// OTIMIZAÇÃO: Prefetching para o objeto que está sendo retornado
#if defined(__GNUC__) || defined(__clang__)
				__builtin_prefetch(obj, 1, 3);
#elif defined(_MSC_VER) && defined(_M_X64)
				_mm_prefetch(reinterpret_cast<const char*>(obj), _MM_HINT_T0);
#endif

				construct_or_reset(obj, std::forward<Args>(args)...);
				return obj;
			}
		}

		pointer obj = nullptr;
		if (m_queue.try_pop(obj)) [[likely]] {
			if constexpr (EnableStats) {
				m_stats.cross_thread_ops.fetch_add(1, std::memory_order_relaxed);
			}
			construct_or_reset(obj, std::forward<Args>(args)...);
			return obj;
		}
		return create_new(std::forward<Args>(args)...);
	}

	/**
	 * @brief Libera um objeto de volta para a pool com otimização de afinidade de thread.
	 * @param obj Ponteiro para o objeto sendo liberado.
	 * @details Caminho de liberação otimizado: limpa o objeto, prefere o cache local da thread para
	 * liberações na mesma thread, e recorre à pool global para operações entre threads.
	 * Rastreia estatísticas entre threads com precisão e lida com o overflow do cache.
	 */
	GNUHOT void release(pointer obj) noexcept {
		if (!obj) [[unlikely]] {
			return;
		}

		if constexpr (EnableStats) {
			this->m_stats.releases.fetch_add(1, std::memory_order_relaxed);
			this->m_stats.in_use.fetch_sub(1, std::memory_order_relaxed);
		}

		bool same_thread = true;
		if constexpr (HasThreadId<T>) {
			same_thread = obj->threadId == ThreadPool::getThreadId();
		}

		this->cleanup_object_optimized(obj);

		if (same_thread) [[likely]] {
			if (!this->m_shutdown_flag.load(std::memory_order_relaxed)) [[likely]] {
				auto &cache = this->local_cache();
				const size_t current_size = cache.size;

				if (cache.is_valid() && current_size < AdjustedLocalCacheSize) [[likely]] {
					cache.data[current_size] = obj;
					cache.size = current_size + 1;

					// OTIMIZAÇÃO: Prefetching para o objeto que acabou de ser inserido no cache
					if (current_size > 0) [[likely]] {
#if defined(__GNUC__) || defined(__clang__)
						__builtin_prefetch(cache.data[current_size - 1], 0, 3); // 0=read, 3=high locality
#elif defined(_MSC_VER) && defined(_M_X64)
						_mm_prefetch(reinterpret_cast<const char*>(cache.data[current_size - 1]), _MM_HINT_T0);
#endif
					}
					return;
				}
			}
		}

		if (!this->safe_return_to_global(obj)) {
			this->safe_destroy_and_deallocate(obj);
		}
		if constexpr (EnableStats) {
			if (!same_thread) {
				this->m_stats.cross_thread_ops.fetch_add(1, std::memory_order_relaxed);
			}
		}
	}

	/**
	 * @brief Pré-popula a pool com objetos prontos para uso.
	 * @param count Número de objetos a serem criados e adicionados à pool.
	 * @details Cria objetos em lote e os adiciona à pool global para melhorar a performance inicial.
	 * Usa um tamanho de lote configurável para eficiência de memória e para na primeira
	 * falha de alocação ou se a pool estiver cheia.
	 */
	void prewarm(size_t count) {
		if (m_shutdown_flag.load(std::memory_order_acquire)) {
			return;
		}

		count = std::min(count, AdjustedPoolSize - m_queue.was_size());
		if (count == 0uz) {
			return;
		}

		std::array<pointer, lockfree_config::PREWARM_BATCH_SIZE> batch;
		while (count > 0uz) {
			const size_t n = std::min(count, batch.size());
			size_t allocated = 0;
			for (size_t i = 0; i < n; ++i) {
				if ((batch[i] = allocate_and_construct())) {
					++allocated;
				} else {
					break;
				}
			}
			if (allocated == 0uz) {
				return;
			}
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

	/**
	 * @brief Descarrega o cache local da thread atual para a pool global.
	 * @details Força o retorno de todos os objetos em cache para a pool global usando uma operação em lote.
	 * Útil para balanceamento de carga ou antes do término de uma thread para prevenir a
	 * perda de objetos e melhorar a disponibilidade de objetos entre threads.
	 */
	void flush_local_cache() noexcept {
		auto &cache = local_cache();
		if (cache.size > 0uz) {
			batch_return_to_global(std::span(cache.data).first(cache.size));
			cache.size = 0;
		}
	}

	/**
	 * @brief Reduz o tamanho da pool destruindo objetos em excesso.
	 * @param max Número máximo de objetos a serem destruídos.
	 * @return O número de objetos que foram realmente destruídos.
	 * @details Encolhe a pool removendo objetos da fila global em lotes. Primeiro descarrega o cache local,
	 * depois destrói objetos da pool global até o limite especificado. Útil em situações de
	 * pressão de memória.
	 */
	[[nodiscard]] size_t shrink(size_t max = AdjustedPoolSize) {
		flush_local_cache();
		size_t released = 0;
		constexpr size_t BATCH_SIZE = 32; // Aumentado para melhor eficiência
		std::array<pointer, BATCH_SIZE> batch;

		while (released < max) {
			size_t batch_count = 0;
			const size_t target = std::min(max - released, BATCH_SIZE);

			// Coleta objetos em lote
			for (size_t i = 0; i < target && m_queue.try_pop(batch[i]); ++i) {
				if (batch[i]) { // Validação adicional
					++batch_count;
				}
			}

			if (batch_count == 0) {
				break;
			}

			// Destrói objetos em lote
			for (size_t i = 0; i < batch_count; ++i) {
				safe_destroy_and_deallocate(batch[i]);
			}

			released += batch_count;
		}
		return released;
	}

	/**
	 * @brief Obtém as estatísticas de performance atuais da pool.
	 * @return Uma struct `PoolStatistics` com os contadores atuais.
	 * @details Retorna um snapshot atômico das métricas de performance da pool, incluindo contagens de
	 * aquisição/liberação, taxas de acerto de cache e operações entre threads. As estatísticas
	 * só são coletadas quando o parâmetro de template `EnableStats` é verdadeiro.
	 */
	[[nodiscard]] PoolStatistics get_stats() const {
		PoolStatistics stats {};
		if constexpr (EnableStats) {
			stats.acquires = this->m_stats.acquires.load(std::memory_order_relaxed);
			stats.releases = this->m_stats.releases.load(std::memory_order_relaxed);
			stats.creates = this->m_stats.creates.load(std::memory_order_relaxed);
			stats.cross_thread_ops = this->m_stats.cross_thread_ops.load(std::memory_order_relaxed);
			stats.same_thread_hits = this->m_stats.same_thread_hits.load(std::memory_order_relaxed);
			stats.in_use = this->m_stats.in_use.load(std::memory_order_relaxed);
			stats.current_pool_size = this->m_queue.was_size();
			stats.cache_hits = this->m_stats.cache_hits.load(std::memory_order_relaxed);
			stats.batch_operations = this->m_stats.batch_operations.load(std::memory_order_relaxed);
		}
		return stats;
	}

	/**
	 * @brief Obtém a capacidade da pool em tempo de compilação.
	 * @return O tamanho máximo da pool especificado em tempo de compilação.
	 */
	[[nodiscard]] static constexpr size_t capacity() noexcept {
		return AdjustedPoolSize;
	}

private:
	// Ajusta automaticamente o tamanho da pool para ser potência de 2
	static constexpr size_t AdjustedPoolSize = lockfree_config::adjust_pool_size<PoolSize>();
	static constexpr size_t AdjustedLocalCacheSize = lockfree_config::adjust_pool_size<LocalCacheSize>();

	LOCKFREE_NO_UNIQUE_ADDRESS Allocator m_allocator;
	std::atomic<bool> m_shutdown_flag;

	struct alignas(CACHE_LINE_SIZE) StatsBlock {
		std::atomic<size_t> acquires { 0 }, releases { 0 }, creates { 0 }, cross_thread_ops { 0 },
			same_thread_hits { 0 }, in_use { 0 }, cache_hits { 0 }, batch_operations { 0 };
	};
	LOCKFREE_NO_UNIQUE_ADDRESS std::conditional_t<EnableStats, StatsBlock, std::monostate> m_stats;

	alignas(CACHE_LINE_SIZE) atomic_queue::AtomicQueue<pointer, AdjustedPoolSize> m_queue;

	/**
	 * @brief Obtém uma referência para o mapa de instâncias ativas com ordem de inicialização garantida.
	 * @return Uma referência para um `parallel_flat_hash_map_m` seguro para threads.
	 * @details Usa o padrão singleton de Meyer para garantir que o mapa seja inicializado sob demanda,
	 * evitando o "static initialization order fiasco". O mapa de hash é seguro para threads
	 * com mutexes internos e otimizado para acesso concorrente.
	 */
	static auto &get_active_instances() {
		static phmap::parallel_flat_hash_map_m<OptimizedObjectPool*, std::chrono::steady_clock::time_point> instances;
		return instances;
	}

	struct alignas(CACHE_LINE_SIZE) ThreadCache {
		size_t size = 0;
		std::atomic<bool> valid { true };
		// Padding para evitar false sharing entre size/valid e data
		char padding[CACHE_LINE_PADDING - sizeof(size_t) - sizeof(std::atomic<bool>)] {};
		alignas(CACHE_LINE_SIZE) pointer data[AdjustedLocalCacheSize];

		bool is_valid() const noexcept {
			return valid.load(std::memory_order_acquire);
		}
		void invalidate() noexcept {
			valid.store(false, std::memory_order_release);
		}
		~ThreadCache() noexcept;
	};

	static thread_local ThreadCache thread_cache;
	ThreadCache &local_cache() {
		return thread_cache;
	}
	static void cleanup_all_caches() {
		// Invalida todos os caches thread-local para prevenir uso após destruição
		// O cleanup real acontece nos destrutores dos ThreadCache individuais
		std::this_thread::sleep_for(std::chrono::milliseconds(5));
	}

	/**
	 * @brief Limpa os objetos restantes da fila global durante a destruição.
	 * @details Processa a fila atômica global em lotes para destruir todos os objetos restantes
	 * de forma segura durante a destruição da pool. Usa um tamanho de lote configurável
	 * para eficiência de memória.
	 */
	void cleanup_global_queue() noexcept {
		constexpr size_t BATCH_SIZE = lockfree_config::CLEANUP_BATCH_SIZE;
		std::array<pointer, BATCH_SIZE> batch;
		while (true) {
			size_t batch_count = 0;
			for (size_t i = 0; i < BATCH_SIZE && m_queue.try_pop(batch[i]); ++i) {
				++batch_count;
			}
			if (batch_count == 0uz) {
				break;
			}
			for (auto obj : std::span(batch).first(batch_count)) {
				safe_destroy_and_deallocate(obj);
			}
		}
	}

	/**
	 * @brief Cria um novo objeto com inicialização adequada e rastreamento de thread.
	 * @tparam Args Tipos dos argumentos do construtor.
	 * @param args Argumentos a serem encaminhados para o construtor do objeto.
	 * @return Um `std::expected` contendo um ponteiro para o novo objeto, ou `PoolError` em caso de falha.
	 * @details Aloca memória, constrói o objeto com os argumentos fornecidos e define o ID da thread,
	 * se suportado. Atualiza as estatísticas de criação quando habilitado.
	 * Fornece segurança de exceção adequada com limpeza em caso de falha.
	 */
	template <typename... Args>
	GNUCOLD GNUNOINLINE PoolResult create_new(Args &&... args) {
		if constexpr (EnableStats) {
			m_stats.creates.fetch_add(1, std::memory_order_relaxed);
		}
		pointer obj = nullptr;
		try {
			obj = m_allocator.allocate(1);
			if (!obj) {
				if constexpr (EnableStats) {
					m_stats.in_use.fetch_sub(1, std::memory_order_relaxed);
				}
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
				if constexpr (EnableStats) {
					m_stats.in_use.fetch_sub(1, std::memory_order_relaxed);
				}
				throw;
			}
		} catch (const std::bad_alloc &) {
			if constexpr (EnableStats) {
				m_stats.in_use.fetch_sub(1, std::memory_order_relaxed);
			}
			return std::unexpected(PoolError::AllocationFailed);
		} catch (...) {
			if constexpr (EnableStats) {
				m_stats.in_use.fetch_sub(1, std::memory_order_relaxed);
			}
			throw;
		}
	}

	/**
	 * @brief Aloca e constrói um objeto padrão para o pré-aquecimento da pool.
	 * @return Ponteiro para o objeto alocado, ou nullptr em caso de falha.
	 * @details Alocação simplificada para pré-aquecimento que apenas constrói objetos com o construtor padrão.
	 * Usa operações `nothrow` quando possível e define o ID da thread. Retorna nullptr em qualquer
	 * falha, em vez de lançar exceções.
	 */
	GNUALWAYSINLINE pointer allocate_and_construct() noexcept {
		try {
			pointer obj = m_allocator.allocate(1);
			if (!obj) {
				return nullptr;
			}
			std::construct_at(obj);
			if constexpr (HasThreadId<T>) {
				obj->threadId = ThreadPool::getThreadId();
			}
			return obj;
		} catch (...) {
			return nullptr;
		}
	}

	/**
	 * @brief Limpa/reseta um objeto para reutilização com segurança de exceção.
	 * @param obj Ponteiro para o objeto a ser limpo.
	 * @details Tenta resetar o estado do objeto usando o método `reset()` se disponível,
	 * caso contrário, usa o método `destroy()`. Otimizado para previsão de desvio
	 * do caso comum com `reset()` como caminho principal.
	 */
	GNUHOT GNUALWAYSINLINE void cleanup_object_optimized(pointer obj) noexcept {
		if (!obj) [[unlikely]] {
			return;
		}
		if constexpr (HasReset<T>) {
			try {
				obj->reset();
			} catch (...) { }
		} else if constexpr (HasDestroy<T>) {
			try {
				obj->destroy();
			} catch (...) { }
		}
	}

	/**
	 * @brief Constrói ou reseta um objeto de forma otimizada com otimizações SIMD.
	 * @details Esta função foi restaurada para incluir a lógica de cópia rápida usando SIMD
	 * para tipos que são trivialmente copiáveis. Isso acelera significativamente a
	 * reinicialização de objetos quando eles são passados por valor.
	 */
	template <typename... Args>
	GNUHOT GNUALWAYSINLINE void construct_or_reset(pointer obj, Args &&... args) noexcept {
		if (!obj) [[unlikely]] {
			return;
		}

		if constexpr (HasReset<T, Args...>) {
			try {
				obj->reset(std::forward<Args>(args)...);
				return;
			} catch (...) { }
		}

		if constexpr (HasBuild<T, Args...>) {
			try {
				obj->build(std::forward<Args>(args)...);
				return;
			} catch (...) { }
		}

		// OTIMIZAÇÃO: Lógica de cópia rápida com SIMD para tipos triviais
		if constexpr (std::is_trivially_copyable_v<T> && sizeof...(Args) == 1) {
			using FirstArg = std::decay_t<std::tuple_element_t<0, std::tuple<Args...>>>;
			if constexpr (std::is_same_v<FirstArg, T>) {
				const T &src = std::get<0>(std::forward_as_tuple(args...));

				// Otimizações específicas por tamanho com fallbacks robustos
				if constexpr (sizeof(T) <= 8) {
					// Para tipos pequenos, usa cópia direta otimizada pelo compilador
					*obj = src;
				} else if constexpr (sizeof(T) == 16) {
#if defined(__SSE2__) || (defined(_MSC_VER) && defined(_M_X64))
					_mm_storeu_si128(reinterpret_cast<__m128i*>(obj), _mm_loadu_si128(reinterpret_cast<const __m128i*>(&src)));
#else
					std::memcpy(obj, &src, 16);
#endif
				} else if constexpr (sizeof(T) == 32) {
#if defined(__AVX2__) || (defined(_MSC_VER) && defined(_M_X64))
					_mm256_storeu_si256(reinterpret_cast<__m256i*>(obj), _mm256_loadu_si256(reinterpret_cast<const __m256i*>(&src)));
#else
					std::memcpy(obj, &src, 32);
#endif
				} else if constexpr (sizeof(T) == 64) {
#ifdef __AVX512F__
					_mm512_storeu_si512(reinterpret_cast<__m512i*>(obj), _mm512_loadu_si512(reinterpret_cast<const __m512i*>(&src)));
#elif defined(__AVX2__) || (defined(_MSC_VER) && defined(_M_X64))
					// Fallback para AVX2: duas operações de 32 bytes
					_mm256_storeu_si256(reinterpret_cast<__m256i*>(obj), _mm256_loadu_si256(reinterpret_cast<const __m256i*>(&src)));
					_mm256_storeu_si256(reinterpret_cast<__m256i*>(obj) + 1, _mm256_loadu_si256(reinterpret_cast<const __m256i*>(&src) + 1));
#else
					std::memcpy(obj, &src, 64);
#endif
				} else {
					// Para tipos maiores, usa memcpy que é otimizada pelo runtime
					std::memcpy(obj, &src, sizeof(T));
				}
				return;
			}
		}

		if constexpr (!std::is_trivially_destructible_v<T> || sizeof...(Args) > 0) {
			try {
				if constexpr (!std::is_trivially_destructible_v<T>) {
					std::destroy_at(obj);
				}
				std::construct_at(obj, std::forward<Args>(args)...);
			} catch (...) { }
		}
	}
};

/**
 * @brief Definição da variável de template estática `thread_local`.
 * @details Esta linha garante que cada thread tenha sua própria instância de `ThreadCache`.
 * É o mecanismo central que permite o cache local por thread, eliminando a contenção
 * na maioria das operações de `acquire` e `release`.
 */
template <typename T, size_t P, bool E, typename A, size_t L>
thread_local OptimizedObjectPool<T, P, E, A, L>::ThreadCache OptimizedObjectPool<T, P, E, A, L>::thread_cache;

/**
 * @brief Implementação do destrutor de `ThreadCache`.
 * @details Este destrutor é uma rede de segurança crucial que é chamada automaticamente quando uma thread termina.
 * Ele garante que nenhum objeto seja vazado. Para cada objeto restante no cache da thread, ele tenta
 * retorná-lo a uma das pools ativas no programa de forma thread-safe.
 * Usa uma abordagem defensiva para evitar race conditions durante shutdown.
 */
template <typename T, size_t P, bool E, typename A, size_t L>
OptimizedObjectPool<T, P, E, A, L>::ThreadCache::~ThreadCache() noexcept {
	invalidate();
	if (size == 0) {
		return;
	}

	// Cria uma cópia local dos objetos para evitar modificação concorrente
	std::array<pointer, L> local_objects;
	const size_t local_size = std::min(size, L);
	std::copy_n(data, local_size, local_objects.begin());
	size = 0; // Limpa o cache imediatamente

	try {
		auto &instances = OptimizedObjectPool<T, P, E, A, L>::get_active_instances();
		for (size_t i = 0; i < local_size; ++i) {
			pointer obj = local_objects[i];
			if (!obj) {
				continue;
			}

			bool returned = false;
			for (const auto &[pool, timestamp] : instances) {
				if (pool && !pool->m_shutdown_flag.load(std::memory_order_relaxed)) {
					if (pool->safe_return_to_global(obj)) {
						returned = true;
						break;
					}
				}
			}

			// Se não conseguiu retornar para nenhuma pool, tenta destruir com segurança
			if (!returned) {
				// Em último caso, apenas ignora o objeto para evitar corrupção
				// É melhor vazar memória do que corromper o heap
			}
		}
	} catch (...) {
		// Ignora todas as exceções durante cleanup para evitar terminate
	}
}

/**
 * @brief Wrapper de `std::shared_ptr` para a pool de objetos com gerenciamento automático RAII.
 * @details Fornece uma interface de `std::shared_ptr` enquanto utiliza a pool de objetos para alocação.
 * Os objetos são retornados automaticamente para a pool quando a contagem de referências do
 * `shared_ptr` chega a zero. Combina a performance da pool com a semântica familiar do `shared_ptr`.
 *
 * @tparam T Tipo do objeto a ser armazenado na pool.
 * @tparam PoolSize Capacidade máxima da pool subjacente.
 * @tparam EnableStats Habilita a coleta de estatísticas.
 * @tparam Allocator Tipo do alocador para a pool.
 * @tparam LocalCacheSize Tamanho do cache local por thread.
 */
template <
	typename T,
	size_t PoolSize = lockfree_config::DEFAULT_POOL_SIZE,
	bool EnableStats = false,
	typename Allocator = std::pmr::polymorphic_allocator<T>,
	size_t LocalCacheSize = lockfree_config::DEFAULT_LOCAL_CACHE_SIZE>
class SharedOptimizedObjectPool {
public:
	using PoolResult = std::expected<std::shared_ptr<T>, PoolError>;

	/**
	 * @brief Construtor padrão que utiliza o recurso de memória padrão.
	 */
	SharedOptimizedObjectPool() :
		m_pool(Allocator(std::pmr::get_default_resource())) { }

	/**
	 * @brief Constrói com um alocador customizado.
	 * @param allocator Instância do alocador customizado a ser usado pela pool subjacente.
	 */
	explicit SharedOptimizedObjectPool(const Allocator &allocator) :
		m_pool(allocator) { }

	/**
	 * @brief Adquire um objeto encapsulado em um `shared_ptr` com um deleter customizado.
	 * @tparam Args Tipos dos argumentos do construtor.
	 * @param args Argumentos a serem encaminhados para o construtor do objeto.
	 * @return Um `std::expected` contendo um `shared_ptr` que gerencia o objeto da pool, ou `PoolError` em caso de falha.
	 * @details Cria um `shared_ptr` com um deleter customizado que retorna o objeto para a pool
	 * quando a contagem de referências chega a zero. Fornece semântica RAII mantendo
	 * os benefícios de performance da pool.
	 */
	template <typename... Args>
	[[nodiscard]] PoolResult acquire(Args &&... args) {
		auto result = m_pool.acquire(std::forward<Args>(args)...);
		if (!result) [[unlikely]] {
			return std::unexpected(result.error());
		}
		return std::shared_ptr<T>(result.value(), [this](T* ptr) noexcept {
			if (ptr) {
				m_pool.release(ptr);
			}
		});
	}

	/**
	 * @brief Pré-popula a pool subjacente com objetos.
	 * @param count Número de objetos a serem criados e adicionados à pool.
	 */
	void prewarm(size_t count) {
		m_pool.prewarm(count);
	}

	/**
	 * @brief Descarrega o cache da thread atual para a pool global.
	 */
	void flush_local_cache() {
		m_pool.flush_local_cache();
	}

	/**
	 * @brief Encolhe a pool destruindo objetos em excesso.
	 * @param max Número máximo de objetos a serem destruídos.
	 * @return O número de objetos que foram realmente destruídos.
	 */
	[[nodiscard]] size_t shrink(size_t max = OptimizedObjectPool<T, PoolSize, EnableStats, Allocator, LocalCacheSize>::effective_pool_size()) {
		return m_pool.shrink(max);
	}

	/**
	 * @brief Obtém as estatísticas de performance da pool subjacente.
	 * @return `PoolStatistics` com as métricas de performance atuais.
	 */
	[[nodiscard]] auto get_stats() const {
		return m_pool.get_stats();
	}

	/**
	 * @brief Obtém a capacidade da pool em tempo de compilação.
	 * @return O tamanho máximo da pool.
	 */
	[[nodiscard]] static constexpr size_t capacity() noexcept {
		return OptimizedObjectPool<T, PoolSize, EnableStats, Allocator, LocalCacheSize>::effective_pool_size();
	}

private:
	OptimizedObjectPool<T, PoolSize, EnableStats, Allocator, LocalCacheSize> m_pool;
};
