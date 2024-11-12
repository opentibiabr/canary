/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class ImbuementFunctions {
public:
	static void init(lua_State* L);

private:
	static int luaCreateImbuement(lua_State* L);
	static int luaImbuementGetName(lua_State* L);
	static int luaImbuementGetId(lua_State* L);
	static int luaImbuementGetItems(lua_State* L);
	static int luaImbuementGetBase(lua_State* L);
	static int luaImbuementGetCategory(lua_State* L);
	static int luaImbuementIsPremium(lua_State* L);
	static int luaImbuementGetElementDamage(lua_State* L);
	static int luaImbuementGetCombatType(lua_State* L);
};
