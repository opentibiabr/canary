/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once
#include <atomic_queue/atomic_queue.h>

template <typename T, size_t CAPACITY>
struct LockfreeFreeList {
	using FreeList = atomic_queue::AtomicQueue2<T*, CAPACITY>;

	static FreeList &get() {
		static FreeList freeList;
		return freeList;
	}

	static void preallocate(size_t count) {
		auto &freeList = get();
		for (size_t i = 0; i < count; ++i) {
			T* p = static_cast<T*>(::operator new(sizeof(T), static_cast<std::align_val_t>(alignof(T))));
			if (!freeList.try_push(p)) {
				::operator delete(p, static_cast<std::align_val_t>(alignof(T)));
				break;
			}
		}
	}
};

template <typename T, size_t CAPACITY>
class LockfreePoolingAllocator {
public:
	using value_type = T;
	using pointer = T*;
	using const_pointer = const T*;
	using void_pointer = void*;
	using const_void_pointer = const void*;
	using size_type = std::size_t;
	using difference_type = std::ptrdiff_t;

	template <typename U>
	struct rebind {
		using other = LockfreePoolingAllocator<U, CAPACITY>;
	};

	LockfreePoolingAllocator() noexcept = default;

	template <typename U>
	explicit LockfreePoolingAllocator(const LockfreePoolingAllocator<U, CAPACITY> &) noexcept { }

	~LockfreePoolingAllocator() = default;

	pointer allocate(size_type n) {
		if (n == 1) {
			pointer p;
			if (LockfreeFreeList<T, CAPACITY>::get().try_pop(p)) {
				return p;
			}
		}
		return static_cast<pointer>(::operator new(n * sizeof(T), static_cast<std::align_val_t>(alignof(T))));
	}

	void deallocate(pointer p, size_type n) noexcept {
		if (n == 1) {
			if (LockfreeFreeList<T, CAPACITY>::get().try_push(p)) {
				return;
			}
		}
		::operator delete(p, static_cast<std::align_val_t>(alignof(T)));
	}

	bool operator==(const LockfreePoolingAllocator &) const noexcept {
		return true;
	}
	bool operator!=(const LockfreePoolingAllocator &other) const noexcept {
		return !(*this == other);
	}
};
