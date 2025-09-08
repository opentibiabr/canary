/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "kv/kv.hpp"

#include "lib/di/container.hpp"
#include "database/database.hpp"

int64_t KV::lastTimestamp_ = 0;
uint64_t KV::counter_ = 0;
std::mutex KV::mutex_ = {};

KVStore &KVStore::getInstance() {
	return inject<KVStore>();
}

void KVStore::set(const std::string &key, const std::initializer_list<ValueWrapper> &init_list) {
	const ValueWrapper wrappedInitList(init_list);
	set(key, wrappedInitList);
}

void KVStore::set(const std::string &key, const std::initializer_list<std::pair<const std::string, ValueWrapper>> &init_list) {
	const ValueWrapper wrappedInitList(init_list);
	set(key, wrappedInitList);
}

void KVStore::set(const std::string &key, const ValueWrapper &value) {
	{
		std::scoped_lock lock(mutex_);
		setLocked(key, value);
	}
	processEvictions();
}

void KVStore::setLocked(const std::string &key, const ValueWrapper &value) {
	auto it = store_.find(key);
	if (it != store_.end()) {
		it->second.first = value;
		lruQueue_.splice(lruQueue_.begin(), lruQueue_, it->second.second);
	} else {
		std::string evictKey;
		ValueWrapper evictValue;
		bool needsEviction = false;

		if (store_.size() >= MAX_SIZE && !lruQueue_.empty()) {
			logger.debug("KVStore::set() - MAX_SIZE reached, removing last element");
			auto last = std::prev(lruQueue_.end());
			evictKey = *last;
			evictValue = store_[*last].first;
			needsEviction = true;
			store_.erase(*last);
			lruQueue_.pop_back();
		}

		lruQueue_.push_front(key);
		store_.try_emplace(key, std::make_pair(value, lruQueue_.begin()));

		if (needsEviction) {
			pendingEvictions_.emplace_back(evictKey, evictValue);
		}
	}
}

std::optional<ValueWrapper> KVStore::get(const std::string &key, bool forceLoad /*= false*/) {
	logger.trace("KVStore::get({})", key);

	{
		std::scoped_lock lock(mutex_);
		if (!forceLoad) {
			auto it = store_.find(key);
			if (it != store_.end()) {
				auto &[value, lruIt] = it->second;
				if (value.isDeleted()) {
					lruQueue_.splice(lruQueue_.end(), lruQueue_, lruIt);
					return std::nullopt;
				}
				lruQueue_.splice(lruQueue_.begin(), lruQueue_, lruIt);
				return value;
			}
		}
	}

	auto value = load(key);
	if (value) {
		{
			std::scoped_lock lock(mutex_);
			setLocked(key, *value);
		}
		processEvictions();
	}
	return value;
}

std::unordered_set<std::string> KVStore::keys(const std::string &prefix /*= ""*/) {
	std::unordered_set<std::string> keys;

	{
		std::scoped_lock lock(mutex_);
		for (const auto &[key, value] : store_) {
			if (key.find(prefix) == 0 && !value.first.isDeleted()) {
				std::string suffix = key.substr(prefix.size());
				keys.insert(suffix);
			}
		}
	}

	for (const auto &key : loadPrefix(prefix)) {
		keys.insert(key);
	}

	return keys;
}

void KV::remove(const std::string &key) {
	set(key, ValueWrapper::deleted());
}

std::shared_ptr<KV> KVStore::scoped(const std::string &scope) {
	logger.trace("KVStore::scoped({})", scope);
	return std::make_shared<ScopedKV>(logger, *this, scope);
}

void KVStore::processEvictions() {
	std::vector<std::pair<std::string, ValueWrapper>> evictions;
	{
		std::scoped_lock lock(mutex_);
		if (!pendingEvictions_.empty()) {
			evictions = std::move(pendingEvictions_);
			pendingEvictions_.clear();
		}
	}

	for (const auto &[key, value] : evictions) {
		save(key, value);
	}
}
