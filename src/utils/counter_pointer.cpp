/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "utils/counter_pointer.hpp"

#include "lib/di/container.hpp"
#include "lib/logging/logger.hpp"

SharedPtrManager &SharedPtrManager::getInstance() {
	static SharedPtrManager instance;
	return instance;
}

void SharedPtrManager::countAllReferencesAndClean() {
	for (auto it = m_sharedPtrMap.begin(); it != m_sharedPtrMap.end();) {
		const auto &sptr = it->second.lock();
		if (sptr) {
			g_logger().debug("Counting references of shared_ptr ({}): {}", it->first, sptr.use_count());
			++it;
		} else {
			g_logger().debug("Object {} was destroyed and will be removed from the map.", it->first);
			it = m_sharedPtrMap.erase(it);
		}
	}
}
