/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/combat/condition.hpp"
#include "game/game.hpp"
#include "lua/functions/creatures/combat/condition_functions.hpp"

int ConditionFunctions::luaConditionCreate(lua_State* L) {
	// Condition(conditionType[, conditionId = CONDITIONID_COMBAT[, subid = 0]])
	ConditionType_t conditionType = getNumber<ConditionType_t>(L, 2);
	ConditionId_t conditionId = getNumber<ConditionId_t>(L, 3, CONDITIONID_COMBAT);
	uint32_t subId = getNumber<uint32_t>(L, 4, 0);

	std::shared_ptr<Condition> condition = Condition::createCondition(conditionId, conditionType, 0, 0, false, subId);
	if (condition) {
		pushUserdata<Condition>(L, condition);
		setMetatable(L, -1, "Condition");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionDelete(lua_State* L) {
	// condition:delete()
	std::shared_ptr<Condition>* conditionPtr = getRawUserDataShared<Condition>(L, 1);
	if (conditionPtr && *conditionPtr) {
		conditionPtr->reset();
	}
	return 0;
}

int ConditionFunctions::luaConditionGetId(lua_State* L) {
	// condition:getId()
	std::shared_ptr<Condition> condition = getUserdataShared<Condition>(L, 1);
	if (condition) {
		lua_pushnumber(L, condition->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionGetSubId(lua_State* L) {
	// condition:getSubId()
	std::shared_ptr<Condition> condition = getUserdataShared<Condition>(L, 1);
	if (condition) {
		lua_pushnumber(L, condition->getSubId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionGetType(lua_State* L) {
	// condition:getType()
	std::shared_ptr<Condition> condition = getUserdataShared<Condition>(L, 1);
	if (condition) {
		lua_pushnumber(L, condition->getType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionGetIcons(lua_State* L) {
	// condition:getIcons()
	std::shared_ptr<Condition> condition = getUserdataShared<Condition>(L, 1);
	if (condition) {
		lua_pushnumber(L, condition->getIcons());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionGetEndTime(lua_State* L) {
	// condition:getEndTime()
	std::shared_ptr<Condition> condition = getUserdataShared<Condition>(L, 1);
	if (condition) {
		lua_pushnumber(L, condition->getEndTime());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionClone(lua_State* L) {
	// condition:clone()
	std::shared_ptr<Condition> condition = getUserdataShared<Condition>(L, 1);
	if (condition) {
		pushUserdata<Condition>(L, condition->clone());
		setMetatable(L, -1, "Condition");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionGetTicks(lua_State* L) {
	// condition:getTicks()
	std::shared_ptr<Condition> condition = getUserdataShared<Condition>(L, 1);
	if (condition) {
		lua_pushnumber(L, condition->getTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionSetTicks(lua_State* L) {
	// condition:setTicks(ticks)
	int32_t ticks = getNumber<int32_t>(L, 2);
	std::shared_ptr<Condition> condition = getUserdataShared<Condition>(L, 1);
	if (condition) {
		condition->setTicks(ticks);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionSetParameter(lua_State* L) {
	// condition:setParameter(key, value)
	std::shared_ptr<Condition> condition = getUserdataShared<Condition>(L, 1);
	if (!condition) {
		lua_pushnil(L);
		return 1;
	}

	ConditionParam_t key = getNumber<ConditionParam_t>(L, 2);
	int32_t value;
	if (isBoolean(L, 3)) {
		value = getBoolean(L, 3) ? 1 : 0;
	} else {
		value = getNumber<int32_t>(L, 3);
	}
	condition->setParam(key, value);
	pushBoolean(L, true);
	return 1;
}

int ConditionFunctions::luaConditionSetFormula(lua_State* L) {
	// condition:setFormula(mina, minb, maxa, maxb)
	double maxb = getNumber<double>(L, 5);
	double maxa = getNumber<double>(L, 4);
	double minb = getNumber<double>(L, 3);
	double mina = getNumber<double>(L, 2);
	std::shared_ptr<ConditionSpeed> condition = getUserdataShared<Condition>(L, 1)->dynamic_self_cast<ConditionSpeed>();
	if (condition) {
		condition->setFormulaVars(mina, minb, maxa, maxb);
		pushBoolean(L, true);
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
	if (isTable(L, 2)) {
		outfit = getOutfit(L, 2);
	} else {
		outfit.lookFamiliarsType = getNumber<uint16_t>(L, 14, outfit.lookFamiliarsType);
		outfit.lookMountFeet = getNumber<uint8_t>(L, 13, outfit.lookMountFeet);
		outfit.lookMountLegs = getNumber<uint8_t>(L, 12, outfit.lookMountLegs);
		outfit.lookMountBody = getNumber<uint8_t>(L, 11, outfit.lookMountBody);
		outfit.lookMountHead = getNumber<uint8_t>(L, 10, outfit.lookMountHead);
		outfit.lookMount = getNumber<uint16_t>(L, 9, outfit.lookMount);
		outfit.lookAddons = getNumber<uint8_t>(L, 8, outfit.lookAddons);
		outfit.lookFeet = getNumber<uint8_t>(L, 7);
		outfit.lookLegs = getNumber<uint8_t>(L, 6);
		outfit.lookBody = getNumber<uint8_t>(L, 5);
		outfit.lookHead = getNumber<uint8_t>(L, 4);
		outfit.lookType = getNumber<uint16_t>(L, 3);
		outfit.lookTypeEx = getNumber<uint16_t>(L, 2);
	}

	std::shared_ptr<ConditionOutfit> condition = getUserdataShared<Condition>(L, 1)->dynamic_self_cast<ConditionOutfit>();
	if (condition) {
		condition->setOutfit(outfit);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ConditionFunctions::luaConditionAddDamage(lua_State* L) {
	// condition:addDamage(rounds, time, value)
	int32_t value = getNumber<int32_t>(L, 4);
	int32_t time = getNumber<int32_t>(L, 3);
	int32_t rounds = getNumber<int32_t>(L, 2);
	std::shared_ptr<ConditionDamage> condition = getUserdataShared<Condition>(L, 1)->dynamic_self_cast<ConditionDamage>();
	if (condition) {
		pushBoolean(L, condition->addDamage(rounds, time, value));
	} else {
		lua_pushnil(L);
	}
	return 1;
}
