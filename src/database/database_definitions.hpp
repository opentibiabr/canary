/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_DATABASE_DATABASE_DEFINITIONS_HPP_
#define SRC_DATABASE_DATABASE_DEFINITIONS_HPP_

// Enum
enum TransactionStates_t {
	STATE_NO_START,
	STATE_START,
	STATE_COMMIT,
};

#endif  // SRC_DATABASE_DATABASE_DEFINITIONS_HPP_
