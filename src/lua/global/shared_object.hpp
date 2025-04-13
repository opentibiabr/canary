/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 *
 * @file shared_object.hpp
 * @brief Provides the SharedObject class for efficient object sharing and type casting.
 *
 * This class implements a base for objects that need to be shared between different parts
 * of the application with smart pointer management. It provides optimized static and dynamic
 * casting operations with caching to reduce the performance impact of frequent casts.
 * The implementation uses C++20/23 features to ensure type safety and performance.
 *
 * Key features:
 * - Cached casting operations to improve performance
 * - Type safety using concepts
 * - Thread-safe reference counting via std::shared_ptr
 * - Memory-efficient caching using weak_ptr
 * - Nodiscard attributes to prevent accidental result discarding
 * - Move semantics to avoid unnecessary copying
 */

#pragma once

#include <parallel_hashmap/phmap.h>
#include <memory>
#include <concepts>
#include <type_traits>

template <typename To, typename From>
concept ConvertibleTo = std::is_convertible_v<From*, To*>;

class SharedObject;
using SharedObjectPtr = std::shared_ptr<SharedObject>;

class SharedObject : public std::enable_shared_from_this<SharedObject> {
public:
	virtual ~SharedObject() = default;

	SharedObject &operator=(const SharedObject &) = delete;
	SharedObject(const SharedObject &) = delete;
	SharedObject() = default;

	[[nodiscard]] SharedObjectPtr asSharedObject() {
		return shared_from_this();
	}

	template <typename T>
	[[nodiscard]] std::shared_ptr<T> static_self_cast() {
		auto type_idx = std::type_index(typeid(T));

		auto it = cast_cache.find(type_idx);
		if (it != cast_cache.end()) {
			if (auto cached = it->second.lock()) {
				return std::static_pointer_cast<T>(std::static_pointer_cast<void>(cached));
			}
			cast_cache.erase(it);
		}

		auto result = std::static_pointer_cast<T>(shared_from_this());
		cast_cache[type_idx] = result;

		return result;
	}

	template <typename T>
	[[nodiscard]] std::shared_ptr<const T> static_self_cast() const {
		auto type_idx = std::type_index(typeid(const T));

		auto it = cast_cache.find(type_idx);
		if (it != cast_cache.end()) {
			if (auto cached = it->second.lock()) {
				return std::static_pointer_cast<const T>(std::static_pointer_cast<void>(cached));
			}
			cast_cache.erase(it);
		}

		auto result = std::static_pointer_cast<const T>(shared_from_this());
		cast_cache[type_idx] = result;

		return result;
	}

	template <typename T>
	[[nodiscard]] std::shared_ptr<T> dynamic_self_cast() {
		auto type_idx = std::type_index(typeid(T));

		auto it = cast_cache.find(type_idx);
		if (it != cast_cache.end()) {
			if (auto cached = it->second.lock()) {
				return std::static_pointer_cast<T>(std::static_pointer_cast<void>(cached));
			}
			cast_cache.erase(it);
		}

		auto result = std::dynamic_pointer_cast<T>(shared_from_this());
		if (result) {
			cast_cache[type_idx] = result;
		}

		return result;
	}

	template <typename TargetType, typename SourceType>
		requires ConvertibleTo<TargetType, SourceType>
	[[nodiscard]] static std::shared_ptr<TargetType> static_cast_ptr(std::shared_ptr<SourceType> source) {
		return std::static_pointer_cast<TargetType>(std::move(source));
	}

	template <typename TargetType, typename SourceType>
	[[nodiscard]] static std::shared_ptr<TargetType> dynamic_cast_ptr(std::shared_ptr<SourceType> source) {
		return std::dynamic_pointer_cast<TargetType>(std::move(source));
	}

	void clear_cast_cache() {
		cast_cache.clear();
	}

private:
	mutable phmap::flat_hash_map<std::type_index, std::weak_ptr<void>> cast_cache;
};
