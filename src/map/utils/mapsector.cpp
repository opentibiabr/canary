/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/creature.hpp"
#include "mapsector.hpp"

bool MapSector::newSector = false;

void MapSector::addCreature(const std::shared_ptr<Creature> &c) {
	creature_list.emplace_back(c);
	if (c->getPlayer()) {
		player_list.emplace_back(c);
	}
}

void MapSector::removeCreature(const std::shared_ptr<Creature> &c) {
	auto iter = std::find(creature_list.begin(), creature_list.end(), c);
	if (iter == creature_list.end()) {
		g_logger().error("[{}]: Creature not found in creature_list!", __FUNCTION__);
		return;
	}

	assert(iter != creature_list.end());
	*iter = creature_list.back();
	creature_list.pop_back();

	if (c->getPlayer()) {
		iter = std::find(player_list.begin(), player_list.end(), c);
		if (iter == player_list.end()) {
			g_logger().error("[{}]: Player not found in player_list!", __FUNCTION__);
			return;
		}

		assert(iter != player_list.end());
		*iter = player_list.back();
		player_list.pop_back();
	}
}
