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

namespace weak {
	template <typename T>
	struct Hash {
		std::size_t operator()(const std::weak_ptr<T> &wp) const {
			auto sp = wp.lock();
			return std::hash<std::shared_ptr<T>>()(sp);
		}
	};

	template <typename T>
	struct Equal {
		bool operator()(const std::weak_ptr<T> &lhs, const std::weak_ptr<T> &rhs) const {
			return lhs.lock() == rhs.lock();
		}
	};

	template <typename T>
	using parallel_flat_hash_set = phmap::parallel_flat_hash_set<std::weak_ptr<T>, Hash<T>, Equal<T>>;

	template <typename T>
	using vector = std::vector<std::weak_ptr<T>>;

	template <typename T>
	using list = std::list<std::weak_ptr<T>>;

	template <typename T>
	typename list<T>::iterator find(const list<T> &lst, const std::shared_ptr<T> &item) {
		return std::find_if(lst.begin(), lst.end(), [item](const std::weak_ptr<T> &weak) {
			return weak.lock() == item;
		});
	}

	template <typename T>
	typename weak::vector<T>::const_iterator find(const weak::vector<T> &vec, const std::shared_ptr<T> &item) {
		return std::find_if(vec.cbegin(), vec.cend(), [item](const std::weak_ptr<T> &weak) {
			return weak.lock() == item;
		});
	}

	template <typename T>
	typename weak::vector<T>::iterator find(weak::vector<T> &vec, const std::shared_ptr<T> &item) {
		return std::find_if(vec.begin(), vec.end(), [item](const std::weak_ptr<T> &weak) {
			return weak.lock() == item;
		});
	}

	template <typename T>
	bool erase(parallel_flat_hash_set<T> &set, const std::shared_ptr<T> &item) {
		return set.erase(item) > 0;
	}

	template <typename T>
	bool erase(vector<T> &vec, const std::shared_ptr<T> &item) {
		auto it = find(vec, item);
		if (it != vec.end()) {
			vec.erase(it);
			return true;
		}
		return false;
	}

	template <typename T>
	bool erase(list<T> &lst, const std::shared_ptr<T> &item) {
		auto it = find(lst, item);
		if (it != lst.end()) {
			lst.erase(it);
			return true;
		}
		return false;
	}

	template <typename T>
	std::vector<std::shared_ptr<T>> lock(vector<T> &vec) {
		std::vector<std::shared_ptr<T>> result;
		result.reserve(vec.size());
		for (auto it = vec.begin(); it != vec.end();) {
			if (auto shared = it->lock()) {
				result.push_back(shared);
				++it;
			} else {
				it = vec.erase(it);
			}
		}
		return result;
	}

	template <typename T>
	std::vector<std::shared_ptr<T>> lock(list<T> &lst) {
		std::vector<std::shared_ptr<T>> result;
		result.reserve(lst.size());
		for (auto it = lst.begin(); it != lst.end();) {
			if (auto shared = it->lock()) {
				result.push_back(shared);
				++it;
			} else {
				it = lst.erase(it);
			}
		}
		return result;
	}

	template <typename T>
	phmap::parallel_flat_hash_set<std::shared_ptr<T>> lock(parallel_flat_hash_set<T> &set) {
		phmap::parallel_flat_hash_set<std::shared_ptr<T>> result;
		result.reserve(set.size());
		for (auto it = set.begin(); it != set.end();) {
			if (auto shared = it->lock()) {
				result.insert(shared);
				++it;
			} else {
				it = set.erase(it);
			}
		}
		return result;
	}
}
