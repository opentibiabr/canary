/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#include "lib/di/soft_singleton.hpp"
#include "utils/tools.hpp"

SoftSingleton::SoftSingleton(std::string id) :
	id(std::move(id)) { }

void SoftSingleton::increment() {
	instance_count++;
	if (instance_count > 1) {
		logger.warn(
			"{} instances created for {}. This is a soft singleton, you probably want to use g_{} instead.",
			instance_count,
			id,
			asLowerCaseString(id)
		);
	}
}

void SoftSingleton::decrement() {
	instance_count--;
}

SoftSingletonGuard::SoftSingletonGuard(SoftSingleton &t) :
	tracker(t) {
	tracker.increment();
}

SoftSingletonGuard::~SoftSingletonGuard() {
	tracker.decrement();
}
