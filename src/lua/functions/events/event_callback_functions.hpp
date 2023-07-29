/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_LUA_FUNCTIONS_EVENTS_EVENT_CALLBACK_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_EVENTS_EVENT_CALLBACK_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

/**
 * @class EventCallbackFunctions
 * @brief Class providing Lua functions for manipulating event callbacks.
 *
 * @note This class is derived from LuaScriptInterface and defines several static functions that are exposed to the Lua environment.
 * @details It allows Lua scripts to create, configure, and register event callbacks.
 *
 * @see LuaScriptInterface
 */
class EventCallbackFunctions : public LuaScriptInterface {
	public:
		static void init(lua_State* luaState);

	private:
		static int luaEventCallbackCreate(lua_State* luaState);
		static int luaEventCallbackType(lua_State* luaState);
		static int luaEventCallbackRegister(lua_State* luaState);

		// Callback functions
		// Creature
		static int luaEventCallbackCreatureOnChangeOutfit(lua_State* luaState);
		static int luaEventCallbackCreatureOnAreaCombat(lua_State* luaState);
		static int luaEventCallbackCreatureOnTargetCombat(lua_State* luaState);
		static int luaEventCallbackCreatureOnHear(lua_State* luaState);
		static int luaEventCallbackCreatureOnDrainHealth(lua_State* luaState);
		// Party
		static int luaEventCallbackPartyOnJoin(lua_State* luaState);
		static int luaEventCallbackPartyOnLeave(lua_State* luaState);
		static int luaEventCallbackPartyOnDisband(lua_State* luaState);
		static int luaEventCallbackPartyOnShareExperience(lua_State* luaState);
		// Player
		static int luaEventCallbackPlayerOnBrowseField(lua_State* luaState);
		static int luaEventCallbackPlayerOnLook(lua_State* luaState);
		static int luaEventCallbackPlayerOnLookInBattleList(lua_State* luaState);
		static int luaEventCallbackPlayerOnLookInTrade(lua_State* luaState);
		static int luaEventCallbackPlayerOnLookInShop(lua_State* luaState);
		static int luaEventCallbackPlayerOnMoveItem(lua_State* luaState);
		static int luaEventCallbackPlayerOnItemMoved(lua_State* luaState);
		static int luaEventCallbackPlayerOnChangeZone(lua_State* luaState);
		static int luaEventCallbackPlayerOnChangeHazard(lua_State* luaState);
		static int luaEventCallbackPlayerOnMoveCreature(lua_State* luaState);
		static int luaEventCallbackPlayerOnReportRuleViolation(lua_State* luaState);
		static int luaEventCallbackPlayerOnReportBug(lua_State* luaState);
		static int luaEventCallbackPlayerOnTurn(lua_State* luaState);
		static int luaEventCallbackPlayerOnTradeRequest(lua_State* luaState);
		static int luaEventCallbackPlayerOnTradeAccept(lua_State* luaState);
		static int luaEventCallbackPlayerOnGainExperience(lua_State* luaState);
		static int luaEventCallbackPlayerOnLoseExperience(lua_State* luaState);
		static int luaEventCallbackPlayerOnGainSkillTries(lua_State* luaState);
		static int luaEventCallbackPlayerOnRemoveCount(lua_State* luaState);
		static int luaEventCallbackPlayerOnRequestQuestLog(lua_State* luaState);
		static int luaEventCallbackPlayerOnRequestQuestLine(lua_State* luaState);
		static int luaEventCallbackPlayerOnStorageUpdate(lua_State* luaState);
		static int luaEventCallbackPlayerOnCombat(lua_State* luaState);
		static int luaEventCallbackPlayerOnInventoryUpdate(lua_State* luaState);
		// Monster
		static int luaEventCallbackMonsterOnDropLoot(lua_State* luaState);
		static int luaEventCallbackMonsterOnSpawn(lua_State* luaState);
		// Npc
		static int luaEventCallbackNpcOnSpawn(lua_State* luaState);
};

#endif // SRC_LUA_FUNCTIONS_EVENTS_EVENT_CALLBACK_FUNCTIONS_HPP_
