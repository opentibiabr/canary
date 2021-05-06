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

#ifndef SRC_LUA_FUNCTIONS_CORE_GAME_CONFIG_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_GAME_CONFIG_FUNCTIONS_HPP_

#include "config/configmanager.h"
#include "lua/scripts/luascript.h"

class ConfigFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerTable(L, "configManager");
			registerMethod(L, "configManager", "getString", ConfigFunctions::luaConfigManagerGetString);
			registerMethod(L, "configManager", "getNumber", ConfigFunctions::luaConfigManagerGetNumber);
			registerMethod(L, "configManager", "getBoolean", ConfigFunctions::luaConfigManagerGetBoolean);

			#define registerEnumIn(L, tableName, value) { \
				std::string enumName = #value; \
				registerVariable(L, tableName, enumName.substr(enumName.find_last_of(':') + 1), value); \
			}
			registerTable(L, "configKeys");
			registerEnumIn(L, "configKeys", ConfigManager::ALLOW_CHANGEOUTFIT)
			registerEnumIn(L, "configKeys", ConfigManager::ONE_PLAYER_ON_ACCOUNT)
			registerEnumIn(L, "configKeys", ConfigManager::AIMBOT_HOTKEY_ENABLED)
			registerEnumIn(L, "configKeys", ConfigManager::REMOVE_RUNE_CHARGES)
			registerEnumIn(L, "configKeys", ConfigManager::EXPERIENCE_FROM_PLAYERS)
			registerEnumIn(L, "configKeys", ConfigManager::FREE_PREMIUM)
			registerEnumIn(L, "configKeys", ConfigManager::REPLACE_KICK_ON_LOGIN)
			registerEnumIn(L, "configKeys", ConfigManager::ALLOW_CLONES)
			registerEnumIn(L, "configKeys", ConfigManager::BIND_ONLY_GLOBAL_ADDRESS)
			registerEnumIn(L, "configKeys", ConfigManager::OPTIMIZE_DATABASE)
			registerEnumIn(L, "configKeys", ConfigManager::MARKET_PREMIUM)
			registerEnumIn(L, "configKeys", ConfigManager::EMOTE_SPELLS)
			registerEnumIn(L, "configKeys", ConfigManager::STAMINA_SYSTEM)
			registerEnumIn(L, "configKeys", ConfigManager::WARN_UNSAFE_SCRIPTS)
			registerEnumIn(L, "configKeys", ConfigManager::CONVERT_UNSAFE_SCRIPTS)
			registerEnumIn(L, "configKeys", ConfigManager::CLASSIC_EQUIPMENT_SLOTS)
			registerEnumIn(L, "configKeys", ConfigManager::ALLOW_BLOCK_SPAWN)
			registerEnumIn(L, "configKeys", ConfigManager::CLASSIC_ATTACK_SPEED)
			registerEnumIn(L, "configKeys", ConfigManager::REMOVE_WEAPON_AMMO)
			registerEnumIn(L, "configKeys", ConfigManager::REMOVE_WEAPON_CHARGES)
			registerEnumIn(L, "configKeys", ConfigManager::REMOVE_POTION_CHARGES)
			registerEnumIn(L, "configKeys", ConfigManager::STOREMODULES)
			registerEnumIn(L, "configKeys", ConfigManager::WEATHER_RAIN)
			registerEnumIn(L, "configKeys", ConfigManager::WEATHER_THUNDER)
			registerEnumIn(L, "configKeys", ConfigManager::FREE_QUESTS)
			registerEnumIn(L, "configKeys", ConfigManager::ALL_CONSOLE_LOG)
			registerEnumIn(L, "configKeys", ConfigManager::SERVER_SAVE_NOTIFY_MESSAGE)
			registerEnumIn(L, "configKeys", ConfigManager::SERVER_SAVE_NOTIFY_DURATION)
			registerEnumIn(L, "configKeys", ConfigManager::SERVER_SAVE_CLEAN_MAP)
			registerEnumIn(L, "configKeys", ConfigManager::SERVER_SAVE_CLOSE)
			registerEnumIn(L, "configKeys", ConfigManager::SERVER_SAVE_SHUTDOWN)
			registerEnumIn(L, "configKeys", ConfigManager::MAP_NAME)
			registerEnumIn(L, "configKeys", ConfigManager::MAP_CUSTOM_NAME)
			registerEnumIn(L, "configKeys", ConfigManager::MAP_CUSTOM_FILE)
			registerEnumIn(L, "configKeys", ConfigManager::MAP_CUSTOM_SPAWN)
			registerEnumIn(L, "configKeys", ConfigManager::MAP_CUSTOM_ENABLED)
			registerEnumIn(L, "configKeys", ConfigManager::HOUSE_RENT_PERIOD)
			registerEnumIn(L, "configKeys", ConfigManager::SERVER_NAME)
			registerEnumIn(L, "configKeys", ConfigManager::OWNER_NAME)
			registerEnumIn(L, "configKeys", ConfigManager::OWNER_EMAIL)
			registerEnumIn(L, "configKeys", ConfigManager::URL)
			registerEnumIn(L, "configKeys", ConfigManager::LOCATION)
			registerEnumIn(L, "configKeys", ConfigManager::IP)
			registerEnumIn(L, "configKeys", ConfigManager::MOTD)
			registerEnumIn(L, "configKeys", ConfigManager::WORLD_TYPE)
			registerEnumIn(L, "configKeys", ConfigManager::MYSQL_HOST)
			registerEnumIn(L, "configKeys", ConfigManager::MYSQL_USER)
			registerEnumIn(L, "configKeys", ConfigManager::MYSQL_PASS)
			registerEnumIn(L, "configKeys", ConfigManager::MYSQL_DB)
			registerEnumIn(L, "configKeys", ConfigManager::MYSQL_SOCK)
			registerEnumIn(L, "configKeys", ConfigManager::DEFAULT_PRIORITY)
			registerEnumIn(L, "configKeys", ConfigManager::MAP_AUTHOR)
			registerEnumIn(L, "configKeys", ConfigManager::STORE_IMAGES_URL)
			registerEnumIn(L, "configKeys", ConfigManager::CLIENT_VERSION_STR)
			registerEnumIn(L, "configKeys", ConfigManager::PARTY_LIST_MAX_DISTANCE)
			registerEnumIn(L, "configKeys", ConfigManager::SQL_PORT)
			registerEnumIn(L, "configKeys", ConfigManager::MAX_PLAYERS)
			registerEnumIn(L, "configKeys", ConfigManager::PZ_LOCKED)
			registerEnumIn(L, "configKeys", ConfigManager::DEFAULT_DESPAWNRANGE)
			registerEnumIn(L, "configKeys", ConfigManager::DEFAULT_DESPAWNRADIUS)
			registerEnumIn(L, "configKeys", ConfigManager::RATE_EXPERIENCE)
			registerEnumIn(L, "configKeys", ConfigManager::RATE_SKILL)
			registerEnumIn(L, "configKeys", ConfigManager::RATE_LOOT)
			registerEnumIn(L, "configKeys", ConfigManager::RATE_MAGIC)
			registerEnumIn(L, "configKeys", ConfigManager::RATE_SPAWN)
			registerEnumIn(L, "configKeys", ConfigManager::HOUSE_PRICE)
			registerEnumIn(L, "configKeys", ConfigManager::MAX_MESSAGEBUFFER)
			registerEnumIn(L, "configKeys", ConfigManager::ACTIONS_DELAY_INTERVAL)
			registerEnumIn(L, "configKeys", ConfigManager::EX_ACTIONS_DELAY_INTERVAL)
			registerEnumIn(L, "configKeys", ConfigManager::KICK_AFTER_MINUTES)
			registerEnumIn(L, "configKeys", ConfigManager::PROTECTION_LEVEL)
			registerEnumIn(L, "configKeys", ConfigManager::DEATH_LOSE_PERCENT)
			registerEnumIn(L, "configKeys", ConfigManager::STATUSQUERY_TIMEOUT)
			registerEnumIn(L, "configKeys", ConfigManager::FRAG_TIME)
			registerEnumIn(L, "configKeys", ConfigManager::WHITE_SKULL_TIME)
			registerEnumIn(L, "configKeys", ConfigManager::GAME_PORT)
			registerEnumIn(L, "configKeys", ConfigManager::LOGIN_PORT)
			registerEnumIn(L, "configKeys", ConfigManager::STATUS_PORT)
			registerEnumIn(L, "configKeys", ConfigManager::STAIRHOP_DELAY)
			registerEnumIn(L, "configKeys", ConfigManager::MARKET_OFFER_DURATION)
			registerEnumIn(L, "configKeys", ConfigManager::CHECK_EXPIRED_MARKET_OFFERS_EACH_MINUTES)
			registerEnumIn(L, "configKeys", ConfigManager::MAX_MARKET_OFFERS_AT_A_TIME_PER_PLAYER)
			registerEnumIn(L, "configKeys", ConfigManager::EXP_FROM_PLAYERS_LEVEL_RANGE)
			registerEnumIn(L, "configKeys", ConfigManager::MAX_PACKETS_PER_SECOND)
			registerEnumIn(L, "configKeys", ConfigManager::STORE_COIN_PACKET)
			registerEnumIn(L, "configKeys", ConfigManager::CLIENT_VERSION)
			registerEnumIn(L, "configKeys", ConfigManager::DAY_KILLS_TO_RED)
			registerEnumIn(L, "configKeys", ConfigManager::WEEK_KILLS_TO_RED)
			registerEnumIn(L, "configKeys", ConfigManager::MONTH_KILLS_TO_RED)
			registerEnumIn(L, "configKeys", ConfigManager::RED_SKULL_DURATION)
			registerEnumIn(L, "configKeys", ConfigManager::BLACK_SKULL_DURATION)
			registerEnumIn(L, "configKeys", ConfigManager::ORANGE_SKULL_DURATION)
			registerEnumIn(L, "configKeys", ConfigManager::RATE_MONSTER_HEALTH)
			registerEnumIn(L, "configKeys", ConfigManager::RATE_MONSTER_ATTACK)
			registerEnumIn(L, "configKeys", ConfigManager::RATE_MONSTER_DEFENSE)
			registerEnumIn(L, "configKeys", ConfigManager::RATE_NPC_HEALTH)
			registerEnumIn(L, "configKeys", ConfigManager::RATE_NPC_ATTACK)
			registerEnumIn(L, "configKeys", ConfigManager::RATE_NPC_DEFENSE)
			#undef registerEnumIn
		}

	private:
		static int luaConfigManagerGetBoolean(lua_State* L);
		static int luaConfigManagerGetNumber(lua_State* L);
		static int luaConfigManagerGetString(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CORE_GAME_CONFIG_FUNCTIONS_HPP_
