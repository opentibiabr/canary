/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/callbacks/event_callback.hpp"

#include "creatures/players/grouping/party.hpp"
#include "creatures/players/player.hpp"
#include "creatures/creatures_definitions.hpp"
#include "game/movement/position.hpp"
#include "game/zones/zone.hpp"
#include "items/containers/container.hpp"
#include "items/item.hpp"
#include "items/items.hpp"
#include "lua/scripts/scripts.hpp"

/**
 * @class EventCallback
 * @brief Class representing an event callback.
 *
 * @note This class is used to encapsulate the logic of a Lua event callback.
 * @details It is derived from the Script class and includes additional information specific to event callbacks.
 *
 * @see Script
 */
EventCallback::EventCallback(const std::string &callbackName, bool skipDuplicationCheck, LuaScriptInterface* interface) :
	m_callbackName(callbackName), m_skipDuplicationCheck(skipDuplicationCheck),
	m_scriptInterface(interface ? interface : &g_scripts().getScriptInterface()) {
	assert(m_scriptInterface != nullptr);
}

LuaScriptInterface* EventCallback::getScriptInterface() const noexcept {
	return m_scriptInterface;
}

bool EventCallback::loadScriptId() {
	LuaScriptInterface &luaInterface = *getScriptInterface();
	m_scriptId = luaInterface.getEvent();
	if (m_scriptId == kInvalidScriptId) {
		g_logger().error("[EventCallback::loadScriptId] Failed to load event. Script name: '{}', Module: '{}'", luaInterface.getLoadingScriptName(), luaInterface.getInterfaceName());
		return false;
	}

	return true;
}

std::string EventCallback::getScriptTypeName() const {
	return m_scriptTypeName;
}

void EventCallback::setScriptTypeName(std::string_view newName) {
	m_scriptTypeName = newName;
}

int32_t EventCallback::getScriptId() const noexcept {
	return m_scriptId;
}

void EventCallback::setScriptId(int32_t newScriptId) noexcept {
	m_scriptId = newScriptId;
}

bool EventCallback::isLoadedScriptId() const noexcept {
	return m_scriptId != kInvalidScriptId;
}

bool EventCallback::canExecute() const {
	if (!m_enabled) {
		g_logger().debug("[EventCallback::canExecute] Callback '{}' disabled", m_callbackName);
		return false;
	}
	if (m_scriptId == kInvalidScriptId) {
		g_logger().warn("[EventCallback::canExecute] Invalid script id for '{}'", m_callbackName);
		return false;
	}
	if (getScriptInterface() == nullptr) {
		g_logger().error("[EventCallback::canExecute] Script interface is null for '{}'", m_callbackName);
		return false;
	}
	return true;
}

std::string EventCallback::getName() const {
	return m_callbackName;
}

bool EventCallback::skipDuplicationCheck() const {
	return m_skipDuplicationCheck;
}

void EventCallback::setSkipDuplicationCheck(bool skip) {
	m_skipDuplicationCheck = skip;
}

EventCallback_t EventCallback::getType() const {
	return m_callbackType;
}

void EventCallback::setType(EventCallback_t type) {
	m_callbackType = type;
}

void EventCallback::pushArgument(lua_State* L, const std::shared_ptr<Player> &player) {
	if (player) {
		Lua::pushUserdata<Player>(L, player);
		Lua::setCreatureMetatable(L, -1, player);
	} else {
		lua_pushnil(L);
	}
}

void EventCallback::pushArgument(lua_State* L, const std::shared_ptr<Item> &item) {
	if (item) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
}

void EventCallback::pushArgument(lua_State* L, const std::shared_ptr<Creature> &creature) {
	if (creature) {
		Lua::pushUserdata<Creature>(L, creature);
		Lua::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}
}

void EventCallback::pushArgument(lua_State* L, const std::shared_ptr<Party> &party) {
	if (party) {
		Lua::pushUserdata<Party>(L, party);
		Lua::setMetatable(L, -1, "Party");
	} else {
		lua_pushnil(L);
	}
}

void EventCallback::pushArgument(lua_State* L, const std::shared_ptr<Monster> &monster) {
	if (monster) {
		Lua::pushUserdata<Monster>(L, monster);
		Lua::setMetatable(L, -1, "Monster");
	} else {
		lua_pushnil(L);
	}
}

void EventCallback::pushArgument(lua_State* L, const std::shared_ptr<Container> &container) {
	if (container) {
		Lua::pushUserdata<Container>(L, container);
		Lua::setMetatable(L, -1, "Container");
	} else {
		lua_pushnil(L);
	}
}

void EventCallback::pushArgument(lua_State* L, const std::shared_ptr<Zone> &zone) {
	if (zone) {
		Lua::pushUserdata<Zone>(L, zone);
		Lua::setMetatable(L, -1, "Zone");
	} else {
		lua_pushnil(L);
	}
}

void EventCallback::pushArgument(lua_State* L, const std::shared_ptr<Tile> &tile) {
	if (tile) {
		Lua::pushUserdata<Tile>(L, tile);
		Lua::setMetatable(L, -1, "Tile");
	} else {
		lua_pushnil(L);
	}
}

void EventCallback::pushArgument(lua_State* L, const std::shared_ptr<Thing> &thing) {
	if (thing) {
		Lua::pushThing(L, thing);
	} else {
		lua_pushnil(L);
	}
}

void EventCallback::pushArgument(lua_State* L, const std::shared_ptr<Cylinder> &cylinder) {
	if (cylinder) {
		Lua::pushCylinder(L, cylinder);
	} else {
		lua_pushnil(L);
	}
}

void EventCallback::pushArgument(lua_State* L, const ItemType* itemType) {
	if (itemType) {
		Lua::pushUserdata<const ItemType>(L, itemType);
		Lua::setMetatable(L, -1, "ItemType");
	} else {
		lua_pushnil(L);
	}
}

void EventCallback::pushArgument(lua_State* L, CombatDamage &damage) {
	lua_createtable(L, 0, 4);

	lua_createtable(L, 0, 2);
	Lua::setField(L, "value", damage.primary.value);
	Lua::setField(L, "type", damage.primary.type);
	lua_setfield(L, -2, "primary");

	lua_createtable(L, 0, 2);
	Lua::setField(L, "value", damage.secondary.value);
	Lua::setField(L, "type", damage.secondary.type);
	lua_setfield(L, -2, "secondary");

	Lua::setField(L, "origin", damage.origin);
	lua_pushboolean(L, damage.critical);
	lua_setfield(L, -2, "critical");
}

void EventCallback::pushArgument(lua_State* L, const Position &position) {
	Lua::pushPosition(L, position);
}

void EventCallback::pushArgument(lua_State* L, const Outfit_t &outfit) {
	Lua::pushOutfit(L, outfit);
}

void EventCallback::pushArgument(lua_State* L, const std::string &value) {
	Lua::pushString(L, value);
}

void EventCallback::pushArgument(lua_State* L, int32_t value) {
	Lua::pushNumber(L, value);
}

void EventCallback::pushArgument(lua_State* L, uint32_t value) {
	Lua::pushNumber(L, value);
}

void EventCallback::pushArgument(lua_State* L, uint64_t value) {
	Lua::pushNumber(L, static_cast<lua_Number>(value));
}

void EventCallback::pushArgument(lua_State* L, uint8_t value) {
	Lua::pushNumber(L, value);
}

void EventCallback::pushArgument(lua_State* L, bool value) {
	Lua::pushBoolean(L, value);
}

void EventCallback::pushArgument(lua_State* L, Direction value) {
	Lua::pushNumber(L, static_cast<int32_t>(value));
}

void EventCallback::pushArgument(lua_State* L, ReturnValue value) {
	Lua::pushNumber(L, static_cast<int32_t>(value));
}

void EventCallback::pushArgument(lua_State* L, SpeakClasses value) {
	Lua::pushNumber(L, static_cast<int32_t>(value));
}

void EventCallback::pushArgument(lua_State* L, Slots_t value) {
	Lua::pushNumber(L, static_cast<int32_t>(value));
}

void EventCallback::pushArgument(lua_State* L, ZoneType_t value) {
	Lua::pushNumber(L, static_cast<int32_t>(value));
}

void EventCallback::pushArgument(lua_State* L, skills_t value) {
	Lua::pushNumber(L, static_cast<int32_t>(value));
}

void EventCallback::pushArgument(lua_State* L, CombatType_t value) {
	Lua::pushNumber(L, static_cast<int32_t>(value));
}

void EventCallback::pushArgument(lua_State* L, TextColor_t value) {
	Lua::pushNumber(L, static_cast<int32_t>(value));
}

void EventCallback::pushArgument(lua_State* L, std::reference_wrapper<CombatDamage> value) {
	pushArgument(L, value.get());
}
