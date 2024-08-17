/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <atomic>
#include <memory>
#include <vector>
#include <thread>
#include <spdlog/spdlog.h>

const int TOTAL_THREADS = static_cast<int>(std::thread::hardware_concurrency());
const size_t LOCAL_CACHE_LIMIT = std::max(35 / TOTAL_THREADS, 5);
constexpr size_t STATIC_PREALLOCATION_SIZE = 100;

struct StackNode {
	void* data;
	StackNode* next;
};

template <std::size_t TSize, size_t CAPACITY>
class LockfreeFreeList {
public:
	LockfreeFreeList() :
		head(nullptr) { }

	static LockfreeFreeList &get() {
		static LockfreeFreeList instance;
		return instance;
	}

	bool pop(void*&result) {
		StackNode* old_head = head.load(std::memory_order_acquire);
		while (old_head != nullptr) {
			if (head.compare_exchange_weak(old_head, old_head->next, std::memory_order_acquire)) {
				result = old_head->data;
				delete old_head;
				return true;
			}

			std::this_thread::yield();
		}
		return false;
	}

	bool push(void* data) {
		auto* new_node = new StackNode { data, nullptr };
		StackNode* old_head = head.load(std::memory_order_relaxed);
		do {
			new_node->next = old_head;
		} while (!head.compare_exchange_weak(old_head, new_node, std::memory_order_release, std::memory_order_relaxed));
		return true;
	}

	void preallocate(const size_t numBlocks) {
		for (size_t i = 0; i < numBlocks; ++i) {
			void* p = operator new(TSize);
			push(p);
		}
	}

private:
	std::atomic<StackNode*> head;
};

template <typename T, size_t CAPACITY>
class LockfreePoolingAllocator : public std::allocator<T> {
public:
	LockfreePoolingAllocator() = default;

	template <typename U, class = std::enable_if_t<!std::is_same_v<U, T>>>
	explicit constexpr LockfreePoolingAllocator(const U &) { }
	using value_type = T;

	T* allocate(size_t) const {
		ensurePreallocation();
		if (!localCache.empty()) {
			void* p = localCache.back();
			localCache.pop_back();
			return static_cast<T*>(p);
		}

		auto &inst = LockfreeFreeList<sizeof(T), CAPACITY>::get();
		void* p;
		if (!inst.pop(p)) {
			p = operator new(sizeof(T));
		}
		return static_cast<T*>(p);
	}

	void deallocate(T* p, size_t) const {
		if (localCache.size() < LOCAL_CACHE_LIMIT) {
			localCache.push_back(p);
		} else {
			auto &inst = LockfreeFreeList<sizeof(T), CAPACITY>::get();
			inst.push(p);
		}
	}

private:
	static thread_local std::vector<void*> localCache;
	static std::once_flag preallocationFlag;

	static void ensurePreallocation() {
		std::call_once(preallocationFlag, []() {
			LockfreeFreeList<sizeof(T), CAPACITY>::get().preallocate(STATIC_PREALLOCATION_SIZE);
		});
	}
};

template <typename T, size_t CAPACITY>
thread_local std::vector<void*> LockfreePoolingAllocator<T, CAPACITY>::localCache;

template <typename T, size_t CAPACITY>
std::once_flag LockfreePoolingAllocator<T, CAPACITY>::preallocationFlag;
