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

#include "creatures/interactions/chat.h"
#include "game/game.h"
#include "game/scheduling/scheduler.h"
#include "lua/functions/core/game/global_functions.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "lua/scripts/script_environment.hpp"
#include "server/network/protocol/protocolstatus.h"

class Creature;
int GlobalFunctions::luaDoPlayerAddItem(lua_State* L) {
	// doPlayerAddItem(cid, itemid, <optional: default: 1> count/subtype, <optional: default: 1> canDropOnMap)
	// doPlayerAddItem(cid, itemid, <optional: default: 1> count, <optional: default: 1> canDropOnMap, <optional: default: 1>subtype)
	Player* player = getPlayer(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint16_t itemId = getNumber<uint16_t>(L, 2);
	int32_t count = getNumber<int32_t>(L, 3, 1);
	bool canDropOnMap = getBoolean(L, 4, true);
	uint16_t subType = getNumber<uint16_t>(L, 5, 1);

	const ItemType& it = Item::items[itemId];
	int32_t itemCount;

	auto parameters = lua_gettop(L);
	if (parameters > 4) {
		// subtype already supplied, count then is the amount
		itemCount = std::max<int32_t>(1, count);
	} else if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = static_cast<int32_t>(std::ceil(static_cast<float>(count) / 100));
		} else {
			itemCount = 1;
		}
		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	while (itemCount > 0) {
		uint16_t stackCount = subType;
		if (it.stackable && stackCount > 100) {
			stackCount = 100;
		}

		Item* newItem = Item::CreateItem(itemId, stackCount);
		if (!newItem) {
			reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		if (it.stackable) {
			subType -= stackCount;
		}

		ReturnValue ret = g_game().internalPlayerAddItem(player, newItem, canDropOnMap);
		if (ret != RETURNVALUE_NOERROR) {
			delete newItem;
			pushBoolean(L, false);
			return 1;
		}

		if (--itemCount == 0) {
			if (newItem->getParent()) {
				uint32_t uid = getScriptEnv()->addThing(newItem);
				lua_pushnumber(L, uid);
				return 1;
			} else {
				// stackable item stacked with existing object, newItem will be released
				pushBoolean(L, false);
				return 1;
			}
		}
	}

	pushBoolean(L, false);
	return 1;
}

int GlobalFunctions::luaDoSetCreatureLight(lua_State* L) {
	// doSetCreatureLight(cid, lightLevel, lightColor, time)
	Creature* creature = getCreature(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint16_t level = getNumber<uint16_t>(L, 2);
	uint16_t color = getNumber<uint16_t>(L, 3);
	uint32_t time = getNumber<uint32_t>(L, 4);
	Condition* condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_LIGHT, time, level | (color << 8));
	creature->addCondition(condition);
	pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaIsValidUID(lua_State* L) {
	// isValidUID(uid)
	pushBoolean(L, getScriptEnv()->getThingByUID(getNumber<uint32_t>(L, -1)) != nullptr);
	return 1;
}

int GlobalFunctions::luaIsDepot(lua_State* L) {
	// isDepot(uid)
	Container* container = getScriptEnv()->getContainerByUID(getNumber<uint32_t>(L, -1));
	pushBoolean(L, container && container->getDepotLocker());
	return 1;
}

int GlobalFunctions::luaIsMoveable(lua_State* L) {
	// isMoveable(uid)
	// isMovable(uid)
	Thing* thing = getScriptEnv()->getThingByUID(getNumber<uint32_t>(L, -1));
	pushBoolean(L, thing && thing->isPushable());
	return 1;
}

int GlobalFunctions::luaDoAddContainerItem(lua_State* L) {
	// doAddContainerItem(uid, itemid, <optional> count/subtype)
	uint32_t uid = getNumber<uint32_t>(L, 1);

	ScriptEnvironment* env = getScriptEnv();
	Container* container = env->getContainerByUID(uid);
	if (!container) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CONTAINER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint16_t itemId = getNumber<uint16_t>(L, 2);
	const ItemType& it = Item::items[itemId];

	int32_t itemCount = 1;
	int32_t subType = 1;
	uint32_t count = getNumber<uint32_t>(L, 3, 1);

	if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = static_cast<int32_t>(std::ceil(static_cast<float>(count) / 100));
		}

		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	while (itemCount > 0) {
		int32_t stackCount = std::min<int32_t>(100, subType);
		Item* newItem = Item::CreateItem(itemId, stackCount);
		if (!newItem) {
			reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		if (it.stackable) {
			subType -= stackCount;
		}

		ReturnValue ret = g_game().internalAddItem(container, newItem);
		if (ret != RETURNVALUE_NOERROR) {
			delete newItem;
			pushBoolean(L, false);
			return 1;
		}

		if (--itemCount == 0) {
			if (newItem->getParent()) {
				lua_pushnumber(L, env->addThing(newItem));
			} else {
				// stackable item stacked with existing object, newItem will be released
				pushBoolean(L, false);
			}
			return 1;
		}
	}

	pushBoolean(L, false);
	return 1;
}

int GlobalFunctions::luaGetDepotId(lua_State* L) {
	// getDepotId(uid)
	uint32_t uid = getNumber<uint32_t>(L, -1);

	Container* container = getScriptEnv()->getContainerByUID(uid);
	if (!container) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CONTAINER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	DepotLocker* depotLocker = container->getDepotLocker();
	if (!depotLocker) {
		reportErrorFunc("Depot not found");
		pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, depotLocker->getDepotId());
	return 1;
}

int GlobalFunctions::luaGetWorldTime(lua_State* L) {
	// getWorldTime()
	uint32_t time = g_game().getLightHour();
	lua_pushnumber(L, time);
	return 1;
}

int GlobalFunctions::luaGetWorldLight(lua_State* L) {
	// getWorldLight()
	LightInfo lightInfo = g_game().getWorldLightInfo();
	lua_pushnumber(L, lightInfo.level);
	lua_pushnumber(L, lightInfo.color);
	return 2;
}

int GlobalFunctions::luaGetWorldUpTime(lua_State* L) {
	// getWorldUpTime()
	uint64_t uptime = (OTSYS_TIME() - ProtocolStatus::start) / 1000;
	lua_pushnumber(L, uptime);
	return 1;
}

int GlobalFunctions::luaCreateCombatArea(lua_State* L) {
	// createCombatArea( {area}, <optional> {extArea} )
	ScriptEnvironment* env = getScriptEnv();
	if (env->getScriptId() != EVENT_ID_LOADING) {
		reportErrorFunc("This function can only be used while loading the script.");
		pushBoolean(L, false);
		return 1;
	}

	uint32_t areaId = g_luaEnvironment.createAreaObject(env->getScriptInterface());
	AreaCombat* area = g_luaEnvironment.getAreaObject(areaId);

	int parameters = lua_gettop(L);
	if (parameters >= 2) {
		uint32_t rowsExtArea;
		std::list<uint32_t> listExtArea;
		if (!isTable(L, 2) || !getArea(L, listExtArea, rowsExtArea)) {
			reportErrorFunc("Invalid extended area table.");
			pushBoolean(L, false);
			return 1;
		}
		area->setupExtArea(listExtArea, rowsExtArea);
	}

	uint32_t rowsArea = 0;
	std::list<uint32_t> listArea;
	if (!isTable(L, 1) || !getArea(L, listArea, rowsArea)) {
		reportErrorFunc("Invalid area table.");
		pushBoolean(L, false);
		return 1;
	}

	area->setupArea(listArea, rowsArea);
	lua_pushnumber(L, areaId);
	return 1;
}

int GlobalFunctions::luaDoAreaCombatHealth(lua_State* L) {
	// doAreaCombatHealth(cid, type, pos, area, min, max, effect[, origin = ORIGIN_SPELL])
	Creature* creature = getCreature(L, 1);
	if (!creature && (!isNumber(L, 1) || getNumber<uint32_t>(L, 1) != 0)) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint32_t areaId = getNumber<uint32_t>(L, 4);
	const AreaCombat* area = g_luaEnvironment.getAreaObject(areaId);
	if (area || areaId == 0) {
		CombatType_t combatType = getNumber<CombatType_t>(L, 2);

		CombatParams params;
		params.combatType = combatType;
		params.impactEffect = getNumber<uint8_t>(L, 7);

		CombatDamage damage;
		damage.origin = getNumber<CombatOrigin>(L, 8, ORIGIN_SPELL);
		damage.primary.type = combatType;
		damage.primary.value = normal_random(getNumber<int64_t>(L, 6), getNumber<int64_t>(L, 5));

		Combat::doCombatHealth(creature, getPosition(L, 3), area, damage, params);
		pushBoolean(L, true);
	} else {
		reportErrorFunc(getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		pushBoolean(L, false);
	}
	return 1;
}

int GlobalFunctions::luaDoTargetCombatHealth(lua_State* L) {
	// doTargetCombatHealth(cid, target, type, min, max, effect[, origin = ORIGIN_SPELL])
	Creature* creature = getCreature(L, 1);
	if (!creature && (!isNumber(L, 1) || getNumber<uint32_t>(L, 1) != 0)) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Creature* target = getCreature(L, 2);
	if (!target) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	CombatType_t combatType = getNumber<CombatType_t>(L, 3);

	CombatParams params;
	params.combatType = combatType;
	params.impactEffect = getNumber<uint8_t>(L, 6);

	CombatDamage damage;
	damage.origin = getNumber<CombatOrigin>(L, 7, ORIGIN_SPELL);
	damage.primary.type = combatType;
	damage.primary.value = normal_random(getNumber<int64_t>(L, 4), getNumber<int64_t>(L, 5));

	// Check if it's a healing then we sould add the non-aggresive tag
	if (combatType == COMBAT_HEALING ||
		(combatType == COMBAT_MANADRAIN && damage.primary.value > 0)) {
		params.aggressive = false;
	}

	Combat::doCombatHealth(creature, target, damage, params);
	pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaDoAreaCombatMana(lua_State* L) {
	// doAreaCombatMana(cid, pos, area, min, max, effect[, origin = ORIGIN_SPELL])
	Creature* creature = getCreature(L, 1);
	if (!creature && (!isNumber(L, 1) || getNumber<uint32_t>(L, 1) != 0)) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint32_t areaId = getNumber<uint32_t>(L, 3);
	const AreaCombat* area = g_luaEnvironment.getAreaObject(areaId);
	if (area || areaId == 0) {
		CombatParams params;
		params.impactEffect = getNumber<uint8_t>(L, 6);

		CombatDamage damage;
		damage.origin = getNumber<CombatOrigin>(L, 7, ORIGIN_SPELL);
		damage.primary.type = COMBAT_MANADRAIN;
		damage.primary.value = normal_random(getNumber<int64_t>(L, 4), getNumber<int64_t>(L, 5));

		Position pos = getPosition(L, 2);
		Combat::doCombatMana(creature, pos, area, damage, params);
		pushBoolean(L, true);
	} else {
		reportErrorFunc(getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		pushBoolean(L, false);
	}
	return 1;
}

int GlobalFunctions::luaDoTargetCombatMana(lua_State* L) {
	// doTargetCombatMana(cid, target, min, max, effect[, origin = ORIGIN_SPELL)
	Creature* creature = getCreature(L, 1);
	if (!creature && (!isNumber(L, 1) || getNumber<uint32_t>(L, 1) != 0)) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Creature* target = getCreature(L, 2);
	if (!target) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	CombatParams params;
	params.impactEffect = getNumber<uint8_t>(L, 5);

	CombatDamage damage;
	damage.origin = getNumber<CombatOrigin>(L, 6, ORIGIN_SPELL);
	damage.primary.type = COMBAT_MANADRAIN;
	damage.primary.value = normal_random(getNumber<int64_t>(L, 3), getNumber<int64_t>(L, 4));

	Combat::doCombatMana(creature, target, damage, params);
	pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaDoAreaCombatCondition(lua_State* L) {
	// doAreaCombatCondition(cid, pos, area, condition, effect)
	Creature* creature = getCreature(L, 1);
	if (!creature && (!isNumber(L, 1) || getNumber<uint32_t>(L, 1) != 0)) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	const Condition* condition = getUserdata<Condition>(L, 4);
	if (!condition) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CONDITION_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint32_t areaId = getNumber<uint32_t>(L, 3);
	const AreaCombat* area = g_luaEnvironment.getAreaObject(areaId);
	if (area || areaId == 0) {
		CombatParams params;
		params.impactEffect = getNumber<uint8_t>(L, 5);
		params.conditionList.emplace_front(condition);
		Combat::doCombatCondition(creature, getPosition(L, 2), area, params);
		pushBoolean(L, true);
	} else {
		reportErrorFunc(getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		pushBoolean(L, false);
	}
	return 1;
}

int GlobalFunctions::luaDoTargetCombatCondition(lua_State* L) {
	// doTargetCombatCondition(cid, target, condition, effect)
	Creature* creature = getCreature(L, 1);
	if (!creature && (!isNumber(L, 1) || getNumber<uint32_t>(L, 1) != 0)) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Creature* target = getCreature(L, 2);
	if (!target) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	const Condition* condition = getUserdata<Condition>(L, 3);
	if (!condition) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CONDITION_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	CombatParams params;
	params.impactEffect = getNumber<uint8_t>(L, 4);
	params.conditionList.emplace_front(condition->clone());
	Combat::doCombatCondition(creature, target, params);
	pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaDoAreaCombatDispel(lua_State* L) {
	// doAreaCombatDispel(cid, pos, area, type, effect)
	Creature* creature = getCreature(L, 1);
	if (!creature && (!isNumber(L, 1) || getNumber<uint32_t>(L, 1) != 0)) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint32_t areaId = getNumber<uint32_t>(L, 3);
	const AreaCombat* area = g_luaEnvironment.getAreaObject(areaId);
	if (area || areaId == 0) {
		CombatParams params;
		params.impactEffect = getNumber<uint8_t>(L, 5);
		params.dispelType = getNumber<ConditionType_t>(L, 4);
		Combat::doCombatDispel(creature, getPosition(L, 2), area, params);

		pushBoolean(L, true);
	} else {
		reportErrorFunc(getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		pushBoolean(L, false);
	}
	return 1;
}

int GlobalFunctions::luaDoTargetCombatDispel(lua_State* L) {
	// doTargetCombatDispel(cid, target, type, effect)
	Creature* creature = getCreature(L, 1);
	if (!creature && (!isNumber(L, 1) || getNumber<uint32_t>(L, 1) != 0)) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Creature* target = getCreature(L, 2);
	if (!target) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	CombatParams params;
	params.dispelType = getNumber<ConditionType_t>(L, 3);
	params.impactEffect = getNumber<uint8_t>(L, 4);
	Combat::doCombatDispel(creature, target, params);
	pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaDoChallengeCreature(lua_State* L) {
	// doChallengeCreature(cid, target)
	Creature* creature = getCreature(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Creature* target = getCreature(L, 2);
	if (!target) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	target->challengeCreature(creature);
	pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaAddEvent(lua_State* L) {
	// addEvent(callback, delay, ...)
	lua_State* globalState = g_luaEnvironment.getLuaState();
	if (!globalState) {
		reportErrorFunc("No valid script interface!");
		pushBoolean(L, false);
		return 1;
	} else if (globalState != L) {
		lua_xmove(L, globalState, lua_gettop(L));
	}

	int parameters = lua_gettop(globalState);
	if (!isFunction(globalState, -parameters)) { // -parameters means the first parameter from left to right
		reportErrorFunc("callback parameter should be a function.");
		pushBoolean(L, false);
		return 1;
	}

	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) || g_configManager().getBoolean(CONVERT_UNSAFE_SCRIPTS)) {
		std::vector<std::pair<int32_t, LuaDataType>> indexes;
		for (int i = 3; i <= parameters; ++i) {
			if (lua_getmetatable(globalState, i) == 0) {
				continue;
			}
			lua_rawgeti(L, -1, 't');

			LuaDataType type = getNumber<LuaDataType>(L, -1);
			if (type != LuaData_Unknown && type != LuaData_Tile) {
				indexes.push_back({i, type});
			}
			lua_pop(globalState, 2);
		}

		if (!indexes.empty()) {
			if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS)) {
				bool plural = indexes.size() > 1;

				std::string warningString = "Argument";
				if (plural) {
					warningString += 's';
				}

				for (const auto& entry : indexes) {
					if (entry == indexes.front()) {
						warningString += ' ';
					} else if (entry == indexes.back()) {
						warningString += " and ";
					} else {
						warningString += ", ";
					}
					warningString += '#';
					warningString += std::to_string(entry.first);
				}

				if (plural) {
					warningString += " are unsafe";
				} else {
					warningString += " is unsafe";
				}

				reportErrorFunc(warningString);
			}

			if (g_configManager().getBoolean(CONVERT_UNSAFE_SCRIPTS)) {
				for (const auto& entry : indexes) {
					switch (entry.second) {
						case LuaData_Item:
						case LuaData_Container:
						case LuaData_Teleport: {
							lua_getglobal(globalState, "Item");
							lua_getfield(globalState, -1, "getUniqueId");
							break;
						}
						case LuaData_Player:
						case LuaData_Monster:
						case LuaData_Npc: {
							lua_getglobal(globalState, "Creature");
							lua_getfield(globalState, -1, "getId");
							break;
						}
						default:
							break;
					}
					lua_replace(globalState, -2);
					lua_pushvalue(globalState, entry.first);
					lua_call(globalState, 1, 1);
					lua_replace(globalState, entry.first);
				}
			}
		}
	}

	LuaTimerEventDesc eventDesc;
	for (int i = 0; i < parameters - 2; ++i) { // -2 because addEvent needs at least two parameters
		eventDesc.parameters.push_back(luaL_ref(globalState, LUA_REGISTRYINDEX));
	}

	uint32_t delay = std::max<uint32_t>(100, getNumber<uint32_t>(globalState, 2));
	lua_pop(globalState, 1);

	eventDesc.function = luaL_ref(globalState, LUA_REGISTRYINDEX);
	eventDesc.scriptId = getScriptEnv()->getScriptId();

	auto& lastTimerEventId = g_luaEnvironment.lastEventTimerId;
	eventDesc.eventId = g_scheduler().addEvent(createSchedulerTask(
					delay, std::bind(&LuaEnvironment::executeTimerEvent, &g_luaEnvironment, lastTimerEventId)
	));

	g_luaEnvironment.timerEvents.emplace(lastTimerEventId, std::move(eventDesc));
	lua_pushnumber(L, lastTimerEventId++);
	return 1;
}

int GlobalFunctions::luaStopEvent(lua_State* L) {
	// stopEvent(eventid)
	lua_State* globalState = g_luaEnvironment.getLuaState();
	if (!globalState) {
		reportErrorFunc("No valid script interface!");
		pushBoolean(L, false);
		return 1;
	}

	uint32_t eventId = getNumber<uint32_t>(L, 1);

	auto& timerEvents = g_luaEnvironment.timerEvents;
	auto it = timerEvents.find(eventId);
	if (it == timerEvents.end()) {
		pushBoolean(L, false);
		return 1;
	}

	LuaTimerEventDesc timerEventDesc = std::move(it->second);
	timerEvents.erase(it);

	g_scheduler().stopEvent(timerEventDesc.eventId);
	luaL_unref(globalState, LUA_REGISTRYINDEX, timerEventDesc.function);

	for (auto parameter : timerEventDesc.parameters) {
		luaL_unref(globalState, LUA_REGISTRYINDEX, parameter);
	}

	pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaSaveServer(lua_State* L) {
	g_game().saveGameState();
	pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaCleanMap(lua_State* L) {
	lua_pushnumber(L, g_game().map.clean());
	return 1;
}

int GlobalFunctions::luaDebugPrint(lua_State* L) {
	// debugPrint(text)
	reportErrorFunc(getString(L, -1));
	return 0;
}

int GlobalFunctions::luaIsInWar(lua_State* L) {
	// isInWar(cid, target)
	Player* player = getPlayer(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Player* targetPlayer = getPlayer(L, 2);
	if (!targetPlayer) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	pushBoolean(L, player->isInWar(targetPlayer));
	return 1;
}

int GlobalFunctions::luaGetWaypointPositionByName(lua_State* L) {
	// getWaypointPositionByName(name)
	auto& waypoints = g_game().map.waypoints;

	auto it = waypoints.find(getString(L, -1));
	if (it != waypoints.end()) {
		pushPosition(L, it->second);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int GlobalFunctions::luaSendChannelMessage(lua_State* L) {
	// sendChannelMessage(channelId, type, message)
	uint16_t channelId = getNumber<uint16_t>(L, 1);
	const ChatChannel* channel = g_chat().getChannelById(channelId);
	if (!channel) {
		pushBoolean(L, false);
		return 1;
	}

	SpeakClasses type = getNumber<SpeakClasses>(L, 2);
	std::string message = getString(L, 3);
	channel->sendToAll(message, type);
	pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaSendGuildChannelMessage(lua_State* L) {
	// sendGuildChannelMessage(guildId, type, message)
	uint32_t guildId = getNumber<uint32_t>(L, 1);
	const ChatChannel* channel = g_chat().getGuildChannelById(guildId);
	if (!channel) {
		pushBoolean(L, false);
		return 1;
	}

	SpeakClasses type = getNumber<SpeakClasses>(L, 2);
	std::string message = getString(L, 3);
	channel->sendToAll(message, type);
	pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaIsType(lua_State* L) {
	// isType(derived, base)
	lua_getmetatable(L, -2);
	lua_getmetatable(L, -2);

	lua_rawgeti(L, -2, 'p');
	uint_fast8_t parentsB = getNumber<uint_fast8_t>(L, 1);

	lua_rawgeti(L, -3, 'h');
	size_t hashB = getNumber<size_t>(L, 1);

	lua_rawgeti(L, -3, 'p');
	uint_fast8_t parentsA = getNumber<uint_fast8_t>(L, 1);
	for (uint_fast8_t i = parentsA; i < parentsB; ++i) {
		lua_getfield(L, -3, "__index");
		lua_replace(L, -4);
	}

	lua_rawgeti(L, -4, 'h');
	size_t hashA = getNumber<size_t>(L, 1);

	pushBoolean(L, hashA == hashB);
	return 1;
}

int GlobalFunctions::luaRawGetMetatable(lua_State* L) {
	// rawgetmetatable(metatableName)
	luaL_getmetatable(L, getString(L, 1).c_str());
	return 1;
}

int GlobalFunctions::luaCreateTable(lua_State* L) {
	// createTable(arrayLength, keyLength)
	lua_createtable(L, getNumber<int32_t>(L, 1), getNumber<int32_t>(L, 2));
	return 1;
}

int GlobalFunctions::luaSystemTime(lua_State* L) {
	// systemTime()
	lua_pushnumber(L, OTSYS_TIME());
	return 1;
}

bool GlobalFunctions::getArea(lua_State* L, std::list<uint32_t>& list, uint32_t& rows) {
	lua_pushnil(L);
	for (rows = 0; lua_next(L, -2) != 0; ++rows) {
		if (!isTable(L, -1)) {
			return false;
		}

		lua_pushnil(L);
		while (lua_next(L, -2) != 0) {
			if (!isNumber(L, -1)) {
				return false;
			}
			list.push_back(getNumber<uint32_t>(L, -1));
			lua_pop(L, 1);
		}

		lua_pop(L, 1);
	}

	lua_pop(L, 1);
	return (rows != 0);
}
