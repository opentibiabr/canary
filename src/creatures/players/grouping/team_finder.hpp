/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

/**
 * Team assemble finder.
 * This class is responsible control and manage the team finder feature.
 **/

class TeamFinder final {
public:
	TeamFinder() = default;
	TeamFinder(uint16_t initMinLevel, uint16_t initMaxLevel, uint8_t initVocationIDs, uint16_t initTeamSlots, uint16_t initFreeSlots, bool initPartyBool, uint32_t initTimestamp, uint8_t initTeamType, uint16_t initBossID, uint16_t initHunt_type, uint16_t initHunt_area, uint16_t initQuestID, uint32_t initLeaderGuid, std::map<uint32_t, uint8_t> initMembersMap) :
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
		membersMap(std::move(initMembersMap)) { }
	~TeamFinder() = default;

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

static const std::unique_ptr<TeamFinder> &TeamFinderNull {};
