/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_IO__FUNCTIONS_IOLOGINDATASAVE_HPP_
#define SRC_IO__FUNCTIONS_IOLOGINDATASAVE_HPP_

#include "io/iologindata.h"

class IOLoginDataSave : public IOLoginData
{
public:
	static bool savePlayerForgeHistory(Player *player);
};

#endif  // SRC_IO__FUNCTIONS_IOLOGINDATASAVE_HPP_
