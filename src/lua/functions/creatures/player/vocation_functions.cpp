/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/player/vocation_functions.hpp"

#include "creatures/players/vocations/vocation.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void VocationFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Vocation", "", VocationFunctions::luaVocationCreate);
	Lua::registerMetaMethod(L, "Vocation", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Vocation", "getId", VocationFunctions::luaVocationGetId);
	Lua::registerMethod(L, "Vocation", "getClientId", VocationFunctions::luaVocationGetClientId);
	Lua::registerMethod(L, "Vocation", "getBaseId", VocationFunctions::luaVocationGetBaseId);
	Lua::registerMethod(L, "Vocation", "getName", VocationFunctions::luaVocationGetName);
	Lua::registerMethod(L, "Vocation", "getDescription", VocationFunctions::luaVocationGetDescription);

	Lua::registerMethod(L, "Vocation", "getRequiredSkillTries", VocationFunctions::luaVocationGetRequiredSkillTries);
	Lua::registerMethod(L, "Vocation", "getRequiredManaSpent", VocationFunctions::luaVocationGetRequiredManaSpent);

	Lua::registerMethod(L, "Vocation", "getCapacityGain", VocationFunctions::luaVocationGetCapacityGain);

	Lua::registerMethod(L, "Vocation", "getHealthGain", VocationFunctions::luaVocationGetHealthGain);
	Lua::registerMethod(L, "Vocation", "getHealthGainTicks", VocationFunctions::luaVocationGetHealthGainTicks);
	Lua::registerMethod(L, "Vocation", "getHealthGainAmount", VocationFunctions::luaVocationGetHealthGainAmount);

	Lua::registerMethod(L, "Vocation", "getManaGain", VocationFunctions::luaVocationGetManaGain);
	Lua::registerMethod(L, "Vocation", "getManaGainTicks", VocationFunctions::luaVocationGetManaGainTicks);
	Lua::registerMethod(L, "Vocation", "getManaGainAmount", VocationFunctions::luaVocationGetManaGainAmount);

	Lua::registerMethod(L, "Vocation", "getMaxSoul", VocationFunctions::luaVocationGetMaxSoul);
	Lua::registerMethod(L, "Vocation", "getSoulGainTicks", VocationFunctions::luaVocationGetSoulGainTicks);

	Lua::registerMethod(L, "Vocation", "getBaseAttackSpeed", VocationFunctions::luaVocationGetBaseAttackSpeed);
	Lua::registerMethod(L, "Vocation", "getAttackSpeed", VocationFunctions::luaVocationGetAttackSpeed);
	Lua::registerMethod(L, "Vocation", "getBaseSpeed", VocationFunctions::luaVocationGetBaseSpeed);

	Lua::registerMethod(L, "Vocation", "getDemotion", VocationFunctions::luaVocationGetDemotion);
	Lua::registerMethod(L, "Vocation", "getPromotion", VocationFunctions::luaVocationGetPromotion);
}

int VocationFunctions::luaVocationCreate(lua_State* L) {
	// Vocation(id or name)
	uint16_t vocationId;
	if (Lua::isNumber(L, 2)) {
		vocationId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		vocationId = g_vocations().getVocationId(Lua::getString(L, 2));
	}

	const auto &vocation = g_vocations().getVocation(vocationId);
	if (vocation) {
		Lua::pushUserdata<Vocation>(L, vocation);
		Lua::setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetId(lua_State* L) {
	// vocation:getId()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetClientId(lua_State* L) {
	// vocation:getClientId()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getClientId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetBaseId(lua_State* L) {
	// vocation:getBaseId()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getBaseId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetName(lua_State* L) {
	// vocation:getName()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		Lua::pushString(L, vocation->getVocName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetDescription(lua_State* L) {
	// vocation:getDescription()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		Lua::pushString(L, vocation->getVocDescription());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetRequiredSkillTries(lua_State* L) {
	// vocation:getRequiredSkillTries(skillType, skillLevel)
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		const skills_t skillType = Lua::getNumber<skills_t>(L, 2);
		const uint16_t skillLevel = Lua::getNumber<uint16_t>(L, 3);
		lua_pushnumber(L, vocation->getReqSkillTries(skillType, skillLevel));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetRequiredManaSpent(lua_State* L) {
	// vocation:getRequiredManaSpent(magicLevel)
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		const uint32_t magicLevel = Lua::getNumber<uint32_t>(L, 2);
		lua_pushnumber(L, vocation->getReqMana(magicLevel));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetCapacityGain(lua_State* L) {
	// vocation:getCapacityGain()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getCapGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetHealthGain(lua_State* L) {
	// vocation:getHealthGain()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getHPGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetHealthGainTicks(lua_State* L) {
	// vocation:getHealthGainTicks()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getHealthGainTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetHealthGainAmount(lua_State* L) {
	// vocation:getHealthGainAmount()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getHealthGainAmount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetManaGain(lua_State* L) {
	// vocation:getManaGain()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getManaGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetManaGainTicks(lua_State* L) {
	// vocation:getManaGainTicks()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getManaGainTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetManaGainAmount(lua_State* L) {
	// vocation:getManaGainAmount()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getManaGainAmount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetMaxSoul(lua_State* L) {
	// vocation:getMaxSoul()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getSoulMax());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetSoulGainTicks(lua_State* L) {
	// vocation:getSoulGainTicks()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getSoulGainTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetBaseAttackSpeed(lua_State* L) {
	// vocation:getBaseAttackSpeed()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getBaseAttackSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetAttackSpeed(lua_State* L) {
	// vocation:getAttackSpeed()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getAttackSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetBaseSpeed(lua_State* L) {
	// vocation:getBaseSpeed()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getBaseSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetDemotion(lua_State* L) {
	// vocation:getDemotion()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (!vocation) {
		lua_pushnil(L);
		return 1;
	}

	const uint16_t fromId = vocation->getFromVocation();
	if (fromId == VOCATION_NONE) {
		lua_pushnil(L);
		return 1;
	}

	const auto &demotedVocation = g_vocations().getVocation(fromId);
	if (demotedVocation && demotedVocation != vocation) {
		Lua::pushUserdata<Vocation>(L, demotedVocation);
		Lua::setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetPromotion(lua_State* L) {
	// vocation:getPromotion()
	const auto &vocation = Lua::getUserdataShared<Vocation>(L, 1);
	if (!vocation) {
		lua_pushnil(L);
		return 1;
	}

	const uint16_t promotedId = g_vocations().getPromotedVocation(vocation->getId());
	if (promotedId == VOCATION_NONE) {
		lua_pushnil(L);
		return 1;
	}

	const auto &promotedVocation = g_vocations().getVocation(promotedId);
	if (promotedVocation && promotedVocation != vocation) {
		Lua::pushUserdata<Vocation>(L, promotedVocation);
		Lua::setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}
