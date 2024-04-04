/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#include <vector>
#include <string>
#include <utility>

#include "kv/kv.hpp"

#include "test_injection.hpp"
#include "lib/di/container.hpp"

namespace di = boost::di;

class KVMemory final : public KVStore {
public:
	static di::extension::injector<> &install(di::extension::injector<> &injector) {
		injector.install(di::bind<KVStore>.to<KVMemory>().in(di::singleton));
		return injector;
	}

	explicit KVMemory(Logger &logger) :
		KVStore(logger) { }

	KVMemory &reset() {
		flush();
		return *this;
	}

protected:
	std::vector<std::string> loadPrefix(const std::string &prefix = "") override {
		return {};
	}
	std::optional<ValueWrapper> load(const std::string &key) override {
		return std::nullopt;
	}
	bool save(const std::string &key, const ValueWrapper &value) override {
		return false;
	}
};

template <>
struct TestInjection<KVStore> {
	using type = KVMemory;
};
