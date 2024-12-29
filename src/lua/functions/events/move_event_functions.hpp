/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class MoveEventFunctions {
public:
	static void init(lua_State* L);

private:
	static int luaCreateMoveEvent(lua_State* L);
	static int luaMoveEventType(lua_State* L);
	static int luaMoveEventRegister(lua_State* L);
	static int luaMoveEventOnCallback(lua_State* L);
	static int luaMoveEventLevel(lua_State* L);
	static int luaMoveEventSlot(lua_State* L);
	static int luaMoveEventMagLevel(lua_State* L);
	static int luaMoveEventPremium(lua_State* L);
	static int luaMoveEventVocation(lua_State* L);
	static int luaMoveEventItemId(lua_State* L);
	static int luaMoveEventActionId(lua_State* L);
	static int luaMoveEventUniqueId(lua_State* L);
	static int luaMoveEventPosition(lua_State* L);
};
