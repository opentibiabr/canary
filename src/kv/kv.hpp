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

class KV : public std::enable_shared_from_this<KV> {
public:
	virtual void set(const std::string &key, const std::initializer_list<ValueWrapper> &init_list) = 0;
	virtual void set(const std::string &key, const std::initializer_list<std::pair<const std::string, ValueWrapper>> &init_list) = 0;
	virtual void set(const std::string &key, const ValueWrapper &value) = 0;

	virtual std::optional<ValueWrapper> get(const std::string &key, bool forceLoad = false) = 0;

	virtual bool saveAll() {
		return true;
	}

	virtual std::shared_ptr<KV> scoped(const std::string &scope) = 0;

	void remove(const std::string &key);

	virtual void flush() {
		saveAll();
	}
};

class KVStore : public KV {
public:
	static constexpr size_t MAX_SIZE = 10000;
	static KVStore &getInstance();

	explicit KVStore(Logger &logger) :
		logger(logger) { }

	void set(const std::string &key, const std::initializer_list<ValueWrapper> &init_list) override;
	void set(const std::string &key, const std::initializer_list<std::pair<const std::string, ValueWrapper>> &init_list) override;
	void set(const std::string &key, const ValueWrapper &value) override;

	std::optional<ValueWrapper> get(const std::string &key, bool forceLoad = false) override;

	void flush() override {
		std::scoped_lock lock(mutex_);
		KV::flush();
		store_.clear();
	}

	std::shared_ptr<KV> scoped(const std::string &scope) override final;

protected:
	phmap::parallel_flat_hash_map<std::string, std::pair<ValueWrapper, std::list<std::string>::iterator>> getStore() {
		std::scoped_lock lock(mutex_);
		phmap::parallel_flat_hash_map<std::string, std::pair<ValueWrapper, std::list<std::string>::iterator>> copy;
		for (const auto &[key, value] : store_) {
			copy.try_emplace(key, value);
		}
		return copy;
	}

protected:
	Logger &logger;

	virtual std::optional<ValueWrapper> load(const std::string &key) = 0;
	virtual bool save(const std::string &key, const ValueWrapper &value) = 0;

private:
	void setLocked(const std::string &key, const ValueWrapper &value);

	phmap::parallel_flat_hash_map<std::string, std::pair<ValueWrapper, std::list<std::string>::iterator>> store_;
	std::list<std::string> lruQueue_;
	std::mutex mutex_;
};

class ScopedKV final : public KV {
public:
	ScopedKV(Logger &logger, KVStore &rootKV, const std::string &prefix) :
		logger(logger), rootKV_(rootKV), prefix_(prefix) { }

	void set(const std::string &key, const std::initializer_list<ValueWrapper> &init_list) override {
		rootKV_.set(buildKey(key), init_list);
	}
	void set(const std::string &key, const std::initializer_list<std::pair<const std::string, ValueWrapper>> &init_list) override {
		rootKV_.set(buildKey(key), init_list);
	}
	void set(const std::string &key, const ValueWrapper &value) override {
		rootKV_.set(buildKey(key), value);
	}

	std::optional<ValueWrapper> get(const std::string &key, bool forceLoad = false) override {
		return rootKV_.get(buildKey(key), forceLoad);
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
		return rootKV_.saveAll();
	}

	std::shared_ptr<KV> scoped(const std::string &scope) override final {
		logger.debug("ScopedKV::scoped({})", buildKey(scope));
		return std::make_shared<ScopedKV>(logger, rootKV_, buildKey(scope));
	}

private:
	std::string buildKey(const std::string &key) const {
		return fmt::format("{}.{}", prefix_, key);
	}

	Logger &logger;
	KVStore &rootKV_;
	std::string prefix_;
};

constexpr auto g_kv = KVStore::getInstance;
