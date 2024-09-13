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

	LockfreePoolingAllocator() = default;

	template <typename U>
	explicit LockfreePoolingAllocator(const LockfreePoolingAllocator<U, CAPACITY> &) noexcept { }

	T* allocate(size_t n) {
		auto &freeList = LockfreeFreeList<T, CAPACITY>::get();
		if (n == 1) {
			T* p;
			if (freeList.try_pop(p)) {
				return p;
			}
		}
		return static_cast<T*>(::operator new(n * sizeof(T), static_cast<std::align_val_t>(alignof(T))));
	}

	void deallocate(T* p, size_t n) noexcept {
		if (n == 1) {
			auto &freeList = LockfreeFreeList<T, CAPACITY>::get();
			if (freeList.try_push(p)) {
				return;
			}
		}
		::operator delete(p, static_cast<std::align_val_t>(alignof(T)));
	}

	template <typename U>
	struct rebind {
		using other = LockfreePoolingAllocator<U, CAPACITY>;
	};
};
