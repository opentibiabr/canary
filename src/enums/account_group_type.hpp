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
	#include <cstdint>
#endif

enum GroupType : uint8_t {
	GROUP_TYPE_NONE = 0,
	GROUP_TYPE_NORMAL = 1,
	GROUP_TYPE_TUTOR = 2,
	GROUP_TYPE_SENIORTUTOR = 3,
	GROUP_TYPE_GAMEMASTER = 4,
	GROUP_TYPE_COMMUNITYMANAGER = 5,
	GROUP_TYPE_GOD = 6
};
