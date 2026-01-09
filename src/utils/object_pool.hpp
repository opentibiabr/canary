/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "utils/lockfree.hpp"

/**
 * @brief A lock-free object pool for efficient memory allocation and reuse.
 *
 * This class provides an efficient mechanism for managing the allocation
 * and deallocation of objects, reducing the overhead associated with
 * frequent memory operations. It uses a lock-free structure to ensure
 * thread safety and high performance in multithreaded environments.
 *
 * @tparam T The type of objects managed by the pool.
 * @tparam CAPACITY The maximum number of objects that can be held in the pool.
 */
template <typename T, size_t CAPACITY>
class ObjectPool {
public:
	/**
	 * @brief The allocator type used for managing object memory.
	 */
	using Allocator = LockfreePoolingAllocator<T, CAPACITY>;

	/**
	 * @brief Allocates an object from the pool and returns it as a `std::shared_ptr`.
	 *
	 * The object is constructed in place using the provided arguments.
	 * The `std::shared_ptr` includes a custom deleter that returns the object
	 * to the pool when it is no longer needed.
	 *
	 * @tparam Args The types of the arguments used to construct the object.* @param args The arguments forwarded to the constructor of the object.
	 * @return A `std::shared_ptr` managing the allocated object, or `nullptr` if the pool is empty.
	 */
	template <typename... Args>
	static std::shared_ptr<T> allocateShared(Args &&... args) {
		T* obj = allocator.allocate(1);
		if (obj) {
			// Construct the object in place
			std::construct_at(obj, std::forward<Args>(args)...);

			// Return a shared_ptr with a custom deleter
			return std::shared_ptr<T>(obj, [](T* ptr) {
				std::destroy_at(ptr); // Destroy the object
				allocator.deallocate(ptr, 1); // Return to the pool
			});
		}
		// Return nullptr if the pool is empty
		return nullptr;
	}

	static void clear() {
		allocator.clear();
	}

	/**
	 * @brief Preallocates a specified number of objects in the pool.
	 *
	 * This method allows you to populate the pool with preallocated objects
	 * to improve performance by reducing the need for dynamic allocations at runtime.
	 *
	 * @param count The number of objects to preallocate.
	 */
	static void preallocate(size_t count) {
		LockfreeFreeList<T, CAPACITY>::preallocate(count);
	}

private:
	/**
	 * @brief The allocator instance used to manage object memory.
	 */
	static Allocator allocator;
};

template <typename T, size_t CAPACITY>
typename ObjectPool<T, CAPACITY>::Allocator ObjectPool<T, CAPACITY>::allocator;
