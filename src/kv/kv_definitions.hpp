/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class ValueWrapper;

#ifndef USE_PRECOMPILED_HEADERS
	#include <string>
	#include <vector>
	#include <memory>
	#include <variant>
#endif

using StringType = std::string;
using BooleanType = bool;
using IntType = int;
using DoubleType = double;
using ArrayType = std::vector<ValueWrapper>;
using MapType = std::unordered_map<std::string, std::shared_ptr<ValueWrapper>>;

using ValueVariant = std::variant<StringType, BooleanType, IntType, DoubleType, ArrayType, MapType>;
