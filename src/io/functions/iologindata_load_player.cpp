/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "io/functions/iologindata_load_player.hpp"

void IOLoginDataLoad::loadPlayerForgeHistory(Player *player, DBResult_ptr result) {
	std::ostringstream query;
	query << "SELECT * FROM `forge_history` WHERE `player_id` = " << player->getGUID();
	if (result = Database::getInstance().storeQuery(query.str())) {
		do {
			auto actionEnum = magic_enum::enum_value<ForgeConversion_t>(result->getNumber<uint16_t>("action_type"));
			ForgeHistory history;
			history.actionType = actionEnum;
			history.description = result->getString("description");
			history.createdAt = result->getNumber<time_t>("done_at");
			history.success = result->getNumber<bool>("is_success");
			player->setForgeHistory(history);
		} while (result->next());
	}
}
