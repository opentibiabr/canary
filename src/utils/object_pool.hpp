/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <memory>
#include <vector>
#include <mutex>

/**
 * @brief A thread-safe object pool for efficient memory allocation and reuse.
 *
 * This class provides an efficient mechanism for managing the allocation
 * and deallocation of objects, reducing the overhead associated with
 * frequent memory operations. The pool dynamically grows as needed and
 * reuses objects to minimize heap allocations.
 *
 * @tparam T The type of objects managed by the pool.
 */
template <typename T>
class ObjectPool {
public:
	/**
	 * @brief Alias for the smart pointer type used by the pool.
	 */
	using Ptr = std::shared_ptr<T>;

	/**
	 * @brief Acquires an object from the pool or creates a new one if the pool is empty.
	 *
	 * The object is constructed in place using the provided arguments.
	 * The `std::shared_ptr` includes a custom deleter that returns the object
	 * to the pool when it is no longer needed.
	 *
	 * @tparam Args The types of the arguments used to construct the object.
	 * @param args The arguments forwarded to the constructor of the object.
	 * @return A `std::shared_ptr` managing the allocated object.
	 */
	template <typename... Args>
	static Ptr acquireObject(Args &&... args) {
		std::lock_guard<std::mutex> lock(mutex_);
		if (!pool_.empty()) {
			T* obj = pool_.back();
			pool_.pop_back();

			// Construct the object in place with new arguments
			new (obj) T(std::forward<Args>(args)...);
			return Ptr(obj, [](T* ptr) {
				ptr->~T(); // Destroy the object
				releaseObject(ptr); // Return to the pool
			});
		}

		// Allocate a new object if the pool is empty
		T* rawPtr = allocator_.allocate(1);
		new (rawPtr) T(std::forward<Args>(args)...);
		return Ptr(rawPtr, [](T* ptr) {
			ptr->~T(); // Destroy the object
			releaseObject(ptr); // Return to the pool
		});
	}

private:
	/**
	 * @brief Returns an object to the pool for future reuse.
	 *
	 * This method is called automatically by the custom deleter when the
	 * `std::shared_ptr` is destroyed.
	 *
	 * @param obj The object to be returned to the pool.
	 */
	static void releaseObject(T* obj) {
		std::lock_guard<std::mutex> lock(mutex_);
		pool_.push_back(obj);
	}

	/**
	 * @brief The internal pool of objects available for reuse.
	 */
	static inline std::vector<T*> pool_;

	/**
	 * @brief The allocator instance used to allocate and deallocate objects.
	 */
	static inline std::allocator<T> allocator_;

	/**
	 * @brief A mutex to ensure thread safety when accessing the pool.
	 */
	static inline std::mutex mutex_;
};
