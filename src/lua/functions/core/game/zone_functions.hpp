#pragma once

#include "lua/scripts/luascript.hpp"

class Zone;

class ZoneFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "Zone", "", ZoneFunctions::luaZoneCreate);
		registerMetaMethod(L, "Zone", "__eq", ZoneFunctions::luaZoneCompare);

		registerMethod(L, "Zone", "getName", ZoneFunctions::luaZoneGetName);
		registerMethod(L, "Zone", "addArea", ZoneFunctions::luaZoneAddArea);
		registerMethod(L, "Zone", "subtractArea", ZoneFunctions::luaZoneSubtractArea);
		registerMethod(L, "Zone", "getRemoveDestination", ZoneFunctions::luaZoneGetRemoveDestination);
		registerMethod(L, "Zone", "setRemoveDestination", ZoneFunctions::luaZoneSetRemoveDestination);
		registerMethod(L, "Zone", "getPositions", ZoneFunctions::luaZoneGetPositions);
		registerMethod(L, "Zone", "getCreatures", ZoneFunctions::luaZoneGetCreatures);
		registerMethod(L, "Zone", "getPlayers", ZoneFunctions::luaZoneGetPlayers);
		registerMethod(L, "Zone", "getMonsters", ZoneFunctions::luaZoneGetMonsters);
		registerMethod(L, "Zone", "getNpcs", ZoneFunctions::luaZoneGetNpcs);
		registerMethod(L, "Zone", "getItems", ZoneFunctions::luaZoneGetItems);

		registerMethod(L, "Zone", "removePlayers", ZoneFunctions::luaZoneRemovePlayers);
		registerMethod(L, "Zone", "removeMonsters", ZoneFunctions::luaZoneRemoveMonsters);
		registerMethod(L, "Zone", "removeNpcs", ZoneFunctions::luaZoneRemoveNpcs);
		registerMethod(L, "Zone", "refresh", ZoneFunctions::luaZoneRefresh);

		registerMethod(L, "Zone", "setMonsterVariant", ZoneFunctions::luaZoneSetMonsterVariant);

		// static methods
		registerMethod(L, "Zone", "getByPosition", ZoneFunctions::luaZoneGetByPosition);
		registerMethod(L, "Zone", "getByName", ZoneFunctions::luaZoneGetByName);
		registerMethod(L, "Zone", "getAll", ZoneFunctions::luaZoneGetAll);
	}

private:
	static int luaZoneCreate(lua_State* L);
	static int luaZoneCompare(lua_State* L);

	static int luaZoneGetName(lua_State* L);
	static int luaZoneAddArea(lua_State* L);
	static int luaZoneSubtractArea(lua_State* L);
	static int luaZoneGetRemoveDestination(lua_State* L);
	static int luaZoneSetRemoveDestination(lua_State* L);
	static int luaZoneRefresh(lua_State* L);
	static int luaZoneGetPositions(lua_State* L);
	static int luaZoneGetCreatures(lua_State* L);
	static int luaZoneGetPlayers(lua_State* L);
	static int luaZoneGetMonsters(lua_State* L);
	static int luaZoneGetNpcs(lua_State* L);
	static int luaZoneGetItems(lua_State* L);

	static int luaZoneRemovePlayers(lua_State* L);
	static int luaZoneRemoveMonsters(lua_State* L);
	static int luaZoneRemoveNpcs(lua_State* L);

	static int luaZoneSetMonsterVariant(lua_State* L);

	static int luaZoneGetByPosition(lua_State* L);
	static int luaZoneGetByName(lua_State* L);
	static int luaZoneGetAll(lua_State* L);
};
