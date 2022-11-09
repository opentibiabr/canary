/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "pch.hpp"

#include "creatures/players/player.h"
#include "lua/functions/core/game/modal_window_functions.hpp"

// ModalWindow
int ModalWindowFunctions::luaModalWindowCreate(lua_State* L) {
    // ModalWindow(id, title, message)
    const std::string& message = getString(L, 4);
    const std::string& title = getString(L, 3);
    uint32_t id = getNumber<uint32_t>(L, 2);

    pushUserdata<ModalWindow>(L, new ModalWindow(id, title, message));
    setMetatable(L, -1, "ModalWindow");
    return 1;
}

int ModalWindowFunctions::luaModalWindowDelete(lua_State* L) {
    ModalWindow** windowPtr = getRawUserdata<ModalWindow>(L, 1);
    if (windowPtr && *windowPtr) {
        delete *windowPtr;
        *windowPtr = nullptr;
    }
    return 0;
}

int ModalWindowFunctions::luaModalWindowGetId(lua_State* L) {
    // modalWindow:getId()
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
    if (window) {
        lua_pushnumber(L, window->id);
    } else {
        lua_pushnil(L);
    }
    return 1;
}

int ModalWindowFunctions::luaModalWindowGetTitle(lua_State* L) {
    // modalWindow:getTitle()
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
    if (window) {
        pushString(L, window->title);
    } else {
        lua_pushnil(L);
    }
    return 1;
}

int ModalWindowFunctions::luaModalWindowGetMessage(lua_State* L) {
    // modalWindow:getMessage()
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
    if (window) {
        pushString(L, window->message);
    } else {
        lua_pushnil(L);
    }
    return 1;
}

int ModalWindowFunctions::luaModalWindowSetTitle(lua_State* L) {
    // modalWindow:setTitle(text)
    const std::string& text = getString(L, 2);
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
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
    const std::string& text = getString(L, 2);
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
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
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
    if (window) {
        lua_pushnumber(L, window->buttons.size());
    } else {
        lua_pushnil(L);
    }
    return 1;
}

int ModalWindowFunctions::luaModalWindowGetChoiceCount(lua_State* L) {
    // modalWindow:getChoiceCount()
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
    if (window) {
        lua_pushnumber(L, window->choices.size());
    } else {
        lua_pushnil(L);
    }
    return 1;
}

int ModalWindowFunctions::luaModalWindowAddButton(lua_State* L) {
    // modalWindow:addButton(id, text)
    const std::string& text = getString(L, 3);
    uint8_t id = getNumber<uint8_t>(L, 2);
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
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
    const std::string& text = getString(L, 3);
    uint8_t id = getNumber<uint8_t>(L, 2);
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
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
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
    if (window) {
        lua_pushnumber(L, window->defaultEnterButton);
    } else {
        lua_pushnil(L);
    }
    return 1;
}

int ModalWindowFunctions::luaModalWindowSetDefaultEnterButton(lua_State* L) {
    // modalWindow:setDefaultEnterButton(buttonId)
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
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
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
    if (window) {
        lua_pushnumber(L, window->defaultEscapeButton);
    } else {
        lua_pushnil(L);
    }
    return 1;
}

int ModalWindowFunctions::luaModalWindowSetDefaultEscapeButton(lua_State* L) {
    // modalWindow:setDefaultEscapeButton(buttonId)
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
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
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
    if (window) {
        pushBoolean(L, window->priority);
    } else {
        lua_pushnil(L);
    }
    return 1;
}

int ModalWindowFunctions::luaModalWindowSetPriority(lua_State* L) {
    // modalWindow:setPriority(priority)
    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
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
    Player* player = getPlayer(L, 2);
    if (!player) {
        lua_pushnil(L);
        return 1;
    }

    ModalWindow* window = getUserdata<ModalWindow>(L, 1);
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
