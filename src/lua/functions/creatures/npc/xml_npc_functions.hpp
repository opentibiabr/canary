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

#ifndef SRC_LUA_FUNCTIONS_CREATURES_NPC_XML_NPC_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_NPC_XML_NPC_FUNCTIONS_HPP_

#include <set>

#include "lua/scripts/luascript.h"

class NpcOldFunctions final : LuaScriptInterface {
	private:
			static void init(lua_State* L) {
				registerClass(L, "NpcOld", "Creature", NpcOldFunctions::luaNpcOldCreate);
				registerMetaMethod(L, "NpcOld", "__eq", NpcOldFunctions::luaUserdataCompare);

				registerMethod(L, "NpcOld", "isNpc", NpcOldFunctions::luaNpcOldIsNpc);
				
				registerMethod(L, "NpcOld", "getParameter", NpcOldFunctions::luaNpcOldGetParameter);
				registerMethod(L, "NpcOld", "setFocus", NpcOldFunctions::luaNpcOldSetFocus);

				registerMethod(L, "NpcOld", "openShopWindow", NpcOldFunctions::luaNpcOldOpenShopWindow);
				registerMethod(L, "NpcOld", "closeShopWindow", NpcOldFunctions::luaNpcOldCloseShopWindow);

				registerMethod(L, "NpcOld", "setMasterPos", NpcOldFunctions::luaNpcOldSetMasterPos);

				registerMethod(L, "NpcOld", "getCurrency", NpcOldFunctions::luaNpcOldGetCurrency);
				registerMethod(L, "NpcOld", "getSpeechBubble", NpcOldFunctions::luaNpcOldGetSpeechBubble);
				registerMethod(L, "NpcOld", "setSpeechBubble", NpcOldFunctions::luaNpcOldSetSpeechBubble);
				registerMethod(L, "NpcOld", "getName", NpcOldFunctions::luaNpcOldGetName);
				registerMethod(L, "NpcOld", "setName", NpcOldFunctions::luaNpcOldSetName);
				registerMethod(L, "NpcOld", "place", NpcOldFunctions::luaNpcOldPlace);
			}

			static int luaNpcOldCreate(lua_State* L);

			static int luaNpcOldIsNpc(lua_State* L);

			static int luaNpcOldGetParameter(lua_State* L);
			static int luaNpcOldSetFocus(lua_State* L);

			static int luaNpcOldOpenShopWindow(lua_State* L);
			static int luaNpcOldCloseShopWindow(lua_State* L);

			static int luaNpcOldSetMasterPos(lua_State* L);

			static int luaNpcOldGetCurrency(lua_State* L);
			static int luaNpcOldGetSpeechBubble(lua_State* L);
			static int luaNpcOldSetSpeechBubble(lua_State* L);
			static int luaNpcOldGetName(lua_State* L);
			static int luaNpcOldSetName(lua_State* L);
			static int luaNpcOldPlace(lua_State* L);

			friend class CreatureFunctions;
};

#endif  // SRC_LUA_FUNCTIONS_CREATURES_NPC_XML_NPC_FUNCTIONS_HPP_
