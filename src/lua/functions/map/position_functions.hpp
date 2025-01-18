/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class PositionFunctions {
public:
	static void init(lua_State* L);

private:
	static int luaPositionCreate(lua_State* L);
	static int luaPositionAdd(lua_State* L);
	static int luaPositionSub(lua_State* L);
	static int luaPositionCompare(lua_State* L);

	static int luaPositionGetDistance(lua_State* L);
	static int luaPositionGetPathTo(lua_State* L);
	static int luaPositionIsSightClear(lua_State* L);

	static int luaPositionGetTile(lua_State* L);
	static int luaPositionGetZones(lua_State* L);

	static int luaPositionSendMagicEffect(lua_State* L);
	static int luaPositionRemoveMagicEffect(lua_State* L);
	static int luaPositionSendDistanceEffect(lua_State* L);

	static int luaPositionSendSingleSoundEffect(lua_State* L);
	static int luaPositionSendDoubleSoundEffect(lua_State* L);

	static int luaPositionToString(lua_State* L);
};
