#pragma once

class Zone;

class ZoneFunctions {
public:
	static void init(lua_State* L);

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
