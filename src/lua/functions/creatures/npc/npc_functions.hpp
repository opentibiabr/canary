/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/functions/creatures/npc/npc_type_functions.hpp"
#include "lua/functions/creatures/npc/shop_functions.hpp"
class NpcFunctions {
private:
	static void init(lua_State* L);

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
	static int luaNpcOpenShopWindowTable(lua_State* L);
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
