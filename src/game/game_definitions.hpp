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

#ifndef SRC_GAME_GAME_DEFINITIONS_HPP_
#define SRC_GAME_GAME_DEFINITIONS_HPP_

#include "movement/position.h"

// Enums
enum Offer_t {
	DISABLED=0,
	ITEM=1,
	STACKABLE_ITEM=2,
	OUTFIT=3,
	OUTFIT_ADDON=4,
	MOUNT=5,
	NAMECHANGE=6,
	SEXCHANGE=7,
	PROMOTION=8,
	PREMIUM_TIME,
	TELEPORT,
	BLESSING,
	BOOST_XP, //not using yet
	BOOST_STAMINA, //not using yet
	WRAP_ITEM
};

enum ClientOffer_t{
	SIMPLE = 0,
	ADDITIONALINFO = 1
};

enum StackPosType_t {
	STACKPOS_MOVE,
	STACKPOS_LOOK,
	STACKPOS_TOPDOWN_ITEM,
	STACKPOS_USEITEM,
	STACKPOS_USETARGET,
	STACKPOS_FIND_THING,
};

enum WorldType_t {
	WORLD_TYPE_NO_PVP = 1,
	WORLD_TYPE_PVP = 2,
	WORLD_TYPE_PVP_ENFORCED = 3,
};

enum GameState_t {
	GAME_STATE_STARTUP,
	GAME_STATE_INIT,
	GAME_STATE_NORMAL,
	GAME_STATE_CLOSED,
	GAME_STATE_SHUTDOWN,
	GAME_STATE_CLOSING,
	GAME_STATE_MAINTAIN,
};

enum QuickLootFilter_t {
	QUICKLOOTFILTER_SKIPPEDLOOT = 0,
	QUICKLOOTFILTER_ACCEPTEDLOOT = 1,
};

enum Faction_t {
	FACTION_DEFAULT = 0,
	FACTION_PLAYER = 1,
	FACTION_LION = 2,
	FACTION_LIONUSURPERS = 3,
	FACTION_LAST = FACTION_LIONUSURPERS,
};

enum LightState_t {
	LIGHT_STATE_DAY,
	LIGHT_STATE_NIGHT,
	LIGHT_STATE_SUNSET,
	LIGHT_STATE_SUNRISE,
};

enum CyclopediaCharacterInfoType_t : uint8_t {
	CYCLOPEDIA_CHARACTERINFO_BASEINFORMATION = 0,
	CYCLOPEDIA_CHARACTERINFO_GENERALSTATS = 1,
	CYCLOPEDIA_CHARACTERINFO_COMBATSTATS = 2,
	CYCLOPEDIA_CHARACTERINFO_RECENTDEATHS = 3,
	CYCLOPEDIA_CHARACTERINFO_RECENTPVPKILLS = 4,
	CYCLOPEDIA_CHARACTERINFO_ACHIEVEMENTS = 5,
	CYCLOPEDIA_CHARACTERINFO_ITEMSUMMARY = 6,
	CYCLOPEDIA_CHARACTERINFO_OUTFITSMOUNTS = 7,
	CYCLOPEDIA_CHARACTERINFO_STORESUMMARY = 8,
	CYCLOPEDIA_CHARACTERINFO_INSPECTION = 9,
	CYCLOPEDIA_CHARACTERINFO_BADGES = 10,
	CYCLOPEDIA_CHARACTERINFO_TITLES = 11
};

enum CyclopediaCharacterInfo_RecentKillStatus_t : uint8_t {
	CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_JUSTIFIED = 0,
	CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_UNJUSTIFIED = 1,
	CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_GUILDWAR = 2,
	CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_ASSISTED = 3,
	CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_ARENA = 4
};

enum HighscoreCategories_t : uint8_t {
	HIGHSCORE_CATEGORY_EXPERIENCE = 0,
	HIGHSCORE_CATEGORY_FIST_FIGHTING,
	HIGHSCORE_CATEGORY_CLUB_FIGHTING,
	HIGHSCORE_CATEGORY_SWORD_FIGHTING,
	HIGHSCORE_CATEGORY_AXE_FIGHTING,
	HIGHSCORE_CATEGORY_DISTANCE_FIGHTING,
	HIGHSCORE_CATEGORY_SHIELDING,
	HIGHSCORE_CATEGORY_FISHING,
	HIGHSCORE_CATEGORY_MAGIC_LEVEL
};

enum HighscoreType_t : uint8_t {
	HIGHSCORE_GETENTRIES = 0,
	HIGHSCORE_OURRANK = 1
};

enum Webhook_Colors_t : uint32_t {
	WEBHOOK_COLOR_ONLINE = 0x00FF00,
	WEBHOOK_COLOR_OFFLINE = 0xFF0000,
	WEBHOOK_COLOR_WARNING = 0xFFFF00,
	WEBHOOK_COLOR_RAID = 0x0000FF
};

// Structs
struct ModalWindow {
	std::list<std::pair<std::string, uint8_t>> buttons, choices;
	std::string title, message;
	uint32_t id;
	uint8_t defaultEnterButton, defaultEscapeButton;
	bool priority;

	ModalWindow(uint32_t newId, std::string newTitle, std::string newMessage) :
                    title(std::move(newTitle)),
                    message(std::move(newMessage)),
                    id(newId),
                    defaultEnterButton(0xFF),
                    defaultEscapeButton(0xFF),
					priority(false) {}
};

#endif  // SRC_GAME_GAME_DEFINITIONS_HPP_
