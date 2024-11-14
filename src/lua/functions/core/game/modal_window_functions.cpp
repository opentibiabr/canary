/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/player.hpp"
#include "lua/functions/core/game/modal_window_functions.hpp"
#include "game/modal_window/modal_window.hpp"

// ModalWindow
int ModalWindowFunctions::luaModalWindowCreate(lua_State* L) {
	// ModalWindow(id, title, message)
	const std::string &message = getString(L, 4);
	const std::string &title = getString(L, 3);
	uint32_t id = getNumber<uint32_t>(L, 2);

	pushUserdata<ModalWindow>(L, std::make_shared<ModalWindow>(id, title, message));
	setMetatable(L, -1, "ModalWindow");
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetId(lua_State* L) {
	// modalWindow:getId()
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->id);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetTitle(lua_State* L) {
	// modalWindow:getTitle()
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		pushString(L, window->title);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetMessage(lua_State* L) {
	// modalWindow:getMessage()
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		pushString(L, window->message);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowSetTitle(lua_State* L) {
	// modalWindow:setTitle(text)
	const std::string &text = getString(L, 2);
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		window->title = text;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowSetMessage(lua_State* L) {
	// modalWindow:setMessage(text)
	const std::string &text = getString(L, 2);
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		window->message = text;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetButtonCount(lua_State* L) {
	// modalWindow:getButtonCount()
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->buttons.size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetChoiceCount(lua_State* L) {
	// modalWindow:getChoiceCount()
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->choices.size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowAddButton(lua_State* L) {
	// modalWindow:addButton(id, text)
	const std::string &text = getString(L, 3);
	uint8_t id = getNumber<uint8_t>(L, 2);
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		window->buttons.emplace_back(text, id);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowAddChoice(lua_State* L) {
	// modalWindow:addChoice(id, text)
	const std::string &text = getString(L, 3);
	uint8_t id = getNumber<uint8_t>(L, 2);
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		window->choices.emplace_back(text, id);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetDefaultEnterButton(lua_State* L) {
	// modalWindow:getDefaultEnterButton()
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->defaultEnterButton);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowSetDefaultEnterButton(lua_State* L) {
	// modalWindow:setDefaultEnterButton(buttonId)
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		window->defaultEnterButton = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetDefaultEscapeButton(lua_State* L) {
	// modalWindow:getDefaultEscapeButton()
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->defaultEscapeButton);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowSetDefaultEscapeButton(lua_State* L) {
	// modalWindow:setDefaultEscapeButton(buttonId)
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		window->defaultEscapeButton = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowHasPriority(lua_State* L) {
	// modalWindow:hasPriority()
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		pushBoolean(L, window->priority);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowSetPriority(lua_State* L) {
	// modalWindow:setPriority(priority)
	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		window->priority = getBoolean(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowSendToPlayer(lua_State* L) {
	// modalWindow:sendToPlayer(player)
	const auto &player = getPlayer(L, 2);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto &window = getUserdataShared<ModalWindow>(L, 1);
	if (window) {
		if (!player->hasModalWindowOpen(window->id)) {
			player->sendModalWindow(*window);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
