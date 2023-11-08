/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "config/configmanager.hpp"
#include "declarations.hpp"
#include "game/game.hpp"
#include "server/network/webhook/webhook.hpp"

#if LUA_VERSION_NUM >= 502
	#undef lua_strlen
	#define lua_strlen lua_rawlen
#endif

namespace {

	std::string getGlobalString(lua_State* L, const char* identifier, const char* defaultValue) {
		lua_getglobal(L, identifier);
		if (!lua_isstring(L, -1)) {
			return defaultValue;
		}

		size_t len = lua_strlen(L, -1);
		std::string ret(lua_tostring(L, -1), len);
		lua_pop(L, 1);
		return ret;
	}

	int32_t getGlobalNumber(lua_State* L, const char* identifier, const int32_t defaultValue = 0) {
		lua_getglobal(L, identifier);
		if (!lua_isnumber(L, -1)) {
			return defaultValue;
		}

		int32_t val = lua_tonumber(L, -1);
		lua_pop(L, 1);
		return val;
	}

	bool getGlobalBoolean(lua_State* L, const char* identifier, const bool defaultValue) {
		lua_getglobal(L, identifier);
		if (!lua_isboolean(L, -1)) {
			if (!lua_isstring(L, -1)) {
				return defaultValue;
			}

			size_t len = lua_strlen(L, -1);
			std::string ret(lua_tostring(L, -1), len);
			lua_pop(L, 1);
			return booleanString(ret);
		}

		int val = lua_toboolean(L, -1);
		lua_pop(L, 1);
		return val != 0;
	}

	float getGlobalFloat(lua_State* L, const char* identifier, const float defaultValue = 0.0) {
		lua_getglobal(L, identifier);
		if (!lua_isnumber(L, -1)) {
			return defaultValue;
		}

		float val = lua_tonumber(L, -1);
		lua_pop(L, 1);
		return val;
	}

}

bool ConfigManager::load() {
	lua_State* L = luaL_newstate();
	if (!L) {
		throw std::ios_base::failure("Failed to allocate memory");
	}

	luaL_openlibs(L);

	if (luaL_dofile(L, configFileLua.c_str())) {
		g_logger().error("[ConfigManager::load] - {}", lua_tostring(L, -1));
		lua_close(L);
		return false;
	}

#ifndef DEBUG_LOG
	g_logger().setLevel(getGlobalString(L, "logLevel", "info"));
#endif

	// Parse config
	// Info that must be loaded one time (unless we reset the modules involved)
	if (!loaded) {
		boolean[BIND_ONLY_GLOBAL_ADDRESS] = getGlobalBoolean(L, "bindOnlyGlobalAddress", false);
		boolean[OPTIMIZE_DATABASE] = getGlobalBoolean(L, "startupDatabaseOptimization", true);
		boolean[TOGGLE_MAP_CUSTOM] = getGlobalBoolean(L, "toggleMapCustom", true);
		boolean[TOGGLE_MAINTAIN_MODE] = getGlobalBoolean(L, "toggleMaintainMode", false);
		string[MAINTAIN_MODE_MESSAGE] = getGlobalString(L, "maintainModeMessage", "");

		string[IP] = getGlobalString(L, "ip", "127.0.0.1");
		string[MAP_NAME] = getGlobalString(L, "mapName", "canary");
		string[MAP_DOWNLOAD_URL] = getGlobalString(L, "mapDownloadUrl", "");
		string[MAP_AUTHOR] = getGlobalString(L, "mapAuthor", "Eduardo Dantas");

		string[MAP_CUSTOM_NAME] = getGlobalString(L, "mapCustomName", "");
		string[MAP_CUSTOM_AUTHOR] = getGlobalString(L, "mapCustomAuthor", "OTServBR");

		string[HOUSE_RENT_PERIOD] = getGlobalString(L, "houseRentPeriod", "never");
		floating[HOUSE_PRICE_RENT_MULTIPLIER] = getGlobalFloat(L, "housePriceRentMultiplier", 1.0);
		floating[HOUSE_RENT_RATE] = getGlobalFloat(L, "houseRentRate", 1.0);
		string[MYSQL_HOST] = getGlobalString(L, "mysqlHost", "127.0.0.1");
		string[MYSQL_USER] = getGlobalString(L, "mysqlUser", "root");
		string[MYSQL_PASS] = getGlobalString(L, "mysqlPass", "");
		string[MYSQL_DB] = getGlobalString(L, "mysqlDatabase", "canary");
		string[MYSQL_SOCK] = getGlobalString(L, "mysqlSock", "");

		string[AUTH_TYPE] = getGlobalString(L, "authType", "password");
		boolean[RESET_SESSIONS_ON_STARTUP] = getGlobalBoolean(L, "resetSessionsOnStartup", false);

		integer[SQL_PORT] = getGlobalNumber(L, "mysqlPort", 3306);
		integer[GAME_PORT] = getGlobalNumber(L, "gameProtocolPort", 7172);
		integer[LOGIN_PORT] = getGlobalNumber(L, "loginProtocolPort", 7171);
		integer[STATUS_PORT] = getGlobalNumber(L, "statusProtocolPort", 7171);

		integer[MARKET_OFFER_DURATION] = getGlobalNumber(L, "marketOfferDuration", 30 * 24 * 60 * 60);

		integer[FREE_DEPOT_LIMIT] = getGlobalNumber(L, "freeDepotLimit", 2000);
		integer[PREMIUM_DEPOT_LIMIT] = getGlobalNumber(L, "premiumDepotLimit", 8000);
		integer[DEPOT_BOXES] = getGlobalNumber(L, "depotBoxes", 20);
		integer[STASH_ITEMS] = getGlobalNumber(L, "stashItemCount", 5000);

		boolean[OLD_PROTOCOL] = getGlobalBoolean(L, "allowOldProtocol", true);
	}

	boolean[ALLOW_CHANGEOUTFIT] = getGlobalBoolean(L, "allowChangeOutfit", true);
	boolean[ONE_PLAYER_ON_ACCOUNT] = getGlobalBoolean(L, "onePlayerOnlinePerAccount", true);
	boolean[AIMBOT_HOTKEY_ENABLED] = getGlobalBoolean(L, "hotkeyAimbotEnabled", true);
	boolean[REMOVE_RUNE_CHARGES] = getGlobalBoolean(L, "removeChargesFromRunes", true);
	boolean[EXPERIENCE_FROM_PLAYERS] = getGlobalBoolean(L, "experienceByKillingPlayers", false);
	boolean[FREE_PREMIUM] = getGlobalBoolean(L, "freePremium", false);
	boolean[REPLACE_KICK_ON_LOGIN] = getGlobalBoolean(L, "replaceKickOnLogin", true);
	boolean[MARKET_PREMIUM] = getGlobalBoolean(L, "premiumToCreateMarketOffer", true);
	boolean[EMOTE_SPELLS] = getGlobalBoolean(L, "emoteSpells", false);
	boolean[STAMINA_SYSTEM] = getGlobalBoolean(L, "staminaSystem", true);
	boolean[WARN_UNSAFE_SCRIPTS] = getGlobalBoolean(L, "warnUnsafeScripts", true);
	boolean[CONVERT_UNSAFE_SCRIPTS] = getGlobalBoolean(L, "convertUnsafeScripts", true);
	boolean[CLASSIC_ATTACK_SPEED] = getGlobalBoolean(L, "classicAttackSpeed", false);
	boolean[TOGGLE_ATTACK_SPEED_ONFIST] = getGlobalBoolean(L, "toggleAttackSpeedOnFist", false);
	integer[MULTIPLIER_ATTACKONFIST] = getGlobalNumber(L, "multiplierSpeedOnFist", 5);
	integer[MAX_SPEED_ATTACKONFIST] = getGlobalNumber(L, "maxSpeedOnFist", 500);
	boolean[SCRIPTS_CONSOLE_LOGS] = getGlobalBoolean(L, "showScriptsLogInConsole", true);
	boolean[STASH_MOVING] = getGlobalBoolean(L, "stashMoving", false);
	boolean[ALLOW_BLOCK_SPAWN] = getGlobalBoolean(L, "allowBlockSpawn", true);
	boolean[REMOVE_WEAPON_AMMO] = getGlobalBoolean(L, "removeWeaponAmmunition", true);
	boolean[REMOVE_WEAPON_CHARGES] = getGlobalBoolean(L, "removeWeaponCharges", true);
	boolean[REMOVE_POTION_CHARGES] = getGlobalBoolean(L, "removeChargesFromPotions", true);
	boolean[GLOBAL_SERVER_SAVE_NOTIFY_MESSAGE] = getGlobalBoolean(L, "globalServerSaveNotifyMessage", true);
	boolean[GLOBAL_SERVER_SAVE_CLEAN_MAP] = getGlobalBoolean(L, "globalServerSaveCleanMap", false);
	boolean[GLOBAL_SERVER_SAVE_CLOSE] = getGlobalBoolean(L, "globalServerSaveClose", false);
	boolean[FORCE_MONSTERTYPE_LOAD] = getGlobalBoolean(L, "forceMonsterTypesOnLoad", true);
	boolean[HOUSE_OWNED_BY_ACCOUNT] = getGlobalBoolean(L, "houseOwnedByAccount", false);
	boolean[CLEAN_PROTECTION_ZONES] = getGlobalBoolean(L, "cleanProtectionZones", false);
	boolean[GLOBAL_SERVER_SAVE_SHUTDOWN] = getGlobalBoolean(L, "globalServerSaveShutdown", true);
	boolean[PUSH_WHEN_ATTACKING] = getGlobalBoolean(L, "pushWhenAttacking", false);

	boolean[WEATHER_RAIN] = getGlobalBoolean(L, "weatherRain", false);
	boolean[WEATHER_THUNDER] = getGlobalBoolean(L, "thunderEffect", false);
	boolean[ALL_CONSOLE_LOG] = getGlobalBoolean(L, "allConsoleLog", false);
	boolean[TOGGLE_FREE_QUEST] = getGlobalBoolean(L, "toggleFreeQuest", true);
	boolean[AUTOLOOT] = getGlobalBoolean(L, "autoLoot", false);
	boolean[AUTOBANK] = getGlobalBoolean(L, "autoBank", false);
	boolean[STAMINA_TRAINER] = getGlobalBoolean(L, "staminaTrainer", false);
	boolean[STAMINA_PZ] = getGlobalBoolean(L, "staminaPz", false);
	boolean[SORT_LOOT_BY_CHANCE] = getGlobalBoolean(L, "sortLootByChance", false);
	boolean[TOGGLE_SAVE_INTERVAL] = getGlobalBoolean(L, "toggleSaveInterval", false);
	boolean[TOGGLE_SAVE_INTERVAL_CLEAN_MAP] = getGlobalBoolean(L, "toggleSaveIntervalCleanMap", false);
	boolean[TELEPORT_SUMMONS] = getGlobalBoolean(L, "teleportSummons", false);
	boolean[ALLOW_RELOAD] = getGlobalBoolean(L, "allowReload", false);

	boolean[ONLY_PREMIUM_ACCOUNT] = getGlobalBoolean(L, "onlyPremiumAccount", false);
	boolean[RATE_USE_STAGES] = getGlobalBoolean(L, "rateUseStages", false);
	boolean[TOGGLE_IMBUEMENT_SHRINE_STORAGE] = getGlobalBoolean(L, "toggleImbuementShrineStorage", true);
	boolean[TOGGLE_IMBUEMENT_NON_AGGRESSIVE_FIGHT_ONLY] = getGlobalBoolean(L, "toggleImbuementNonAggressiveFightOnly", false);

	boolean[TOGGLE_DOWNLOAD_MAP] = getGlobalBoolean(L, "toggleDownloadMap", false);
	boolean[USE_ANY_DATAPACK_FOLDER] = getGlobalBoolean(L, "useAnyDatapackFolder", false);
	boolean[INVENTORY_GLOW] = getGlobalBoolean(L, "inventoryGlowOnFiveBless", false);
	boolean[XP_DISPLAY_MODE] = getGlobalBoolean(L, "experienceDisplayRates", true);

	string[DEFAULT_PRIORITY] = getGlobalString(L, "defaultPriority", "high");
	string[SERVER_NAME] = getGlobalString(L, "serverName", "");
	string[SERVER_MOTD] = getGlobalString(L, "serverMotd", "");
	string[OWNER_NAME] = getGlobalString(L, "ownerName", "");
	string[OWNER_EMAIL] = getGlobalString(L, "ownerEmail", "");
	string[URL] = getGlobalString(L, "url", "");
	string[LOCATION] = getGlobalString(L, "location", "");
	string[WORLD_TYPE] = getGlobalString(L, "worldType", "pvp");
	string[STORE_IMAGES_URL] = getGlobalString(L, "coinImagesURL", "");
	string[DISCORD_WEBHOOK_URL] = getGlobalString(L, "discordWebhookURL", "");
	string[SAVE_INTERVAL_TYPE] = getGlobalString(L, "saveIntervalType", "");
	string[GLOBAL_SERVER_SAVE_TIME] = getGlobalString(L, "globalServerSaveTime", "06:00");
	string[DATA_DIRECTORY] = getGlobalString(L, "dataPackDirectory", "data-otservbr-global");
	string[CORE_DIRECTORY] = getGlobalString(L, "coreDirectory", "data");

	string[FORGE_FIENDISH_INTERVAL_TYPE] = getGlobalString(L, "forgeFiendishIntervalType", "hour");
	string[FORGE_FIENDISH_INTERVAL_TIME] = getGlobalString(L, "forgeFiendishIntervalTime", "1");

	integer[MAX_PLAYERS] = getGlobalNumber(L, "maxPlayers");
	integer[PZ_LOCKED] = getGlobalNumber(L, "pzLocked", 60000);
	integer[DEFAULT_DESPAWNRANGE] = getGlobalNumber(L, "deSpawnRange", 2);
	integer[DEFAULT_DESPAWNRADIUS] = getGlobalNumber(L, "deSpawnRadius", 50);
	integer[RATE_EXPERIENCE] = getGlobalNumber(L, "rateExp", 1);
	integer[RATE_SKILL] = getGlobalNumber(L, "rateSkill", 1);
	integer[RATE_LOOT] = getGlobalNumber(L, "rateLoot", 1);
	integer[RATE_MAGIC] = getGlobalNumber(L, "rateMagic", 1);
	integer[RATE_SPAWN] = getGlobalNumber(L, "rateSpawn", 1);
	integer[RATE_KILLING_IN_THE_NAME_OF_POINTS] = getGlobalNumber(L, "rateKillingInTheNameOfPoints", 1);

	integer[HOUSE_PRICE_PER_SQM] = getGlobalNumber(L, "housePriceEachSQM", 1000);
	integer[HOUSE_BUY_LEVEL] = getGlobalNumber(L, "houseBuyLevel", 0);
	boolean[HOUSE_PURSHASED_SHOW_PRICE] = getGlobalBoolean(L, "housePurchasedShowPrice", false);
	boolean[ONLY_INVITED_CAN_MOVE_HOUSE_ITEMS] = getGlobalBoolean(L, "onlyInvitedCanMoveHouseItems", true);

	integer[ACTIONS_DELAY_INTERVAL] = getGlobalNumber(L, "timeBetweenActions", 200);
	integer[EX_ACTIONS_DELAY_INTERVAL] = getGlobalNumber(L, "timeBetweenExActions", 1000);
	integer[MAX_MESSAGEBUFFER] = getGlobalNumber(L, "maxMessageBuffer", 4);
	integer[KICK_AFTER_MINUTES] = getGlobalNumber(L, "kickIdlePlayerAfterMinutes", 15);
	integer[PROTECTION_LEVEL] = getGlobalNumber(L, "protectionLevel", 1);
	integer[DEATH_LOSE_PERCENT] = getGlobalNumber(L, "deathLosePercent", -1);
	integer[STATUSQUERY_TIMEOUT] = getGlobalNumber(L, "statusTimeout", 5000);
	integer[FRAG_TIME] = getGlobalNumber(L, "timeToDecreaseFrags", 24 * 60 * 60 * 1000);
	integer[WHITE_SKULL_TIME] = getGlobalNumber(L, "whiteSkullTime", 15 * 60 * 1000);
	integer[STAIRHOP_DELAY] = getGlobalNumber(L, "stairJumpExhaustion", 2000);
	integer[MAX_CONTAINER] = getGlobalNumber(L, "maxContainer", 500);
	integer[MAX_CONTAINER_ITEM] = getGlobalNumber(L, "maxItem", 5000);
	integer[EXP_FROM_PLAYERS_LEVEL_RANGE] = getGlobalNumber(L, "expFromPlayersLevelRange", 75);
	integer[CHECK_EXPIRED_MARKET_OFFERS_EACH_MINUTES] = getGlobalNumber(L, "checkExpiredMarketOffersEachMinutes", 60);
	integer[MAX_MARKET_OFFERS_AT_A_TIME_PER_PLAYER] = getGlobalNumber(L, "maxMarketOffersAtATimePerPlayer", 100);
	integer[MAX_PACKETS_PER_SECOND] = getGlobalNumber(L, "maxPacketsPerSecond", 25);
	integer[COMPRESSION_LEVEL] = getGlobalNumber(L, "packetCompressionLevel", 6);
	integer[STORE_COIN_PACKET] = getGlobalNumber(L, "coinPacketSize", 25);
	integer[DAY_KILLS_TO_RED] = getGlobalNumber(L, "dayKillsToRedSkull", 3);
	integer[WEEK_KILLS_TO_RED] = getGlobalNumber(L, "weekKillsToRedSkull", 5);
	integer[MONTH_KILLS_TO_RED] = getGlobalNumber(L, "monthKillsToRedSkull", 10);
	integer[RED_SKULL_DURATION] = getGlobalNumber(L, "redSkullDuration", 30);
	integer[BLACK_SKULL_DURATION] = getGlobalNumber(L, "blackSkullDuration", 45);
	integer[ORANGE_SKULL_DURATION] = getGlobalNumber(L, "orangeSkullDuration", 7);
	integer[GLOBAL_SERVER_SAVE_NOTIFY_DURATION] = getGlobalNumber(L, "globalServerSaveNotifyDuration", 5);

	integer[PARTY_LIST_MAX_DISTANCE] = getGlobalNumber(L, "partyListMaxDistance", 0);

	integer[PUSH_DELAY] = getGlobalNumber(L, "pushDelay", 1000);
	integer[PUSH_DISTANCE_DELAY] = getGlobalNumber(L, "pushDistanceDelay", 1500);

	integer[STAMINA_ORANGE_DELAY] = getGlobalNumber(L, "staminaOrangeDelay", 1);
	integer[STAMINA_GREEN_DELAY] = getGlobalNumber(L, "staminaGreenDelay", 5);
	integer[STAMINA_PZ_GAIN] = getGlobalNumber(L, "staminaPzGain", 1);
	integer[STAMINA_TRAINER_DELAY] = getGlobalNumber(L, "staminaTrainerDelay", 5);
	integer[STAMINA_TRAINER_GAIN] = getGlobalNumber(L, "staminaTrainerGain", 1);
	integer[SAVE_INTERVAL_TIME] = getGlobalNumber(L, "saveIntervalTime", 1);
	integer[MAX_ALLOWED_ON_A_DUMMY] = getGlobalNumber(L, "maxAllowedOnADummy", 1);
	integer[FREE_QUEST_STAGE] = getGlobalNumber(L, "freeQuestStage", 1);
	integer[DEPOTCHEST] = getGlobalNumber(L, "depotChest", 4);
	integer[CRITICALCHANCE] = getGlobalNumber(L, "criticalChance", 10);

	integer[ADVENTURERSBLESSING_LEVEL] = getGlobalNumber(L, "adventurersBlessingLevel", 21);
	integer[FORGE_MAX_ITEM_TIER] = getGlobalNumber(L, "forgeMaxItemTier", 10);
	integer[FORGE_COST_ONE_SLIVER] = getGlobalNumber(L, "forgeCostOneSliver", 20);
	integer[FORGE_SLIVER_AMOUNT] = getGlobalNumber(L, "forgeSliverAmount", 3);
	integer[FORGE_CORE_COST] = getGlobalNumber(L, "forgeCoreCost", 50);
	integer[FORGE_MAX_DUST] = getGlobalNumber(L, "forgeMaxDust", 225);
	integer[FORGE_FUSION_DUST_COST] = getGlobalNumber(L, "forgeFusionCost", 100);
	integer[FORGE_TRANSFER_DUST_COST] = getGlobalNumber(L, "forgeTransferCost", 100);
	integer[FORGE_BASE_SUCCESS_RATE] = getGlobalNumber(L, "forgeBaseSuccessRate", 50);
	integer[FORGE_BONUS_SUCCESS_RATE] = getGlobalNumber(L, "forgeBonusSuccessRate", 15);
	integer[FORGE_TIER_LOSS_REDUCTION] = getGlobalNumber(L, "forgeTierLossReduction", 50);
	integer[FORGE_AMOUNT_MULTIPLIER] = getGlobalNumber(L, "forgeAmountMultiplier", 3);
	integer[FORGE_MIN_SLIVERS] = getGlobalNumber(L, "forgeMinSlivers", 3);
	integer[FORGE_MAX_SLIVERS] = getGlobalNumber(L, "forgeMaxSlivers", 7);
	integer[FORGE_INFLUENCED_CREATURES_LIMIT] = getGlobalNumber(L, "forgeInfluencedLimit", 300);
	integer[FORGE_FIENDISH_CREATURES_LIMIT] = getGlobalNumber(L, "forgeFiendishLimit", 3);
	integer[DISCORD_WEBHOOK_DELAY_MS] = getGlobalNumber(L, "discordWebhookDelayMs", Webhook::DEFAULT_DELAY_MS);

	floating[BESTIARY_RATE_CHARM_SHOP_PRICE] = getGlobalFloat(L, "bestiaryRateCharmShopPrice", 1.0);
	floating[RATE_HEALTH_REGEN] = getGlobalFloat(L, "rateHealthRegen", 1.0);
	floating[RATE_HEALTH_REGEN_SPEED] = getGlobalFloat(L, "rateHealthRegenSpeed", 1.0);
	floating[RATE_MANA_REGEN] = getGlobalFloat(L, "rateManaRegen", 1.0);
	floating[RATE_MANA_REGEN_SPEED] = getGlobalFloat(L, "rateManaRegenSpeed", 1.0);
	floating[RATE_SOUL_REGEN] = getGlobalFloat(L, "rateSoulRegen", 1.0);
	floating[RATE_SOUL_REGEN_SPEED] = getGlobalFloat(L, "rateSoulRegenSpeed", 1.0);
	floating[RATE_SPELL_COOLDOWN] = getGlobalFloat(L, "rateSpellCooldown", 1.0);
	floating[RATE_ATTACK_SPEED] = getGlobalFloat(L, "rateAttackSpeed", 1.0);
	floating[RATE_OFFLINE_TRAINING_SPEED] = getGlobalFloat(L, "rateOfflineTrainingSpeed", 1.0);
	floating[RATE_EXERCISE_TRAINING_SPEED] = getGlobalFloat(L, "rateExerciseTrainingSpeed", 1.0);

	floating[RATE_MONSTER_HEALTH] = getGlobalFloat(L, "rateMonsterHealth", 1.0);
	floating[RATE_MONSTER_ATTACK] = getGlobalFloat(L, "rateMonsterAttack", 1.0);
	floating[RATE_MONSTER_DEFENSE] = getGlobalFloat(L, "rateMonsterDefense", 1.0);
	floating[RATE_BOSS_HEALTH] = getGlobalFloat(L, "rateBossHealth", 1.0);
	floating[RATE_BOSS_ATTACK] = getGlobalFloat(L, "rateBossAttack", 1.0);
	floating[RATE_BOSS_DEFENSE] = getGlobalFloat(L, "rateBossDefense", 1.0);
	integer[BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN] = getGlobalNumber(L, "bossDefaultTimeToFightAgain", 20 * 60 * 60);
	integer[BOSS_DEFAULT_TIME_TO_DEFEAT] = getGlobalNumber(L, "bossDefaultTimeToDefeat", 20 * 60);

	floating[RATE_NPC_HEALTH] = getGlobalFloat(L, "rateNpcHealth", 1.0);
	floating[RATE_NPC_ATTACK] = getGlobalFloat(L, "rateNpcAttack", 1.0);
	floating[RATE_NPC_DEFENSE] = getGlobalFloat(L, "rateNpcDefense", 1.0);

	boolean[PREY_ENABLED] = getGlobalBoolean(L, "preySystemEnabled", true);
	boolean[PREY_FREE_THIRD_SLOT] = getGlobalBoolean(L, "preyFreeThirdSlot", false);
	integer[PREY_REROLL_PRICE_LEVEL] = getGlobalNumber(L, "preyRerollPricePerLevel", 200);
	integer[PREY_SELECTION_LIST_PRICE] = getGlobalNumber(L, "preySelectListPrice", 5);
	integer[PREY_BONUS_TIME] = getGlobalNumber(L, "preyBonusTime", 7200);
	integer[PREY_BONUS_REROLL_PRICE] = getGlobalNumber(L, "preyBonusRerollPrice", 1);
	integer[PREY_FREE_REROLL_TIME] = getGlobalNumber(L, "preyFreeRerollTime", 72000);

	boolean[TASK_HUNTING_ENABLED] = getGlobalBoolean(L, "taskHuntingSystemEnabled", true);
	boolean[TASK_HUNTING_FREE_THIRD_SLOT] = getGlobalBoolean(L, "taskHuntingFreeThirdSlot", false);
	integer[TASK_HUNTING_LIMIT_EXHAUST] = getGlobalNumber(L, "taskHuntingLimitedTasksExhaust", 72000);
	integer[TASK_HUNTING_REROLL_PRICE_LEVEL] = getGlobalNumber(L, "taskHuntingRerollPricePerLevel", 200);
	integer[TASK_HUNTING_SELECTION_LIST_PRICE] = getGlobalNumber(L, "taskHuntingSelectListPrice", 5);
	integer[TASK_HUNTING_BONUS_REROLL_PRICE] = getGlobalNumber(L, "taskHuntingBonusRerollPrice", 1);
	integer[TASK_HUNTING_FREE_REROLL_TIME] = getGlobalNumber(L, "taskHuntingFreeRerollTime", 72000);

	integer[BESTIARY_KILL_MULTIPLIER] = getGlobalNumber(L, "bestiaryKillMultiplier", 1);
	integer[BOSSTIARY_KILL_MULTIPLIER] = getGlobalNumber(L, "bosstiaryKillMultiplier", 1);
	boolean[BOOSTED_BOSS_SLOT] = getGlobalBoolean(L, "boostedBossSlot", true);
	integer[BOOSTED_BOSS_LOOT_BONUS] = getGlobalNumber(L, "boostedBossLootBonus", 250);
	integer[BOOSTED_BOSS_KILL_BONUS] = getGlobalNumber(L, "boostedBossKillBonus", 3);

	integer[FAMILIAR_TIME] = getGlobalNumber(L, "familiarTime", 30);

	boolean[TOGGLE_GOLD_POUCH_ALLOW_ANYTHING] = getGlobalBoolean(L, "toggleGoldPouchAllowAnything", false);
	boolean[TOGGLE_GOLD_POUCH_QUICKLOOT_ONLY] = getGlobalBoolean(L, "toggleGoldPouchQuickLootOnly", false);
	boolean[TOGGLE_SERVER_IS_RETRO] = getGlobalBoolean(L, "toggleServerIsRetroPVP", false);
	boolean[TOGGLE_TRAVELS_FREE] = getGlobalBoolean(L, "toggleTravelsFree", false);
	integer[BUY_AOL_COMMAND_FEE] = getGlobalNumber(L, "buyAolCommandFee", 0);
	integer[BUY_BLESS_COMMAND_FEE] = getGlobalNumber(L, "buyBlessCommandFee", 0);
	boolean[TELEPORT_PLAYER_TO_VOCATION_ROOM] = getGlobalBoolean(L, "teleportPlayerToVocationRoom", true);

	boolean[TOGGLE_HAZARDSYSTEM] = getGlobalBoolean(L, "toogleHazardSystem", true);
	integer[HAZARD_CRITICAL_INTERVAL] = getGlobalNumber(L, "hazardCriticalInterval", 2000);
	integer[HAZARD_CRITICAL_CHANCE] = getGlobalNumber(L, "hazardCriticalChance", 750);
	integer[HAZARD_CRITICAL_MULTIPLIER] = getGlobalNumber(L, "hazardCriticalMultiplier", 25);
	integer[HAZARD_DAMAGE_MULTIPLIER] = getGlobalNumber(L, "hazardDamageMultiplier", 200);
	integer[HAZARD_DODGE_MULTIPLIER] = getGlobalNumber(L, "hazardDodgeMultiplier", 85);
	integer[HAZARD_PODS_DROP_MULTIPLIER] = getGlobalNumber(L, "hazardPodsDropMultiplier", 87);
	integer[HAZARD_PODS_TIME_TO_DAMAGE] = getGlobalNumber(L, "hazardPodsTimeToDamage", 2000);
	integer[HAZARD_PODS_TIME_TO_SPAWN] = getGlobalNumber(L, "hazardPodsTimeToSpawn", 4000);
	integer[HAZARD_EXP_BONUS_MULTIPLIER] = getGlobalNumber(L, "hazardExpBonusMultiplier", 2);
	integer[HAZARD_LOOT_BONUS_MULTIPLIER] = getGlobalNumber(L, "hazardLootBonusMultiplier", 2);
	integer[HAZARD_PODS_DAMAGE] = getGlobalNumber(L, "hazardPodsDamage", 5);
	integer[HAZARD_SPAWN_PLUNDER_MULTIPLIER] = getGlobalNumber(L, "hazardSpawnPlunderMultiplier", 25);
	integer[LOW_LEVEL_BONUS_EXP] = getGlobalNumber(L, "lowLevelBonusExp", 50);

	boolean[LOYALTY_ENABLED] = getGlobalBoolean(L, "loyaltyEnabled", true);
	integer[LOYALTY_POINTS_PER_CREATION_DAY] = getGlobalNumber(L, "loyaltyPointsPerCreationDay", 1);
	integer[LOYALTY_POINTS_PER_PREMIUM_DAY_SPENT] = getGlobalNumber(L, "loyaltyPointsPerPremiumDaySpent", 0);
	integer[LOYALTY_POINTS_PER_PREMIUM_DAY_PURCHASED] = getGlobalNumber(L, "loyaltyPointsPerPremiumDayPurchased", 0);
	floating[LOYALTY_BONUS_PERCENTAGE_MULTIPLIER] = getGlobalFloat(L, "loyaltyBonusPercentageMultiplier", 1.0);

	boolean[TOGGLE_WHEELSYSTEM] = getGlobalBoolean(L, "wheelSystemEnabled", true);
	integer[WHEEL_POINTS_PER_LEVEL] = getGlobalNumber(L, "wheelPointsPerLevel", 1);

	boolean[PARTY_AUTO_SHARE_EXPERIENCE] = getGlobalBoolean(L, "partyAutoShareExperience", true);
	boolean[PARTY_SHARE_LOOT_BOOSTS] = getGlobalBoolean(L, "partyShareLootBoosts", true);
	floating[PARTY_SHARE_LOOT_BOOSTS_DIMINISHING_FACTOR] = getGlobalFloat(L, "partyShareLootBoostsDimishingFactor", 0.7f);
	integer[TIBIADROME_CONCOCTION_COOLDOWN] = getGlobalNumber(L, "tibiadromeConcoctionCooldown", 24 * 60 * 60);
	integer[TIBIADROME_CONCOCTION_DURATION] = getGlobalNumber(L, "tibiadromeConcoctionDuration", 1 * 60 * 60);
	string[TIBIADROME_CONCOCTION_TICK_TYPE] = getGlobalString(L, "tibiadromeConcoctionTickType", "online");

	string[M_CONST] = getGlobalString(L, "memoryConst", "1<<16");
	integer[T_CONST] = getGlobalNumber(L, "temporaryConst", 2);
	integer[PARALLELISM] = getGlobalNumber(L, "parallelism", 2);

	// Vip System
	boolean[VIP_SYSTEM_ENABLED] = getGlobalBoolean(L, "vipSystemEnabled", false);
	integer[VIP_BONUS_EXP] = getGlobalNumber(L, "vipBonusExp", 0);
	integer[VIP_BONUS_LOOT] = getGlobalNumber(L, "vipBonusLoot", 0);
	integer[VIP_BONUS_SKILL] = getGlobalNumber(L, "vipBonusSkill", 0);
	boolean[VIP_AUTOLOOT_VIP_ONLY] = getGlobalBoolean(L, "vipAutoLootVipOnly", false);
	boolean[VIP_STAY_ONLINE] = getGlobalBoolean(L, "vipStayOnline", false);
	integer[VIP_FAMILIAR_TIME_COOLDOWN_REDUCTION] = getGlobalNumber(L, "vipFamiliarTimeCooldownReduction", 0);

	boolean[REWARD_CHEST_COLLECT_ENABLED] = getGlobalBoolean(L, "rewardChestCollectEnabled", true);
	integer[REWARD_CHEST_MAX_COLLECT_ITEMS] = getGlobalNumber(L, "rewardChestMaxCollectItems", 200);

	boolean[TOGGLE_MOUNT_IN_PZ] = getGlobalBoolean(L, "toggleMountInProtectionZone", false);

	boolean[TOGGLE_HOUSE_TRANSFER_ON_SERVER_RESTART] = getGlobalBoolean(L, "togglehouseTransferOnRestart", false);

	boolean[TOGGLE_RECEIVE_REWARD] = getGlobalBoolean(L, "toggleReceiveReward", false);

	loaded = true;
	lua_close(L);
	return true;
}

bool ConfigManager::reload() {
	bool result = load();
	if (transformToSHA1(getString(SERVER_MOTD)) != g_game().getMotdHash()) {
		g_game().incrementMotdNum();
	}
	return result;
}

static std::string dummyStr;

const std::string &ConfigManager::getString(stringConfig_t what) const {
	if (what >= LAST_STRING_CONFIG) {
		g_logger().warn("[ConfigManager::getString] - Accessing invalid index: {}", fmt::underlying(what));
		return dummyStr;
	}
	return string[what];
}

int32_t ConfigManager::getNumber(integerConfig_t what) const {
	if (what >= LAST_INTEGER_CONFIG) {
		g_logger().warn("[ConfigManager::getNumber] - Accessing invalid index: {}", fmt::underlying(what));
		return 0;
	}
	return integer[what];
}

int16_t ConfigManager::getShortNumber(integerConfig_t what) const {
	if (what >= LAST_INTEGER_CONFIG) {
		g_logger().warn("[ConfigManager::getShortNumber] - Accessing invalid index: {}", fmt::underlying(what));
		return 0;
	}
	return integer[what];
}

bool ConfigManager::getBoolean(booleanConfig_t what) const {
	if (what >= LAST_BOOLEAN_CONFIG) {
		g_logger().warn("[ConfigManager::getBoolean] - Accessing invalid index: {}", fmt::underlying(what));
		return false;
	}
	return boolean[what];
}

float ConfigManager::getFloat(floatingConfig_t what) const {
	if (what >= LAST_FLOATING_CONFIG) {
		g_logger().warn("[ConfigManager::getFLoat] - Accessing invalid index: {}", fmt::underlying(what));
		return 0;
	}
	return floating[what];
}
