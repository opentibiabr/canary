/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "kv/kv.hpp"
#include "lib/di/container.hpp"
#include "utils/tools.hpp"

KVStore &KVStore::getInstance() {
	return inject<KVStore>();
}

void KVStore::set(const std::string &key, const std::initializer_list<ValueWrapper> &init_list) {
	ValueWrapper wrappedInitList(init_list);
	set(key, wrappedInitList);
}

void KVStore::set(const std::string &key, const std::initializer_list<std::pair<const std::string, ValueWrapper>> &init_list) {
	ValueWrapper wrappedInitList(init_list);
	set(key, wrappedInitList);
}

void KVStore::set(const std::string &key, const ValueWrapper &value) {
	std::lock_guard lock(mutex_);
	return setLocked(key, value);
}

void KVStore::setLocked(const std::string &key, const ValueWrapper &value) {
	logger.debug("KVStore::set({})", key);
	auto it = store_.find(key);
	if (it != store_.end()) {
		it->second.first = value;
		lruQueue_.splice(lruQueue_.begin(), lruQueue_, it->second.second);
	} else {
		if (store_.size() >= MAX_SIZE) {
			logger.debug("KVStore::set() - MAX_SIZE reached, removing last element");
			auto last = lruQueue_.end();
			last--;
			save(*last, store_[*last].first);
			store_.erase(*last);
			lruQueue_.pop_back();
		}

		lruQueue_.push_front(key);
		store_.try_emplace(key, std::make_pair(value, lruQueue_.begin()));
	}
}

std::optional<ValueWrapper> KVStore::get(const std::string &key, bool forceLoad /*= false */) {
	logger.debug("KVStore::get({})", key);
	std::lock_guard lock(mutex_);
	if (forceLoad || !store_.contains(key)) {
		auto value = load(key);
		if (value) {
			setLocked(key, *value);
		}
		return value;
	}

	auto &[value, timestamp] = store_[key];
	lruQueue_.splice(lruQueue_.begin(), lruQueue_, timestamp);
	return value;
}
