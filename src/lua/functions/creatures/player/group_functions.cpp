/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "creatures/players/grouping/groups.h"
#include "game/game.h"
#include "lua/functions/creatures/player/group_functions.hpp"

int GroupFunctions::luaGroupCreate(lua_State* L) {
	// Group(id)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Group* group = g_game().groups.getGroup(id);
	if (group) {
		pushUserdata<Group>(L, group);
		setMetatable(L, -1, "Group");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GroupFunctions::luaGroupGetId(lua_State* L) {
	// group:getId()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->id);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GroupFunctions::luaGroupGetName(lua_State* L) {
	// group:getName()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		pushString(L, group->name);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GroupFunctions::luaGroupGetFlags(lua_State* L) {
	// group:getFlags()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->flags);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GroupFunctions::luaGroupGetCustomFlags(lua_State* L) {
	// group:getCustomFlags()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->customflags);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GroupFunctions::luaGroupGetAccess(lua_State* L) {
	// group:getAccess()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		pushBoolean(L, group->access);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GroupFunctions::luaGroupGetMaxDepotItems(lua_State* L) {
	// group:getMaxDepotItems()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->maxDepotItems);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GroupFunctions::luaGroupGetMaxVipEntries(lua_State* L) {
	// group:getMaxVipEntries()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->maxVipEntries);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GroupFunctions::luaGroupHasFlag(lua_State* L) {
	// group:hasFlag(flag)
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		PlayerFlags flag = getNumber<PlayerFlags>(L, 2);
		pushBoolean(L, (group->flags & flag) != 0);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GroupFunctions::luaGroupHasCustomFlag(lua_State* L) {
	// group:hasCustomFlag(flag)
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		PlayerCustomFlags customflag = getNumber<PlayerCustomFlags>(L, 2);
		pushBoolean(L, (group->customflags & customflag) != 0);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
