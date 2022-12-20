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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_SERVER_SERVER_DEFINITIONS_HPP_
#define SRC_SERVER_SERVER_DEFINITIONS_HPP_

// Enums
// Connection and networkmessage.
enum {FORCE_CLOSE = true};
enum {HEADER_LENGTH = 2};
enum {CHECKSUM_LENGTH = 4};
enum {XTEA_MULTIPLE = 8};
enum {MAX_BODY_LENGTH = NETWORKMESSAGE_MAXSIZE - HEADER_LENGTH - CHECKSUM_LENGTH - XTEA_MULTIPLE};
enum {MAX_PROTOCOL_BODY_LENGTH = MAX_BODY_LENGTH - 10};

enum ConnectionState_t : uint8_t {
	CONNECTION_STATE_OPEN,
	CONNECTION_STATE_IDENTIFYING,
	CONNECTION_STATE_READINGS,
	CONNECTION_STATE_CLOSED
};
// Connection and networkmessage.

// Protocol.
enum RequestedInfo_t : uint16_t {
	REQUEST_BASIC_SERVER_INFO = 1 << 0,
	REQUEST_OWNER_SERVER_INFO = 1 << 1,
	REQUEST_MISC_SERVER_INFO = 1 << 2,
	REQUEST_PLAYERS_INFO = 1 << 3,
	REQUEST_MAP_INFO = 1 << 4,
	REQUEST_EXT_PLAYERS_INFO = 1 << 5,
	REQUEST_PLAYER_STATUS_INFO = 1 << 6,
	REQUEST_SERVER_SOFTWARE_INFO = 1 << 7,
};

enum ChecksumMethods_t : uint8_t {
	CHECKSUM_METHOD_NONE,
	CHECKSUM_METHOD_ADLER32,
	CHECKSUM_METHOD_SEQUENCE
};

enum SessionEndInformations : uint8_t {
	// Guessing unknown types are ban/protocol error or something.
	// But since there aren't any difference from logout should we care?
	SESSION_END_LOGOUT,
	SESSION_END_UNK2,
	SESSION_END_FORCECLOSE,
	SESSION_END_UNK3,
};

enum Resource_t : uint8_t {
	RESOURCE_BANK = 0x00,
	RESOURCE_INVENTORY = 0x01,
	RESOURCE_PREY_CARDS = 0x0A,
	RESOURCE_TASK_HUNTING = 0x32,
	RESOURCE_FORGE_DUST = 0x46,
	RESOURCE_FORGE_SLIVER = 0x47,
	RESOURCE_FORGE_CORES = 0x48,
	RESOURCE_WHEEL_OF_DESTINY = 0x56
};

enum InspectObjectTypes : uint8_t {
	INSPECT_NORMALOBJECT = 0,
	INSPECT_NPCTRADE = 1,
	INSPECT_PLAYERTRADE = 2,
	INSPECT_CYCLOPEDIA = 3
};

enum CyclopediaCharacterInfo_OutfitType_t : uint8_t {
	CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE = 0,
	CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST = 1,
	CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_STORE = 2
};

enum MagicEffectsType_t : uint8_t {
	//ends magic effect loop
	MAGIC_EFFECTS_END_LOOP = 0,
	// needs uint8_t delta after type to adjust position
	MAGIC_EFFECTS_DELTA = 1,
	// needs uint16_t delay after type to delay in miliseconds effect display
	MAGIC_EFFECTS_DELAY = 2,
	// needs uint8_t effectid after type
	MAGIC_EFFECTS_CREATE_EFFECT = 3,
	// needs uint8_t and deltaX(int8_t), deltaY(int8_t) after type
	MAGIC_EFFECTS_CREATE_DISTANCEEFFECT = 4,
	// needs uint8_t and deltaX(int8_t), deltaY(int8_t) after type
	MAGIC_EFFECTS_CREATE_DISTANCEEFFECT_REVERSED = 5,
	// needs uint16_t after type
	MAGIC_EFFECTS_CREATE_SOUND_MAIN_EFFECT = 6,
	// needs uint8_t and uint16_t after type
	MAGIC_EFFECTS_CREATE_SOUND_SECONDARY_EFFECT = 7,
};

enum ImpactAnalyzerAndTracker_t : uint8_t {
	ANALYZER_HEAL = 0,
	ANALYZER_DAMAGE_DEALT = 1,
	ANALYZER_DAMAGE_RECEIVED = 2
};

enum Supply_Stash_Actions_t : uint8_t {
	SUPPLY_STASH_ACTION_STOW_ITEM = 0,
	SUPPLY_STASH_ACTION_STOW_CONTAINER = 1,
	SUPPLY_STASH_ACTION_STOW_STACK = 2,
	SUPPLY_STASH_ACTION_WITHDRAW = 3
};

// Structs
struct HighscoreCategory {
	HighscoreCategory(const char* name, uint8_t id) :
        name(name),
        id(id) {}

	const char* name;
	uint8_t id;
};

struct HighscoreCharacter {
	HighscoreCharacter(std::string name, uint64_t points,
                       uint32_t id, uint32_t rank,
                       uint16_t level, uint8_t vocation) :
        name(std::move(name)),
        points(points),
        id(id),
        rank(rank),
        level(level),
        vocation(vocation) {}

	std::string name;
	uint64_t points;
	uint32_t id;
	uint32_t rank;
	uint16_t level;
	uint8_t vocation;
};

#endif  // SRC_SERVER_SERVER_DEFINITIONS_HPP_
