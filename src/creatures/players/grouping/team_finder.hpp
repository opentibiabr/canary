/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_CREATURES_PLAYERS_GROUPING_TEAM_FINDER_HPP_
#define SRC_CREATURES_PLAYERS_GROUPING_TEAM_FINDER_HPP_

/**
  * Team assemble finder.
  * This class is responsible control and manage the team finder feature.
**/

class TeamFinder {
 public:
	TeamFinder() = default;
	TeamFinder(uint16_t initMinLevel, uint16_t initMaxLevel, uint8_t initVocationIDs,
               uint16_t initTeamSlots, uint16_t initFreeSlots, bool initPartyBool,
               uint32_t initTimestamp, uint8_t initTeamType, uint16_t initBossID,
               uint16_t initHunt_type, uint16_t initHunt_area, uint16_t initQuestID,
               uint32_t initLeaderGuid, std::map<uint32_t, uint8_t> initMembersMap) :
            minLevel(initMinLevel),
            maxLevel(initMaxLevel),
            vocationIDs(initVocationIDs),
            teamSlots(initTeamSlots),
            freeSlots(initFreeSlots),
            partyBool(initPartyBool),
            timestamp(initTimestamp),
            teamType(initTeamType),
            bossID(initBossID),
            hunt_type(initHunt_type),
            hunt_area(initHunt_area),
            questID(initQuestID),
            leaderGuid(initLeaderGuid),
            membersMap(initMembersMap) {}
	virtual ~TeamFinder() = default;

	uint16_t minLevel = 0;
	uint16_t maxLevel = 0;
	uint8_t vocationIDs = 0;
	uint16_t teamSlots = 0;
	uint16_t freeSlots = 0;
	bool partyBool = false;
	uint32_t timestamp = 0;
	uint8_t teamType = 0;
	uint16_t bossID = 0;
	uint16_t hunt_type = 0;
	uint16_t hunt_area = 0;
	uint16_t questID = 0;
	uint32_t leaderGuid = 0;

	// list: player:getGuid(), player status
	std::map<uint32_t, uint8_t> membersMap = {};
};

#endif  // SRC_CREATURES_PLAYERS_GROUPING_TEAM_FINDER_HPP_
