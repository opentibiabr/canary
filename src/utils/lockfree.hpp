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
#include <memory_resource>

constexpr size_t STATIC_PREALLOCATION_SIZE = 500;

template <typename T, size_t CAPACITY>
struct LockfreeFreeList {
	using FreeList = atomic_queue::AtomicQueue2<T*, CAPACITY>;

	static FreeList &get() {
		static FreeList freeList;
		return freeList;
	}

	static void preallocate(const size_t count, std::pmr::memory_resource* resource = std::pmr::get_default_resource()) {
		auto &freeList = get();
		for (size_t i = 0; i < count; ++i) {
			T* p = static_cast<T*>(resource->allocate(sizeof(T), alignof(T)));
			if (!freeList.try_push(p)) {
				resource->deallocate(p, sizeof(T), alignof(T));
			}
		}
	}
};

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

	T* allocate(std::size_t n) {
		if (n == 1) {
			T* p;
			if (LockfreeFreeList<T, CAPACITY>::get().try_pop(p)) {
				return p;
			}
			g_logger().warn("Freelist empty, using default resource allocation.");
		}
		return static_cast<T*>(std::pmr::get_default_resource()->allocate(n * sizeof(T), alignof(T)));
	}

	void deallocate(T* p, std::size_t n) {
		if (n == 1) {
			if (LockfreeFreeList<T, CAPACITY>::get().try_push(p)) {
				return;
			}
			g_logger().warn("Freelist full, using default resource deallocation.");
		}
		std::pmr::get_default_resource()->deallocate(p, n * sizeof(T), alignof(T));
	}

	bool operator==(const LockfreePoolingAllocator &) const noexcept {
		return true;
	}
	bool operator!=(const LockfreePoolingAllocator &) const noexcept {
		return false;
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
