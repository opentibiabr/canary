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

#include "pch.hpp"

#include "lua/functions/core/game/config_functions.hpp"
#include "config/configmanager.h"

void ConfigFunctions::init(lua_State* L) {
	registerTable(L, "configManager");
	registerMethod(L, "configManager", "getString", ConfigFunctions::luaConfigManagerGetString);
	registerMethod(L, "configManager", "getNumber", ConfigFunctions::luaConfigManagerGetNumber);
	registerMethod(L, "configManager", "getBoolean", ConfigFunctions::luaConfigManagerGetBoolean);
	registerMethod(L, "configManager", "getFloat", ConfigFunctions::luaConfigManagerGetFloat);

	#define registerEnumIn(L, tableName, value) { \
		std::string enumName = #value; \
		registerVariable(L, tableName, enumName.substr(enumName.find_last_of(':') + 1), value); \
	}
	registerTable(L, "configKeys");
	registerEnumIn(L, "configKeys", ALLOW_CHANGEOUTFIT)
	registerEnumIn(L, "configKeys", ONE_PLAYER_ON_ACCOUNT)
	registerEnumIn(L, "configKeys", AIMBOT_HOTKEY_ENABLED)
	registerEnumIn(L, "configKeys", REMOVE_RUNE_CHARGES)
	registerEnumIn(L, "configKeys", EXPERIENCE_FROM_PLAYERS)
	registerEnumIn(L, "configKeys", FREE_PREMIUM)
	registerEnumIn(L, "configKeys", REPLACE_KICK_ON_LOGIN)
	registerEnumIn(L, "configKeys", ALLOW_CLONES)
	registerEnumIn(L, "configKeys", BIND_ONLY_GLOBAL_ADDRESS)
	registerEnumIn(L, "configKeys", OPTIMIZE_DATABASE)
	registerEnumIn(L, "configKeys", MARKET_PREMIUM)
	registerEnumIn(L, "configKeys", EMOTE_SPELLS)
	registerEnumIn(L, "configKeys", STAMINA_SYSTEM)
	registerEnumIn(L, "configKeys", WARN_UNSAFE_SCRIPTS)
	registerEnumIn(L, "configKeys", CONVERT_UNSAFE_SCRIPTS)
	registerEnumIn(L, "configKeys", ALLOW_BLOCK_SPAWN)
	registerEnumIn(L, "configKeys", CLASSIC_ATTACK_SPEED)
	registerEnumIn(L, "configKeys", REMOVE_WEAPON_AMMO)
	registerEnumIn(L, "configKeys", REMOVE_WEAPON_CHARGES)
	registerEnumIn(L, "configKeys", REMOVE_POTION_CHARGES)
	registerEnumIn(L, "configKeys", WEATHER_RAIN)
	registerEnumIn(L, "configKeys", ALLOW_RELOAD)
	registerEnumIn(L, "configKeys", WEATHER_THUNDER)
	registerEnumIn(L, "configKeys", TOGGLE_FREE_QUEST)
	registerEnumIn(L, "configKeys", FREE_QUEST_STAGE)
	registerEnumIn(L, "configKeys", ALL_CONSOLE_LOG)
	registerEnumIn(L, "configKeys", GLOBAL_SERVER_SAVE_NOTIFY_MESSAGE)
	registerEnumIn(L, "configKeys", GLOBAL_SERVER_SAVE_NOTIFY_DURATION)
	registerEnumIn(L, "configKeys", GLOBAL_SERVER_SAVE_CLEAN_MAP)
	registerEnumIn(L, "configKeys", GLOBAL_SERVER_SAVE_CLOSE)
	registerEnumIn(L, "configKeys", GLOBAL_SERVER_SAVE_SHUTDOWN)
	registerEnumIn(L, "configKeys", MAP_NAME)
	registerEnumIn(L, "configKeys", TOGGLE_MAP_CUSTOM)
	registerEnumIn(L, "configKeys", MAP_CUSTOM_NAME)
	registerEnumIn(L, "configKeys", HOUSE_RENT_PERIOD)
	registerEnumIn(L, "configKeys", SERVER_NAME)
	registerEnumIn(L, "configKeys", OWNER_NAME)
	registerEnumIn(L, "configKeys", OWNER_EMAIL)
	registerEnumIn(L, "configKeys", URL)
	registerEnumIn(L, "configKeys", LOCATION)
	registerEnumIn(L, "configKeys", IP)
	registerEnumIn(L, "configKeys", MOTD)
	registerEnumIn(L, "configKeys", WORLD_TYPE)
	registerEnumIn(L, "configKeys", MYSQL_HOST)
	registerEnumIn(L, "configKeys", MYSQL_USER)
	registerEnumIn(L, "configKeys", MYSQL_PASS)
	registerEnumIn(L, "configKeys", MYSQL_DB)
	registerEnumIn(L, "configKeys", MYSQL_SOCK)
	registerEnumIn(L, "configKeys", DEFAULT_PRIORITY)
	registerEnumIn(L, "configKeys", MAP_AUTHOR)
	registerEnumIn(L, "configKeys", STORE_IMAGES_URL)
	registerEnumIn(L, "configKeys", PARTY_LIST_MAX_DISTANCE)
	registerEnumIn(L, "configKeys", SQL_PORT)
	registerEnumIn(L, "configKeys", MAX_PLAYERS)
	registerEnumIn(L, "configKeys", PZ_LOCKED)
	registerEnumIn(L, "configKeys", DEFAULT_DESPAWNRANGE)
	registerEnumIn(L, "configKeys", PREY_ENABLED)
	registerEnumIn(L, "configKeys", PREY_FREE_THIRD_SLOT)
	registerEnumIn(L, "configKeys", PREY_REROLL_PRICE_LEVEL)
	registerEnumIn(L, "configKeys", PREY_BONUS_TIME)
	registerEnumIn(L, "configKeys", PREY_BONUS_REROLL_PRICE)
	registerEnumIn(L, "configKeys", PREY_FREE_REROLL_TIME)
	registerEnumIn(L, "configKeys", TASK_HUNTING_ENABLED)
	registerEnumIn(L, "configKeys", TASK_HUNTING_FREE_THIRD_SLOT)
	registerEnumIn(L, "configKeys", TASK_HUNTING_LIMIT_EXHAUST)
	registerEnumIn(L, "configKeys", TASK_HUNTING_REROLL_PRICE_LEVEL)
	registerEnumIn(L, "configKeys", TASK_HUNTING_SELECTION_LIST_PRICE)
	registerEnumIn(L, "configKeys", TASK_HUNTING_BONUS_REROLL_PRICE)
	registerEnumIn(L, "configKeys", TASK_HUNTING_FREE_REROLL_TIME)
	registerEnumIn(L, "configKeys", DEFAULT_DESPAWNRADIUS)
	registerEnumIn(L, "configKeys", RATE_EXPERIENCE)
	registerEnumIn(L, "configKeys", RATE_SKILL)
	registerEnumIn(L, "configKeys", RATE_LOOT)
	registerEnumIn(L, "configKeys", RATE_MAGIC)
	registerEnumIn(L, "configKeys", RATE_SPAWN)
	registerEnumIn(L, "configKeys", HOUSE_PRICE)
	registerEnumIn(L, "configKeys", MAX_MESSAGEBUFFER)
	registerEnumIn(L, "configKeys", ACTIONS_DELAY_INTERVAL)
	registerEnumIn(L, "configKeys", EX_ACTIONS_DELAY_INTERVAL)
	registerEnumIn(L, "configKeys", KICK_AFTER_MINUTES)
	registerEnumIn(L, "configKeys", PROTECTION_LEVEL)
	registerEnumIn(L, "configKeys", DEATH_LOSE_PERCENT)
	registerEnumIn(L, "configKeys", STATUSQUERY_TIMEOUT)
	registerEnumIn(L, "configKeys", FRAG_TIME)
	registerEnumIn(L, "configKeys", WHITE_SKULL_TIME)
	registerEnumIn(L, "configKeys", GAME_PORT)
	registerEnumIn(L, "configKeys", LOGIN_PORT)
	registerEnumIn(L, "configKeys", STATUS_PORT)
	registerEnumIn(L, "configKeys", STAIRHOP_DELAY)
	registerEnumIn(L, "configKeys", MARKET_OFFER_DURATION)
	registerEnumIn(L, "configKeys", CHECK_EXPIRED_MARKET_OFFERS_EACH_MINUTES)
	registerEnumIn(L, "configKeys", MAX_MARKET_OFFERS_AT_A_TIME_PER_PLAYER)
	registerEnumIn(L, "configKeys", EXP_FROM_PLAYERS_LEVEL_RANGE)
	registerEnumIn(L, "configKeys", MAX_PACKETS_PER_SECOND)
	registerEnumIn(L, "configKeys", STORE_COIN_PACKET)
	registerEnumIn(L, "configKeys", DAY_KILLS_TO_RED)
	registerEnumIn(L, "configKeys", WEEK_KILLS_TO_RED)
	registerEnumIn(L, "configKeys", MONTH_KILLS_TO_RED)
	registerEnumIn(L, "configKeys", RED_SKULL_DURATION)
	registerEnumIn(L, "configKeys", BLACK_SKULL_DURATION)
	registerEnumIn(L, "configKeys", ORANGE_SKULL_DURATION)
	registerEnumIn(L, "configKeys", RATE_MONSTER_HEALTH)
	registerEnumIn(L, "configKeys", RATE_MONSTER_ATTACK)
	registerEnumIn(L, "configKeys", RATE_MONSTER_DEFENSE)
	registerEnumIn(L, "configKeys", RATE_NPC_HEALTH)
	registerEnumIn(L, "configKeys", RATE_NPC_ATTACK)
	registerEnumIn(L, "configKeys", RATE_NPC_DEFENSE)

	registerEnumIn(L, "configKeys", RATE_HEALTH_REGEN)
	registerEnumIn(L, "configKeys", RATE_HEALTH_REGEN_SPEED)
	registerEnumIn(L, "configKeys", RATE_MANA_REGEN)
	registerEnumIn(L, "configKeys", RATE_MANA_REGEN_SPEED)
	registerEnumIn(L, "configKeys", RATE_SOUL_REGEN)
	registerEnumIn(L, "configKeys", RATE_SOUL_REGEN_SPEED)

	registerEnumIn(L, "configKeys", RATE_SPELL_COOLDOWN)
	registerEnumIn(L, "configKeys", RATE_ATTACK_SPEED)
	registerEnumIn(L, "configKeys", RATE_OFFLINE_TRAINING_SPEED)
	registerEnumIn(L, "configKeys", RATE_EXERCISE_TRAINING_SPEED)

	registerEnumIn(L, "configKeys", STAMINA_TRAINER)
	registerEnumIn(L, "configKeys", STAMINA_PZ)
	registerEnumIn(L, "configKeys", STAMINA_ORANGE_DELAY)
	registerEnumIn(L, "configKeys", STAMINA_GREEN_DELAY)
	registerEnumIn(L, "configKeys", STAMINA_TRAINER_DELAY)
	registerEnumIn(L, "configKeys", STAMINA_PZ_GAIN)
	registerEnumIn(L, "configKeys", STAMINA_TRAINER_GAIN)
	registerEnumIn(L, "configKeys", SORT_LOOT_BY_CHANCE)
	registerEnumIn(L, "configKeys", MAX_ALLOWED_ON_A_DUMMY)

	registerEnumIn(L, "configKeys", PUSH_WHEN_ATTACKING)
	registerEnumIn(L, "configKeys", TOGGLE_SAVE_INTERVAL)
	registerEnumIn(L, "configKeys", SAVE_INTERVAL_TYPE)
	registerEnumIn(L, "configKeys", TOGGLE_SAVE_INTERVAL_CLEAN_MAP)
	registerEnumIn(L, "configKeys", SAVE_INTERVAL_TIME)
	registerEnumIn(L, "configKeys", RATE_USE_STAGES)
	registerEnumIn(L, "configKeys", TOGGLE_IMBUEMENT_SHRINE_STORAGE)
	registerEnumIn(L, "configKeys", GLOBAL_SERVER_SAVE_TIME)
	registerEnumIn(L, "configKeys", DATA_DIRECTORY)
	registerEnumIn(L, "configKeys", CORE_DIRECTORY)

	registerEnumIn(L, "configKeys", FORGE_COST_ONE_SLIVER)
	registerEnumIn(L, "configKeys", FORGE_SLIVER_AMOUNT)
	registerEnumIn(L, "configKeys", FORGE_CORE_COST)
	registerEnumIn(L, "configKeys", FORGE_MAX_DUST)
	registerEnumIn(L, "configKeys", FORGE_FUSION_DUST_COST)
	registerEnumIn(L, "configKeys", FORGE_TRANSFER_DUST_COST)
	registerEnumIn(L, "configKeys", FORGE_BASE_SUCCESS_RATE)
	registerEnumIn(L, "configKeys", FORGE_BONUS_SUCCESS_RATE)
	registerEnumIn(L, "configKeys", FORGE_TIER_LOSS_REDUCTION)
	registerEnumIn(L, "configKeys", FORGE_INFLUENCED_CREATURES_LIMIT)

	#undef registerEnumIn
}

int ConfigFunctions::luaConfigManagerGetString(lua_State* L) {
	pushString(L, g_configManager().getString(getNumber<stringConfig_t>(L, -1)));
	return 1;
}

int ConfigFunctions::luaConfigManagerGetNumber(lua_State* L) {
	lua_pushnumber(L, g_configManager().getNumber(getNumber<integerConfig_t>(L, -1)));
	return 1;
}

int ConfigFunctions::luaConfigManagerGetBoolean(lua_State* L) {
	pushBoolean(L, g_configManager().getBoolean(getNumber<booleanConfig_t>(L, -1)));
	return 1;
}

int ConfigFunctions::luaConfigManagerGetFloat(lua_State* L) {
	lua_pushnumber(L, g_configManager().getFloat(getNumber<floatingConfig_t>(L, -1)));
	return 1;
}
