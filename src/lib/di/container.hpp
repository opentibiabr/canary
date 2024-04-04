/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#include "account/account_repository_db.hpp"
#include "lib/di/injector.hpp"
#include "lib/logging/log_with_spd_log.hpp"
#include "kv/kv_sql.hpp"

namespace di = boost::di;

class DI final {
private:
	inline static di::extension::injector<>* testContainer;
	const inline static auto defaultContainer = di::make_injector(
		di::bind<AccountRepository>().to<AccountRepositoryDB>().in(di::singleton),
		di::bind<KVStore>().to<KVSQL>().in(di::singleton),
		di::bind<Logger>().to<LogWithSpdLog>().in(di::singleton)
	);

public:
	inline static void setTestContainer(di::extension::injector<>* container) {
		testContainer = container;
	}

	/**
	 * Create will always return a new instance, it's used for unique instances or non-shared
	 * states. This can only be used by classes that allow being copied, cloned and moved.
	 * Instances acquired with create need to be managed by the caller using smart pointers.
	 */
	template <class T>
	inline static T create() {
		return testContainer ? testContainer->create<T>() : defaultContainer.create<T>();
	}

	/**
	 * Get returns you a reference of a instance that the DI contains.
	 * It will always return the same instance, it's used for singletons shared instances.
	 * Instances acquired with get are managed by the DI and can be merely references.
	 */
	template <class T>
	inline static T &get() {
		return create<T &>();
	}
};

/**
 * Simplified global function for contextual injection. Keep in mind that constructor injection is always
 * a better choice than contextual injection. This is only a helper to simplify injection in
 * complex legacy contexts.
 */
template <typename Type>
inline Type &inject() {
	return DI::get<Type>();
}
