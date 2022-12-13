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

#include "game/game.h"
#include "io/iobestiary.h"
#include "lua/functions/creatures/monster/charm_functions.hpp"

int CharmFunctions::luaCharmCreate(lua_State* L) {
	// charm(id)
	if (isNumber(L, 2)) {
		charmRune_t charmid = getNumber<charmRune_t>(L, 2);
		std::vector<Charm*> charmList = g_game().getCharmList();
		for (auto& it : charmList) {
			Charm* charm = it;
			if (charm->id == charmid) {
				pushUserdata<Charm>(L, charm);
				setMetatable(L, -1, "Charm");
				pushBoolean(L, true);
			}
		}
	}

	lua_pushnil(L);
	return 1;
}

int CharmFunctions::luaCharmName(lua_State* L) {
	// get: charm:name() set: charm:name(string)
	Charm* charm = getUserdata<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		pushString(L, charm->name);
	} else {
		charm->name = getString(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmDescription(lua_State* L) {
	// get: charm:description() set: charm:description(string)
	Charm* charm = getUserdata<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		pushString(L, charm->description);
	} else {
		charm->description = getString(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmType(lua_State* L) {
	// get: charm:type() set: charm:type(charm_t)
	Charm* charm = getUserdata<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->type);
	} else {
		charm->type = getNumber<charm_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmPoints(lua_State* L) {
	// get: charm:points() set: charm:points(value)
	Charm* charm = getUserdata<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->points);
	} else {
		charm->points = getNumber<int16_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmDamageType(lua_State* L) {
	// get: charm:damageType() set: charm:damageType(type)
	Charm* charm = getUserdata<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->dmgtype);
	} else {
		charm->dmgtype = getNumber<CombatType_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmPercentage(lua_State* L) {
	// get: charm:percentage() set: charm:percentage(value)
	Charm* charm = getUserdata<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->percent);
	} else {
		charm->percent = getNumber<int8_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmChance(lua_State* L) {
	// get: charm:chance() set: charm:chance(value)
	Charm* charm = getUserdata<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->chance);
	} else {
		charm->chance = getNumber<int8_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmMessageCancel(lua_State* L) {
	// get: charm:messageCancel() set: charm:messageCancel(string)
	Charm* charm = getUserdata<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		pushString(L, charm->cancelMsg);
	} else {
		charm->cancelMsg = getString(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmMessageServerLog(lua_State* L) {
	// get: charm:messageServerLog() set: charm:messageServerLog(string)
	Charm* charm = getUserdata<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		pushString(L, charm->logMsg);
	} else {
		charm->logMsg = getString(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmEffect(lua_State* L) {
	// get: charm:effect() set: charm:effect(value)
	Charm* charm = getUserdata<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->effect);
	} else {
		charm->effect = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmCastSound(lua_State* L) {
	// get: charm:castSound() set: charm:castSound(sound)
	Charm* charm = getUserdata<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->soundCastEffect);
	} else {
		charm->soundCastEffect = getNumber<SoundEffect_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmImpactSound(lua_State* L) {
	// get: charm:impactSound() set: charm:impactSound(sound)
	Charm* charm = getUserdata<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->soundImpactEffect);
	} else {
		charm->soundImpactEffect = getNumber<SoundEffect_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}
