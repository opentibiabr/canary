/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <parallel_hashmap/phmap.h>

class SharedObject;
using SharedObjectPtr = std::shared_ptr<SharedObject>;

class SharedObject : public std::enable_shared_from_this<SharedObject> {
public:
	virtual ~SharedObject() = default;

	SharedObject &operator=(const SharedObject &) = delete;

	SharedObjectPtr asSharedObject() {
		return shared_from_this();
	}

	template <typename T>
	std::shared_ptr<T> static_self_cast() {
		return std::static_pointer_cast<T>(shared_from_this());
	}

	template <typename T>
	std::shared_ptr<T> dynamic_self_cast() {
		return std::dynamic_pointer_cast<T>(shared_from_this());
	}

	template <typename TargetType, typename SourceType>
	std::shared_ptr<TargetType> static_self_cast(std::shared_ptr<SourceType> source) {
		return std::static_pointer_cast<TargetType>(source);
	}

	template <typename TargetType, typename SourceType>
	std::shared_ptr<TargetType> dynamic_self_cast(std::shared_ptr<SourceType> source) {
		return std::dynamic_pointer_cast<TargetType>(source);
	}
};
