/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <string>
#include <mutex>
#include <initializer_list>
#include <parallel_hashmap/phmap.h>
#include <optional>

#include "lib/logging/logger.hpp"
#include "kv/value_wrapper.hpp"

class KVStore {
public:
	static constexpr size_t MAX_SIZE = 10000;

	static KVStore &getInstance();

	explicit KVStore(Logger &logger) :
		logger(logger) { }
	virtual ~KVStore() = default;

	template <typename T>
	void set(const std::string &key, const std::vector<T> &vec);
	virtual void set(const std::string &key, const std::initializer_list<ValueWrapper> &init_list);
	virtual void set(const std::string &key, const std::initializer_list<std::pair<const std::string, ValueWrapper>> &init_list);
	virtual void set(const std::string &key, const ValueWrapper &value);

	virtual std::optional<ValueWrapper> get(const std::string &key, bool forceLoad = false);

	template <typename T>
	T get(const std::string &key, bool forceLoad = false);

	virtual bool saveAll() {
		return true;
	}

	template <typename T>
	std::shared_ptr<KVStore> scoped(const T &scope);

	friend class ScopedKV;

	void flush() {
		saveAll();
		store_.clear();
	}

protected:
	phmap::parallel_flat_hash_map<std::string, std::pair<ValueWrapper, std::list<std::string>::iterator>> getStore() {
		std::scoped_lock lock(mutex_);
		phmap::parallel_flat_hash_map<std::string, std::pair<ValueWrapper, std::list<std::string>::iterator>> copy;
		for (const auto &[key, value] : store_) {
			copy.try_emplace(key, value);
		}
		return copy;
	}
	virtual std::optional<ValueWrapper> load(const std::string &key) = 0;
	virtual bool save(const std::string &key, const ValueWrapper &value) = 0;
	Logger &logger;

private:
	void setLocked(const std::string &key, const ValueWrapper &value);

	phmap::parallel_flat_hash_map<std::string, std::pair<ValueWrapper, std::list<std::string>::iterator>> store_;
	std::list<std::string> lruQueue_;
	std::mutex mutex_;
};

template <typename T>
void KVStore::set(const std::string &key, const std::vector<T> &vec) {
	ValueWrapper wrapped(vec);
	set(key, wrapped);
}

template <typename T>
T KVStore::get(const std::string &key, bool forceLoad /*= false */) {
	auto optValue = get(key, forceLoad);
	if (optValue.has_value()) {
		return optValue->get<T>();
	}
	return T {};
}

class ScopedKV final : public KVStore {
public:
	ScopedKV(KVStore &parentKV, const std::string &prefix) :
		KVStore(parentKV.logger), parentKV_(parentKV), prefix_(prefix) { }

	template <typename T>
	void set(const std::string &key, const std::vector<T> &vec) {
		parentKV_.set(buildKey(key), vec);
	}
	void set(const std::string &key, const std::initializer_list<ValueWrapper> &init_list) override {
		parentKV_.set(buildKey(key), init_list);
	}
	void set(const std::string &key, const std::initializer_list<std::pair<const std::string, ValueWrapper>> &init_list) override {
		parentKV_.set(buildKey(key), init_list);
	}
	void set(const std::string &key, const ValueWrapper &value) override {
		parentKV_.set(buildKey(key), value);
	}

	std::optional<ValueWrapper> get(const std::string &key, bool forceLoad = false) override {
		return parentKV_.get(buildKey(key), forceLoad);
	}

	template <typename T>
	T get(const std::string &key, bool forceLoad = false) {
		auto optValue = get(key, forceLoad);
		if (optValue.has_value()) {
			return optValue->get<T>();
		}
		return T {};
	}

	bool saveAll() override {
		return parentKV_.saveAll();
	}

protected:
	std::optional<ValueWrapper> load(const std::string &key) override {
		return parentKV_.load(buildKey(key));
	}
	bool save(const std::string &key, const ValueWrapper &value) override {
		return parentKV_.save(buildKey(key), value);
	}

private:
	std::string buildKey(const std::string &key) const {
		return prefix_ + "." + key;
	}

	KVStore &parentKV_;
	std::string prefix_;
};

template <typename T>
std::shared_ptr<KVStore> KVStore::scoped(const T &scope) {
	return std::make_shared<ScopedKV>(*this, fmt::format("{}", scope));
}

constexpr auto g_kv = KVStore::getInstance;
