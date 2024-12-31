/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class ModalWindowFunctions {
public:
	static void init(lua_State* L);

private:
	static int luaModalWindowCreate(lua_State* L);

	static int luaModalWindowGetId(lua_State* L);
	static int luaModalWindowGetTitle(lua_State* L);
	static int luaModalWindowGetMessage(lua_State* L);

	static int luaModalWindowSetTitle(lua_State* L);
	static int luaModalWindowSetMessage(lua_State* L);

	static int luaModalWindowGetButtonCount(lua_State* L);
	static int luaModalWindowGetChoiceCount(lua_State* L);

	static int luaModalWindowAddButton(lua_State* L);
	static int luaModalWindowAddChoice(lua_State* L);

	static int luaModalWindowGetDefaultEnterButton(lua_State* L);
	static int luaModalWindowSetDefaultEnterButton(lua_State* L);

	static int luaModalWindowGetDefaultEscapeButton(lua_State* L);
	static int luaModalWindowSetDefaultEscapeButton(lua_State* L);

	static int luaModalWindowHasPriority(lua_State* L);
	static int luaModalWindowSetPriority(lua_State* L);

	static int luaModalWindowSendToPlayer(lua_State* L);
};
