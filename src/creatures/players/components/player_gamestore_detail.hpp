/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "kv/value_wrapper_proto.hpp"

class ValueWrapper;

#ifndef USE_PRECOMPILED_HEADERS
	#include <string>
	#include <cstdint>
#endif

struct StoreDetail {
	std::string description;
	int32_t coinAmount {};
	int createdAt {};
	bool isGold {};

	std::string toString() const;
	ValueWrapper serialize() const;
	static StoreDetail deserialize(const ValueWrapper &val);
};
