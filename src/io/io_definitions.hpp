/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

// Enums
enum FILELOADER_ERRORS {
	ERROR_NONE = 0,
	ERROR_INVALID_FILE_VERSION,
	ERROR_CAN_NOT_OPEN,
	ERROR_CAN_NOT_CREATE,
	ERROR_EOF,
	ERROR_SEEK_ERROR,
	ERROR_NOT_OPEN,
	ERROR_INVALID_NODE,
	ERROR_INVALID_FORMAT,
};

enum OTBM_AttrTypes_t {
	OTBM_ATTR_DESCRIPTION = 1,
	OTBM_ATTR_EXT_FILE = 2,
	OTBM_ATTR_TILE_FLAGS = 3,
	OTBM_ATTR_ACTION_ID = 4,
	OTBM_ATTR_UNIQUE_ID = 5,
	OTBM_ATTR_TEXT = 6,
	OTBM_ATTR_DESC = 7,
	OTBM_ATTR_TELE_DEST = 8,
	OTBM_ATTR_ITEM = 9,
	OTBM_ATTR_DEPOT_ID = 10,
	OTBM_ATTR_EXT_SPAWN_MONSTER_FILE = 11,
	OTBM_ATTR_RUNE_CHARGES = 12,
	OTBM_ATTR_EXT_HOUSE_FILE = 13,
	OTBM_ATTR_HOUSEDOORID = 14,
	OTBM_ATTR_COUNT = 15,
	OTBM_ATTR_DURATION = 16,
	OTBM_ATTR_DECAYING_STATE = 17,
	OTBM_ATTR_WRITTENDATE = 18,
	OTBM_ATTR_WRITTENBY = 19,
	OTBM_ATTR_SLEEPERGUID = 20,
	OTBM_ATTR_SLEEPSTART = 21,
	OTBM_ATTR_CHARGES = 22,
	OTBM_ATTR_EXT_SPAWN_NPC_FILE = 23,
	OTBM_ATTR_EXT_ZONE_FILE = 24,
};

enum OTBM_NodeTypes_t {
	OTBM_ROOTV1 = 1,
	OTBM_MAP_DATA = 2,
	OTBM_ITEM_DEF = 3,
	OTBM_TILE_AREA = 4,
	OTBM_TILE = 5,
	OTBM_ITEM = 6,
	OTBM_TILE_SQUARE = 7,
	OTBM_TILE_REF = 8,
	OTBM_SPAWNS = 9,
	OTBM_SPAWN_AREA = 10,
	OTBM_MONSTER = 11,
	OTBM_TOWNS = 12,
	OTBM_TOWN = 13,
	OTBM_HOUSETILE = 14,
	OTBM_WAYPOINTS = 15,
	OTBM_WAYPOINT = 16,
	OTBM_TILE_ZONE = 19
};

enum OTBM_TileFlag_t : uint32_t {
	OTBM_TILEFLAG_PROTECTIONZONE = 1 << 0,
	OTBM_TILEFLAG_NOPVPZONE = 1 << 2,
	OTBM_TILEFLAG_NOLOGOUT = 1 << 3,
	OTBM_TILEFLAG_PVPZONE = 1 << 4
};

// Structs
struct MarketStatistics {
	MarketStatistics() {
		numTransactions = 0;
		highestPrice = 0;
		totalPrice = 0;
		lowestPrice = 0;
	}

	uint32_t numTransactions;
	uint64_t highestPrice;
	uint64_t totalPrice;
	uint64_t lowestPrice;
};
