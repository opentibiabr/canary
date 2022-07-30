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

#include "creatures/combat/combat.h"
#include "game/game.h"
#include "lua/functions/creatures/combat/combat_functions.hpp"
#include "lua/scripts/lua_environment.hpp"

int CombatFunctions::luaCombatCreate(lua_State* L) {
	// Combat()
	pushUserdata<Combat>(L, g_luaEnvironment.createCombatObject(getScriptEnv()->getScriptInterface()));
	setMetatable(L, -1, "Combat");
	return 1;
}

int CombatFunctions::luaCombatSetParameter(lua_State* L) {
	// combat:setParameter(key, value)
	Combat* combat = getUserdata<Combat>(L, 1);
	if (!combat) {
		lua_pushnil(L);
		return 1;
	}

	CombatParam_t key = getNumber<CombatParam_t>(L, 2);
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
	Combat* combat = getUserdata<Combat>(L, 1);
	if (!combat) {
		lua_pushnil(L);
		return 1;
	}

	formulaType_t type = getNumber<formulaType_t>(L, 2);
	double mina = getNumber<double>(L, 3);
	double minb = getNumber<double>(L, 4);
	double maxa = getNumber<double>(L, 5);
	double maxb = getNumber<double>(L, 6);
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

	const AreaCombat* area = g_luaEnvironment.getAreaObject(getNumber<uint32_t>(L, 2));
	if (!area) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	Combat* combat = getUserdata<Combat>(L, 1);
	if (combat) {
		combat->setArea(new AreaCombat(*area));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CombatFunctions::luaCombatSetCondition(lua_State* L) {
	// combat:addCondition(condition)
	Condition* condition = getUserdata<Condition>(L, 2);
	Combat* combat = getUserdata<Combat>(L, 1);
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
	Combat* combat = getUserdata<Combat>(L, 1);
	if (!combat) {
		lua_pushnil(L);
		return 1;
	}

	CallBackParam_t key = getNumber<CallBackParam_t>(L, 2);
	if (!combat->setCallback(key)) {
		lua_pushnil(L);
		return 1;
	}

	CallBack* callback = combat->getCallback(key);
	if (!callback) {
		lua_pushnil(L);
		return 1;
	}

	const std::string& function = getString(L, 3);
	pushBoolean(L, callback->loadCallBack(getScriptEnv()->getScriptInterface(), function));
	return 1;
}

int CombatFunctions::luaCombatSetOrigin(lua_State* L) {
	// combat:setOrigin(origin)
	Combat* combat = getUserdata<Combat>(L, 1);
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
	Combat* combat = getUserdata<Combat>(L, 1);
	if (!combat) {
		pushBoolean(L, false);
		return 1;
	}

	if (isUserdata(L, 2)) {
		LuaDataType type = getUserdataType(L, 2);
		if (type != LuaData_Player && type != LuaData_Monster && type != LuaData_Npc) {
			pushBoolean(L, false);
			return 1;
		}
	}

	Creature* creature = getCreature(L, 2);

	const LuaVariant& variant = getVariant(L, 3);
	switch (variant.type) {
		case VARIANT_NUMBER: {
			Creature* target = g_game().getCreatureByID(variant.number);
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
			combat->doCombat(creature, variant.pos);
			break;
		}

		case VARIANT_TARGETPOSITION: {
			if (combat->hasArea()) {
				combat->doCombat(creature, variant.pos);
			} else {
				combat->postCombatEffects(creature, variant.pos);
				g_game().addMagicEffect(variant.pos, CONST_ME_POFF);
			}
			break;
		}

		case VARIANT_STRING: {
			Player* target = g_game().getPlayerByName(variant.text);
			if (!target) {
				pushBoolean(L, false);
				return 1;
			}

			combat->doCombat(creature, target);
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

	pushBoolean(L, true);
	return 1;
}
