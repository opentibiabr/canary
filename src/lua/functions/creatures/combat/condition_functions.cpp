/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/combat/condition_functions.hpp"

#include "creatures/combat/condition.hpp"
#include "enums/player_icons.hpp"
#include "game/game.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void ConditionFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Condition", "", ConditionFunctions::luaConditionCreate);
	Lua::registerMetaMethod(L, "Condition", "__eq", Lua::luaUserdataCompare);
	Lua::registerMetaMethod(L, "Condition", "__gc", ConditionFunctions::luaConditionDelete);
	Lua::registerMethod(L, "Condition", "delete", ConditionFunctions::luaConditionDelete);

	Lua::registerMethod(L, "Condition", "getId", ConditionFunctions::luaConditionGetId);
	Lua::registerMethod(L, "Condition", "getSubId", ConditionFunctions::luaConditionGetSubId);
	Lua::registerMethod(L, "Condition", "getType", ConditionFunctions::luaConditionGetType);
	Lua::registerMethod(L, "Condition", "getIcons", ConditionFunctions::luaConditionGetIcons);
	Lua::registerMethod(L, "Condition", "getEndTime", ConditionFunctions::luaConditionGetEndTime);

	Lua::registerMethod(L, "Condition", "clone", ConditionFunctions::luaConditionClone);

	Lua::registerMethod(L, "Condition", "getTicks", ConditionFunctions::luaConditionGetTicks);
	Lua::registerMethod(L, "Condition", "setTicks", ConditionFunctions::luaConditionSetTicks);

	Lua::registerMethod(L, "Condition", "setParameter", ConditionFunctions::luaConditionSetParameter);
	Lua::registerMethod(L, "Condition", "setFormula", ConditionFunctions::luaConditionSetFormula);
	Lua::registerMethod(L, "Condition", "setOutfit", ConditionFunctions::luaConditionSetOutfit);

	Lua::registerMethod(L, "Condition", "addDamage", ConditionFunctions::luaConditionAddDamage);
}

int ConditionFunctions::luaConditionCreate(lua_State* L) {
	// Condition(conditionType, conditionId = CONDITIONID_COMBAT, subid = 0, isPersistent = false)
	const ConditionType_t conditionType = Lua::getNumber<ConditionType_t>(L, 2);
	if (conditionType == CONDITION_NONE) {
		Lua::reportErrorFunc("Invalid condition type");
		return 1;
	}

	const auto conditionId = Lua::getNumber<ConditionId_t>(L, 3, CONDITIONID_COMBAT);
	const auto subId = Lua::getNumber<uint32_t>(L, 4, 0);
	const bool isPersistent = Lua::getBoolean(L, 5, false);

	const auto &condition = Condition::createCondition(conditionId, conditionType, 0, 0, false, subId, isPersistent);
	if (condition) {
		Lua::pushUserdata<Condition>(L, condition);
		Lua::setMetatable(L, -1, "Condition");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionDelete(lua_State* L) {
	// condition:delete()
	std::shared_ptr<Condition>* conditionPtr = Lua::getRawUserDataShared<Condition>(L, 1);
	if (conditionPtr && *conditionPtr) {
		conditionPtr->reset();
	}
	return 0;
}

int ConditionFunctions::luaConditionGetId(lua_State* L) {
	// condition:getId()
	const auto &condition = Lua::getUserdataShared<Condition>(L, 1, "Condition");
	if (condition) {
		lua_pushnumber(L, condition->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionGetSubId(lua_State* L) {
	// condition:getSubId()
	const auto &condition = Lua::getUserdataShared<Condition>(L, 1, "Condition");
	if (condition) {
		lua_pushnumber(L, condition->getSubId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionGetType(lua_State* L) {
	// condition:getType()
	const auto &condition = Lua::getUserdataShared<Condition>(L, 1, "Condition");
	if (condition) {
		lua_pushnumber(L, condition->getType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionGetIcons(lua_State* L) {
	// condition:getIcons()
	const auto &condition = Lua::getUserdataShared<Condition>(L, 1, "Condition");
	if (condition) {
		const auto icons = condition->getIcons();
		lua_newtable(L); // Creates a new table on the Lua stack
		int index = 1;
		for (const auto &icon : icons) {
			lua_pushstring(L, magic_enum::enum_name(icon).data()); // Converts the enum to a string
			lua_rawseti(L, -2, index++); // Inserts into the Lua table array
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionGetEndTime(lua_State* L) {
	// condition:getEndTime()
	const auto &condition = Lua::getUserdataShared<Condition>(L, 1, "Condition");
	if (condition) {
		lua_pushnumber(L, condition->getEndTime());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionClone(lua_State* L) {
	// condition:clone()
	const auto &condition = Lua::getUserdataShared<Condition>(L, 1, "Condition");
	if (condition) {
		Lua::pushUserdata<Condition>(L, condition->clone());
		Lua::setMetatable(L, -1, "Condition");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionGetTicks(lua_State* L) {
	// condition:getTicks()
	const auto &condition = Lua::getUserdataShared<Condition>(L, 1, "Condition");
	if (condition) {
		lua_pushnumber(L, condition->getTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionSetTicks(lua_State* L) {
	// condition:setTicks(ticks)
	const int32_t ticks = Lua::getNumber<int32_t>(L, 2);
	const auto &condition = Lua::getUserdataShared<Condition>(L, 1, "Condition");
	if (condition) {
		condition->setTicks(ticks);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionSetParameter(lua_State* L) {
	// condition:setParameter(key, value)
	const auto &condition = Lua::getUserdataShared<Condition>(L, 1, "Condition");
	if (!condition) {
		lua_pushnil(L);
		return 1;
	}

	const ConditionParam_t key = Lua::getNumber<ConditionParam_t>(L, 2);
	int32_t value;
	if (Lua::isBoolean(L, 3)) {
		value = Lua::getBoolean(L, 3) ? 1 : 0;
	} else {
		value = Lua::getNumber<int32_t>(L, 3);
	}
	condition->setParam(key, value);
	Lua::pushBoolean(L, true);
	return 1;
}

int ConditionFunctions::luaConditionSetFormula(lua_State* L) {
	// condition:setFormula(mina, minb, maxa, maxb)
	const double maxb = Lua::getNumber<double>(L, 5);
	const double maxa = Lua::getNumber<double>(L, 4);
	const double minb = Lua::getNumber<double>(L, 3);
	const double mina = Lua::getNumber<double>(L, 2);
	const std::shared_ptr<ConditionSpeed> &condition = Lua::getUserdataShared<Condition>(L, 1, "Condition")->dynamic_self_cast<ConditionSpeed>();
	if (condition) {
		condition->setFormulaVars(mina, minb, maxa, maxb);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionSetOutfit(lua_State* L) {
	// condition:setOutfit(outfit)
	// condition:setOutfit(lookTypeEx, lookType, lookHead, lookBody, lookLegs, lookFeet[,
	// lookAddons[, lookMount[, lookMountHead[, lookMountBody[, lookMountLegs[, lookMountFeet[, lookFamiliarsType]]]]]]])
	Outfit_t outfit;
	if (Lua::isTable(L, 2)) {
		outfit = Lua::getOutfit(L, 2);
	} else {
		outfit.lookFamiliarsType = Lua::getNumber<uint16_t>(L, 14, outfit.lookFamiliarsType);
		outfit.lookMountFeet = Lua::getNumber<uint8_t>(L, 13, outfit.lookMountFeet);
		outfit.lookMountLegs = Lua::getNumber<uint8_t>(L, 12, outfit.lookMountLegs);
		outfit.lookMountBody = Lua::getNumber<uint8_t>(L, 11, outfit.lookMountBody);
		outfit.lookMountHead = Lua::getNumber<uint8_t>(L, 10, outfit.lookMountHead);
		outfit.lookMount = Lua::getNumber<uint16_t>(L, 9, outfit.lookMount);
		outfit.lookAddons = Lua::getNumber<uint8_t>(L, 8, outfit.lookAddons);
		outfit.lookFeet = Lua::getNumber<uint8_t>(L, 7);
		outfit.lookLegs = Lua::getNumber<uint8_t>(L, 6);
		outfit.lookBody = Lua::getNumber<uint8_t>(L, 5);
		outfit.lookHead = Lua::getNumber<uint8_t>(L, 4);
		outfit.lookType = Lua::getNumber<uint16_t>(L, 3);
		outfit.lookTypeEx = Lua::getNumber<uint16_t>(L, 2);
	}

	const std::shared_ptr<ConditionOutfit> &condition = Lua::getUserdataShared<Condition>(L, 1, "Condition")->dynamic_self_cast<ConditionOutfit>();
	if (condition) {
		condition->setOutfit(outfit);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionAddDamage(lua_State* L) {
	// condition:addDamage(rounds, time, value)
	const int32_t value = Lua::getNumber<int32_t>(L, 4);
	const int32_t time = Lua::getNumber<int32_t>(L, 3);
	const int32_t rounds = Lua::getNumber<int32_t>(L, 2);
	const std::shared_ptr<ConditionDamage> &condition = Lua::getUserdataShared<Condition>(L, 1, "Condition")->dynamic_self_cast<ConditionDamage>();
	if (condition) {
		Lua::pushBoolean(L, condition->addDamage(rounds, time, value));
	} else {
		lua_pushnil(L);
	}
	return 1;
}
