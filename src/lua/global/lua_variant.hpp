/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "enums/lua_variant_type.hpp"
#include "game/movement/position.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <string>
#endif

struct LuaVariant {
	LuaVariantType_t type = VARIANT_NONE;
	std::string text;
	std::string instantName;
	std::string runeName;
	Position pos;
	uint32_t number = 0;
};
