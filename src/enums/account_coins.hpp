/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

enum class CoinTransactionType : uint8_t {
	Add = 1,
	Remove = 2
};

enum class CoinType : uint8_t {
	Normal = 1,
	Tournament = 2,
	Transferable = 3
};
