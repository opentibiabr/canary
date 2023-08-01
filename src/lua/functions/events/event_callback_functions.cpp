/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/functions/events/event_callback_functions.hpp"

#include "lua/callbacks/event_callback.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "utils/tools.h"
#include "items/item.h"
#include "creatures/players/player.h"

/**
 * @class EventCallbackFunctions
 * @brief Class providing Lua functions for manipulating event callbacks.
 *
 * @note This class is derived from LuaScriptInterface and defines several static functions that are exposed to the Lua environment.
 * @details It allows Lua scripts to create, configure, and register event callbacks.
 *
 * @see LuaScriptInterface
 */

void EventCallbackFunctions::init(lua_State* luaState) {
	registerClass(luaState, "EventCallback", "", EventCallbackFunctions::luaEventCallbackCreate);
	registerMethod(luaState, "EventCallback", "type", EventCallbackFunctions::luaEventCallbackType);
	registerMethod(luaState, "EventCallback", "register", EventCallbackFunctions::luaEventCallbackRegister);

	// Callback functions
	registerMethod(luaState, "EventCallback", "creatureOnChangeOutfit", EventCallbackFunctions::luaEventCallbackCreatureOnChangeOutfit);
	registerMethod(luaState, "EventCallback", "creatureOnAreaCombat", EventCallbackFunctions::luaEventCallbackCreatureOnAreaCombat);
	registerMethod(luaState, "EventCallback", "creatureOnTargetCombat", EventCallbackFunctions::luaEventCallbackCreatureOnTargetCombat);
	registerMethod(luaState, "EventCallback", "creatureOnHear", EventCallbackFunctions::luaEventCallbackCreatureOnHear);
	registerMethod(luaState, "EventCallback", "creatureOnDrainHealth", EventCallbackFunctions::luaEventCallbackCreatureOnDrainHealth);
	registerMethod(luaState, "EventCallback", "partyOnJoin", EventCallbackFunctions::luaEventCallbackPartyOnJoin);
	registerMethod(luaState, "EventCallback", "partyOnLeave", EventCallbackFunctions::luaEventCallbackPartyOnLeave);
	registerMethod(luaState, "EventCallback", "partyOnDisband", EventCallbackFunctions::luaEventCallbackPartyOnDisband);
	registerMethod(luaState, "EventCallback", "partyOnShareExperience", EventCallbackFunctions::luaEventCallbackPartyOnShareExperience);
	registerMethod(luaState, "EventCallback", "playerOnBrowseField", EventCallbackFunctions::luaEventCallbackPlayerOnBrowseField);
	registerMethod(luaState, "EventCallback", "playerOnLook", EventCallbackFunctions::luaEventCallbackPlayerOnLook);
	registerMethod(luaState, "EventCallback", "playerOnLookInBattleList", EventCallbackFunctions::luaEventCallbackPlayerOnLookInBattleList);
	registerMethod(luaState, "EventCallback", "playerOnLookInTrade", EventCallbackFunctions::luaEventCallbackPlayerOnLookInTrade);
	registerMethod(luaState, "EventCallback", "playerOnLookInShop", EventCallbackFunctions::luaEventCallbackPlayerOnLookInShop);
	registerMethod(luaState, "EventCallback", "playerOnMoveItem", EventCallbackFunctions::luaEventCallbackPlayerOnMoveItem);
	registerMethod(luaState, "EventCallback", "playerOnItemMoved", EventCallbackFunctions::luaEventCallbackPlayerOnItemMoved);
	registerMethod(luaState, "EventCallback", "playerOnChangeZone", EventCallbackFunctions::luaEventCallbackPlayerOnChangeZone);
	registerMethod(luaState, "EventCallback", "playerOnChangeHazard", EventCallbackFunctions::luaEventCallbackPlayerOnChangeHazard);
	registerMethod(luaState, "EventCallback", "playerOnMoveCreature", EventCallbackFunctions::luaEventCallbackPlayerOnMoveCreature);
	registerMethod(luaState, "EventCallback", "playerOnReportRuleViolation", EventCallbackFunctions::luaEventCallbackPlayerOnReportRuleViolation);
	registerMethod(luaState, "EventCallback", "playerOnReportBug", EventCallbackFunctions::luaEventCallbackPlayerOnReportBug);
	registerMethod(luaState, "EventCallback", "playerOnTurn", EventCallbackFunctions::luaEventCallbackPlayerOnTurn);
	registerMethod(luaState, "EventCallback", "playerOnTradeRequest", EventCallbackFunctions::luaEventCallbackPlayerOnTradeRequest);
	registerMethod(luaState, "EventCallback", "playerOnTradeAccept", EventCallbackFunctions::luaEventCallbackPlayerOnTradeAccept);
	registerMethod(luaState, "EventCallback", "playerOnGainExperience", EventCallbackFunctions::luaEventCallbackPlayerOnGainExperience);
	registerMethod(luaState, "EventCallback", "playerOnLoseExperience", EventCallbackFunctions::luaEventCallbackPlayerOnLoseExperience);
	registerMethod(luaState, "EventCallback", "playerOnGainSkillTries", EventCallbackFunctions::luaEventCallbackPlayerOnGainSkillTries);
	registerMethod(luaState, "EventCallback", "playerOnRequestQuestLog", EventCallbackFunctions::luaEventCallbackPlayerOnRequestQuestLog);
	registerMethod(luaState, "EventCallback", "playerOnRequestQuestLine", EventCallbackFunctions::luaEventCallbackPlayerOnRequestQuestLine);
	registerMethod(luaState, "EventCallback", "playerOnStorageUpdate", EventCallbackFunctions::luaEventCallbackPlayerOnStorageUpdate);
	registerMethod(luaState, "EventCallback", "playerOnRemoveCount", EventCallbackFunctions::luaEventCallbackPlayerOnRemoveCount);
	registerMethod(luaState, "EventCallback", "playerOnCombat", EventCallbackFunctions::luaEventCallbackPlayerOnCombat);
	registerMethod(luaState, "EventCallback", "playerOnInventoryUpdate", EventCallbackFunctions::luaEventCallbackPlayerOnInventoryUpdate);
	registerMethod(luaState, "EventCallback", "monsterOnDropLoot", EventCallbackFunctions::luaEventCallbackMonsterOnDropLoot);
	registerMethod(luaState, "EventCallback", "monsterOnSpawn", EventCallbackFunctions::luaEventCallbackMonsterOnSpawn);
	registerMethod(luaState, "EventCallback", "npcOnSpawn", EventCallbackFunctions::luaEventCallbackNpcOnSpawn);
}

int EventCallbackFunctions::luaEventCallbackCreate(lua_State* luaState) {
	auto eventCallback = new EventCallback(getScriptEnv()->getScriptInterface());
	if (!eventCallback) {
		reportErrorFunc("EventCallback is nil");
		return 0;
	}

	pushUserdata<EventCallback>(luaState, eventCallback);
	setMetatable(luaState, -1, "EventCallback");
	return 1;
}

int EventCallbackFunctions::luaEventCallbackType(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 0;
	}

	auto typeName = getString(luaState, 2);
	auto lowerTypeName = asLowerCaseString(typeName);
	bool found = false;
	for (auto enumValue : magic_enum::enum_values<EventCallback_t>()) {
		std::string enumName = std::string(magic_enum::enum_name(enumValue));
		auto lowerEnumTypeName = asLowerCaseString(enumName);

		if (lowerEnumTypeName == lowerTypeName) {
			callback->setType(enumValue);
			callback->setScriptTypeName(typeName);
			found = true;
			break;
		}
	}

	if (!found) {
		SPDLOG_ERROR("[{}] No valid event name: {}", __func__, typeName);
		pushBoolean(luaState, false);
	}

	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackRegister(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil, failed to register script");
		return 0;
	}

	if (!callback->isLoadedCallback()) {
		reportErrorFunc("Callback not is loaded, failed to register script");
		return 0;
	}

	g_callbacks().addCallback(callback);
	pushBoolean(luaState, true);
	return 1;
}

// Callback functions
// Creature
int EventCallbackFunctions::luaEventCallbackCreatureOnChangeOutfit(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackCreatureOnAreaCombat(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackCreatureOnTargetCombat(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackCreatureOnHear(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackCreatureOnDrainHealth(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

// Party
int EventCallbackFunctions::luaEventCallbackPartyOnJoin(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPartyOnLeave(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPartyOnDisband(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPartyOnShareExperience(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

// Player
int EventCallbackFunctions::luaEventCallbackPlayerOnBrowseField(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnLook(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnLookInBattleList(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnLookInTrade(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnLookInShop(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnMoveItem(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnItemMoved(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnChangeZone(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnChangeHazard(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnMoveCreature(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnReportRuleViolation(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnReportBug(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnTurn(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnTradeRequest(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnTradeAccept(lua_State* luaState) {
	// callback:playerOnTradeAccept(player, target, item, targetItem)
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnGainExperience(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnLoseExperience(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnGainSkillTries(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnRemoveCount(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnRequestQuestLog(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnRequestQuestLine(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnStorageUpdate(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnCombat(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackPlayerOnInventoryUpdate(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

// Monster
int EventCallbackFunctions::luaEventCallbackMonsterOnDropLoot(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

int EventCallbackFunctions::luaEventCallbackMonsterOnSpawn(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}

// Npc
int EventCallbackFunctions::luaEventCallbackNpcOnSpawn(lua_State* luaState) {
	auto callback = getUserdata<EventCallback>(luaState, 1);
	if (!callback) {
		reportErrorFunc("EventCallback is nil");
		return 1;
	}

	if (!callback->loadCallback()) {
		reportErrorFunc("Cannot load callback");
		return 1;
	}

	callback->setLoadedCallback(true);
	pushBoolean(luaState, true);
	return 1;
}
