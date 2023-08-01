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
 * @brief Provides a set of static functions for working with Event Callbacks in Lua.
 *
 * @details This class encapsulates the Lua binding functions related to event callbacks,
 * allowing for interaction between the C++ codebase and Lua scripts.
 */
class EventCallbackFunctions : public LuaScriptInterface {
	public:
		/**
		 * @brief Initializes the Lua state with the event callback functions.
		 *
		 * This function registers the event callback-related functions with the given Lua state,
		 * making them accessible to Lua scripts.
		 *
		 * @param luaState The Lua state to initialize.
		 */
		static void init(lua_State* luaState);

	private:
		/**
		 * @brief Creates a new EventCallback object in Lua.
		 *
		 * This function is called from Lua to create a new EventCallback object,
		 * which can then be used to register various event handlers.
		 *
		 * @param luaState The Lua state.
		 * @return Number of return values on the Lua stack.
		 */
		static int luaEventCallbackCreate(lua_State* luaState);

		/**
		 * @brief Sets or gets the type of an EventCallback object in Lua.
		 *
		 * This function is called from Lua to set or get the type of an EventCallback object.
		 *
		 * @param luaState The Lua state.
		 * @return Number of return values on the Lua stack.
		 */
		static int luaEventCallbackType(lua_State* luaState);

		/**
		 * @brief Registers an EventCallback object in Lua.
		 *
		 * This function is called from Lua to register an EventCallback object,
		 * allowing it to be triggered by specific events in the game.
		 *
		 * @param luaState The Lua state.
		 * @return Number of return values on the Lua stack.
		 */
		static int luaEventCallbackRegister(lua_State* luaState);

		/**
		 * @defgroup Event Callback Functions
		 * @brief Lua binding functions for handling various events related to Creatures and Party, Player, Monster and Npc.
		 *
		 * These functions serve as the entry points for various event types related to varios classes in the game. They are triggered by specific game events.
		 *
		 * Each function takes the Lua state as a parameter and returns the number of return values on the Lua stack.
		 *
		 * @note here start the lua binder functions {
		 */
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

		/**
		 * @note here end the lua binder functions }
		 */
};

#endif // SRC_LUA_FUNCTIONS_EVENTS_EVENT_CALLBACK_FUNCTIONS_HPP_
