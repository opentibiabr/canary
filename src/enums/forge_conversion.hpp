/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

enum class ForgeAction_t : uint8_t {
	FUSION = 0,
	TRANSFER = 1,
	DUSTTOSLIVERS = 2,
	SLIVERSTOCORES = 3,
	INCREASELIMIT = 4
};
