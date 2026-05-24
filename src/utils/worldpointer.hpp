/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2026 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <atomic>
#include <cassert>
#include <compare>
#include <cstddef>
#include <memory>
#include <memory_resource>
#include <new>
#include <type_traits>
#include <utility>

// World pointers are used to manage the memory of in-game objects in a
// reasonably efficient and safe manner, replacing `shared_ptr<T>` which has
// unwanted performance characteristics, especially in multi-threaded
// scenarios.
//
// The idea is to avoid the constant reference bumping by saying that the game
// world keeps a single reference to the object, and enforcing that there's
// only a single owner inside the game world. This is done with the affine
// `WorldPtr<T>::Owning` type which is somewhat analogous to
// `unique_ptr<shared_ptr<T>>`, except that it uses Quiescent State Based
// Reclamation (QBSR) instead of cleaning up straight away.
//
// While we can certainly use `WorldPtr<T>::Owning` for a lot of things, we
// sometimes need to store pointers in intermediate containers or whatnot which
// we can't do with an affine type. For that we have `WorldPtr<T>::Borrowed`
// which is valid until the next Quiescent State, which is to say the next game
// world tick. We can copy these to our heart's content as long as we don't
// keep them across ticks.
//
// For the cases where we do need to keep something across a tick, both of
// these pointer types implicitly cast to `WorldPtr<T>::Shared` which employs
// plain reference counting, extending the lifetime of the object. Note that
// we can do this with a borrowed pointer even after the respective
// `WorldPtr<T>::Owning` has been destroyed, since the underlying object is
// still valid.
//
// Note that there is no way to create a `WorldPtr<T>::Shared` directly: we
// always start with an owning pointer and then share or borrow it as needed.
// This is a largely arbitrary design choice, but there is little reason to
// create one of these without the intent of putting it into the game world,
// and if we allow the creation of owning pointers from shared ones that were
// created on the outside, we risk violating the affine invariant.
//
// ****************************************************************************
//
// `WorldPtr<T, YourAllocatorType>::quiescentState` must be invoked for each
// `T`. The per-(T, Allocator) statics inside `BlockAllocator` are `inline
// static` — the C++17 ODR rule deduplicates them across all TUs that
// instantiate the same `(T, Allocator)` pair, so no per-type boilerplate is
// required from the user.
//
// Since the game world is single-threaded for now, the quiescent states are
// always "global" and it's trivial for us to guarantee that a borrowed pointer
// never outlives a world tick. Once the game world becomes multi-threaded, we
// will need to synchronize the quiescent states across all threads, which is
// fairly trivial to do with epochs.
template <typename T>
struct WorldPtr {
	WorldPtr() = delete;

	struct Block;

	using DefaultAllocator = std::allocator<Block>;
	template <typename Allocator = DefaultAllocator>
	class Base;
	template <typename Allocator = DefaultAllocator>
	class Owning;
	template <typename Allocator = DefaultAllocator>
	class Borrowed;
	template <typename Allocator = DefaultAllocator>
	class Shared;

	template <typename Allocator>
	struct BlockAllocator {
		// Inline-defined so a single `(T, Allocator)` instantiation gets one
		// shared definition across every TU that touches it — no per-type
		// `template<> template<> ... = nullptr;` boilerplate in user code.
		inline static Block* retirees = nullptr;
		inline static Allocator instance {};
	};

	struct Block {
		std::atomic_size_t reference_count;

		// Intrusive list of retired pointers so we won't need an allocation
		// every time an object is retired. The actual type is
		// `Base<Allocator>` but circular dependencies suck.
		void* next;

		// The value itself; `Base<Allocator>::inner_` always points here.
		//
		// Note that, since the idea is to mostly use owning or borrowed
		// pointers which don't touch the reference count, there's little
		// reason to waste memory aligning this to the next cache line.
		T value;

		// `requires` clause excludes the `Block(Block&)` / `Block(Block&&)` /
		// `Block(const Block&)` paths so the variadic forwarding constructor
		// cannot accidentally outcompete the implicitly-declared copy/move
		// constructors when called with a single `Block` argument. In
		// practice no caller constructs Block directly (Block is private to
		// WorldPtr<T> and only built via `Owning::make` → `newObject` →
		// `AllocTraits::construct`), so this is defensive; the constraint
		// makes that intent explicit (and silences cpp:S6458).
		template <typename... Args>
			requires(sizeof...(Args) != 1
		             || !(std::is_same_v<std::remove_cvref_t<Args>, Block> || ...))
		Block(Args &&... args) :
			reference_count(1), value(std::forward<Args>(args)...) { }

		static void incrementReferenceCount(Block* block) noexcept {
			block->reference_count.fetch_add(1, std::memory_order_relaxed);
		}

		template <typename Allocator>
		static void decrementReferenceCount(Block* block) noexcept {
			// Future work: we can weaken this memory barrier if dropping
			// all references moves an object to the retiree list, and the
			// actual deletion is done after all threads have executed a
			// full memory barrier (essentially amortizing it). This imposes
			// some requirements on the non-game threads though so it's better
			// explored in the future.
			if (block->reference_count.fetch_sub(1, std::memory_order_acq_rel) == 1) {
				using AllocTraits = std::allocator_traits<Allocator>;
				auto &alloc = BlockAllocator<Allocator>::instance;
				AllocTraits::destroy(alloc, block);
				AllocTraits::deallocate(alloc, block, 1);
			}
		}

		// CAS-loop: bump refcount only if currently > 0. Returns true on
		// success. Mirrors the `tryIncrementStrong` helper used by PolyPtr.
		// Closes the in-tick window between `Owning::~Owning` retire-push
		// and the next `quiescentState()` drain — without it,
		// `Borrowed::operator Shared()` would resurrect a block whose
		// retire was already enqueued but not yet drained.
		//
		// CAVEAT: this only protects against the in-tick race. WorldPtr
		// (unlike PolyPtr) has no weak group keeping the block memory
		// alive after refcount hits 0; if the caller holds a Borrowed
		// past quiescentState, the block memory itself may have been
		// deallocated and reading `reference_count` here is UB. Callers
		// of `Borrowed::share()` MUST observe the tick-bound contract.
		static bool tryIncrementReferenceCount(Block* block) noexcept {
			size_t cur = block->reference_count.load(std::memory_order_relaxed);
			while (cur != 0) {
				if (block->reference_count.compare_exchange_weak(
						cur, cur + 1,
						std::memory_order_acq_rel,
						std::memory_order_relaxed
					)) {
					return true;
				}
			}
			return false;
		}
	};

	template <typename Allocator>
	class Base {
		Block* getBlock() const noexcept {
			// `offsetof` is conditionally-supported for non-standard-layout
			// types (C++17 §22.2.4/3). The previous
			// `static_assert(is_standard_layout_v<Block>)` was over-strict:
			// Mount and Outfit contain `std::string`, and on MSVC's debug
			// STL (the `/MDd` build path used by `Compile (Solution)`)
			// `std::string` carries container-proxy bookkeeping that
			// disqualifies it from standard-layout. Every compiler we
			// support (MSVC, GCC, Clang) computes the correct member
			// offset regardless, and the runtime arithmetic is identical.
			//
			// GCC's `-Winvalid-offsetof` is the only diagnostic that
			// fires; silenced locally so other TUs that include this
			// header are unaffected.
#if defined(__GNUC__) && !defined(__clang__)
	#pragma GCC diagnostic push
	#pragma GCC diagnostic ignored "-Winvalid-offsetof"
#endif
			if (inner_) {
				return reinterpret_cast<Block*>(
					reinterpret_cast<char*>(inner_) - offsetof(Block, value)
				);
			}
#if defined(__GNUC__) && !defined(__clang__)
	#pragma GCC diagnostic pop
#endif

			return nullptr;
		}

	protected:
		T* inner_;

		Base() noexcept :
			inner_(nullptr) { }

		Base(T* pointer) noexcept :
			inner_(pointer) { }

		// This is a bit ugly, but `Base(Args&&...args)` could potentially
		// alias the `Base(T*)` constructor.
		template <typename... Args>
		[[nodiscard]] static T* newObject(Args &&... args) {
			using AllocTraits = std::allocator_traits<Allocator>;
			auto &alloc = BlockAllocator<Allocator>::instance;
			auto* block = AllocTraits::allocate(alloc, 1);

			try {
				AllocTraits::construct(
					alloc,
					block,
					std::forward<Args>(args)...
				);
			} catch (...) {
				AllocTraits::deallocate(alloc, block, 1);
				throw;
			}

			return &block->value;
		}

		void incrementReferenceCount() const noexcept {
			if (auto block = getBlock()) {
				Block::incrementReferenceCount(block);
			}
		}

		// Tries to bump refcount, returns false if already 0 (block being
		// destroyed). Used by `Borrowed::operator Shared()` so a Borrowed
		// observed before the source Owning died (but converted after)
		// cannot resurrect a retired block.
		[[nodiscard]] bool tryIncrementReferenceCount() const noexcept {
			if (auto block = getBlock()) {
				return Block::tryIncrementReferenceCount(block);
			}
			return false;
		}

		void decrementReferenceCount() const noexcept {
			if (auto block = getBlock()) {
				Block::template decrementReferenceCount<Allocator>(block);
			}
		}

		void retire() const noexcept {
			if (auto block = getBlock()) {
				assert(useCount() > 0);

				block->next = BlockAllocator<Allocator>::retirees;
				BlockAllocator<Allocator>::retirees = block;
			}
		}

		void set(T* value) noexcept {
			inner_ = value;
		}

		size_t useCount() const noexcept {
			auto block = getBlock();
			assert(block != nullptr);
			// NOSONAR cpp:S3519 — `block` is recovered from `inner_` via
			// `offsetof(Block, value)`, so it correctly points to the start
			// of the intrusive control block. SonarCloud's static analyzer
			// tracks `block` as `&value - 16` and flags `reference_count`
			// (at Block offset 0) as a "negative byte offset -16" access
			// relative to `value` — that's the intentional intrusive layout,
			// not an out-of-bounds.
			return block->reference_count.load(std::memory_order_relaxed); // NOSONAR
		}

	public:
		[[nodiscard]] T* get() const noexcept {
			return inner_;
		}

		[[nodiscard]] T* operator->() const noexcept {
			assert(get() != nullptr);
			return get();
		}

		[[nodiscard]] T &operator*() const noexcept {
			assert(get() != nullptr);
			return *get();
		}

		[[nodiscard]] explicit operator bool() const noexcept {
			return static_cast<bool>(get());
		}

		[[nodiscard]] bool operator==(std::nullptr_t) const noexcept {
			return !static_cast<bool>(get());
		}
	};

	template <typename Allocator>
	class Shared : public Base<Allocator> {
		using super = Base<Allocator>;

		Shared(T* pointer) noexcept :
			super(pointer) { }

		friend class Borrowed<Allocator>;
		friend class Owning<Allocator>;

	public:
		// Re-introduce Base's `operator==(nullptr_t)` so it isn't hidden
		// by this class's own `operator==(const Shared&)` per C++ name
		// hiding rules. MSVC's C++20 rewriter is otherwise unhappy with
		// `s == nullptr` / `s != nullptr`.
		using Base<Allocator>::operator==;

		Shared() noexcept = default;
		// `explicit` blocks the C++20 rewriter from synthesising
		// `Shared(nullptr)` as the rhs of `s != nullptr`, which would
		// otherwise collide with `Base::operator==(nullptr_t)`.
		explicit Shared(std::nullptr_t) noexcept :
			super(nullptr) { }

		Shared(Shared &&other) noexcept :
			super(std::exchange(other.inner_, nullptr)) { }

		Shared(const Shared &other) noexcept :
			super(other.get()) {
			this->incrementReferenceCount();
		}

		~Shared() noexcept {
			this->decrementReferenceCount();
		}

		Shared &operator=(Shared &&other) noexcept {
			if (this != &other) {
				this->decrementReferenceCount();
				this->set(std::exchange(other.inner_, nullptr));
			}

			return *this;
		}

		Shared &operator=(const Shared &other) noexcept {
			if (this->get() != other.get()) {
				this->decrementReferenceCount();
				other.incrementReferenceCount();

				this->set(other.get());
			}

			return *this;
		}

		Shared &operator=(std::nullptr_t) noexcept {
			if (this->get() != nullptr) {
				this->decrementReferenceCount();
				this->set(nullptr);
			}
			return *this;
		}

		[[nodiscard]] bool operator==(const Shared &other) const noexcept {
			return this->get() == other.get();
		}

		[[nodiscard]] size_t useCount() const noexcept {
			assert(this->get() != nullptr);
			return super::useCount();
		}
	};

	template <typename Allocator>
	class Borrowed : public Base<Allocator> {
		using super = Base<Allocator>;

		Borrowed(T* pointer) noexcept :
			super(pointer) { }

		friend class Owning<Allocator>;
		friend class Shared<Allocator>;

	public:
		using Base<Allocator>::operator==;

		Borrowed() noexcept = default;
		explicit Borrowed(std::nullptr_t) noexcept :
			super(nullptr) { }

		Borrowed(const Borrowed &) noexcept = default;
		Borrowed &operator=(const Borrowed &) noexcept = default;
		Borrowed(Borrowed &&) noexcept = default;
		Borrowed &operator=(Borrowed &&) noexcept = default;

		// Promote to Shared. Returns a null Shared when:
		//   - the Borrowed itself is null, OR
		//   - the block's refcount has reached 0 (Owning already destroyed,
		//     block enqueued on retire list, value destruction pending the
		//     next quiescentState drain). CAS-loop refuses to resurrect.
		//
		// Behaviour change from the previous version (bare `fetch_add`):
		// callers that assume `share()` always returns a valid Shared must
		// now check for null, same shape as `PolyPtr<T>::Borrowed::share()`
		// and `std::weak_ptr::lock()`.
		[[nodiscard]] operator Shared<Allocator>() const noexcept {
			if (!this->tryIncrementReferenceCount()) {
				return Shared<Allocator> {};
			}
			return Shared<Allocator>(this->get());
		}

		[[nodiscard]] bool operator==(const Borrowed &other) const noexcept {
			return this->get() == other.get();
		}

		[[nodiscard]] Shared<Allocator> share() const noexcept {
			return static_cast<Shared<Allocator>>(*this);
		}
	};

	template <typename Allocator>
	class Owning : public Base<Allocator> {
		using super = Base<Allocator>;

		Owning(T* pointer) noexcept :
			super(pointer) { }

	public:
		using Base<Allocator>::operator==;

		Owning() noexcept = default;
		explicit Owning(std::nullptr_t) noexcept :
			super(nullptr) { }

		Owning(Owning &&other) noexcept :
			super(std::exchange(other.inner_, nullptr)) { }

		Owning(const Owning &) = delete;
		Owning &operator=(const Owning &) = delete;

		~Owning() noexcept {
			this->retire();
		}

		Owning &operator=(Owning &&other) noexcept {
			if (this != &other) {
				this->retire();
				this->set(std::exchange(other.inner_, nullptr));
			}

			return *this;
		}

		Owning &operator=(std::nullptr_t) noexcept {
			reset();
			return *this;
		}

		[[nodiscard]] operator Shared<Allocator>() const noexcept {
			assert(this->get() != nullptr);
			this->incrementReferenceCount();
			return Shared<Allocator>(this->get());
		}

		[[nodiscard]] operator Borrowed<Allocator>() const noexcept {
			assert(this->get() != nullptr);
			return Borrowed<Allocator>(this->get());
		}

		[[nodiscard]] bool operator==(const Owning &other) const noexcept {
#ifndef NDEBUG
			// Since this is an affine type, two different instances must never
			// compare equal unless they're both null. Debug-only triple-check
			// (compiled out in release to keep == zero-cost).
			assert(this->get() == nullptr || ((this->get() == other.get()) == (this == &other)));
#endif
			return this->get() == other.get();
		}

		template <typename... Args>
		[[nodiscard]] static Owning make(Args &&... args) {
			return Owning(super::newObject(std::forward<Args>(args)...));
		}

		[[nodiscard]] Shared<Allocator> share() const noexcept {
			return static_cast<Shared<Allocator>>(*this);
		}

		[[nodiscard]] Borrowed<Allocator> borrow() const noexcept {
			return static_cast<Borrowed<Allocator>>(*this);
		}

		void reset() noexcept {
			this->retire();
			this->set(nullptr);
		}
	};

	template <typename Allocator = DefaultAllocator>
	static void quiescentState() {
		static_assert(!std::is_copy_constructible_v<Owning<Allocator>>);
		static_assert(std::is_copy_constructible_v<Borrowed<Allocator>>);
		static_assert(std::is_copy_constructible_v<Shared<Allocator>>);

		static_assert(!std::is_copy_assignable_v<Owning<Allocator>>);
		static_assert(std::is_copy_assignable_v<Borrowed<Allocator>>);
		static_assert(std::is_copy_assignable_v<Shared<Allocator>>);

		static_assert(std::is_move_assignable_v<Borrowed<Allocator>>);
		static_assert(std::is_move_assignable_v<Owning<Allocator>>);
		static_assert(std::is_move_assignable_v<Shared<Allocator>>);

		static_assert(!std::is_convertible_v<Borrowed<Allocator>, Owning<Allocator>>);
		static_assert(!std::is_convertible_v<Shared<Allocator>, Borrowed<Allocator>>);
		static_assert(!std::is_convertible_v<Shared<Allocator>, Owning<Allocator>>);
		static_assert(std::is_convertible_v<Borrowed<Allocator>, Shared<Allocator>>);
		static_assert(std::is_convertible_v<Owning<Allocator>, Borrowed<Allocator>>);
		static_assert(std::is_convertible_v<Owning<Allocator>, Shared<Allocator>>);

		static_assert(std::is_standard_layout_v<Base<Allocator>>);
		static_assert(std::is_standard_layout_v<Borrowed<Allocator>>);
		static_assert(std::is_standard_layout_v<Owning<Allocator>>);
		static_assert(std::is_standard_layout_v<Shared<Allocator>>);

		// `std::is_layout_compatible_v` is C++20 (P0466R5) but ships in
		// libc++ only with Xcode 16+ / macOS 14+. Apple Clang's libc++
		// on older macOS images (and on the GitHub-hosted macOS runner)
		// doesn't define it, so guard with the feature-test macro.
		// The check is a defence-in-depth assertion that the three
		// affine pointer wrappers and their `Base` share an identical
		// layout — required if anyone ever relies on type-punning
		// between them. Other compilers (GCC 12+, MSVC 19.30+) get it.
#if defined(__cpp_lib_is_layout_compatible) && __cpp_lib_is_layout_compatible >= 201907L
		static_assert(std::is_layout_compatible_v<Owning<Allocator>, Base<Allocator>>);
		static_assert(std::is_layout_compatible_v<Owning<Allocator>, Borrowed<Allocator>>);
		static_assert(std::is_layout_compatible_v<Owning<Allocator>, Shared<Allocator>>);
		static_assert(std::is_layout_compatible_v<Shared<Allocator>, Borrowed<Allocator>>);
#endif

		// Drain the retiree list, starting over again and again until it's
		// completely empty, as destroying objects can populate it.
		while (BlockAllocator<Allocator>::retirees != nullptr) {
			auto it = BlockAllocator<Allocator>::retirees;
			BlockAllocator<Allocator>::retirees = nullptr;

			while (it != nullptr) {
				auto next = static_cast<Block*>(it->next);
				Block::template decrementReferenceCount<Allocator>(it);
				it = next;
			}
		}
	}
};

// Make all pointer types hashable on the underlying object identity so that
// they work as a key in hash containers (e.g. phmap::parallel_flat_hash_set).
//
// Note that this requires the containers to explicitly use this as a custom
// hasher; we can't express this as a `std::hash` specialization unless we drop
// the idea of using custom allocators.
// Transparent hash for WorldPtr<T,Alloc>. Same rationale as PolyPtr's: a
// `find()` keyed on a Borrowed shouldn't need to materialise a Shared just to
// hash. Use together with `WorldPtrTransparentEqual<T,Alloc>`.
template <typename T, typename Allocator = typename WorldPtr<T>::DefaultAllocator>
struct WorldPtrTransparentHash {
	using is_transparent = void;

	size_t operator()(const typename WorldPtr<T>::template Shared<Allocator> &ptr) const noexcept {
		return std::hash<T*> {}(ptr.get());
	}
	size_t operator()(const typename WorldPtr<T>::template Borrowed<Allocator> &ptr) const noexcept {
		return std::hash<T*> {}(ptr.get());
	}
	size_t operator()(const typename WorldPtr<T>::template Owning<Allocator> &ptr) const noexcept {
		return std::hash<T*> {}(ptr.get());
	}
	size_t operator()(const T* ptr) const noexcept {
		// `std::hash<T*>` takes `T*`, not `const T*` — GCC's strict mode
		// rejects the implicit non-const conversion. Use the const
		// specialisation explicitly; the pointer-value hash is identical
		// either way, so this stays compatible with the transparent
		// `T*` / `Owning` / `Borrowed` / `Shared` / `Weak` overloads above.
		return std::hash<const T*> {}(ptr);
	}
};

template <typename T, typename Allocator = typename WorldPtr<T>::DefaultAllocator>
struct WorldPtrTransparentEqual {
	using is_transparent = void;

	template <typename A, typename B>
	bool operator()(const A &a, const B &b) const noexcept {
		return getRaw(a) == getRaw(b);
	}

private:
	static T* getRaw(const typename WorldPtr<T>::template Shared<Allocator> &p) noexcept {
		return p.get();
	}
	static T* getRaw(const typename WorldPtr<T>::template Borrowed<Allocator> &p) noexcept {
		return p.get();
	}
	static T* getRaw(const typename WorldPtr<T>::template Owning<Allocator> &p) noexcept {
		return p.get();
	}
	static T* getRaw(T* p) noexcept {
		return p;
	}
};

// Legacy aliases.
template <typename T, typename Allocator = typename WorldPtr<T>::DefaultAllocator>
using WorldPtrBorrowedHash = WorldPtrTransparentHash<T, Allocator>;
template <typename T, typename Allocator = typename WorldPtr<T>::DefaultAllocator>
using WorldPtrSharedHash = WorldPtrTransparentHash<T, Allocator>;
template <typename T, typename Allocator = typename WorldPtr<T>::DefaultAllocator>
using WorldPtrOwningHash = WorldPtrTransparentHash<T, Allocator>;

// ===========================================================================
// PolyPtr<T> — affine pointer pair for polymorphic hierarchies
// ===========================================================================
//
// `WorldPtr<T>` is intrusive: `Block` stores `T value` inline, and `getBlock()`
// recovers the block via `offsetof(Block, value)`. That trick is great for
// final / non-polymorphic types (Mount, Outfit) but breaks for hierarchies:
//
//   1. T may be abstract (e.g. Tile, Item) — `Block { T value; }` does not
//      compile.
//   2. Storage often wants the BASE type (`Owning<Tile>` in Floor) but the
//      destructor must call the CONCRETE type's destructor — the intrusive
//      design needs the allocator template parameter to know the concrete
//      type, which is lost on upcast.
//   3. Virtual inheritance (Cylinder : virtual Thing) makes `static_cast`
//      between derived/base non-trivial, but the intrusive design's reverse-
//      cast via `offsetof` cannot adjust.
//
// `PolyPtr<T>` solves all three by separating the bookkeeping from the value:
//
//   - `Header` (atomic refcount + intrusive next + deleter pointer) is the
//     prefix of every block. The deleter is type-erased — set at allocation
//     time, knows the CONCRETE type and Allocator.
//   - `ConcreteBlock<C>` is `{ Header, C value }`. Header is the first
//     member, so a `Header*` is interconvertible with a `ConcreteBlock<C>*`
//     for standard-layout types.
//   - `Owning/Borrowed/Shared` carry `{ Header* header_, T* value_ }`. Cross-
//     type upcast is `static_cast<Base*>(value_)` (which the compiler resolves
//     correctly even with virtual/multiple inheritance) while `header_` stays
//     unchanged. Destruction is `header_->deleter(header_)`, which always
//     dispatches to the concrete type's destructor and allocator.
//
// Cost: pointer pair is 16 bytes instead of 8. Each `Header` is +8 bytes for
// the deleter. In hot paths the difference (extra register on pass-by-value)
// is dwarfed by the atomic refcount eliminated against `shared_ptr`.
//
// Retiree list is a SINGLE GLOBAL chain shared across every `PolyPtr<T>` —
// `PolyPtr<Tile>::quiescentState()` drains every retired polymorphic block
// regardless of base type. This avoids the per-T drain-list bookkeeping that
// would otherwise be needed when `Owning<Derived>` is upcast to `Owning<Base>`
// before retirement.
//
// Multi-threaded ready: the retire list head is atomic (lock-free push via
// CAS). Drain is a single-writer epoch boundary; in Canary this is the
// dispatcher's end-of-tick. Multi-threaded reader semantics are guaranteed
// by deferred destruction — `Owning`/`Shared::~` NEVER destroy the value
// inline; instead they push to the retire list, and `quiescentState()` runs
// the destructor only at the epoch boundary, after all parallel tasks have
// joined. Readers that obtained a `Borrowed` during the tick can safely
// dereference it for the entire tick.
//
// Refcount model (matches std::shared_ptr/weak_ptr):
//   - strong_refcount: number of Owning + Shared references. When this hits
//     0, the VALUE is destroyed (at the next quiescent state).
//   - weak_refcount:   number of Weak references PLUS 1 if strong > 0 (the
//     "implicit weak" representing the strong group). When this hits 0, the
//     BLOCK memory is deallocated.
// Two-stage destruction: value first (at strong→0 + quiescent), then block
// (at weak→0). Lets `Weak` outlive the value and still observe a valid Header
// to check `expired()`.

// Forward declarations needed before `PolyPtr<T>` can friend the mixin from
// inside its nested Borrowed/Shared, and before `make` can call the wiring
// helper.
template <typename T>
class enable_borrowed_from_this;

namespace world_ptr_poly_detail {
	struct Header;
	struct DeleterTable;

	template <typename T>
	void wireBorrowedFromThis(T* value, Header* header) noexcept;
}

namespace world_ptr_poly_detail {

	struct Header {
		std::atomic<size_t> strong_refcount;
		std::atomic<size_t> weak_refcount;
		Header* next; // intrusive retire-list link (non-atomic — only the
		              // list HEAD is atomic; once on the list, next is fixed)
		const DeleterTable* deleter_table;
	};

	// Per-(Concrete, Allocator) static table. Header just stores a pointer
	// to it — single 8-byte field for both destructor and deallocator
	// (saves 8 bytes vs storing two raw function pointers in Header).
	struct DeleterTable {
		void (*destroy_value)(Header*); // runs Concrete destructor only
		void (*deallocate)(Header*); // releases the block memory
	};

	// `Header` itself must be standard-layout for the Header* ↔ Block* cast
	// in `deleterFn` to be well-defined.
	static_assert(std::is_standard_layout_v<Header>);

	// Storage-style block: holds the concrete value as raw bytes constructed
	// in-place via placement new. This keeps `ConcreteBlock<Concrete>` itself
	// standard-layout regardless of whether `Concrete` has virtual functions
	// or non-trivial layout — required so the `reinterpret_cast<Block*>(Header*)`
	// in `deleterFn` is well-defined (the standard guarantees pointer-
	// interconvertibility between a standard-layout struct and its first
	// non-static data member).
	template <typename Concrete>
	struct ConcreteBlock {
		Header header;
		alignas(Concrete) std::byte storage[sizeof(Concrete)];

		Concrete* value() noexcept {
			return std::launder(reinterpret_cast<Concrete*>(&storage[0]));
		}

		const Concrete* value() const noexcept {
			return std::launder(reinterpret_cast<const Concrete*>(&storage[0]));
		}
	};

	template <typename Concrete, typename Allocator>
	struct AllocatorInstance {
		inline static Allocator instance {};
	};

	// Type-erased destructor / deallocator pair. Instantiated per
	// (Concrete, Allocator).
	template <typename Concrete, typename Allocator>
	void destroyValueFn(Header* h) {
		static_assert(std::is_standard_layout_v<ConcreteBlock<Concrete>>);
		auto* block = reinterpret_cast<ConcreteBlock<Concrete>*>(h);
		block->value()->~Concrete();
	}

	template <typename Concrete, typename Allocator>
	void deallocateFn(Header* h) {
		auto* block = reinterpret_cast<ConcreteBlock<Concrete>*>(h);
		using AllocTraits = std::allocator_traits<Allocator>;
		auto &alloc = AllocatorInstance<Concrete, Allocator>::instance;
		AllocTraits::deallocate(alloc, block, 1);
	}

	template <typename Concrete, typename Allocator>
	inline constexpr DeleterTable deleterTableFor {
		&destroyValueFn<Concrete, Allocator>,
		&deallocateFn<Concrete, Allocator>
	};

	// Global retire-list head. Atomic so multi-threaded pushes are lock-free.
	// Drain is single-writer (typically the dispatcher at end-of-tick).
	inline std::atomic<Header*> g_retirees { nullptr };

	// Lock-free push to the retire list. Caller must hold the only reference
	// to `h` at this point (h is private until published via the CAS).
	inline void retirePush(Header* h) noexcept {
		Header* old_head = g_retirees.load(std::memory_order_relaxed);
		do {
			h->next = old_head;
		} while (!g_retirees.compare_exchange_weak(
			old_head, h,
			std::memory_order_release,
			std::memory_order_relaxed
		));
	}

	// Decrement strong refcount; if it hits 0, defer value destruction to
	// the retire list. NEVER destroys inline — that would race against
	// Borrowed readers in other threads.
	inline void decrementStrong(Header* h) noexcept {
		if (h && h->strong_refcount.fetch_sub(1, std::memory_order_acq_rel) == 1) {
			retirePush(h);
		}
	}

	// Atomic CAS-loop: bump strong only if it is currently > 0. Returns
	// true on success. Used by EVERY "promote from non-Shared source to
	// Shared" path (`Borrowed → Shared`, `sharedDowncast_`,
	// `sharedDynamicDowncast_`, `sharedFromThis`) so a block that was
	// already retired (strong reached 0 and is sitting on the retire list,
	// pending QSBR drain) cannot be resurrected — the resurrection would
	// produce a Shared pointing at memory the next `quiescentState()` will
	// destroy unconditionally, then a double `retirePush` when the
	// resurrected Shared dies.
	//
	// Counterpart to `Weak::lock()`'s inline CAS. The bare `fetch_add` is
	// only safe when the caller ALREADY holds a strong reference to the
	// block (Shared copy ctor, Owning conversion to Shared) — those paths
	// keep using `incrementStrong()` directly.
	[[nodiscard]] inline bool tryIncrementStrong(Header* h) noexcept {
		if (!h) {
			return false;
		}
		size_t cur = h->strong_refcount.load(std::memory_order_relaxed);
		while (cur != 0) {
			if (h->strong_refcount.compare_exchange_weak(
					cur, cur + 1,
					std::memory_order_acq_rel,
					std::memory_order_relaxed
				)) {
				return true;
			}
		}
		return false;
	}

	// Decrement weak refcount; if it hits 0, deallocate the block memory.
	// The value was already destroyed at strong→0 (during quiescent drain).
	inline void decrementWeak(Header* h) noexcept {
		if (h && h->weak_refcount.fetch_sub(1, std::memory_order_acq_rel) == 1) {
			h->deleter_table->deallocate(h);
		}
	}

	inline void quiescentState() {
		// Drain repeatedly — value destruction can release more Shareds
		// (e.g. a Tile's destructor releases its items vector), which can
		// push more blocks to the retire list.
		while (true) {
			// Steal the entire list in one atomic swap. From here on, `it`
			// is a private linked list — no other thread can see it.
			Header* it = g_retirees.exchange(nullptr, std::memory_order_acquire);
			if (!it) {
				break;
			}
			while (it != nullptr) {
				auto* next = it->next;
				// 1. Run destructor on the value (strong was 0 when retired).
				it->deleter_table->destroy_value(it);
				// 2. Decrement weak (the implicit "1" representing the strong
				//    group). If no `Weak` outlived the strong group, this
				//    deallocates the block immediately.
				decrementWeak(it);
				it = next;
			}
		}
	}

} // namespace world_ptr_poly_detail

template <typename T>
struct PolyPtr {
	// NOTE: `static_assert(is_polymorphic_v<T>)` is intentionally NOT here at
	// class scope — that would fire during template instantiation even when
	// `T` is forward-declared (which happens whenever a header pass-by-value
	// of `Borrowed`/`Shared` is used with `class T;`). The check moved to
	// `Owning::make` where T must be complete anyway (we placement-new it).
	using Header = world_ptr_poly_detail::Header;
	template <typename Concrete>
	using ConcreteBlock = world_ptr_poly_detail::ConcreteBlock<Concrete>;
	template <typename Concrete>
	using DefaultAllocator = std::allocator<ConcreteBlock<Concrete>>;

	class Base;
	class Borrowed;
	class Shared;
	class Owning;
	class Weak;

	class Base {
	public:
		// Public to allow cross-type (PolyPtr<Derived> → PolyPtr<Base>)
		// constructors to read the source pair without a maze of friend
		// declarations across nested templates. Treat as internal — direct
		// mutation breaks invariants.
		Header* header_;
		T* value_;

	protected:
		Base() noexcept :
			header_(nullptr), value_(nullptr) { }

		Base(Header* h, T* v) noexcept :
			header_(h), value_(v) { }

		void incrementStrong() const noexcept {
			if (header_) {
				header_->strong_refcount.fetch_add(1, std::memory_order_relaxed);
			}
		}

		void decrementStrong() const noexcept {
			// Deferred — pushes to retire list if strong hits 0.
			world_ptr_poly_detail::decrementStrong(header_);
		}

		void incrementWeak() const noexcept {
			if (header_) {
				header_->weak_refcount.fetch_add(1, std::memory_order_relaxed);
			}
		}

		void decrementWeak() const noexcept {
			// Deallocates block if weak hits 0.
			world_ptr_poly_detail::decrementWeak(header_);
		}

		void clear() noexcept {
			header_ = nullptr;
			value_ = nullptr;
		}

		size_t useCount() const noexcept {
			assert(header_ != nullptr);
			return header_->strong_refcount.load(std::memory_order_relaxed);
		}

	public:
		[[nodiscard]] T* get() const noexcept {
			return value_;
		}

		[[nodiscard]] T* operator->() const noexcept {
			assert(value_ != nullptr);
			return value_;
		}

		[[nodiscard]] T &operator*() const noexcept {
			assert(value_ != nullptr);
			return *value_;
		}

		[[nodiscard]] explicit operator bool() const noexcept {
			return value_ != nullptr;
		}

		[[nodiscard]] bool operator==(std::nullptr_t) const noexcept {
			return value_ == nullptr;
		}
	};

	class Shared : public Base {
		friend class Borrowed;
		friend class Owning;
		// Mixin needs the (Header*, T*) ctor to materialise a Shared of `this`.
		friend class ::enable_borrowed_from_this<T>;
		// Cross-PolyPtr access (typed downcast helpers in PolyPtr<U>).
		template <typename>
		friend struct ::PolyPtr;

		Shared(Header* h, T* v) noexcept :
			Base(h, v) { }

	public:
		using Base::operator==;
		using element_type = T;

		Shared() noexcept = default;
		explicit Shared(std::nullptr_t) noexcept :
			Base() { }

		Shared(Shared &&other) noexcept :
			Base(other.header_, other.value_) {
			other.clear();
		}

		Shared(const Shared &other) noexcept :
			Base(other.header_, other.value_) {
			this->incrementStrong();
		}

		// Cross-type upcast: PolyPtr<Derived>::Shared → PolyPtr<T>::Shared.
		// The source type's `Derived` parameter is deduced indirectly via
		// `Other::element_type` because `PolyPtr<X>::Shared` itself is a
		// non-deduced context (the compiler can't infer X from the nested
		// name). `static_cast` correctly adjusts the pointer for any
		// inheritance form (single, multiple, virtual). The original
		// `header_` is preserved so the deleter still destroys the concrete
		// type.
		template <
			typename Other,
			typename Derived = typename std::remove_cvref_t<Other>::element_type,
			std::enable_if_t<
				// `std::conjunction` is short-circuiting at the metafunction
		        // level: subsequent traits aren't even instantiated when an
		        // earlier one is false. With raw `&&`, MSVC eagerly evaluates
		        // `is_base_of<T, Cylinder>` which requires Cylinder complete
		        // in every translation unit including this header.
				std::conjunction_v<
					std::is_same<std::remove_cvref_t<Other>, typename PolyPtr<Derived>::Shared>,
					std::negation<std::is_same<T, Derived>>,
					std::is_base_of<T, Derived>>,
				int>
			= 0>
		Shared(const Other &other) noexcept :
			Base(other.header_, static_cast<T*>(other.value_)) {
			this->incrementStrong();
		}

		~Shared() noexcept {
			this->decrementStrong();
		}

		Shared &operator=(Shared &&other) noexcept {
			if (this != &other) {
				this->decrementStrong();
				this->header_ = other.header_;
				this->value_ = other.value_;
				other.clear();
			}
			return *this;
		}

		Shared &operator=(const Shared &other) noexcept {
			if (this->value_ != other.value_) {
				this->decrementStrong();
				other.incrementStrong();
				this->header_ = other.header_;
				this->value_ = other.value_;
			}
			return *this;
		}

		Shared &operator=(std::nullptr_t) noexcept {
			if (this->value_ != nullptr) {
				this->decrementStrong();
				this->clear();
			}
			return *this;
		}

		[[nodiscard]] bool operator==(const Shared &other) const noexcept {
			return this->value_ == other.value_;
		}

		[[nodiscard]] size_t useCount() const noexcept {
			assert(this->value_ != nullptr);
			return Base::useCount();
		}

		// Implicit demotion to Borrowed — a Shared already holds a strong
		// reference, so producing a transient view of the same pointee is
		// always safe and zero-cost.
		[[nodiscard]] operator Borrowed() const noexcept {
			return Borrowed(this->header_, this->value_);
		}

		[[nodiscard]] Borrowed borrow() const noexcept {
			return static_cast<Borrowed>(*this);
		}
	};

	class Borrowed : public Base {
		friend class Owning;
		friend class Shared;
		// Mixin needs the (Header*, T*) ctor to materialise a Borrowed of `this`.
		friend class ::enable_borrowed_from_this<T>;
		// Cross-PolyPtr access (typed downcast helpers in PolyPtr<U>).
		template <typename>
		friend struct ::PolyPtr;

		Borrowed(Header* h, T* v) noexcept :
			Base(h, v) { }

	public:
		using Base::operator==;
		using element_type = T;

		Borrowed() noexcept = default;
		explicit Borrowed(std::nullptr_t) noexcept :
			Base() { }

		Borrowed(const Borrowed &) noexcept = default;
		Borrowed &operator=(const Borrowed &) noexcept = default;
		Borrowed(Borrowed &&) noexcept = default;
		Borrowed &operator=(Borrowed &&) noexcept = default;

		// Cross-type upcast: PolyPtr<Derived>::Borrowed → PolyPtr<T>::Borrowed.
		// See note on Shared cross-type ctor for the deduction trick.
		template <
			typename Other,
			typename Derived = typename std::remove_cvref_t<Other>::element_type,
			std::enable_if_t<
				std::conjunction_v<
					std::is_same<std::remove_cvref_t<Other>, typename PolyPtr<Derived>::Borrowed>,
					std::negation<std::is_same<T, Derived>>,
					std::is_base_of<T, Derived>>,
				int>
			= 0>
		Borrowed(const Other &other) noexcept :
			Base(other.header_, static_cast<T*>(other.value_)) { }

		// Promote to Shared. Returns a null Shared when:
		//   - the Borrowed itself is null (default-constructed), OR
		//   - the block has already been retired (last Owning/Shared dropped
		//     between the Borrowed being observed and this conversion). The
		//     CAS-loop refuses to bump a strong refcount that has reached 0,
		//     because the QSBR drain runs the destructor unconditionally and
		//     would race with anyone holding the resurrected Shared.
		//
		// Callers that previously assumed `share()` always succeeds (e.g.
		// pinning a tile across an async lambda) must now branch on the
		// returned Shared being null — same shape as `Weak::lock()`.
		[[nodiscard]] operator Shared() const noexcept {
			if (!world_ptr_poly_detail::tryIncrementStrong(this->header_)) {
				return Shared {};
			}
			return Shared(this->header_, this->value_);
		}

		[[nodiscard]] bool operator==(const Borrowed &other) const noexcept {
			return this->value_ == other.value_;
		}

		[[nodiscard]] Shared share() const noexcept {
			return static_cast<Shared>(*this);
		}
	};

	class Owning : public Base {
		friend class Shared;
		friend class Borrowed;
		// Cross-PolyPtr access (typed downcast helpers in PolyPtr<U>).
		template <typename>
		friend struct ::PolyPtr;

		Owning(Header* h, T* v) noexcept :
			Base(h, v) { }

	public:
		using Base::operator==;
		using element_type = T;

		Owning() noexcept = default;
		explicit Owning(std::nullptr_t) noexcept :
			Base() { }

		Owning(const Owning &) = delete;
		Owning &operator=(const Owning &) = delete;

		Owning(Owning &&other) noexcept :
			Base(other.header_, other.value_) {
			other.clear();
		}

		// Cross-type upcast (move-only — affine semantics preserved). See
		// note on Shared cross-type ctor for the deduction trick. The
		// `is_rvalue_reference_v<Other&&>` clause blocks lvalue sources so
		// the affine invariant cannot be silently broken via implicit copy.
		template <
			typename Other,
			typename Derived = typename std::remove_cvref_t<Other>::element_type,
			std::enable_if_t<
				std::conjunction_v<
					std::is_same<std::remove_cvref_t<Other>, typename PolyPtr<Derived>::Owning>,
					std::negation<std::is_same<T, Derived>>,
					std::bool_constant<std::is_rvalue_reference_v<Other &&>>,
					std::is_base_of<T, Derived>>,
				int>
			= 0>
		Owning(Other &&other) noexcept :
			Base(other.header_, static_cast<T*>(other.value_)) {
			other.header_ = nullptr;
			other.value_ = nullptr;
		}

		~Owning() noexcept {
			// Mechanically identical to `Shared::~Shared` — Owning is just a
			// strong ref with affine semantics. Pushes to retire list if it
			// was the last strong ref.
			this->decrementStrong();
		}

		Owning &operator=(Owning &&other) noexcept {
			if (this != &other) {
				this->decrementStrong();
				this->header_ = other.header_;
				this->value_ = other.value_;
				other.clear();
			}
			return *this;
		}

		Owning &operator=(std::nullptr_t) noexcept {
			reset();
			return *this;
		}

		// Promote to Shared. Null-tolerant — a default-constructed Owning
		// produces a default-constructed Shared. `incrementStrong` is
		// internally null-safe.
		[[nodiscard]] operator Shared() const noexcept {
			this->incrementStrong();
			return Shared(this->header_, this->value_);
		}

		// Demote to Borrowed view. Null-tolerant — a default-constructed
		// Owning produces a default-constructed Borrowed (both null). This
		// is required so containers of `Owning` (e.g. `Floor::tiles`) can
		// surface a Borrowed for empty slots without firing an assert.
		[[nodiscard]] operator Borrowed() const noexcept {
			return Borrowed(this->header_, this->value_);
		}

		[[nodiscard]] bool operator==(const Owning &other) const noexcept {
			// Affine — distinct instances must never compare equal unless both null.
			assert(this->value_ == nullptr || ((this->value_ == other.value_) == (this == &other)));
			return this->value_ == other.value_;
		}

		// `make` only available for concrete (non-abstract) T. For abstract T
		// (e.g. PolyPtr<Tile>), use `make_poly<DerivedConcrete>(...)` and rely
		// on the cross-type upcast.
		template <typename Allocator = DefaultAllocator<T>, typename... Args>
			requires(!std::is_abstract_v<T>)
		[[nodiscard]] static Owning make(Args &&... args) {
			static_assert(
				std::is_polymorphic_v<T>,
				"PolyPtr<T> requires a polymorphic type. For concrete final / "
				"non-polymorphic types, use WorldPtr<T> — its 8-byte intrusive "
				"design is more compact."
			);
			using AllocTraits = std::allocator_traits<Allocator>;
			auto &alloc = world_ptr_poly_detail::AllocatorInstance<T, Allocator>::instance;
			auto* block = AllocTraits::allocate(alloc, 1);
			// Header is a standard-layout aggregate; init its fields directly
			// (no AllocTraits::construct, since the storage byte array must
			// not be value-initialized).
			//
			// strong=1 (Owning's stake). weak=1 (implicit weak representing
			// the strong group — decremented when strong→0 in quiescentState).
			block->header.strong_refcount.store(1, std::memory_order_relaxed);
			block->header.weak_refcount.store(1, std::memory_order_relaxed);
			block->header.next = nullptr;
			block->header.deleter_table = &world_ptr_poly_detail::deleterTableFor<T, Allocator>;
			try {
				::new (static_cast<void*>(&block->storage[0])) T(std::forward<Args>(args)...);
			} catch (...) {
				AllocTraits::deallocate(alloc, block, 1);
				throw;
			}
			// If T (or any of its bases) opts into the
			// `enable_borrowed_from_this` mixin, wire its `poly_header_` field
			// so methods on T can return a Borrowed/Shared of `this` without
			// needing the caller to pass it in. Detection is via SFINAE — no
			// cost for types that don't use the mixin.
			world_ptr_poly_detail::wireBorrowedFromThis(block->value(), &block->header);
			return Owning(&block->header, block->value());
		}

		[[nodiscard]] Shared share() const noexcept {
			return static_cast<Shared>(*this);
		}

		[[nodiscard]] Borrowed borrow() const noexcept {
			return static_cast<Borrowed>(*this);
		}

		void reset() noexcept {
			this->decrementStrong();
			this->clear();
		}
	};

	// ============================================================
	// Weak — non-pinning observer, analog of `std::weak_ptr`.
	// ============================================================
	//
	// Doesn't keep the value alive. Detects destruction via the strong
	// refcount on the Header (which is kept allocated until the LAST Weak
	// is destroyed, even after the value itself has been destroyed).
	//
	// Three read APIs, by descending cost / ascending safety:
	//   - `expired()`         : 1 atomic LOAD. Snapshot of "is value alive?".
	//   - `borrowIfAlive()`   : 1 atomic LOAD + comparison. Returns a
	//                           tick-bound `Borrowed` if alive, else null.
	//                           Use intra-tick read-only; cheaper than lock().
	//   - `lock()`            : 1 CAS. Bumps strong; returns `Shared` (pinning)
	//                           if alive, else null. Use to retain across ticks.
	//
	// Use Weak to break ownership cycles (the canonical motivator is
	// Item.m_parent → Tile, where Tile owns Item via items vector).
	class Weak : public Base {
		friend class Shared;
		friend class Borrowed;
		friend class Owning;
		// Cross-PolyPtr access (typed downcast helpers in PolyPtr<U>).
		template <typename>
		friend struct ::PolyPtr;

		Weak(Header* h, T* v) noexcept :
			Base(h, v) {
			this->incrementWeak();
		}

	public:
		using Base::operator==;
		using element_type = T;

		Weak() noexcept = default;

		explicit Weak(std::nullptr_t) noexcept :
			Base() { }

		Weak(const Weak &other) noexcept :
			Base(other.header_, other.value_) {
			this->incrementWeak();
		}

		Weak(Weak &&other) noexcept :
			Base(other.header_, other.value_) {
			other.clear();
		}

		// From Shared: same-type implicit conversion (always safe — strong > 0).
		Weak(const Shared &shared) noexcept :
			Base(shared.header_, shared.value_) {
			this->incrementWeak();
		}

		// From Borrowed: explicit (Borrowed is tick-bound; storing a Weak
		// from one may extend the observable validity past the current tick,
		// which is fine but the caller should be intentional).
		explicit Weak(const Borrowed &borrowed) noexcept :
			Base(borrowed.header_, borrowed.value_) {
			this->incrementWeak();
		}

		// Cross-type upcast: PolyPtr<Derived>::Weak → PolyPtr<T>::Weak.
		template <
			typename Other,
			typename Derived = typename std::remove_cvref_t<Other>::element_type,
			std::enable_if_t<
				std::conjunction_v<
					std::is_same<std::remove_cvref_t<Other>, typename PolyPtr<Derived>::Weak>,
					std::negation<std::is_same<T, Derived>>,
					std::is_base_of<T, Derived>>,
				int>
			= 0>
		Weak(const Other &other) noexcept :
			Base(other.header_, static_cast<T*>(other.value_)) {
			this->incrementWeak();
		}

		~Weak() noexcept {
			this->decrementWeak();
		}

		Weak &operator=(const Weak &other) noexcept {
			if (this->value_ != other.value_) {
				this->decrementWeak();
				other.incrementWeak();
				this->header_ = other.header_;
				this->value_ = other.value_;
			}
			return *this;
		}

		Weak &operator=(Weak &&other) noexcept {
			if (this != &other) {
				this->decrementWeak();
				this->header_ = other.header_;
				this->value_ = other.value_;
				other.clear();
			}
			return *this;
		}

		Weak &operator=(std::nullptr_t) noexcept {
			if (this->header_) {
				this->decrementWeak();
				this->clear();
			}
			return *this;
		}

		Weak &operator=(const Shared &shared) noexcept {
			if (this->value_ != shared.value_) {
				this->decrementWeak();
				this->header_ = shared.header_;
				this->value_ = shared.value_;
				this->incrementWeak();
			}
			return *this;
		}

		Weak &operator=(const Borrowed &borrowed) noexcept {
			if (this->value_ != borrowed.value_) {
				this->decrementWeak();
				this->header_ = borrowed.header_;
				this->value_ = borrowed.value_;
				this->incrementWeak();
			}
			return *this;
		}

		// Cheapest check: 1 atomic LOAD. "Did the underlying value already
		// have its destructor run?"
		[[nodiscard]] bool expired() const noexcept {
			if (!this->header_) {
				return true;
			}
			return this->header_->strong_refcount.load(std::memory_order_acquire) == 0;
		}

		// Returns a `Borrowed` if the value is still alive at this moment.
		// Cheaper than `lock()` (no CAS), but the returned Borrowed must be
		// used WITHIN the current tick — relies on QSBR for safety. After
		// the next `quiescentState()`, the underlying value may be destroyed.
		[[nodiscard]] Borrowed borrowIfAlive() const noexcept {
			if (!this->header_) {
				return Borrowed {};
			}
			if (this->header_->strong_refcount.load(std::memory_order_acquire) == 0) {
				return Borrowed {};
			}
			return Borrowed(this->header_, this->value_);
		}

		// Atomically attempts to acquire a `Shared` (pinning). Returns null
		// `Shared` if the value has already been destroyed. Cost: 1 CAS.
		// Use this when you need to keep the value alive past the current
		// tick (e.g., capturing into a deferred event lambda).
		[[nodiscard]] Shared lock() const noexcept {
			if (!world_ptr_poly_detail::tryIncrementStrong(this->header_)) {
				return Shared {};
			}
			return Shared(this->header_, this->value_);
		}

		[[nodiscard]] bool operator==(const Weak &other) const noexcept {
			return this->value_ == other.value_;
		}

		void reset() noexcept {
			this->decrementWeak();
			this->clear();
		}
	};

	// Internal: typed downcast helpers. Public (free) versions live below
	// as `static_pointer_cast_poly` / `dynamic_pointer_cast_poly` and
	// delegate here. Kept inside `PolyPtr<T>` so the friend declaration on
	// `PolyPtr<Derived>::Shared` (`template<typename> friend struct PolyPtr;`)
	// grants access to its private (Header*, T*) constructor.
	template <typename Derived>
	[[nodiscard]] static typename PolyPtr<Derived>::Shared sharedDowncast_(Header* h, T* v) noexcept {
		if (!v) {
			return typename PolyPtr<Derived>::Shared {};
		}
		// CAS-loop: same rationale as Borrowed→Shared. The source of the
		// downcast may be a Borrowed/Weak observing an already-retired
		// block; a bare `fetch_add` would resurrect it.
		if (!world_ptr_poly_detail::tryIncrementStrong(h)) {
			return typename PolyPtr<Derived>::Shared {};
		}
		return typename PolyPtr<Derived>::Shared(h, static_cast<Derived*>(v));
	}

	template <typename Derived>
	[[nodiscard]] static typename PolyPtr<Derived>::Borrowed borrowedDowncast_(Header* h, T* v) noexcept {
		if (!v) {
			return typename PolyPtr<Derived>::Borrowed {};
		}
		return typename PolyPtr<Derived>::Borrowed(h, static_cast<Derived*>(v));
	}

	template <typename Derived>
	[[nodiscard]] static typename PolyPtr<Derived>::Shared sharedDynamicDowncast_(Header* h, T* v) noexcept {
		if (!v) {
			return typename PolyPtr<Derived>::Shared {};
		}
		auto* d = dynamic_cast<Derived*>(v);
		if (!d) {
			return typename PolyPtr<Derived>::Shared {};
		}
		// CAS-loop: cannot bump strong on a retired block (see sharedDowncast_).
		if (!world_ptr_poly_detail::tryIncrementStrong(h)) {
			return typename PolyPtr<Derived>::Shared {};
		}
		return typename PolyPtr<Derived>::Shared(h, d);
	}

	template <typename Derived>
	[[nodiscard]] static typename PolyPtr<Derived>::Borrowed borrowedDynamicDowncast_(Header* h, T* v) noexcept {
		if (!v) {
			return typename PolyPtr<Derived>::Borrowed {};
		}
		auto* d = dynamic_cast<Derived*>(v);
		if (!d) {
			return typename PolyPtr<Derived>::Borrowed {};
		}
		return typename PolyPtr<Derived>::Borrowed(h, d);
	}

	template <typename Derived>
	[[nodiscard]] static typename PolyPtr<Derived>::Weak weakDowncast_(Header* h, T* v) noexcept {
		if (!v) {
			return typename PolyPtr<Derived>::Weak {};
		}
		// The `Weak(Header*, T*)` constructor already calls `incrementWeak()`.
		// A bare `fetch_add` here would bump weak_refcount TWICE per downcast
		// while `~Weak` only decrements once — block leaks because weak never
		// reaches 0, so `decrementWeak` never deallocates after `quiescentState`
		// runs the value destructor.
		return typename PolyPtr<Derived>::Weak(h, static_cast<Derived*>(v));
	}

	template <typename Derived>
	[[nodiscard]] static typename PolyPtr<Derived>::Weak weakDynamicDowncast_(Header* h, T* v) noexcept {
		if (!v) {
			return typename PolyPtr<Derived>::Weak {};
		}
		auto* d = dynamic_cast<Derived*>(v);
		if (!d) {
			return typename PolyPtr<Derived>::Weak {};
		}
		// See note on weakDowncast_ — single increment via the constructor only.
		return typename PolyPtr<Derived>::Weak(h, d);
	}

	// Drains EVERY retired PolyPtr block, regardless of T. Calling
	// `PolyPtr<Tile>::quiescentState()` is equivalent to calling
	// `PolyPtr<Item>::quiescentState()` — they share the global retire list.
	static void quiescentState() {
		static_assert(!std::is_copy_constructible_v<Owning>);
		static_assert(std::is_copy_constructible_v<Borrowed>);
		static_assert(std::is_copy_constructible_v<Shared>);
		static_assert(std::is_copy_constructible_v<Weak>);

		static_assert(!std::is_copy_assignable_v<Owning>);
		static_assert(std::is_copy_assignable_v<Borrowed>);
		static_assert(std::is_copy_assignable_v<Shared>);
		static_assert(std::is_copy_assignable_v<Weak>);

		static_assert(std::is_move_assignable_v<Borrowed>);
		static_assert(std::is_move_assignable_v<Owning>);
		static_assert(std::is_move_assignable_v<Shared>);
		static_assert(std::is_move_assignable_v<Weak>);

		static_assert(!std::is_convertible_v<Borrowed, Owning>);
		static_assert(!std::is_convertible_v<Shared, Owning>);
		static_assert(std::is_convertible_v<Borrowed, Shared>);
		static_assert(std::is_convertible_v<Shared, Borrowed>); // Shared can demote to a transient view
		static_assert(std::is_convertible_v<Owning, Borrowed>);
		static_assert(std::is_convertible_v<Owning, Shared>);
		// Weak: Shared→Weak implicit (always safe), Borrowed→Weak explicit
		// (intentional tick→cross-tick promotion). Weak→Shared/Borrowed
		// require lock() / borrowIfAlive() — not implicit (correctness).
		static_assert(std::is_convertible_v<Shared, Weak>);
		static_assert(!std::is_convertible_v<Borrowed, Weak>);
		static_assert(!std::is_convertible_v<Weak, Shared>);
		static_assert(!std::is_convertible_v<Weak, Borrowed>);

		world_ptr_poly_detail::quiescentState();
	}
};

// Free factory for upcast-on-construction:
//
//   PolyPtr<Tile>::Owning t = make_poly<DynamicTile>(pos);
//
// Returns a `PolyPtr<Concrete>::Owning` which the implicit cross-type ctor
// converts to `PolyPtr<Base>::Owning` at the assignment site.
template <
	typename Concrete,
	typename Allocator = typename PolyPtr<Concrete>::template DefaultAllocator<Concrete>,
	typename... Args>
[[nodiscard]] auto make_poly(Args &&... args) {
	static_assert(std::is_polymorphic_v<Concrete>);
	static_assert(!std::is_abstract_v<Concrete>);
	return PolyPtr<Concrete>::Owning::template make<Allocator>(std::forward<Args>(args)...);
}

// ===========================================================================
// Typed downcast helpers — analogous to std::static_pointer_cast / dynamic
//
// `PolyPtr<Base>::Shared` / `Borrowed` only expose the base pointer type. To
// recover a `PolyPtr<Derived>::Shared` (e.g. `PolyPtr<HouseTile>::Shared` from
// `PolyPtr<Tile>::Shared`) without paying RTTI on every access, use these.
//
// `static_pointer_cast_poly` is unchecked — caller must KNOW the runtime type
// matches. `dynamic_pointer_cast_poly` does an `dynamic_cast`, returning a
// null PolyPtr if the cast fails.
//
// Refcount semantics match shared_ptr's casts: Shared casts bump the block;
// Borrowed casts are zero-atomic.
// ===========================================================================

template <typename Derived, typename Base>
[[nodiscard]] typename PolyPtr<Derived>::Shared static_pointer_cast_poly(
	const typename PolyPtr<Base>::Shared &src
) noexcept {
	static_assert(std::is_base_of_v<Base, Derived>);
	return PolyPtr<Base>::template sharedDowncast_<Derived>(src.header_, src.value_);
}

template <typename Derived, typename Base>
[[nodiscard]] typename PolyPtr<Derived>::Borrowed static_pointer_cast_poly(
	const typename PolyPtr<Base>::Borrowed &src
) noexcept {
	static_assert(std::is_base_of_v<Base, Derived>);
	return PolyPtr<Base>::template borrowedDowncast_<Derived>(src.header_, src.value_);
}

template <typename Derived, typename Base>
[[nodiscard]] typename PolyPtr<Derived>::Shared dynamic_pointer_cast_poly(
	const typename PolyPtr<Base>::Shared &src
) noexcept {
	static_assert(std::is_base_of_v<Base, Derived>);
	return PolyPtr<Base>::template sharedDynamicDowncast_<Derived>(src.header_, src.value_);
}

template <typename Derived, typename Base>
[[nodiscard]] typename PolyPtr<Derived>::Borrowed dynamic_pointer_cast_poly(
	const typename PolyPtr<Base>::Borrowed &src
) noexcept {
	static_assert(std::is_base_of_v<Base, Derived>);
	return PolyPtr<Base>::template borrowedDynamicDowncast_<Derived>(src.header_, src.value_);
}

template <typename Derived, typename Base>
[[nodiscard]] typename PolyPtr<Derived>::Weak static_pointer_cast_poly(
	const typename PolyPtr<Base>::Weak &src
) noexcept {
	static_assert(std::is_base_of_v<Base, Derived>);
	return PolyPtr<Base>::template weakDowncast_<Derived>(src.header_, src.value_);
}

template <typename Derived, typename Base>
[[nodiscard]] typename PolyPtr<Derived>::Weak dynamic_pointer_cast_poly(
	const typename PolyPtr<Base>::Weak &src
) noexcept {
	static_assert(std::is_base_of_v<Base, Derived>);
	return PolyPtr<Base>::template weakDynamicDowncast_<Derived>(src.header_, src.value_);
}

// Free function alias for the global QSBR drain. Equivalent to
// `PolyPtr<AnyT>::quiescentState()` — picks no specific T, since the retire
// list is global. Prefer this in dispatcher code where the choice of T is
// arbitrary, to avoid implying per-type behavior.
inline void polyPtrQuiescentState() noexcept {
	world_ptr_poly_detail::quiescentState();
}

// ===========================================================================
// enable_borrowed_from_this<T> — mixin analogous to enable_shared_from_this
// ===========================================================================
//
// A class `T` that inherits `enable_borrowed_from_this<T>` can call
// `borrowedFromThis()` / `sharedFromThis()` from inside its own methods to
// obtain a `PolyPtr<T>::Borrowed` / `PolyPtr<T>::Shared` of itself. This is
// the equivalent of `enable_shared_from_this::shared_from_this()` for
// objects managed by `PolyPtr`.
//
// Mechanism: the mixin holds an opaque `Header*` field. `PolyPtr<T>::Owning::make`
// detects whether the constructed object derives from this mixin and wires
// the field automatically (no caller boilerplate). If wiring did not happen
// — e.g. the object was stack-allocated, or constructed via `make_shared`
// in legacy code — the methods return null pointers (Borrowed/Shared{}).
//
// Inheritance recipe: a base in a hierarchy inherits the mixin parameterised
// on itself (e.g. `class Tile : public enable_borrowed_from_this<Tile>`).
// Subclasses (DynamicTile, StaticTile, HouseTile) then transparently inherit
// the field and the methods. The wiring function uses the mixin's
// `enable_borrowed_from_this_self_t` typedef to find the right base class.
//
// Cost: 8 bytes per instance (the `Header*` field), the same as
// `enable_shared_from_this`'s internal `weak_ptr`.
template <typename T>
class enable_borrowed_from_this {
public:
	// Tag that lets `wireBorrowedFromThis<U>` discover which mixin
	// instantiation is in U's base class chain.
	using enable_borrowed_from_this_self_t = T;

protected:
	world_ptr_poly_detail::Header* poly_header_ = nullptr;

	template <typename U>
	friend void world_ptr_poly_detail::wireBorrowedFromThis(U* value, world_ptr_poly_detail::Header* header) noexcept;

public:
	// `borrowedFromThis` and `sharedFromThis` are method templates (with the
	// `Self` default parameter unused at the call site) so that
	// `PolyPtr<T>::Borrowed` is NOT referenced while this class itself is
	// being instantiated. Otherwise:
	//
	//   class T : public enable_borrowed_from_this<T>
	//
	// would force `PolyPtr<T>` (and its `is_polymorphic_v<T>` static_assert)
	// to instantiate before T is complete — which the standard forbids and
	// MSVC rejects with "undefined class … as argument to __is_polymorphic".
	//
	// Method-template bodies are only instantiated when the method is called,
	// at which point T is complete and `PolyPtr<T>` instantiates cleanly.
	template <typename Self = T>
	[[nodiscard]] auto borrowedFromThis() noexcept -> typename PolyPtr<Self>::Borrowed {
		if (!poly_header_) {
			return typename PolyPtr<Self>::Borrowed {};
		}
		return typename PolyPtr<Self>::Borrowed(poly_header_, static_cast<Self*>(this));
	}

	template <typename Self = T>
	[[nodiscard]] auto sharedFromThis() noexcept -> typename PolyPtr<Self>::Shared {
		if (!poly_header_) {
			return typename PolyPtr<Self>::Shared {};
		}
		// CAS-loop: refuses to resurrect a block whose strong refcount has
		// already reached 0 (object is in the retire list, destructor about
		// to run at next QSBR drain). std::enable_shared_from_this throws
		// `bad_weak_ptr` in this case; we mirror the safe semantics by
		// returning a null Shared instead.
		if (!world_ptr_poly_detail::tryIncrementStrong(poly_header_)) {
			return typename PolyPtr<Self>::Shared {};
		}
		return typename PolyPtr<Self>::Shared(poly_header_, static_cast<Self*>(this));
	}
};

namespace world_ptr_poly_detail {

	// Called from `PolyPtr<T>::Owning::make` after placement-new. Sets the
	// mixin's `poly_header_` if T (or any base) derives from
	// `enable_borrowed_from_this<X>` — no-op otherwise. Detection uses the
	// `enable_borrowed_from_this_self_t` typedef which is inherited along
	// with the mixin, so it works whether T itself or one of its bases
	// declared the mixin.
	template <typename T>
	void wireBorrowedFromThis(T* value, Header* header) noexcept {
		if constexpr (requires { typename T::enable_borrowed_from_this_self_t; }) {
			using Self = typename T::enable_borrowed_from_this_self_t;
			static_cast<enable_borrowed_from_this<Self>*>(value)->poly_header_ = header;
		}
	}

} // namespace world_ptr_poly_detail

// Auto-dispatch alias: picks WorldPtr (intrusive, 8B) or PolyPtr (erased, 16B)
// based on whether T is polymorphic. Useful when generic code shouldn't care.
template <typename T>
struct AnyPtrSelector {
	using type = std::conditional_t<std::is_polymorphic_v<T>, PolyPtr<T>, WorldPtr<T>>;
};

template <typename T>
using AnyPtr = typename AnyPtrSelector<T>::type;

// Heterogeneous (transparent) hashers/comparators — `is_transparent` lets
// phmap/std associative containers accept lookup keys of a different type
// (Borrowed, Shared, raw `T*`) without materialising a Shared (which would
// bump the refcount). Use these as the hasher AND key_equal pair.
template <typename T>
struct PolyPtrTransparentHash {
	using is_transparent = void;

	size_t operator()(const typename PolyPtr<T>::Shared &ptr) const noexcept {
		return std::hash<T*> {}(ptr.get());
	}
	size_t operator()(const typename PolyPtr<T>::Borrowed &ptr) const noexcept {
		return std::hash<T*> {}(ptr.get());
	}
	size_t operator()(const typename PolyPtr<T>::Owning &ptr) const noexcept {
		return std::hash<T*> {}(ptr.get());
	}
	size_t operator()(const typename PolyPtr<T>::Weak &ptr) const noexcept {
		return std::hash<T*> {}(ptr.get());
	}
	size_t operator()(const T* ptr) const noexcept {
		// `std::hash<T*>` takes `T*`, not `const T*` — GCC's strict mode
		// rejects the implicit non-const conversion. Use the const
		// specialisation explicitly; the pointer-value hash is identical
		// either way, so this stays compatible with the transparent
		// `T*` / `Owning` / `Borrowed` / `Shared` / `Weak` overloads above.
		return std::hash<const T*> {}(ptr);
	}
};

template <typename T>
struct PolyPtrTransparentEqual {
	using is_transparent = void;

	template <typename A, typename B>
	bool operator()(const A &a, const B &b) const noexcept {
		return getRaw(a) == getRaw(b);
	}

private:
	static T* getRaw(const typename PolyPtr<T>::Shared &p) noexcept {
		return p.get();
	}
	static T* getRaw(const typename PolyPtr<T>::Borrowed &p) noexcept {
		return p.get();
	}
	static T* getRaw(const typename PolyPtr<T>::Owning &p) noexcept {
		return p.get();
	}
	static T* getRaw(const typename PolyPtr<T>::Weak &p) noexcept {
		return p.get();
	}
	static T* getRaw(T* p) noexcept {
		return p;
	}
};

// Legacy non-transparent aliases retained for source compatibility.
template <typename T>
using PolyPtrBorrowedHash = PolyPtrTransparentHash<T>;
template <typename T>
using PolyPtrSharedHash = PolyPtrTransparentHash<T>;
template <typename T>
using PolyPtrOwningHash = PolyPtrTransparentHash<T>;
