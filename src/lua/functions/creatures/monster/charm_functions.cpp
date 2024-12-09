/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/monster/charm_functions.hpp"

#include "game/game.hpp"
#include "io/iobestiary.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void CharmFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Charm", "", CharmFunctions::luaCharmCreate);
	Lua::registerMetaMethod(L, "Charm", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Charm", "name", CharmFunctions::luaCharmName);
	Lua::registerMethod(L, "Charm", "description", CharmFunctions::luaCharmDescription);
	Lua::registerMethod(L, "Charm", "type", CharmFunctions::luaCharmType);
	Lua::registerMethod(L, "Charm", "points", CharmFunctions::luaCharmPoints);
	Lua::registerMethod(L, "Charm", "damageType", CharmFunctions::luaCharmDamageType);
	Lua::registerMethod(L, "Charm", "percentage", CharmFunctions::luaCharmPercentage);
	Lua::registerMethod(L, "Charm", "chance", CharmFunctions::luaCharmChance);
	Lua::registerMethod(L, "Charm", "messageCancel", CharmFunctions::luaCharmMessageCancel);
	Lua::registerMethod(L, "Charm", "messageServerLog", CharmFunctions::luaCharmMessageServerLog);
	Lua::registerMethod(L, "Charm", "effect", CharmFunctions::luaCharmEffect);
	Lua::registerMethod(L, "Charm", "castSound", CharmFunctions::luaCharmCastSound);
	Lua::registerMethod(L, "Charm", "impactSound", CharmFunctions::luaCharmImpactSound);
}

int CharmFunctions::luaCharmCreate(lua_State* L) {
	// charm(id)
	if (Lua::isNumber(L, 2)) {
		const charmRune_t charmid = Lua::getNumber<charmRune_t>(L, 2);
		const auto charmList = g_game().getCharmList();
		for (const auto &charm : charmList) {
			if (charm->id == charmid) {
				Lua::pushUserdata<Charm>(L, charm);
				Lua::setMetatable(L, -1, "Charm");
				Lua::pushBoolean(L, true);
			}
		}
	}

	lua_pushnil(L);
	return 1;
}

int CharmFunctions::luaCharmName(lua_State* L) {
	// get: charm:name() set: charm:name(string)
	const auto &charm = Lua::getUserdataShared<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		Lua::pushString(L, charm->name);
	} else {
		charm->name = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmDescription(lua_State* L) {
	// get: charm:description() set: charm:description(string)
	const auto &charm = Lua::getUserdataShared<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		Lua::pushString(L, charm->description);
	} else {
		charm->description = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmType(lua_State* L) {
	// get: charm:type() set: charm:type(charm_t)
	const auto &charm = Lua::getUserdataShared<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->type);
	} else {
		charm->type = Lua::getNumber<charm_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmPoints(lua_State* L) {
	// get: charm:points() set: charm:points(value)
	const auto &charm = Lua::getUserdataShared<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->points);
	} else {
		charm->points = Lua::getNumber<int16_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmDamageType(lua_State* L) {
	// get: charm:damageType() set: charm:damageType(type)
	const auto &charm = Lua::getUserdataShared<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->dmgtype);
	} else {
		charm->dmgtype = Lua::getNumber<CombatType_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmPercentage(lua_State* L) {
	// get: charm:percentage() set: charm:percentage(value)
	const auto &charm = Lua::getUserdataShared<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->percent);
	} else {
		charm->percent = Lua::getNumber<uint16_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmChance(lua_State* L) {
	// get: charm:chance() set: charm:chance(value)
	const auto &charm = Lua::getUserdataShared<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->chance);
	} else {
		charm->chance = Lua::getNumber<int8_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmMessageCancel(lua_State* L) {
	// get: charm:messageCancel() set: charm:messageCancel(string)
	const auto &charm = Lua::getUserdataShared<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		Lua::pushString(L, charm->cancelMsg);
	} else {
		charm->cancelMsg = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmMessageServerLog(lua_State* L) {
	// get: charm:messageServerLog() set: charm:messageServerLog(string)
	const auto &charm = Lua::getUserdataShared<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		Lua::pushString(L, charm->logMsg);
	} else {
		charm->logMsg = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmEffect(lua_State* L) {
	// get: charm:effect() set: charm:effect(value)
	const auto &charm = Lua::getUserdataShared<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, charm->effect);
	} else {
		charm->effect = Lua::getNumber<uint16_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmCastSound(lua_State* L) {
	// get: charm:castSound() set: charm:castSound(sound)
	const auto &charm = Lua::getUserdataShared<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, static_cast<lua_Number>(charm->soundCastEffect));
	} else {
		charm->soundCastEffect = Lua::getNumber<SoundEffect_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int CharmFunctions::luaCharmImpactSound(lua_State* L) {
	// get: charm:impactSound() set: charm:impactSound(sound)
	const auto &charm = Lua::getUserdataShared<Charm>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, static_cast<lua_Number>(charm->soundImpactEffect));
	} else {
		charm->soundImpactEffect = Lua::getNumber<SoundEffect_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}
