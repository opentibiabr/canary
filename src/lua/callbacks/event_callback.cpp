/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/callbacks/event_callback.hpp"

#include "game/game.h"

#include "lua/global/baseevents.h"

/**
 * @class Callbacks
 * @brief Class managing all event callbacks.
 *
 * @note This class is a singleton that holds all registered event callbacks.
 * @details It provides functions to add new callbacks and retrieve callbacks by type.
 */
Callbacks::Callbacks() {
	spdlog_dev(info, "Constructing singleton for class {}", __func__);
}

Callbacks::~Callbacks() {
	spdlog_dev(info, "Destructing singleton for class {}", __func__);
}

Callbacks &Callbacks::getInstance() {
	// Guaranteed to be destroyed
	static Callbacks instance;
	// Instantiated on first use
	return instance;
}

void Callbacks::addCallback(EventCallback* callback) {
	callbacks.push_back(callback);
}

std::vector<EventCallback*> Callbacks::getCallbacks() {
	return callbacks;
}

std::vector<EventCallback*> Callbacks::getCallbacksByType(EventCallback_t type) {
	std::vector<EventCallback*> eventCallbacks;
	for (auto callback : getCallbacks()) {
		if (callback->getType() != type) {
			continue;
		}

		eventCallbacks.push_back(callback);
	}

	return eventCallbacks;
}

/**
 * @class CallbackFunctions
 * @brief Class providing Lua functions for manipulating event callbacks.
 *
 * @note This class is derived from LuaScriptInterface and defines several static functions that are exposed to the Lua environment.
 * @details It allows Lua scripts to create, configure, and register event callbacks.
 *
 * @see LuaScriptInterface
 */

void CallbackLuaFunctionsBinder::init(lua_State* luaState) {
	registerClass(luaState, "EventCallback", "", CallbackLuaFunctionsBinder::luaEventCallbackCreate);
	registerMethod(luaState, "EventCallback", "type", CallbackLuaFunctionsBinder::luaEventCallbackType);
	registerMethod(luaState, "EventCallback", "register", CallbackLuaFunctionsBinder::luaEventCallbackRegister);

	// Callback functions
	registerMethod(luaState, "EventCallback", "creatureOnChangeOutfit", CallbackLuaFunctionsBinder::luaEventCallbackCreatureOnChangeOutfit);
	registerMethod(luaState, "EventCallback", "creatureOnAreaCombat", CallbackLuaFunctionsBinder::luaEventCallbackCreatureOnAreaCombat);
	registerMethod(luaState, "EventCallback", "creatureOnTargetCombat", CallbackLuaFunctionsBinder::luaEventCallbackCreatureOnTargetCombat);
	registerMethod(luaState, "EventCallback", "creatureOnHear", CallbackLuaFunctionsBinder::luaEventCallbackCreatureOnHear);
	registerMethod(luaState, "EventCallback", "creatureOnDrainHealth", CallbackLuaFunctionsBinder::luaEventCallbackCreatureOnDrainHealth);
	registerMethod(luaState, "EventCallback", "partyOnJoin", CallbackLuaFunctionsBinder::luaEventCallbackPartyOnJoin);
	registerMethod(luaState, "EventCallback", "partyOnLeave", CallbackLuaFunctionsBinder::luaEventCallbackPartyOnLeave);
	registerMethod(luaState, "EventCallback", "partyOnDisband", CallbackLuaFunctionsBinder::luaEventCallbackPartyOnDisband);
	registerMethod(luaState, "EventCallback", "partyOnShareExperience", CallbackLuaFunctionsBinder::luaEventCallbackPartyOnShareExperience);
	registerMethod(luaState, "EventCallback", "playerOnBrowseField", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnBrowseField);
	registerMethod(luaState, "EventCallback", "playerOnLook", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnLook);
	registerMethod(luaState, "EventCallback", "playerOnLookInBattleList", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnLookInBattleList);
	registerMethod(luaState, "EventCallback", "playerOnLookInTrade", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnLookInTrade);
	registerMethod(luaState, "EventCallback", "playerOnLookInShop", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnLookInShop);
	registerMethod(luaState, "EventCallback", "playerOnMoveItem", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnMoveItem);
	registerMethod(luaState, "EventCallback", "playerOnItemMoved", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnItemMoved);
	registerMethod(luaState, "EventCallback", "playerOnChangeZone", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnChangeZone);
	registerMethod(luaState, "EventCallback", "playerOnChangeHazard", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnChangeHazard);
	registerMethod(luaState, "EventCallback", "playerOnMoveCreature", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnMoveCreature);
	registerMethod(luaState, "EventCallback", "playerOnReportRuleViolation", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnReportRuleViolation);
	registerMethod(luaState, "EventCallback", "playerOnReportBug", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnReportBug);
	registerMethod(luaState, "EventCallback", "playerOnTurn", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnTurn);
	registerMethod(luaState, "EventCallback", "playerOnTradeRequest", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnTradeRequest);
	registerMethod(luaState, "EventCallback", "playerOnTradeAccept", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnTradeAccept);
	registerMethod(luaState, "EventCallback", "playerOnGainExperience", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnGainExperience);
	registerMethod(luaState, "EventCallback", "playerOnLoseExperience", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnLoseExperience);
	registerMethod(luaState, "EventCallback", "playerOnGainSkillTries", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnGainSkillTries);
	registerMethod(luaState, "EventCallback", "playerOnRequestQuestLog", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnRequestQuestLog);
	registerMethod(luaState, "EventCallback", "playerOnRequestQuestLine", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnRequestQuestLine);
	registerMethod(luaState, "EventCallback", "playerOnStorageUpdate", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnStorageUpdate);
	registerMethod(luaState, "EventCallback", "playerOnRemoveCount", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnRemoveCount);
	registerMethod(luaState, "EventCallback", "playerOnCombat", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnCombat);
	registerMethod(luaState, "EventCallback", "playerOnInventoryUpdate", CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnInventoryUpdate);
	registerMethod(luaState, "EventCallback", "monsterOnDropLoot", CallbackLuaFunctionsBinder::luaEventCallbackMonsterOnDropLoot);
	registerMethod(luaState, "EventCallback", "monsterOnSpawn", CallbackLuaFunctionsBinder::luaEventCallbackMonsterOnSpawn);
	registerMethod(luaState, "EventCallback", "npcOnSpawn", CallbackLuaFunctionsBinder::luaEventCallbackNpcOnSpawn);
}

int CallbackLuaFunctionsBinder::luaEventCallbackCreate(lua_State* luaState) {
	auto eventCallback = new EventCallback(getScriptEnv()->getScriptInterface());
	if (!eventCallback) {
		reportErrorFunc("EventCallback is nil");
		return 0;
	}

	pushUserdata<EventCallback>(luaState, eventCallback);
	setMetatable(luaState, -1, "EventCallback");
	return 1;
}

int CallbackLuaFunctionsBinder::luaEventCallbackType(lua_State* luaState) {
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
		SPDLOG_ERROR("[{}] No valid event name: {}",
					__func__, typeName);
		pushBoolean(luaState, false);
	}

	pushBoolean(luaState, true);
	return 1;
}

int CallbackLuaFunctionsBinder::luaEventCallbackRegister(lua_State* luaState) {
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
int CallbackLuaFunctionsBinder::luaEventCallbackCreatureOnChangeOutfit(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackCreatureOnAreaCombat(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackCreatureOnTargetCombat(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackCreatureOnHear(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackCreatureOnDrainHealth(lua_State* luaState) {
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
int CallbackLuaFunctionsBinder::luaEventCallbackPartyOnJoin(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPartyOnLeave(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPartyOnDisband(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPartyOnShareExperience(lua_State* luaState) {
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
int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnBrowseField(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnLook(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnLookInBattleList(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnLookInTrade(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnLookInShop(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnMoveItem(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnItemMoved(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnChangeZone(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnChangeHazard(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnMoveCreature(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnReportRuleViolation(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnReportBug(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnTurn(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnTradeRequest(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnTradeAccept(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnGainExperience(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnLoseExperience(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnGainSkillTries(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnRemoveCount(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnRequestQuestLog(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnRequestQuestLine(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnStorageUpdate(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnCombat(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackPlayerOnInventoryUpdate(lua_State* luaState) {
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
int CallbackLuaFunctionsBinder::luaEventCallbackMonsterOnDropLoot(lua_State* luaState) {
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

int CallbackLuaFunctionsBinder::luaEventCallbackMonsterOnSpawn(lua_State* luaState) {
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
int CallbackLuaFunctionsBinder::luaEventCallbackNpcOnSpawn(lua_State* luaState) {
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
