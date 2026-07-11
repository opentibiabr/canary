/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <cstdint>

namespace ImbuementStoragePolicy {
	template <typename StorageReader>
	[[nodiscard]] bool shouldHide(bool storageFilteringEnabled, uint32_t storageId, uint16_t baseId, StorageReader &&readStorage) {
		if (!storageFilteringEnabled || storageId == 0 || baseId < 1 || baseId > 3) {
			return false;
		}

		return readStorage(storageId) == -1;
	}
}
