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

#include "creatures/players/vocations/vocation.h"
#include "lua/functions/creatures/player/vocation_functions.hpp"

int VocationFunctions::luaVocationCreate(lua_State* L) {
	// Vocation(id or name)
	uint16_t vocationId;
	if (isNumber(L, 2)) {
		vocationId = getNumber<uint16_t>(L, 2);
	} else {
		vocationId = g_vocations().getVocationId(getString(L, 2));
	}

	Vocation* vocation = g_vocations().getVocation(vocationId);
	if (vocation) {
		pushUserdata<Vocation>(L, vocation);
		setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetId(lua_State* L) {
	// vocation:getId()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetClientId(lua_State* L) {
	// vocation:getClientId()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getClientId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetBaseId(lua_State* L) {
	// vocation:getBaseId()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getBaseId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetName(lua_State* L) {
	// vocation:getName()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		pushString(L, vocation->getVocName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetDescription(lua_State* L) {
	// vocation:getDescription()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		pushString(L, vocation->getVocDescription());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetRequiredSkillTries(lua_State* L) {
	// vocation:getRequiredSkillTries(skillType, skillLevel)
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		skills_t skillType = getNumber<skills_t>(L, 2);
		uint16_t skillLevel = getNumber<uint16_t>(L, 3);
		lua_pushnumber(L, vocation->getReqSkillTries(skillType, skillLevel));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetRequiredManaSpent(lua_State* L) {
	// vocation:getRequiredManaSpent(magicLevel)
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		uint32_t magicLevel = getNumber<uint32_t>(L, 2);
		lua_pushnumber(L, vocation->getReqMana(magicLevel));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetCapacityGain(lua_State* L) {
	// vocation:getCapacityGain()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getCapGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetHealthGain(lua_State* L) {
	// vocation:getHealthGain()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getHPGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetHealthGainTicks(lua_State* L) {
	// vocation:getHealthGainTicks()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getHealthGainTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetHealthGainAmount(lua_State* L) {
	// vocation:getHealthGainAmount()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getHealthGainAmount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetManaGain(lua_State* L) {
	// vocation:getManaGain()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getManaGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetManaGainTicks(lua_State* L) {
	// vocation:getManaGainTicks()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getManaGainTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetManaGainAmount(lua_State* L) {
	// vocation:getManaGainAmount()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getManaGainAmount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetMaxSoul(lua_State* L) {
	// vocation:getMaxSoul()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getSoulMax());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetSoulGainTicks(lua_State* L) {
	// vocation:getSoulGainTicks()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getSoulGainTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetBaseAttackSpeed(lua_State* L) {
	// vocation:getBaseAttackSpeed()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getBaseAttackSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetAttackSpeed(lua_State* L) {
	// vocation:getAttackSpeed()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getAttackSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetBaseSpeed(lua_State* L) {
	// vocation:getBaseSpeed()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getBaseSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetDemotion(lua_State* L) {
	// vocation:getDemotion()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (!vocation) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t fromId = vocation->getFromVocation();
	if (fromId == VOCATION_NONE) {
		lua_pushnil(L);
		return 1;
	}

	Vocation* demotedVocation = g_vocations().getVocation(fromId);
	if (demotedVocation && demotedVocation != vocation) {
		pushUserdata<Vocation>(L, demotedVocation);
		setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int VocationFunctions::luaVocationGetPromotion(lua_State* L) {
	// vocation:getPromotion()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (!vocation) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t promotedId = g_vocations().getPromotedVocation(vocation->getId());
	if (promotedId == VOCATION_NONE) {
		lua_pushnil(L);
		return 1;
	}

	Vocation* promotedVocation = g_vocations().getVocation(promotedId);
	if (promotedVocation && promotedVocation != vocation) {
		pushUserdata<Vocation>(L, promotedVocation);
		setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}
