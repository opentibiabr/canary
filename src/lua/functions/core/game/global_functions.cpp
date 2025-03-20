/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/game/global_functions.hpp"

#include "config/configmanager.hpp"
#include "creatures/creature.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/interactions/chat.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/scheduling/save_manager.hpp"
#include "items/containers/depot/depotlocker.hpp"
#include "lua/global/globalevent.hpp"
#include "lua/global/lua_timer_event_descr.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "lua/scripts/script_environment.hpp"
#include "server/network/protocol/protocolstatus.hpp"
#include "lua/functions/lua_functions_loader.hpp"
#include "creatures/players/player.hpp"

void GlobalFunctions::init(lua_State* L) {
	lua_register(L, "addEvent", GlobalFunctions::luaAddEvent);
	lua_register(L, "cleanMap", GlobalFunctions::luaCleanMap);
	lua_register(L, "createCombatArea", GlobalFunctions::luaCreateCombatArea);
	lua_register(L, "debugPrint", GlobalFunctions::luaDebugPrint);
	lua_register(L, "doAddContainerItem", GlobalFunctions::luaDoAddContainerItem);
	lua_register(L, "doAreaCombatCondition", GlobalFunctions::luaDoAreaCombatCondition);
	lua_register(L, "doAreaCombatDispel", GlobalFunctions::luaDoAreaCombatDispel);
	lua_register(L, "doAreaCombatHealth", GlobalFunctions::luaDoAreaCombatHealth);
	lua_register(L, "doAreaCombatMana", GlobalFunctions::luaDoAreaCombatMana);
	lua_register(L, "doChallengeCreature", GlobalFunctions::luaDoChallengeCreature);
	lua_register(L, "doPlayerAddItem", GlobalFunctions::luaDoPlayerAddItem);
	lua_register(L, "doTargetCombatCondition", GlobalFunctions::luaDoTargetCombatCondition);
	lua_register(L, "doTargetCombatDispel", GlobalFunctions::luaDoTargetCombatDispel);
	lua_register(L, "doTargetCombatHealth", GlobalFunctions::luaDoTargetCombatHealth);
	lua_register(L, "doTargetCombatMana", GlobalFunctions::luaDoTargetCombatMana);
	lua_register(L, "getDepotId", GlobalFunctions::luaGetDepotId);
	lua_register(L, "getWaypointPositionByName", GlobalFunctions::luaGetWaypointPositionByName);
	lua_register(L, "getWorldLight", GlobalFunctions::luaGetWorldLight);
	lua_register(L, "getWorldTime", GlobalFunctions::luaGetWorldTime);
	lua_register(L, "getWorldUpTime", GlobalFunctions::luaGetWorldUpTime);
	lua_register(L, "isDepot", GlobalFunctions::luaIsDepot);
	lua_register(L, "isInWar", GlobalFunctions::luaIsInWar);
	lua_register(L, "isMovable", GlobalFunctions::luaIsMovable);
	lua_register(L, "isValidUID", GlobalFunctions::luaIsValidUID);
	lua_register(L, "saveServer", GlobalFunctions::luaSaveServer);
	lua_register(L, "sendChannelMessage", GlobalFunctions::luaSendChannelMessage);
	lua_register(L, "sendGuildChannelMessage", GlobalFunctions::luaSendGuildChannelMessage);
	lua_register(L, "stopEvent", GlobalFunctions::luaStopEvent);

	Lua::registerGlobalVariable(L, "INDEX_WHEREEVER", INDEX_WHEREEVER);
	Lua::registerGlobalBoolean(L, "VIRTUAL_PARENT", true);
	Lua::registerGlobalMethod(L, "isType", GlobalFunctions::luaIsType);
	Lua::registerGlobalMethod(L, "rawgetmetatable", GlobalFunctions::luaRawGetMetatable);
	Lua::registerGlobalMethod(L, "createTable", GlobalFunctions::luaCreateTable);
	Lua::registerGlobalMethod(L, "systemTime", GlobalFunctions::luaSystemTime);
	Lua::registerGlobalMethod(L, "getFormattedTimeRemaining", GlobalFunctions::luaGetFormattedTimeRemaining);
	Lua::registerGlobalMethod(L, "reportError", GlobalFunctions::luaReportError);
}

int GlobalFunctions::luaDoPlayerAddItem(lua_State* L) {
	// doPlayerAddItem(cid, itemid, <optional: default: 1> count/subtype, <optional: default: 1> canDropOnMap)
	// doPlayerAddItem(cid, itemid, <optional: default: 1> count, <optional: default: 1> canDropOnMap, <optional: default: 1>subtype)
	const auto &player = Lua::getPlayer(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const uint16_t itemId = Lua::getNumber<uint16_t>(L, 2);
	const auto count = Lua::getNumber<int32_t>(L, 3, 1);
	const bool canDropOnMap = Lua::getBoolean(L, 4, true);
	auto subType = Lua::getNumber<uint16_t>(L, 5, 1);

	const ItemType &it = Item::items[itemId];
	int32_t itemCount;

	const auto parameters = lua_gettop(L);
	if (parameters > 4) {
		// subtype already supplied, count then is the amount
		itemCount = std::max<int32_t>(1, count);
	} else if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = static_cast<int32_t>(std::ceil(static_cast<float>(count) / it.stackSize));
		} else {
			itemCount = 1;
		}
		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	while (itemCount > 0) {
		uint16_t stackCount = subType;
		if (it.stackable && stackCount > it.stackSize) {
			stackCount = it.stackSize;
		}

		const auto &newItem = Item::CreateItem(itemId, stackCount);
		if (!newItem) {
			Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
			Lua::pushBoolean(L, false);
			return 1;
		}

		if (it.stackable) {
			subType -= stackCount;
		}

		ReturnValue ret = g_game().internalPlayerAddItem(player, newItem, canDropOnMap);
		if (ret != RETURNVALUE_NOERROR) {
			Lua::pushBoolean(L, false);
			return 1;
		}

		if (--itemCount == 0) {
			if (newItem->getParent()) {
				const uint32_t uid = Lua::getScriptEnv()->addThing(newItem);
				lua_pushnumber(L, uid);
				return 1;
			} else {
				// stackable item stacked with existing object, newItem will be released
				Lua::pushBoolean(L, false);
				return 1;
			}
		}
	}

	Lua::pushBoolean(L, false);
	return 1;
}

int GlobalFunctions::luaIsValidUID(lua_State* L) {
	// isValidUID(uid)
	Lua::pushBoolean(L, Lua::getScriptEnv()->getThingByUID(Lua::getNumber<uint32_t>(L, -1)) != nullptr);
	return 1;
}

int GlobalFunctions::luaIsDepot(lua_State* L) {
	// isDepot(uid)
	const auto &container = Lua::getScriptEnv()->getContainerByUID(Lua::getNumber<uint32_t>(L, -1));
	Lua::pushBoolean(L, container && container->getDepotLocker());
	return 1;
}

int GlobalFunctions::luaIsMovable(lua_State* L) {
	// isMovable(uid)
	// isMovable(uid)
	const auto &thing = Lua::getScriptEnv()->getThingByUID(Lua::getNumber<uint32_t>(L, -1));
	Lua::pushBoolean(L, thing && thing->isPushable());
	return 1;
}

int GlobalFunctions::luaDoAddContainerItem(lua_State* L) {
	// doAddContainerItem(uid, itemid, <optional> count/subtype)
	const uint32_t uid = Lua::getNumber<uint32_t>(L, 1);

	ScriptEnvironment* env = Lua::getScriptEnv();
	const auto &container = env->getContainerByUID(uid);
	if (!container) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CONTAINER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const uint16_t itemId = Lua::getNumber<uint16_t>(L, 2);
	const ItemType &it = Item::items[itemId];

	int32_t itemCount = 1;
	int32_t subType = 1;
	const auto count = Lua::getNumber<uint32_t>(L, 3, 1);

	if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = static_cast<int32_t>(std::ceil(static_cast<float>(count) / it.stackSize));
		}

		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	while (itemCount > 0) {
		const int32_t stackCount = std::min<int32_t>(it.stackSize, subType);
		const auto &newItem = Item::CreateItem(itemId, stackCount);
		if (!newItem) {
			Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
			Lua::pushBoolean(L, false);
			return 1;
		}

		if (it.stackable) {
			subType -= stackCount;
		}

		ReturnValue ret = g_game().internalAddItem(container, newItem);
		if (ret != RETURNVALUE_NOERROR) {
			Lua::pushBoolean(L, false);
			return 1;
		}

		if (--itemCount == 0) {
			if (newItem->getParent()) {
				lua_pushnumber(L, env->addThing(newItem));
			} else {
				// stackable item stacked with existing object, newItem will be released
				Lua::pushBoolean(L, false);
			}
			return 1;
		}
	}

	Lua::pushBoolean(L, false);
	return 1;
}

int GlobalFunctions::luaGetDepotId(lua_State* L) {
	// getDepotId(uid)
	const uint32_t uid = Lua::getNumber<uint32_t>(L, -1);

	const auto &container = Lua::getScriptEnv()->getContainerByUID(uid);
	if (!container) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CONTAINER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &depotLocker = container->getDepotLocker();
	if (!depotLocker) {
		Lua::reportErrorFunc("Depot not found");
		Lua::pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, depotLocker->getDepotId());
	return 1;
}

int GlobalFunctions::luaGetWorldTime(lua_State* L) {
	// getWorldTime()
	const uint32_t time = g_game().getLightHour();
	lua_pushnumber(L, time);
	return 1;
}

int GlobalFunctions::luaGetWorldLight(lua_State* L) {
	// getWorldLight()
	const LightInfo lightInfo = g_game().getWorldLightInfo();
	lua_pushnumber(L, lightInfo.level);
	lua_pushnumber(L, lightInfo.color);
	return 2;
}

int GlobalFunctions::luaGetWorldUpTime(lua_State* L) {
	// getWorldUpTime()
	const uint64_t uptime = (OTSYS_TIME(true) - ProtocolStatus::start) / 1000;
	lua_pushnumber(L, uptime);
	return 1;
}

int GlobalFunctions::luaCreateCombatArea(lua_State* L) {
	// createCombatArea( {area}, <optional> {extArea} )
	const ScriptEnvironment* env = Lua::getScriptEnv();
	if (env->getScriptId() != EVENT_ID_LOADING) {
		Lua::reportErrorFunc("This function can only be used while loading the script.");
		Lua::pushBoolean(L, false);
		return 1;
	}

	const uint32_t areaId = g_luaEnvironment().createAreaObject(env->getScriptInterface());
	const auto &area = g_luaEnvironment().getAreaObject(areaId);

	const int parameters = lua_gettop(L);
	if (parameters >= 2) {
		uint32_t rowsExtArea;
		std::list<uint32_t> listExtArea;
		if (!Lua::isTable(L, 2) || !getArea(L, listExtArea, rowsExtArea)) {
			Lua::reportErrorFunc("Invalid extended area table.");
			Lua::pushBoolean(L, false);
			return 1;
		}
		area->setupExtArea(listExtArea, rowsExtArea);
	}

	uint32_t rowsArea = 0;
	std::list<uint32_t> listArea;
	if (!Lua::isTable(L, 1) || !getArea(L, listArea, rowsArea)) {
		Lua::reportErrorFunc("Invalid area table.");
		Lua::pushBoolean(L, false);
		return 1;
	}

	area->setupArea(listArea, rowsArea);
	lua_pushnumber(L, areaId);
	return 1;
}

int GlobalFunctions::luaDoAreaCombatHealth(lua_State* L) {
	// doAreaCombatHealth(cid, type, pos, area, min, max, effect[, origin = ORIGIN_SPELL])
	const auto &creature = Lua::getCreature(L, 1);
	if (!creature && (!Lua::isNumber(L, 1) || Lua::getNumber<uint32_t>(L, 1) != 0)) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const uint32_t areaId = Lua::getNumber<uint32_t>(L, 4);
	const auto &area = g_luaEnvironment().getAreaObject(areaId);
	if (area || areaId == 0) {
		const CombatType_t combatType = Lua::getNumber<CombatType_t>(L, 2);

		CombatParams params;
		params.combatType = combatType;
		params.impactEffect = Lua::getNumber<uint16_t>(L, 7);

		CombatDamage damage;
		damage.origin = Lua::getNumber<CombatOrigin>(L, 8, ORIGIN_SPELL);
		damage.primary.type = combatType;
		damage.primary.value = normal_random(Lua::getNumber<int32_t>(L, 6), Lua::getNumber<int32_t>(L, 5));

		damage.instantSpellName = Lua::getString(L, 9);
		damage.runeSpellName = Lua::getString(L, 10);
		if (creature) {
			if (const auto &player = creature->getPlayer()) {
				player->wheel().getCombatDataSpell(damage);
			}
		}

		Combat::doCombatHealth(creature, Lua::getPosition(L, 3), area, damage, params);
		Lua::pushBoolean(L, true);
	} else {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int GlobalFunctions::luaDoTargetCombatHealth(lua_State* L) {
	// doTargetCombatHealth(cid, target, type, min, max, effect[, origin = ORIGIN_SPELL])
	const auto &creature = Lua::getCreature(L, 1);
	if (!creature && (!Lua::isNumber(L, 1) || Lua::getNumber<uint32_t>(L, 1) != 0)) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &target = Lua::getCreature(L, 2);
	if (!target) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const CombatType_t combatType = Lua::getNumber<CombatType_t>(L, 3);

	CombatParams params;
	params.combatType = combatType;
	params.impactEffect = Lua::getNumber<uint16_t>(L, 6);

	CombatDamage damage;
	damage.origin = Lua::getNumber<CombatOrigin>(L, 7, ORIGIN_SPELL);
	damage.primary.type = combatType;
	damage.primary.value = normal_random(Lua::getNumber<int32_t>(L, 4), Lua::getNumber<int32_t>(L, 5));

	damage.instantSpellName = Lua::getString(L, 9);
	damage.runeSpellName = Lua::getString(L, 10);
	if (creature) {
		if (const auto &player = creature->getPlayer()) {
			player->wheel().getCombatDataSpell(damage);
		}
	}

	// Check if it's a healing then we sould add the non-aggresive tag
	if (combatType == COMBAT_HEALING || (combatType == COMBAT_MANADRAIN && damage.primary.value > 0)) {
		params.aggressive = false;
	}

	Combat::doCombatHealth(creature, target, damage, params);
	Lua::pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaDoAreaCombatMana(lua_State* L) {
	// doAreaCombatMana(cid, pos, area, min, max, effect[, origin = ORIGIN_SPELL])
	const auto &creature = Lua::getCreature(L, 1);
	if (!creature && (!Lua::isNumber(L, 1) || Lua::getNumber<uint32_t>(L, 1) != 0)) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const uint32_t areaId = Lua::getNumber<uint32_t>(L, 3);
	const auto &area = g_luaEnvironment().getAreaObject(areaId);
	if (area || areaId == 0) {
		CombatParams params;
		params.impactEffect = Lua::getNumber<uint16_t>(L, 6);

		CombatDamage damage;
		damage.origin = Lua::getNumber<CombatOrigin>(L, 7, ORIGIN_SPELL);
		damage.primary.type = COMBAT_MANADRAIN;
		damage.primary.value = normal_random(Lua::getNumber<int32_t>(L, 4), Lua::getNumber<int32_t>(L, 5));

		damage.instantSpellName = Lua::getString(L, 8);
		damage.runeSpellName = Lua::getString(L, 9);
		if (creature) {
			if (const auto &player = creature->getPlayer()) {
				player->wheel().getCombatDataSpell(damage);
			}
		}

		const Position pos = Lua::getPosition(L, 2);
		Combat::doCombatMana(creature, pos, area, damage, params);
		Lua::pushBoolean(L, true);
	} else {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int GlobalFunctions::luaDoTargetCombatMana(lua_State* L) {
	// doTargetCombatMana(cid, target, min, max, effect[, origin = ORIGIN_SPELL)
	const auto &creature = Lua::getCreature(L, 1);
	if (!creature && (!Lua::isNumber(L, 1) || Lua::getNumber<uint32_t>(L, 1) != 0)) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &target = Lua::getCreature(L, 2);
	if (!target) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	CombatParams params;
	const auto minval = Lua::getNumber<int32_t>(L, 3);
	const auto maxval = Lua::getNumber<int32_t>(L, 4);
	params.aggressive = minval + maxval < 0;
	params.impactEffect = Lua::getNumber<uint16_t>(L, 5);

	CombatDamage damage;
	damage.origin = Lua::getNumber<CombatOrigin>(L, 6, ORIGIN_SPELL);
	damage.primary.type = COMBAT_MANADRAIN;
	damage.primary.value = normal_random(minval, maxval);

	damage.instantSpellName = Lua::getString(L, 7);
	damage.runeSpellName = Lua::getString(L, 8);
	if (creature) {
		if (const auto &player = creature->getPlayer()) {
			player->wheel().getCombatDataSpell(damage);
		}
	}

	Combat::doCombatMana(creature, target, damage, params);
	Lua::pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaDoAreaCombatCondition(lua_State* L) {
	// doAreaCombatCondition(cid, pos, area, condition, effect)
	const auto &creature = Lua::getCreature(L, 1);
	if (!creature && (!Lua::isNumber(L, 1) || Lua::getNumber<uint32_t>(L, 1) != 0)) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &condition = Lua::getUserdataShared<Condition>(L, 4, "Condition");
	if (!condition) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CONDITION_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const uint32_t areaId = Lua::getNumber<uint32_t>(L, 3);
	const auto &area = g_luaEnvironment().getAreaObject(areaId);
	if (area || areaId == 0) {
		CombatParams params;
		params.impactEffect = Lua::getNumber<uint16_t>(L, 5);
		params.conditionList.emplace_back(condition);
		Combat::doCombatCondition(creature, Lua::getPosition(L, 2), area, params);
		Lua::pushBoolean(L, true);
	} else {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int GlobalFunctions::luaDoTargetCombatCondition(lua_State* L) {
	// doTargetCombatCondition(cid, target, condition, effect)
	const auto &creature = Lua::getCreature(L, 1);
	if (!creature && (!Lua::isNumber(L, 1) || Lua::getNumber<uint32_t>(L, 1) != 0)) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &target = Lua::getCreature(L, 2);
	if (!target) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &condition = Lua::getUserdataShared<Condition>(L, 3, "Condition");
	if (!condition) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CONDITION_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	CombatParams params;
	params.impactEffect = Lua::getNumber<uint16_t>(L, 4);
	params.conditionList.emplace_back(condition->clone());
	Combat::doCombatCondition(creature, target, params);
	Lua::pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaDoAreaCombatDispel(lua_State* L) {
	// doAreaCombatDispel(cid, pos, area, type, effect)
	const auto &creature = Lua::getCreature(L, 1);
	if (!creature && (!Lua::isNumber(L, 1) || Lua::getNumber<uint32_t>(L, 1) != 0)) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const uint32_t areaId = Lua::getNumber<uint32_t>(L, 3);
	const auto &area = g_luaEnvironment().getAreaObject(areaId);
	if (area || areaId == 0) {
		CombatParams params;
		params.impactEffect = Lua::getNumber<uint16_t>(L, 5);
		params.dispelType = Lua::getNumber<ConditionType_t>(L, 4);
		Combat::doCombatDispel(creature, Lua::getPosition(L, 2), area, params);

		Lua::pushBoolean(L, true);
	} else {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int GlobalFunctions::luaDoTargetCombatDispel(lua_State* L) {
	// doTargetCombatDispel(cid, target, type, effect)
	const auto &creature = Lua::getCreature(L, 1);
	if (!creature && (!Lua::isNumber(L, 1) || Lua::getNumber<uint32_t>(L, 1) != 0)) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &target = Lua::getCreature(L, 2);
	if (!target) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	CombatParams params;
	params.dispelType = Lua::getNumber<ConditionType_t>(L, 3);
	params.impactEffect = Lua::getNumber<uint16_t>(L, 4);
	Combat::doCombatDispel(creature, target, params);
	Lua::pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaDoChallengeCreature(lua_State* L) {
	// doChallengeCreature(cid, target, targetChangeCooldown)
	const auto &creature = Lua::getCreature(L, 1);
	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &target = Lua::getCreature(L, 2);
	if (!target) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const int targetChangeCooldown = Lua::getNumber<int32_t>(L, 3, 6000);
	// This function must be defined to take and handle the targetChangeCooldown.
	target->challengeCreature(creature, targetChangeCooldown);

	Lua::pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaAddEvent(lua_State* L) {
	// addEvent(callback, delay, ...)
	lua_State* globalState = g_luaEnvironment().getLuaState();
	if (!globalState) {
		Lua::reportErrorFunc("No valid script interface!");
		Lua::pushBoolean(L, false);
		return 1;
	} else if (globalState != L) {
		lua_xmove(L, globalState, lua_gettop(L));
	}

	const int parameters = lua_gettop(globalState);
	if (!Lua::isFunction(globalState, -parameters)) { // -parameters means the first parameter from left to right
		Lua::reportErrorFunc("callback parameter should be a function.");
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) || g_configManager().getBoolean(CONVERT_UNSAFE_SCRIPTS)) {
		std::vector<std::pair<int32_t, LuaData_t>> indexes;
		for (int i = 3; i <= parameters; ++i) {
			if (lua_getmetatable(globalState, i) == 0) {
				continue;
			}
			lua_rawgeti(L, -1, 't');

			LuaData_t type = Lua::getNumber<LuaData_t>(L, -1);
			if (type != LuaData_t::Unknown && type <= LuaData_t::Npc) {
				indexes.emplace_back(i, type);
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

				for (const auto &entry : indexes) {
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

				Lua::reportErrorFunc(warningString);
			}

			if (g_configManager().getBoolean(CONVERT_UNSAFE_SCRIPTS)) {
				for (const auto &entry : indexes) {
					switch (entry.second) {
						case LuaData_t::Item:
						case LuaData_t::Container:
						case LuaData_t::Teleport: {
							lua_getglobal(globalState, "Item");
							lua_getfield(globalState, -1, "getUniqueId");
							break;
						}
						case LuaData_t::Player:
						case LuaData_t::Monster:
						case LuaData_t::Npc: {
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

	const uint32_t delay = std::max<uint32_t>(100, Lua::getNumber<uint32_t>(globalState, 2));
	lua_pop(globalState, 1);

	eventDesc.function = luaL_ref(globalState, LUA_REGISTRYINDEX);
	eventDesc.scriptId = Lua::getScriptEnv()->getScriptId();
	eventDesc.scriptName = Lua::getScriptEnv()->getScriptInterface()->getLoadingScriptName();

	auto &lastTimerEventId = g_luaEnvironment().lastEventTimerId;
	eventDesc.eventId = g_dispatcher().scheduleEvent(
		delay,
		[lastTimerEventId] { g_luaEnvironment().executeTimerEvent(lastTimerEventId); },
		"LuaEnvironment::executeTimerEvent"
	);

	g_luaEnvironment().timerEvents.try_emplace(lastTimerEventId, std::move(eventDesc));
	lua_pushnumber(L, lastTimerEventId++);
	return 1;
}

int GlobalFunctions::luaStopEvent(lua_State* L) {
	// stopEvent(eventid)
	lua_State* globalState = g_luaEnvironment().getLuaState();
	if (!globalState) {
		Lua::reportErrorFunc("No valid script interface!");
		Lua::pushBoolean(L, false);
		return 1;
	}

	const uint32_t eventId = Lua::getNumber<uint32_t>(L, 1);

	auto &timerEvents = g_luaEnvironment().timerEvents;
	const auto it = timerEvents.find(eventId);
	if (it == timerEvents.end()) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	const LuaTimerEventDesc timerEventDesc = std::move(it->second);
	timerEvents.erase(it);

	g_dispatcher().stopEvent(timerEventDesc.eventId);
	luaL_unref(globalState, LUA_REGISTRYINDEX, timerEventDesc.function);

	for (const auto parameter : timerEventDesc.parameters) {
		luaL_unref(globalState, LUA_REGISTRYINDEX, parameter);
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaSaveServer(lua_State* L) {
	g_globalEvents().save();
	g_saveManager().scheduleAll();
	Lua::pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaCleanMap(lua_State* L) {
	lua_pushnumber(L, g_game().map.clean());
	return 1;
}

int GlobalFunctions::luaDebugPrint(lua_State* L) {
	// debugPrint(text)
	Lua::reportErrorFunc(Lua::getString(L, -1));
	return 0;
}

int GlobalFunctions::luaIsInWar(lua_State* L) {
	// isInWar(cid, target)
	const auto &player = Lua::getPlayer(L, 1);
	if (!player) {
		Lua::reportErrorFunc(fmt::format("{} - Player", Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND)));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &targetPlayer = Lua::getPlayer(L, 2);
	if (!targetPlayer) {
		Lua::reportErrorFunc(fmt::format("{} - TargetPlayer", Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND)));
		Lua::pushBoolean(L, false);
		return 1;
	}

	Lua::pushBoolean(L, player->isInWar(targetPlayer));
	return 1;
}

int GlobalFunctions::luaGetWaypointPositionByName(lua_State* L) {
	// getWaypointPositionByName(name)
	auto &waypoints = g_game().map.waypoints;

	const auto it = waypoints.find(Lua::getString(L, -1));
	if (it != waypoints.end()) {
		Lua::pushPosition(L, it->second);
	} else {
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int GlobalFunctions::luaSendChannelMessage(lua_State* L) {
	// sendChannelMessage(channelId, type, message)
	const uint16_t channelId = Lua::getNumber<uint16_t>(L, 1);
	const auto &channel = g_chat().getChannelById(channelId);
	if (!channel) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	const SpeakClasses type = Lua::getNumber<SpeakClasses>(L, 2);
	const std::string message = Lua::getString(L, 3);
	channel->sendToAll(message, type);
	Lua::pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaSendGuildChannelMessage(lua_State* L) {
	// sendGuildChannelMessage(guildId, type, message)
	const uint32_t guildId = Lua::getNumber<uint32_t>(L, 1);
	const auto &channel = g_chat().getGuildChannelById(guildId);
	if (!channel) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	const SpeakClasses type = Lua::getNumber<SpeakClasses>(L, 2);
	const std::string message = Lua::getString(L, 3);
	channel->sendToAll(message, type);
	Lua::pushBoolean(L, true);
	return 1;
}

int GlobalFunctions::luaIsType(lua_State* L) {
	// isType(derived, base)
	lua_getmetatable(L, -2);
	lua_getmetatable(L, -2);

	lua_rawgeti(L, -2, 'p');
	const uint_fast8_t parentsB = Lua::getNumber<uint_fast8_t>(L, 1);

	lua_rawgeti(L, -3, 'h');
	const size_t hashB = Lua::getNumber<size_t>(L, 1);

	lua_rawgeti(L, -3, 'p');
	const uint_fast8_t parentsA = Lua::getNumber<uint_fast8_t>(L, 1);
	for (uint_fast8_t i = parentsA; i < parentsB; ++i) {
		lua_getfield(L, -3, "__index");
		lua_replace(L, -4);
	}

	lua_rawgeti(L, -4, 'h');
	const size_t hashA = Lua::getNumber<size_t>(L, 1);

	Lua::pushBoolean(L, hashA == hashB);
	return 1;
}

int GlobalFunctions::luaRawGetMetatable(lua_State* L) {
	// rawgetmetatable(metatableName)
	luaL_getmetatable(L, Lua::getString(L, 1).c_str());
	return 1;
}

int GlobalFunctions::luaCreateTable(lua_State* L) {
	// createTable(arrayLength, keyLength)
	lua_createtable(L, Lua::getNumber<int32_t>(L, 1), Lua::getNumber<int32_t>(L, 2));
	return 1;
}

int GlobalFunctions::luaSystemTime(lua_State* L) {
	// systemTime()
	lua_pushnumber(L, OTSYS_TIME());
	return 1;
}

int GlobalFunctions::luaGetFormattedTimeRemaining(lua_State* L) {
	// getFormattedTimeRemaining(time)
	const time_t time = Lua::getNumber<uint32_t>(L, 1);
	lua_pushstring(L, getFormattedTimeRemaining(time).c_str());
	return 1;
}

int GlobalFunctions::luaReportError(lua_State* L) {
	// reportError(errorDescription)
	const auto errorDescription = Lua::getString(L, 1);
	Lua::reportError(__func__, errorDescription, true);
	return 1;
}

bool GlobalFunctions::getArea(lua_State* L, std::list<uint32_t> &list, uint32_t &rows) {
	lua_pushnil(L);
	for (rows = 0; lua_next(L, -2) != 0; ++rows) {
		if (!Lua::isTable(L, -1)) {
			return false;
		}

		lua_pushnil(L);
		while (lua_next(L, -2) != 0) {
			if (!Lua::isNumber(L, -1)) {
				return false;
			}
			list.push_back(Lua::getNumber<uint32_t>(L, -1));
			lua_pop(L, 1);
		}

		lua_pop(L, 1);
	}

	lua_pop(L, 1);
	return (rows != 0);
}
