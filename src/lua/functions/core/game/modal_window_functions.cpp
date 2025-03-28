/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/game/modal_window_functions.hpp"

#include "creatures/players/player.hpp"
#include "game/modal_window/modal_window.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void ModalWindowFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "ModalWindow", "", ModalWindowFunctions::luaModalWindowCreate);
	Lua::registerMetaMethod(L, "ModalWindow", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "ModalWindow", "getId", ModalWindowFunctions::luaModalWindowGetId);
	Lua::registerMethod(L, "ModalWindow", "getTitle", ModalWindowFunctions::luaModalWindowGetTitle);
	Lua::registerMethod(L, "ModalWindow", "getMessage", ModalWindowFunctions::luaModalWindowGetMessage);

	Lua::registerMethod(L, "ModalWindow", "setTitle", ModalWindowFunctions::luaModalWindowSetTitle);
	Lua::registerMethod(L, "ModalWindow", "setMessage", ModalWindowFunctions::luaModalWindowSetMessage);

	Lua::registerMethod(L, "ModalWindow", "getButtonCount", ModalWindowFunctions::luaModalWindowGetButtonCount);
	Lua::registerMethod(L, "ModalWindow", "getChoiceCount", ModalWindowFunctions::luaModalWindowGetChoiceCount);

	Lua::registerMethod(L, "ModalWindow", "addButton", ModalWindowFunctions::luaModalWindowAddButton);
	Lua::registerMethod(L, "ModalWindow", "addChoice", ModalWindowFunctions::luaModalWindowAddChoice);

	Lua::registerMethod(L, "ModalWindow", "getDefaultEnterButton", ModalWindowFunctions::luaModalWindowGetDefaultEnterButton);
	Lua::registerMethod(L, "ModalWindow", "setDefaultEnterButton", ModalWindowFunctions::luaModalWindowSetDefaultEnterButton);

	Lua::registerMethod(L, "ModalWindow", "getDefaultEscapeButton", ModalWindowFunctions::luaModalWindowGetDefaultEscapeButton);
	Lua::registerMethod(L, "ModalWindow", "setDefaultEscapeButton", ModalWindowFunctions::luaModalWindowSetDefaultEscapeButton);

	Lua::registerMethod(L, "ModalWindow", "hasPriority", ModalWindowFunctions::luaModalWindowHasPriority);
	Lua::registerMethod(L, "ModalWindow", "setPriority", ModalWindowFunctions::luaModalWindowSetPriority);

	Lua::registerMethod(L, "ModalWindow", "sendToPlayer", ModalWindowFunctions::luaModalWindowSendToPlayer);
}

// ModalWindow
int ModalWindowFunctions::luaModalWindowCreate(lua_State* L) {
	// ModalWindow(id, title, message)
	const std::string &message = Lua::getString(L, 4);
	const std::string &title = Lua::getString(L, 3);
	uint32_t id = Lua::getNumber<uint32_t>(L, 2);

	Lua::pushUserdata<ModalWindow>(L, std::make_shared<ModalWindow>(id, title, message));
	Lua::setMetatable(L, -1, "ModalWindow");
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetId(lua_State* L) {
	// modalWindow:getId()
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		lua_pushnumber(L, window->id);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetTitle(lua_State* L) {
	// modalWindow:getTitle()
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		Lua::pushString(L, window->title);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetMessage(lua_State* L) {
	// modalWindow:getMessage()
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		Lua::pushString(L, window->message);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowSetTitle(lua_State* L) {
	// modalWindow:setTitle(text)
	const std::string &text = Lua::getString(L, 2);
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		window->title = text;
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowSetMessage(lua_State* L) {
	// modalWindow:setMessage(text)
	const std::string &text = Lua::getString(L, 2);
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		window->message = text;
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetButtonCount(lua_State* L) {
	// modalWindow:getButtonCount()
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		lua_pushnumber(L, window->buttons.size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetChoiceCount(lua_State* L) {
	// modalWindow:getChoiceCount()
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		lua_pushnumber(L, window->choices.size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowAddButton(lua_State* L) {
	// modalWindow:addButton(id, text)
	const std::string &text = Lua::getString(L, 3);
	uint8_t id = Lua::getNumber<uint8_t>(L, 2);
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		window->buttons.emplace_back(text, id);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowAddChoice(lua_State* L) {
	// modalWindow:addChoice(id, text)
	const std::string &text = Lua::getString(L, 3);
	uint8_t id = Lua::getNumber<uint8_t>(L, 2);
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		window->choices.emplace_back(text, id);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetDefaultEnterButton(lua_State* L) {
	// modalWindow:getDefaultEnterButton()
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		lua_pushnumber(L, window->defaultEnterButton);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowSetDefaultEnterButton(lua_State* L) {
	// modalWindow:setDefaultEnterButton(buttonId)
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		window->defaultEnterButton = Lua::getNumber<uint8_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowGetDefaultEscapeButton(lua_State* L) {
	// modalWindow:getDefaultEscapeButton()
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		lua_pushnumber(L, window->defaultEscapeButton);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowSetDefaultEscapeButton(lua_State* L) {
	// modalWindow:setDefaultEscapeButton(buttonId)
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		window->defaultEscapeButton = Lua::getNumber<uint8_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowHasPriority(lua_State* L) {
	// modalWindow:hasPriority()
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		Lua::pushBoolean(L, window->priority);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowSetPriority(lua_State* L) {
	// modalWindow:setPriority(priority)
	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		window->priority = Lua::getBoolean(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ModalWindowFunctions::luaModalWindowSendToPlayer(lua_State* L) {
	// modalWindow:sendToPlayer(player)
	const auto &player = Lua::getPlayer(L, 2);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto &window = Lua::getUserdataShared<ModalWindow>(L, 1, "ModalWindow");
	if (window) {
		if (!player->hasModalWindowOpen(window->id)) {
			player->sendModalWindow(*window);
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
