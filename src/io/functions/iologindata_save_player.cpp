/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "io/functions/iologindata_save_player.hpp"

bool IOLoginDataSave::savePlayerForgeHistory(Player *player) {
	std::ostringstream query;
	query << "DELETE FROM `forge_history` WHERE `player_id` = " << player->getGUID();
	if (!Database::getInstance().executeQuery(query.str())) {
		return false;
	}

	query.str(std::string());

	DBInsert insertQuery("INSERT INTO `forge_history` (`player_id`, `action_type`, `description`, `done_at`, `is_success`) VALUES");
	for (const auto &history : player->getForgeHistory()) {
		const auto stringDescription = Database::getInstance().escapeString(history.description);
		auto actionString = magic_enum::enum_integer(history.actionType);
		// Append query informations
		query << player->getGUID() << ','
		<< std::to_string(actionString) << ','
		<< stringDescription << ','
		<< history.createdAt << ','
		<< history.success;

		if (!insertQuery.addRow(query)) {
			return false;
		}
	}

	if (!insertQuery.execute()) {
		return false;
	}

	return true;
}
