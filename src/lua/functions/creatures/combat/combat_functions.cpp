/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/combat/combat_functions.hpp"

#include "creatures/combat/combat.hpp"
#include "creatures/combat/condition.hpp"
#include "game/game.hpp"
#include "lua/global/lua_variant.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "creatures/players/player.hpp"

int CombatFunctions::luaCombatCreate(lua_State* L) {
	// Combat()
	pushUserdata<Combat>(L, g_luaEnvironment().createCombatObject(getScriptEnv()->getScriptInterface()));
	setMetatable(L, -1, "Combat");
	return 1;
}

int CombatFunctions::luaCombatSetParameter(lua_State* L) {
	// combat:setParameter(key, value)
	const auto &combat = getUserdataShared<Combat>(L, 1);
	if (!combat) {
		lua_pushnil(L);
		return 1;
	}

	const CombatParam_t key = getNumber<CombatParam_t>(L, 2);
	uint32_t value;
	if (isBoolean(L, 3)) {
		value = getBoolean(L, 3) ? 1 : 0;
	} else {
		value = getNumber<uint32_t>(L, 3);
	}
	combat->setParam(key, value);
	pushBoolean(L, true);
	return 1;
}

int CombatFunctions::luaCombatSetFormula(lua_State* L) {
	// combat:setFormula(type, mina, minb, maxa, maxb)
	const auto &combat = getUserdataShared<Combat>(L, 1);
	if (!combat) {
		lua_pushnil(L);
		return 1;
	}

	const formulaType_t type = getNumber<formulaType_t>(L, 2);
	const double mina = getNumber<double>(L, 3);
	const double minb = getNumber<double>(L, 4);
	const double maxa = getNumber<double>(L, 5);
	const double maxb = getNumber<double>(L, 6);
	combat->setPlayerCombatValues(type, mina, minb, maxa, maxb);
	pushBoolean(L, true);
	return 1;
}

int CombatFunctions::luaCombatSetArea(lua_State* L) {
	// combat:setArea(area)
	if (getScriptEnv()->getScriptId() != EVENT_ID_LOADING) {
		reportErrorFunc("This function can only be used while loading the script.");
		lua_pushnil(L);
		return 1;
	}

	const std::unique_ptr<AreaCombat> &area = g_luaEnvironment().getAreaObject(getNumber<uint32_t>(L, 2));
	if (!area) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const auto &combat = getUserdataShared<Combat>(L, 1);
	if (combat) {
		auto areaClone = area->clone();
		combat->setArea(areaClone);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CombatFunctions::luaCombatSetCondition(lua_State* L) {
	// combat:addCondition(condition)
	const std::shared_ptr<Condition> &condition = getUserdataShared<Condition>(L, 2);
	auto* combat = getUserdata<Combat>(L, 1);
	if (combat && condition) {
		combat->addCondition(condition->clone());
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CombatFunctions::luaCombatSetCallback(lua_State* L) {
	// combat:setCallback(key, function)
	const auto &combat = getUserdataShared<Combat>(L, 1);
	if (!combat) {
		lua_pushnil(L);
		return 1;
	}

	const CallBackParam_t key = getNumber<CallBackParam_t>(L, 2);
	if (!combat->setCallback(key)) {
		lua_pushnil(L);
		return 1;
	}

	CallBack* callback = combat->getCallback(key);
	if (!callback) {
		lua_pushnil(L);
		return 1;
	}

	const std::string &function = getString(L, 3);
	pushBoolean(L, callback->loadCallBack(getScriptEnv()->getScriptInterface(), function));
	return 1;
}

int CombatFunctions::luaCombatSetOrigin(lua_State* L) {
	// combat:setOrigin(origin)
	const auto &combat = getUserdataShared<Combat>(L, 1);
	if (combat) {
		combat->setOrigin(getNumber<CombatOrigin>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CombatFunctions::luaCombatExecute(lua_State* L) {
	// combat:execute(creature, variant)
	const auto &combat = getUserdataShared<Combat>(L, 1);
	if (!combat) {
		pushBoolean(L, false);
		return 1;
	}

	if (isUserdata(L, 2)) {
		const LuaData_t type = getUserdataType(L, 2);
		if (type != LuaData_t::Player && type != LuaData_t::Monster && type != LuaData_t::Npc) {
			pushBoolean(L, false);
			return 1;
		}
	}

	const auto &creature = getCreature(L, 2);
	if (!creature) {
		pushBoolean(L, false);
		return 1;
	}

	const LuaVariant &variant = getVariant(L, 3);
	combat->setInstantSpellName(variant.instantName);
	combat->setRuneSpellName(variant.runeName);
	bool result = true;
	switch (variant.type) {
		case VARIANT_NUMBER: {
			const std::shared_ptr<Creature> &target = g_game().getCreatureByID(variant.number);
			if (!target) {
				pushBoolean(L, false);
				return 1;
			}

			if (combat->hasArea()) {
				combat->doCombat(creature, target->getPosition());
			} else {
				combat->doCombat(creature, target);
			}
			break;
		}

		case VARIANT_POSITION: {
			result = combat->doCombat(creature, variant.pos);
			break;
		}

		case VARIANT_TARGETPOSITION: {
			if (combat->hasArea()) {
				result = combat->doCombat(creature, variant.pos);
			} else {
				combat->postCombatEffects(creature, creature->getPosition(), variant.pos);
				g_game().addMagicEffect(variant.pos, CONST_ME_POFF);
			}
			break;
		}

		case VARIANT_STRING: {
			const std::shared_ptr<Player> &target = g_game().getPlayerByName(variant.text);
			if (!target) {
				pushBoolean(L, false);
				return 1;
			}

			result = combat->doCombat(creature, target);
			break;
		}

		case VARIANT_NONE: {
			reportErrorFunc(getErrorDesc(LUA_ERROR_VARIANT_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		default: {
			break;
		}
	}

	pushBoolean(L, result);
	return 1;
}
