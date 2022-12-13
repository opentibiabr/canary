/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_IO_FUNCTIONS_IOLOGINDATALOAD_HPP_
#define SRC_IO_FUNCTIONS_IOLOGINDATALOAD_HPP_

#include "io/iologindata.h"

class IOLoginDataLoad : public IOLoginData
{
public:
	static void loadPlayerForgeHistory(Player *player, DBResult_ptr result);
};

#endif  // SRC_IO_FUNCTIONS_IOLOGINDATALOAD_HPP_
