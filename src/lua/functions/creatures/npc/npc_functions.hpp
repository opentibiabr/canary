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

#ifndef SRC_LUA_FUNCTIONS_CREATURES_NPC_NPC_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_NPC_NPC_FUNCTIONS_HPP_

#include "lua/functions/creatures/npc/npc_type_functions.hpp"
#include "lua/functions/creatures/npc/shop_functions.hpp"
#include "lua/scripts/luascript.h"

class NpcFunctions final : LuaScriptInterface {
	private:
			static void init(lua_State* L) {
				registerClass(L, "Npc", "Creature", NpcFunctions::luaNpcCreate);
				registerMetaMethod(L, "Npc", "__eq", NpcFunctions::luaUserdataCompare);
				registerMethod(L, "Npc", "isNpc", NpcFunctions::luaNpcIsNpc);
				registerMethod(L, "Npc", "setMasterPos", NpcFunctions::luaNpcSetMasterPos);
				registerMethod(L, "Npc", "getCurrency", NpcFunctions::luaNpcGetCurrency);
				registerMethod(L, "Npc", "setCurrency", NpcFunctions::luaNpcSetCurrency);
				registerMethod(L, "Npc", "getSpeechBubble", NpcFunctions::luaNpcGetSpeechBubble);
				registerMethod(L, "Npc", "setSpeechBubble", NpcFunctions::luaNpcSetSpeechBubble);
				registerMethod(L, "Npc", "getId", NpcFunctions::luaNpcGetId);
				registerMethod(L, "Npc", "getName", NpcFunctions::luaNpcGetName);
				registerMethod(L, "Npc", "setName", NpcFunctions::luaNpcSetName);
				registerMethod(L, "Npc", "place", NpcFunctions::luaNpcPlace);
				registerMethod(L, "Npc", "say", NpcFunctions::luaNpcSay);
				registerMethod(L, "Npc", "turnToCreature", NpcFunctions::luaNpcTurnToCreature);
				registerMethod(L, "Npc", "setPlayerInteraction", NpcFunctions::luaNpcSetPlayerInteraction);
				registerMethod(L, "Npc", "removePlayerInteraction", NpcFunctions::luaNpcRemovePlayerInteraction);
				registerMethod(L, "Npc", "isInteractingWithPlayer", NpcFunctions::luaNpcIsInteractingWithPlayer);
				registerMethod(L, "Npc", "isInTalkRange", NpcFunctions::luaNpcIsInTalkRange);
				registerMethod(L, "Npc", "isPlayerInteractingOnTopic", NpcFunctions::luaNpcIsPlayerInteractingOnTopic);
				registerMethod(L, "Npc", "openShopWindow", NpcFunctions::luaNpcOpenShopWindow);
				registerMethod(L, "Npc", "closeShopWindow", NpcFunctions::luaNpcCloseShopWindow);
				registerMethod(L, "Npc", "getShopItem", NpcFunctions::luaNpcGetShopItem);
				registerMethod(L, "Npc", "isMerchant", NpcFunctions::luaNpcIsMerchant);

				registerMethod(L, "Npc", "move", NpcFunctions::luaNpcMove);
				registerMethod(L, "Npc", "turn", NpcFunctions::luaNpcTurn);
				registerMethod(L, "Npc", "follow", NpcFunctions::luaNpcFollow);
				registerMethod(L, "Npc", "sellItem", NpcFunctions::luaNpcSellItem);

				registerMethod(L, "Npc", "getDistanceTo", NpcFunctions::luaNpcGetDistanceTo);
				
				ShopFunctions::init(L);
				NpcTypeFunctions::init(L);
			}

			static int luaNpcCreate(lua_State* L);

			static int luaNpcIsNpc(lua_State* L);

			static int luaNpcSetMasterPos(lua_State* L);

			static int luaNpcGetCurrency(lua_State* L);
			static int luaNpcSetCurrency(lua_State* L);
			static int luaNpcGetSpeechBubble(lua_State* L);
			static int luaNpcSetSpeechBubble(lua_State* L);
			static int luaNpcGetId(lua_State* L);
			static int luaNpcGetName(lua_State* L);
			static int luaNpcSetName(lua_State* L);
			static int luaNpcPlace(lua_State* L);
			static int luaNpcSay(lua_State* L);
			static int luaNpcTurnToCreature(lua_State* L);
			static int luaNpcSetPlayerInteraction(lua_State* L);
			static int luaNpcRemovePlayerInteraction(lua_State* L);
			static int luaNpcIsInteractingWithPlayer(lua_State* L);
			static int luaNpcIsInTalkRange(lua_State* L);
			static int luaNpcIsPlayerInteractingOnTopic(lua_State* L);
			static int luaNpcOpenShopWindow(lua_State* L);
			static int luaNpcCloseShopWindow(lua_State* L);
			static int luaNpcGetShopItem(lua_State* L);
			static int luaNpcIsMerchant(lua_State* L);

			static int luaNpcMove(lua_State* L);
			static int luaNpcTurn(lua_State* L);
			static int luaNpcFollow(lua_State* L);
			static int luaNpcSellItem(lua_State* L);

			static int luaNpcGetDistanceTo(lua_State* L);

			friend class CreatureFunctions;
};

#endif  // SRC_LUA_FUNCTIONS_CREATURES_NPC_NPC_FUNCTIONS_HPP_
