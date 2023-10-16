/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/functions/core/game/config_functions.hpp"
#include "config/configmanager.hpp"

void ConfigFunctions::init(lua_State* L) {
	registerTable(L, "configManager");
	registerMethod(L, "configManager", "getString", ConfigFunctions::luaConfigManagerGetString);
	registerMethod(L, "configManager", "getNumber", ConfigFunctions::luaConfigManagerGetNumber);
	registerMethod(L, "configManager", "getBoolean", ConfigFunctions::luaConfigManagerGetBoolean);
	registerMethod(L, "configManager", "getFloat", ConfigFunctions::luaConfigManagerGetFloat);

#define registerEnumIn(L, tableName, value)                                                     \
	do {                                                                                        \
		std::string enumName = #value;                                                          \
		registerVariable(L, tableName, enumName.substr(enumName.find_last_of(':') + 1), value); \
	} while (0)
	registerTable(L, "configKeys");
	registerEnumIn(L, "configKeys", ALLOW_CHANGEOUTFIT);
	registerEnumIn(L, "configKeys", ONE_PLAYER_ON_ACCOUNT);
	registerEnumIn(L, "configKeys", AIMBOT_HOTKEY_ENABLED);
	registerEnumIn(L, "configKeys", REMOVE_RUNE_CHARGES);
	registerEnumIn(L, "configKeys", EXPERIENCE_FROM_PLAYERS);
	registerEnumIn(L, "configKeys", FREE_PREMIUM);
	registerEnumIn(L, "configKeys", REPLACE_KICK_ON_LOGIN);
	registerEnumIn(L, "configKeys", BIND_ONLY_GLOBAL_ADDRESS);
	registerEnumIn(L, "configKeys", OPTIMIZE_DATABASE);
	registerEnumIn(L, "configKeys", MARKET_PREMIUM);
	registerEnumIn(L, "configKeys", EMOTE_SPELLS);
	registerEnumIn(L, "configKeys", STAMINA_SYSTEM);
	registerEnumIn(L, "configKeys", WARN_UNSAFE_SCRIPTS);
	registerEnumIn(L, "configKeys", CONVERT_UNSAFE_SCRIPTS);
	registerEnumIn(L, "configKeys", ALLOW_BLOCK_SPAWN);
	registerEnumIn(L, "configKeys", CLASSIC_ATTACK_SPEED);
	registerEnumIn(L, "configKeys", REMOVE_WEAPON_AMMO);
	registerEnumIn(L, "configKeys", REMOVE_WEAPON_CHARGES);
	registerEnumIn(L, "configKeys", REMOVE_POTION_CHARGES);
	registerEnumIn(L, "configKeys", WEATHER_RAIN);
	registerEnumIn(L, "configKeys", ALLOW_RELOAD);
	registerEnumIn(L, "configKeys", WEATHER_THUNDER);
	registerEnumIn(L, "configKeys", TOGGLE_FREE_QUEST);
	registerEnumIn(L, "configKeys", FREE_QUEST_STAGE);
	registerEnumIn(L, "configKeys", ALL_CONSOLE_LOG);
	registerEnumIn(L, "configKeys", GLOBAL_SERVER_SAVE_NOTIFY_MESSAGE);
	registerEnumIn(L, "configKeys", GLOBAL_SERVER_SAVE_NOTIFY_DURATION);
	registerEnumIn(L, "configKeys", XP_DISPLAY_MODE);
	registerEnumIn(L, "configKeys", GLOBAL_SERVER_SAVE_CLEAN_MAP);
	registerEnumIn(L, "configKeys", GLOBAL_SERVER_SAVE_CLOSE);
	registerEnumIn(L, "configKeys", GLOBAL_SERVER_SAVE_SHUTDOWN);
	registerEnumIn(L, "configKeys", MAP_NAME);
	registerEnumIn(L, "configKeys", TOGGLE_MAP_CUSTOM);
	registerEnumIn(L, "configKeys", MAP_CUSTOM_NAME);
	registerEnumIn(L, "configKeys", HOUSE_RENT_PERIOD);
	registerEnumIn(L, "configKeys", SERVER_NAME);
	registerEnumIn(L, "configKeys", SERVER_MOTD);
	registerEnumIn(L, "configKeys", OWNER_NAME);
	registerEnumIn(L, "configKeys", OWNER_EMAIL);
	registerEnumIn(L, "configKeys", URL);
	registerEnumIn(L, "configKeys", LOCATION);
	registerEnumIn(L, "configKeys", IP);
	registerEnumIn(L, "configKeys", WORLD_TYPE);
	registerEnumIn(L, "configKeys", MYSQL_HOST);
	registerEnumIn(L, "configKeys", MYSQL_USER);
	registerEnumIn(L, "configKeys", MYSQL_PASS);
	registerEnumIn(L, "configKeys", MYSQL_DB);
	registerEnumIn(L, "configKeys", MYSQL_SOCK);
	registerEnumIn(L, "configKeys", DEFAULT_PRIORITY);
	registerEnumIn(L, "configKeys", MAP_AUTHOR);
	registerEnumIn(L, "configKeys", STORE_IMAGES_URL);
	registerEnumIn(L, "configKeys", PARTY_LIST_MAX_DISTANCE);
	registerEnumIn(L, "configKeys", SQL_PORT);
	registerEnumIn(L, "configKeys", MAX_PLAYERS);
	registerEnumIn(L, "configKeys", PZ_LOCKED);
	registerEnumIn(L, "configKeys", DEFAULT_DESPAWNRANGE);
	registerEnumIn(L, "configKeys", PREY_ENABLED);
	registerEnumIn(L, "configKeys", PREY_FREE_THIRD_SLOT);
	registerEnumIn(L, "configKeys", PREY_REROLL_PRICE_LEVEL);
	registerEnumIn(L, "configKeys", PREY_BONUS_TIME);
	registerEnumIn(L, "configKeys", PREY_BONUS_REROLL_PRICE);
	registerEnumIn(L, "configKeys", PREY_FREE_REROLL_TIME);
	registerEnumIn(L, "configKeys", TASK_HUNTING_ENABLED);
	registerEnumIn(L, "configKeys", TASK_HUNTING_FREE_THIRD_SLOT);
	registerEnumIn(L, "configKeys", TASK_HUNTING_LIMIT_EXHAUST);
	registerEnumIn(L, "configKeys", TASK_HUNTING_REROLL_PRICE_LEVEL);
	registerEnumIn(L, "configKeys", TASK_HUNTING_SELECTION_LIST_PRICE);
	registerEnumIn(L, "configKeys", TASK_HUNTING_BONUS_REROLL_PRICE);
	registerEnumIn(L, "configKeys", TASK_HUNTING_FREE_REROLL_TIME);
	registerEnumIn(L, "configKeys", DEFAULT_DESPAWNRADIUS);
	registerEnumIn(L, "configKeys", RATE_EXPERIENCE);
	registerEnumIn(L, "configKeys", RATE_SKILL);
	registerEnumIn(L, "configKeys", RATE_LOOT);
	registerEnumIn(L, "configKeys", RATE_MAGIC);
	registerEnumIn(L, "configKeys", RATE_SPAWN);
	registerEnumIn(L, "configKeys", RATE_KILLING_IN_THE_NAME_OF_POINTS);
	registerEnumIn(L, "configKeys", HOUSE_PRICE_PER_SQM);
	registerEnumIn(L, "configKeys", HOUSE_BUY_LEVEL);
	registerEnumIn(L, "configKeys", MAX_MESSAGEBUFFER);
	registerEnumIn(L, "configKeys", ACTIONS_DELAY_INTERVAL);
	registerEnumIn(L, "configKeys", EX_ACTIONS_DELAY_INTERVAL);
	registerEnumIn(L, "configKeys", KICK_AFTER_MINUTES);
	registerEnumIn(L, "configKeys", PROTECTION_LEVEL);
	registerEnumIn(L, "configKeys", DEATH_LOSE_PERCENT);
	registerEnumIn(L, "configKeys", STATUSQUERY_TIMEOUT);
	registerEnumIn(L, "configKeys", FRAG_TIME);
	registerEnumIn(L, "configKeys", WHITE_SKULL_TIME);
	registerEnumIn(L, "configKeys", GAME_PORT);
	registerEnumIn(L, "configKeys", LOGIN_PORT);
	registerEnumIn(L, "configKeys", STATUS_PORT);
	registerEnumIn(L, "configKeys", STAIRHOP_DELAY);
	registerEnumIn(L, "configKeys", MARKET_OFFER_DURATION);
	registerEnumIn(L, "configKeys", CHECK_EXPIRED_MARKET_OFFERS_EACH_MINUTES);
	registerEnumIn(L, "configKeys", MAX_MARKET_OFFERS_AT_A_TIME_PER_PLAYER);
	registerEnumIn(L, "configKeys", EXP_FROM_PLAYERS_LEVEL_RANGE);
	registerEnumIn(L, "configKeys", MAX_PACKETS_PER_SECOND);
	registerEnumIn(L, "configKeys", STORE_COIN_PACKET);
	registerEnumIn(L, "configKeys", DAY_KILLS_TO_RED);
	registerEnumIn(L, "configKeys", WEEK_KILLS_TO_RED);
	registerEnumIn(L, "configKeys", MONTH_KILLS_TO_RED);
	registerEnumIn(L, "configKeys", RED_SKULL_DURATION);
	registerEnumIn(L, "configKeys", BLACK_SKULL_DURATION);
	registerEnumIn(L, "configKeys", ORANGE_SKULL_DURATION);
	registerEnumIn(L, "configKeys", RATE_MONSTER_HEALTH);
	registerEnumIn(L, "configKeys", RATE_MONSTER_ATTACK);
	registerEnumIn(L, "configKeys", RATE_MONSTER_DEFENSE);
	registerEnumIn(L, "configKeys", RATE_BOSS_HEALTH);
	registerEnumIn(L, "configKeys", RATE_BOSS_ATTACK);
	registerEnumIn(L, "configKeys", RATE_BOSS_DEFENSE);
	registerEnumIn(L, "configKeys", BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN);
	registerEnumIn(L, "configKeys", BOSS_DEFAULT_TIME_TO_DEFEAT);
	registerEnumIn(L, "configKeys", RATE_NPC_HEALTH);
	registerEnumIn(L, "configKeys", RATE_NPC_ATTACK);
	registerEnumIn(L, "configKeys", RATE_NPC_DEFENSE);

	registerEnumIn(L, "configKeys", RATE_HEALTH_REGEN);
	registerEnumIn(L, "configKeys", RATE_HEALTH_REGEN_SPEED);
	registerEnumIn(L, "configKeys", RATE_MANA_REGEN);
	registerEnumIn(L, "configKeys", RATE_MANA_REGEN_SPEED);
	registerEnumIn(L, "configKeys", RATE_SOUL_REGEN);
	registerEnumIn(L, "configKeys", RATE_SOUL_REGEN_SPEED);

	registerEnumIn(L, "configKeys", RATE_SPELL_COOLDOWN);
	registerEnumIn(L, "configKeys", RATE_ATTACK_SPEED);
	registerEnumIn(L, "configKeys", RATE_OFFLINE_TRAINING_SPEED);
	registerEnumIn(L, "configKeys", RATE_EXERCISE_TRAINING_SPEED);

	registerEnumIn(L, "configKeys", STAMINA_TRAINER);
	registerEnumIn(L, "configKeys", STAMINA_PZ);
	registerEnumIn(L, "configKeys", STAMINA_ORANGE_DELAY);
	registerEnumIn(L, "configKeys", STAMINA_GREEN_DELAY);
	registerEnumIn(L, "configKeys", STAMINA_TRAINER_DELAY);
	registerEnumIn(L, "configKeys", STAMINA_PZ_GAIN);
	registerEnumIn(L, "configKeys", STAMINA_TRAINER_GAIN);
	registerEnumIn(L, "configKeys", SORT_LOOT_BY_CHANCE);
	registerEnumIn(L, "configKeys", MAX_ALLOWED_ON_A_DUMMY);

	registerEnumIn(L, "configKeys", PUSH_WHEN_ATTACKING);
	registerEnumIn(L, "configKeys", TOGGLE_SAVE_INTERVAL);
	registerEnumIn(L, "configKeys", SAVE_INTERVAL_TYPE);
	registerEnumIn(L, "configKeys", TOGGLE_SAVE_INTERVAL_CLEAN_MAP);
	registerEnumIn(L, "configKeys", SAVE_INTERVAL_TIME);
	registerEnumIn(L, "configKeys", RATE_USE_STAGES);
	registerEnumIn(L, "configKeys", TOGGLE_IMBUEMENT_SHRINE_STORAGE);
	registerEnumIn(L, "configKeys", TOGGLE_IMBUEMENT_NON_AGGRESSIVE_FIGHT_ONLY);
	registerEnumIn(L, "configKeys", GLOBAL_SERVER_SAVE_TIME);
	registerEnumIn(L, "configKeys", DATA_DIRECTORY);
	registerEnumIn(L, "configKeys", CORE_DIRECTORY);

	registerEnumIn(L, "configKeys", FORGE_COST_ONE_SLIVER);
	registerEnumIn(L, "configKeys", FORGE_SLIVER_AMOUNT);
	registerEnumIn(L, "configKeys", FORGE_CORE_COST);
	registerEnumIn(L, "configKeys", FORGE_MAX_DUST);
	registerEnumIn(L, "configKeys", FORGE_FUSION_DUST_COST);
	registerEnumIn(L, "configKeys", FORGE_TRANSFER_DUST_COST);
	registerEnumIn(L, "configKeys", FORGE_BASE_SUCCESS_RATE);
	registerEnumIn(L, "configKeys", FORGE_BONUS_SUCCESS_RATE);
	registerEnumIn(L, "configKeys", FORGE_TIER_LOSS_REDUCTION);
	registerEnumIn(L, "configKeys", FORGE_AMOUNT_MULTIPLIER);
	registerEnumIn(L, "configKeys", FORGE_INFLUENCED_CREATURES_LIMIT);

	registerEnumIn(L, "configKeys", BESTIARY_KILL_MULTIPLIER);
	registerEnumIn(L, "configKeys", BOSSTIARY_KILL_MULTIPLIER);
	registerEnumIn(L, "configKeys", BOOSTED_BOSS_SLOT);
	registerEnumIn(L, "configKeys", BOOSTED_BOSS_LOOT_BONUS);
	registerEnumIn(L, "configKeys", BOOSTED_BOSS_KILL_BONUS);
	registerEnumIn(L, "configKeys", BESTIARY_RATE_CHARM_SHOP_PRICE);

	registerEnumIn(L, "configKeys", FAMILIAR_TIME);

	registerEnumIn(L, "configKeys", TOGGLE_GOLD_POUCH_ALLOW_ANYTHING);
	registerEnumIn(L, "configKeys", TOGGLE_SERVER_IS_RETRO);
	registerEnumIn(L, "configKeys", TOGGLE_TRAVELS_FREE);
	registerEnumIn(L, "configKeys", BUY_AOL_COMMAND_FEE);
	registerEnumIn(L, "configKeys", BUY_BLESS_COMMAND_FEE);
	registerEnumIn(L, "configKeys", TELEPORT_PLAYER_TO_VOCATION_ROOM);

	registerEnumIn(L, "configKeys", HAZARD_SPAWN_PLUNDER_MULTIPLIER);
	registerEnumIn(L, "configKeys", HAZARD_CRITICAL_INTERVAL);
	registerEnumIn(L, "configKeys", HAZARD_CRITICAL_CHANCE);
	registerEnumIn(L, "configKeys", HAZARD_CRITICAL_MULTIPLIER);
	registerEnumIn(L, "configKeys", HAZARD_DAMAGE_MULTIPLIER);
	registerEnumIn(L, "configKeys", HAZARD_DODGE_MULTIPLIER);
	registerEnumIn(L, "configKeys", HAZARD_PODS_DROP_MULTIPLIER);
	registerEnumIn(L, "configKeys", HAZARD_PODS_TIME_TO_DAMAGE);
	registerEnumIn(L, "configKeys", HAZARD_PODS_TIME_TO_SPAWN);
	registerEnumIn(L, "configKeys", HAZARD_EXP_BONUS_MULTIPLIER);
	registerEnumIn(L, "configKeys", HAZARD_LOOT_BONUS_MULTIPLIER);
	registerEnumIn(L, "configKeys", HAZARD_PODS_DAMAGE);
	registerEnumIn(L, "configKeys", TOGGLE_HAZARDSYSTEM);
	registerEnumIn(L, "configKeys", LOW_LEVEL_BONUS_EXP);

	registerEnumIn(L, "configKeys", LOYALTY_ENABLED);
	registerEnumIn(L, "configKeys", LOYALTY_POINTS_PER_CREATION_DAY);
	registerEnumIn(L, "configKeys", LOYALTY_POINTS_PER_PREMIUM_DAY_SPENT);
	registerEnumIn(L, "configKeys", LOYALTY_POINTS_PER_PREMIUM_DAY_PURCHASED);
	registerEnumIn(L, "configKeys", LOYALTY_BONUS_PERCENTAGE_MULTIPLIER);

	registerEnumIn(L, "configKeys", PARTY_SHARE_LOOT_BOOSTS);
	registerEnumIn(L, "configKeys", PARTY_SHARE_LOOT_BOOSTS_DIMINISHING_FACTOR);
	registerEnumIn(L, "configKeys", TIBIADROME_CONCOCTION_COOLDOWN);
	registerEnumIn(L, "configKeys", TIBIADROME_CONCOCTION_DURATION);
	registerEnumIn(L, "configKeys", TIBIADROME_CONCOCTION_TICK_TYPE);

	registerEnumIn(L, "configKeys", AUTH_TYPE);
	registerEnumIn(L, "configKeys", RESET_SESSIONS_ON_STARTUP);

	registerEnumIn(L, "configKeys", TOGGLE_ATTACK_SPEED_ONFIST);
	registerEnumIn(L, "configKeys", MULTIPLIER_ATTACKONFIST);
	registerEnumIn(L, "configKeys", MAX_SPEED_ATTACKONFIST);

	registerEnumIn(L, "configKeys", M_CONST);
	registerEnumIn(L, "configKeys", T_CONST);
	registerEnumIn(L, "configKeys", PARALLELISM);

	registerEnumIn(L, "configKeys", AUTOLOOT);

	registerEnumIn(L, "configKeys", VIP_SYSTEM_ENABLED);
	registerEnumIn(L, "configKeys", VIP_BONUS_EXP);
	registerEnumIn(L, "configKeys", VIP_BONUS_LOOT);
	registerEnumIn(L, "configKeys", VIP_BONUS_SKILL);
	registerEnumIn(L, "configKeys", VIP_AUTOLOOT_VIP_ONLY);
	registerEnumIn(L, "configKeys", VIP_STAY_ONLINE);
	registerEnumIn(L, "configKeys", VIP_FAMILIAR_TIME_COOLDOWN_REDUCTION);

	registerEnumIn(L, "configKeys", TOGGLE_HOUSE_TRANSFER_ON_SERVER_RESTART);

	registerEnumIn(L, "configKeys", TOGGLE_RECEIVE_REWARD);
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
