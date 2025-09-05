/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <string>
	#include <mutex>
	#include <initializer_list>
	#include <parallel_hashmap/phmap.h>
	#include <optional>
	#include <unordered_set>
	#include <iomanip>
	#include <list>
	#include <utility>
#endif

#include "kv/value_wrapper.hpp"

class KV : public std::enable_shared_from_this<KV> {
public:
	virtual ~KV() = default;
	virtual void set(const std::string &key, const std::initializer_list<ValueWrapper> &init_list) = 0;
	virtual void set(const std::string &key, const std::initializer_list<std::pair<const std::string, ValueWrapper>> &init_list) = 0;
	virtual void set(const std::string &key, const ValueWrapper &value) = 0;

	virtual std::optional<ValueWrapper> get(const std::string &key, bool forceLoad = false) = 0;

	virtual bool saveAll() {
		return true;
	}

	virtual std::shared_ptr<KV> scoped(const std::string &scope) = 0;

	virtual std::unordered_set<std::string> keys(const std::string &prefix = "") = 0;

	void remove(const std::string &key);

	virtual void flush() {
		saveAll();
	}

	static std::string generateUUID() {
		std::lock_guard<std::mutex> lock(mutex_);

		const auto now = std::chrono::system_clock::now().time_since_epoch();
		const auto milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(now).count();

		if (milliseconds != lastTimestamp_) {
			counter_ = 0;
			lastTimestamp_ = milliseconds;
		} else {
			++counter_;
		}

		std::stringstream ss;
		ss << std::setw(20) << std::setfill('0') << milliseconds << "-"
		   << std::setw(12) << std::setfill('0') << counter_;

		return ss.str();
	}

private:
	static int64_t lastTimestamp_;
	static uint64_t counter_;
	static std::mutex mutex_;
};

class KVStore : public KV {
public:
	static constexpr size_t MAX_SIZE = 1000000;
	static KVStore &getInstance();

	explicit KVStore(Logger &logger) :
		logger(logger) { }

	void set(const std::string &key, const std::initializer_list<ValueWrapper> &init_list) override;
	void set(const std::string &key, const std::initializer_list<std::pair<const std::string, ValueWrapper>> &init_list) override;
	void set(const std::string &key, const ValueWrapper &value) override;

	std::optional<ValueWrapper> get(const std::string &key, bool forceLoad = false) override;

	void flush() override {
		std::vector<std::pair<std::string, ValueWrapper>> snapshot;
		{
			std::scoped_lock lock(mutex_);
			snapshot.reserve(store_.size() + pendingEvictions_.size());
			for (const auto &[k, v] : store_) {
				snapshot.emplace_back(k, v.first);
			}
			snapshot.insert(snapshot.end(), pendingEvictions_.begin(), pendingEvictions_.end());
			store_.clear();
			pendingEvictions_.clear();
		}
		for (const auto &[k, v] : snapshot) {
			save(k, v);
		}
	}

	std::shared_ptr<KV> scoped(const std::string &scope) final;
	std::unordered_set<std::string> keys(const std::string &prefix = "") override;

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
	virtual std::vector<std::string> loadPrefix(const std::string &prefix = "") = 0;

private:
	void setLocked(const std::string &key, const ValueWrapper &value);
	void processEvictions();

	phmap::parallel_flat_hash_map<std::string, std::pair<ValueWrapper, std::list<std::string>::iterator>> store_;
	std::list<std::string> lruQueue_;
	std::mutex mutex_;
	// Evicted entries pending persistence; accessed under mutex_
	std::vector<std::pair<std::string, ValueWrapper>> pendingEvictions_;
};

class ScopedKV final : public KV {
public:
	ScopedKV(Logger &logger, KVStore &rootKV, std::string prefix) :
		logger(logger), rootKV_(rootKV), prefix_(std::move(prefix)) { }

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
		const auto optValue = get(key, forceLoad);
		if (optValue.has_value()) {
			return optValue->get<T>();
		}
		return T {};
	}

	bool saveAll() override {
		return rootKV_.saveAll();
	}

	std::shared_ptr<KV> scoped(const std::string &scope) override {
		logger.trace("ScopedKV::scoped({})", buildKey(scope));
		return std::make_shared<ScopedKV>(logger, rootKV_, buildKey(scope));
	}

	std::unordered_set<std::string> keys(const std::string &prefix = "") override {
		return rootKV_.keys(buildKey(prefix));
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
