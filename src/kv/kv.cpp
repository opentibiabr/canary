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
	return setLocked(key, value);
}

void KVStore::setLocked(const std::string &key, const ValueWrapper &value) {
	std::optional<std::pair<std::string, ValueWrapper>> evicted;

	{
		std::scoped_lock lk(mutex_);

		if (store_.size() >= MAX_SIZE) {
			auto last = std::prev(lruQueue_.end());
			evicted = std::make_pair(*last, store_[*last].first);
			store_.erase(*last);
			lruQueue_.pop_back();
		}

		lruQueue_.remove(key);
		lruQueue_.push_front(key);
		store_[key] = std::make_pair(value, lruQueue_.begin());
	}

	if (evicted) {
		save(evicted->first, evicted->second);
	}
}

std::optional<ValueWrapper> KVStore::get(const std::string &key, bool forceLoad /*= false*/) {
	std::optional<ValueWrapper> cached;
	{
		std::scoped_lock lk(mutex_);
		if (!forceLoad) {
			auto it = store_.find(key);
			if (it != store_.end() && !it->second.first.isDeleted()) {
				cached = it->second.first;
			}
		}
	}

	if (cached) {
		return cached;
	}

	if (auto dbVal = load(key)) {
		set(key, *dbVal);
		return dbVal;
	}
	return std::nullopt;
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
