/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/combat/combat_functions.hpp"

#include "creatures/creature.hpp"
#include "creatures/combat/combat.hpp"
#include "creatures/combat/condition.hpp"
#include "game/game.hpp"
#include "lua/global/lua_variant.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "creatures/players/player.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void CombatFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Combat", "", CombatFunctions::luaCombatCreate);
	Lua::registerMetaMethod(L, "Combat", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Combat", "setParameter", CombatFunctions::luaCombatSetParameter);
	Lua::registerMethod(L, "Combat", "setFormula", CombatFunctions::luaCombatSetFormula);

	Lua::registerMethod(L, "Combat", "setArea", CombatFunctions::luaCombatSetArea);
	Lua::registerMethod(L, "Combat", "addCondition", CombatFunctions::luaCombatSetCondition);
	Lua::registerMethod(L, "Combat", "setCallback", CombatFunctions::luaCombatSetCallback);
	Lua::registerMethod(L, "Combat", "setOrigin", CombatFunctions::luaCombatSetOrigin);

	Lua::registerMethod(L, "Combat", "execute", CombatFunctions::luaCombatExecute);

	ConditionFunctions::init(L);
	SpellFunctions::init(L);
	VariantFunctions::init(L);
}

int CombatFunctions::luaCombatCreate(lua_State* L) {
	// Combat()
	auto combat = std::make_shared<Combat>();
	Lua::pushUserdata<Combat>(L, combat);
	Lua::setMetatable(L, -1, "Combat");
	return 1;
}

int CombatFunctions::luaCombatSetParameter(lua_State* L) {
	// combat:setParameter(key, value)
	const auto &combat = Lua::getUserdataShared<Combat>(L, 1, "Combat");
	if (!combat) {
		lua_pushnil(L);
		return 1;
	}

	const CombatParam_t key = Lua::getNumber<CombatParam_t>(L, 2);
	uint32_t value;
	if (Lua::isBoolean(L, 3)) {
		value = Lua::getBoolean(L, 3) ? 1 : 0;
	} else {
		value = Lua::getNumber<uint32_t>(L, 3);
	}
	combat->setParam(key, value);
	Lua::pushBoolean(L, true);
	return 1;
}

int CombatFunctions::luaCombatSetFormula(lua_State* L) {
	// combat:setFormula(type, mina, minb, maxa, maxb)
	const auto &combat = Lua::getUserdataShared<Combat>(L, 1, "Combat");
	if (!combat) {
		lua_pushnil(L);
		return 1;
	}

	const formulaType_t type = Lua::getNumber<formulaType_t>(L, 2);
	const double mina = Lua::getNumber<double>(L, 3);
	const double minb = Lua::getNumber<double>(L, 4);
	const double maxa = Lua::getNumber<double>(L, 5);
	const double maxb = Lua::getNumber<double>(L, 6);
	combat->setPlayerCombatValues(type, mina, minb, maxa, maxb);
	Lua::pushBoolean(L, true);
	return 1;
}

int CombatFunctions::luaCombatSetArea(lua_State* L) {
	// combat:setArea(area)
	if (Lua::getScriptEnv()->getScriptId() != EVENT_ID_LOADING) {
		Lua::reportErrorFunc("This function can only be used while loading the script.");
		lua_pushnil(L);
		return 1;
	}

	const std::unique_ptr<AreaCombat> &area = g_luaEnvironment().getAreaObject(Lua::getNumber<uint32_t>(L, 2));
	if (!area) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const auto &combat = Lua::getUserdataShared<Combat>(L, 1, "Combat");
	if (combat) {
		auto areaClone = area->clone();
		combat->setArea(areaClone);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CombatFunctions::luaCombatSetCondition(lua_State* L) {
	// combat:addCondition(condition)
	const std::shared_ptr<Condition> &condition = Lua::getUserdataShared<Condition>(L, 2, "Condition");
	auto* combat = Lua::getUserdata<Combat>(L, 1);
	if (combat && condition) {
		combat->addCondition(condition->clone());
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CombatFunctions::luaCombatSetCallback(lua_State* L) {
	// combat:setCallback(key, function)
	const auto &combat = Lua::getUserdataShared<Combat>(L, 1, "Combat");
	if (!combat) {
		lua_pushnil(L);
		return 1;
	}

	const CallBackParam_t key = Lua::getNumber<CallBackParam_t>(L, 2);
	if (!combat->setCallback(key)) {
		lua_pushnil(L);
		return 1;
	}

	CallBack* callback = combat->getCallback(key);
	if (!callback) {
		lua_pushnil(L);
		return 1;
	}

	const std::string &function = Lua::getString(L, 3);
	Lua::pushBoolean(L, callback->loadCallBack(Lua::getScriptEnv()->getScriptInterface(), function));
	return 1;
}

int CombatFunctions::luaCombatSetOrigin(lua_State* L) {
	// combat:setOrigin(origin)
	const auto &combat = Lua::getUserdataShared<Combat>(L, 1, "Combat");
	if (combat) {
		combat->setOrigin(Lua::getNumber<CombatOrigin>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CombatFunctions::luaCombatExecute(lua_State* L) {
	// combat:execute(creature, variant)
	const auto &combat = Lua::getUserdataShared<Combat>(L, 1, "Combat");
	if (!combat) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (Lua::isUserdata(L, 2)) {
		using enum LuaData_t;
		const LuaData_t type = Lua::getUserdataType(L, 2);
		if (type != Player && type != Monster && type != Npc) {
			Lua::pushBoolean(L, false);
			return 1;
		}
	}

	const auto &creature = Lua::getCreature(L, 2);
	if (!creature) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	const LuaVariant &variant = Lua::getVariant(L, 3);
	combat->setInstantSpellName(variant.instantName);
	combat->setRuneSpellName(variant.runeName);
	bool result = true;
	switch (variant.type) {
		case VARIANT_NUMBER: {
			const std::shared_ptr<Creature> &target = g_game().getCreatureByID(variant.number);
			if (!target) {
				Lua::pushBoolean(L, false);
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
				Lua::pushBoolean(L, false);
				return 1;
			}

			result = combat->doCombat(creature, target);
			break;
		}

		case VARIANT_NONE: {
			Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_VARIANT_NOT_FOUND));
			Lua::pushBoolean(L, false);
			return 1;
		}

		default: {
			break;
		}
	}

	Lua::pushBoolean(L, result);
	return 1;
}
