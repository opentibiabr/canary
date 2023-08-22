/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class CharmFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "Charm", "", CharmFunctions::luaCharmCreate);
		registerMetaMethod(L, "Charm", "__eq", CharmFunctions::luaUserdataCompare);

		registerMethod(L, "Charm", "name", CharmFunctions::luaCharmName);
		registerMethod(L, "Charm", "description", CharmFunctions::luaCharmDescription);
		registerMethod(L, "Charm", "type", CharmFunctions::luaCharmType);
		registerMethod(L, "Charm", "points", CharmFunctions::luaCharmPoints);
		registerMethod(L, "Charm", "damageType", CharmFunctions::luaCharmDamageType);
		registerMethod(L, "Charm", "percentage", CharmFunctions::luaCharmPercentage);
		registerMethod(L, "Charm", "chance", CharmFunctions::luaCharmChance);
		registerMethod(L, "Charm", "messageCancel", CharmFunctions::luaCharmMessageCancel);
		registerMethod(L, "Charm", "messageServerLog", CharmFunctions::luaCharmMessageServerLog);
		registerMethod(L, "Charm", "effect", CharmFunctions::luaCharmEffect);
		registerMethod(L, "Charm", "castSound", CharmFunctions::luaCharmCastSound);
		registerMethod(L, "Charm", "impactSound", CharmFunctions::luaCharmImpactSound);
	}

private:
	static int luaCharmCreate(lua_State* L);
	static int luaCharmName(lua_State* L);
	static int luaCharmDescription(lua_State* L);
	static int luaCharmType(lua_State* L);
	static int luaCharmPoints(lua_State* L);
	static int luaCharmDamageType(lua_State* L);
	static int luaCharmPercentage(lua_State* L);
	static int luaCharmChance(lua_State* L);
	static int luaCharmMessageCancel(lua_State* L);
	static int luaCharmMessageServerLog(lua_State* L);
	static int luaCharmEffect(lua_State* L);
	static int luaCharmCastSound(lua_State* L);
	static int luaCharmImpactSound(lua_State* L);
};
