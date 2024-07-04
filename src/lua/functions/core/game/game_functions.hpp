/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class GameFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerTable(L, "Game");

		registerMethod(L, "Game", "createNpcType", GameFunctions::luaGameCreateNpcType);
		registerMethod(L, "Game", "createMonsterType", GameFunctions::luaGameCreateMonsterType);

		registerMethod(L, "Game", "getSpectators", GameFunctions::luaGameGetSpectators);

		registerMethod(L, "Game", "getBoostedCreature", GameFunctions::luaGameGetBoostedCreature);
		registerMethod(L, "Game", "getBestiaryList", GameFunctions::luaGameGetBestiaryList);

		registerMethod(L, "Game", "getPlayers", GameFunctions::luaGameGetPlayers);
		registerMethod(L, "Game", "loadMap", GameFunctions::luaGameLoadMap);
		registerMethod(L, "Game", "loadMapChunk", GameFunctions::luaGameloadMapChunk);

		registerMethod(L, "Game", "getExperienceForLevel", GameFunctions::luaGameGetExperienceForLevel);
		registerMethod(L, "Game", "getMonsterCount", GameFunctions::luaGameGetMonsterCount);
		registerMethod(L, "Game", "getPlayerCount", GameFunctions::luaGameGetPlayerCount);
		registerMethod(L, "Game", "getNpcCount", GameFunctions::luaGameGetNpcCount);
		registerMethod(L, "Game", "getMonsterTypes", GameFunctions::luaGameGetMonsterTypes);

		registerMethod(L, "Game", "getTowns", GameFunctions::luaGameGetTowns);
		registerMethod(L, "Game", "getHouses", GameFunctions::luaGameGetHouses);

		registerMethod(L, "Game", "getGameState", GameFunctions::luaGameGetGameState);
		registerMethod(L, "Game", "setGameState", GameFunctions::luaGameSetGameState);

		registerMethod(L, "Game", "getWorldType", GameFunctions::luaGameGetWorldType);
		registerMethod(L, "Game", "setWorldType", GameFunctions::luaGameSetWorldType);

		registerMethod(L, "Game", "getReturnMessage", GameFunctions::luaGameGetReturnMessage);

		registerMethod(L, "Game", "createItem", GameFunctions::luaGameCreateItem);
		registerMethod(L, "Game", "createContainer", GameFunctions::luaGameCreateContainer);
		registerMethod(L, "Game", "createMonster", GameFunctions::luaGameCreateMonster);
		registerMethod(L, "Game", "createNpc", GameFunctions::luaGameCreateNpc);
		registerMethod(L, "Game", "generateNpc", GameFunctions::luaGameGenerateNpc);
		registerMethod(L, "Game", "createTile", GameFunctions::luaGameCreateTile);
		registerMethod(L, "Game", "createBestiaryCharm", GameFunctions::luaGameCreateBestiaryCharm);

		registerMethod(L, "Game", "createItemClassification", GameFunctions::luaGameCreateItemClassification);

		registerMethod(L, "Game", "getBestiaryCharm", GameFunctions::luaGameGetBestiaryCharm);

		registerMethod(L, "Game", "startRaid", GameFunctions::luaGameStartRaid);

		registerMethod(L, "Game", "getClientVersion", GameFunctions::luaGameGetClientVersion);

		registerMethod(L, "Game", "reload", GameFunctions::luaGameReload);

		registerMethod(L, "Game", "hasDistanceEffect", GameFunctions::luaGameHasDistanceEffect);
		registerMethod(L, "Game", "hasEffect", GameFunctions::luaGameHasEffect);
		registerMethod(L, "Game", "getOfflinePlayer", GameFunctions::luaGameGetOfflinePlayer);
		registerMethod(L, "Game", "getNormalizedPlayerName", GameFunctions::luaGameGetNormalizedPlayerName);
		registerMethod(L, "Game", "getNormalizedGuildName", GameFunctions::luaGameGetNormalizedGuildName);

		registerMethod(L, "Game", "addInfluencedMonster", GameFunctions::luaGameAddInfluencedMonster);
		registerMethod(L, "Game", "removeInfluencedMonster", GameFunctions::luaGameRemoveInfluencedMonster);
		registerMethod(L, "Game", "getInfluencedMonsters", GameFunctions::luaGameGetInfluencedMonsters);
		registerMethod(L, "Game", "makeFiendishMonster", GameFunctions::luaGameMakeFiendishMonster);
		registerMethod(L, "Game", "removeFiendishMonster", GameFunctions::luaGameRemoveFiendishMonster);
		registerMethod(L, "Game", "getFiendishMonsters", GameFunctions::luaGameGetFiendishMonsters);
		registerMethod(L, "Game", "getBoostedBoss", GameFunctions::luaGameGetBoostedBoss);

		registerMethod(L, "Game", "getLadderIds", GameFunctions::luaGameGetLadderIds);
		registerMethod(L, "Game", "getDummies", GameFunctions::luaGameGetDummies);

		registerMethod(L, "Game", "getTalkActions", GameFunctions::luaGameGetTalkActions);
		registerMethod(L, "Game", "getEventCallbacks", GameFunctions::luaGameGetEventCallbacks);

		registerMethod(L, "Game", "registerAchievement", GameFunctions::luaGameRegisterAchievement);
		registerMethod(L, "Game", "getAchievementInfoById", GameFunctions::luaGameGetAchievementInfoById);
		registerMethod(L, "Game", "getAchievementInfoByName", GameFunctions::luaGameGetAchievementInfoByName);
		registerMethod(L, "Game", "getSecretAchievements", GameFunctions::luaGameGetSecretAchievements);
		registerMethod(L, "Game", "getPublicAchievements", GameFunctions::luaGameGetPublicAchievements);
		registerMethod(L, "Game", "getAchievements", GameFunctions::luaGameGetAchievements);
	}

private:
	static int luaGameCreateMonsterType(lua_State* L);
	static int luaGameCreateNpcType(lua_State* L);

	static int luaGameGetSpectators(lua_State* L);

	static int luaGameGetBoostedCreature(lua_State* L);
	static int luaGameGetBestiaryList(lua_State* L);

	static int luaGameGetPlayers(lua_State* L);
	static int luaGameLoadMap(lua_State* L);
	static int luaGameloadMapChunk(lua_State* L);

	static int luaGameGetExperienceForLevel(lua_State* L);
	static int luaGameGetMonsterCount(lua_State* L);
	static int luaGameGetPlayerCount(lua_State* L);
	static int luaGameGetNpcCount(lua_State* L);
	static int luaGameGetMonsterTypes(lua_State* L);

	static int luaGameGetTowns(lua_State* L);
	static int luaGameGetHouses(lua_State* L);

	static int luaGameGetGameState(lua_State* L);
	static int luaGameSetGameState(lua_State* L);

	static int luaGameGetWorldType(lua_State* L);
	static int luaGameSetWorldType(lua_State* L);

	static int luaGameGetReturnMessage(lua_State* L);

	static int luaGameCreateItem(lua_State* L);
	static int luaGameCreateContainer(lua_State* L);
	static int luaGameCreateMonster(lua_State* L);
	static int luaGameGenerateNpc(lua_State* L);
	static int luaGameCreateNpc(lua_State* L);
	static int luaGameCreateTile(lua_State* L);

	static int luaGameGetBestiaryCharm(lua_State* L);
	static int luaGameCreateBestiaryCharm(lua_State* L);

	static int luaGameCreateItemClassification(lua_State* L);

	static int luaGameStartRaid(lua_State* L);

	static int luaGameGetClientVersion(lua_State* L);

	static int luaGameReload(lua_State* L);

	static int luaGameGetOfflinePlayer(lua_State* L);
	static int luaGameGetNormalizedPlayerName(lua_State* L);
	static int luaGameGetNormalizedGuildName(lua_State* L);
	static int luaGameHasEffect(lua_State* L);
	static int luaGameHasDistanceEffect(lua_State* L);

	static int luaGameAddInfluencedMonster(lua_State* L);
	static int luaGameRemoveInfluencedMonster(lua_State* L);
	static int luaGameGetInfluencedMonsters(lua_State* L);
	static int luaGameMakeFiendishMonster(lua_State* L);
	static int luaGameRemoveFiendishMonster(lua_State* L);
	static int luaGameGetFiendishMonsters(lua_State* L);

	static int luaGameGetBoostedBoss(lua_State* L);

	static int luaGameGetLadderIds(lua_State* L);
	static int luaGameGetDummies(lua_State* L);

	static int luaGameGetTalkActions(lua_State* L);
	static int luaGameGetEventCallbacks(lua_State* L);

	static int luaGameRegisterAchievement(lua_State* L);
	static int luaGameGetAchievementInfoById(lua_State* L);
	static int luaGameGetAchievementInfoByName(lua_State* L);
	static int luaGameGetSecretAchievements(lua_State* L);
	static int luaGameGetPublicAchievements(lua_State* L);
	static int luaGameGetAchievements(lua_State* L);
};
