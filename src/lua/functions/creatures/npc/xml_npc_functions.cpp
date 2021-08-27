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

#include "otpch.h"

#include <boost/range/adaptor/reversed.hpp>

#include "game/game.h"
#include "creatures/creature.h"
#include "creatures/npcs/xml_npc.hpp"
#include "lua/functions/creatures/npc/xml_npc_functions.hpp"

int NpcOldFunctions::luaNpcOldCreate(lua_State* L)
{
	// NpcOld([id or name or userdata])
	NpcOld* npcOld;
	if (lua_gettop(L) >= 2) {
		if (isNumber(L, 2)) {
			npcOld = g_game.getNpcOldByID(getNumber<uint32_t>(L, 2));
		} else if (isString(L, 2)) {
			npcOld = g_game.getNpcOldByName(getString(L, 2));
		} else if (isUserdata(L, 2)) {
			if (getUserdataType(L, 2) != LuaData_NpcOld) {
				lua_pushnil(L);
				return 1;
			}
			npcOld = getUserdata<NpcOld>(L, 2);
		} else {
			npcOld = nullptr;
		}
	} else {
		npcOld = getScriptEnv()->getNpcOld();
	}

	if (npcOld) {
		pushUserdata<NpcOld>(L, npcOld);
		setMetatable(L, -1, "NpcOld");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcOldFunctions::luaNpcOldIsNpc(lua_State* L)
{
	// npcOld:isNpc()
	pushBoolean(L, getUserdata<const NpcOld>(L, 1) != nullptr);
	return 1;
}

//
int NpcOldFunctions::luaNpcOldGetParameter(lua_State* L)
{
	// npcOld:getParameter(key)
	const std::string& key = getString(L, 2);
	NpcOld* npcOld = getUserdata<NpcOld>(L, 1);
	if (npcOld) {
		auto it = npcOld->parameters.find(key);
		if (it != npcOld->parameters.end()) {
			pushString(L, it->second);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcOldFunctions::luaNpcOldSetFocus(lua_State* L)
{
	// npcOld:setFocus(creature)
	Creature* creature = getCreature(L, 2);
	NpcOld* npcOld = getUserdata<NpcOld>(L, 1);
	if (npcOld) {
		npcOld->setCreatureFocus(creature);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcOldFunctions::luaNpcOldOpenShopWindow(lua_State* L)
{
	// npcOld:openOldShopWindow(cid, items, buyCallback, sellCallback)
	if (!isTable(L, 3)) {
		reportErrorFunc("item list is not a table.");
		pushBoolean(L, false);
		return 1;
	}

	Player* player = getPlayer(L, 2);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	NpcOld* npcOld = getUserdata<NpcOld>(L, 1);
	if (!npcOld) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	int32_t sellCallback = -1;
	if (LuaScriptInterface::isFunction(L, 5)) {
		sellCallback = luaL_ref(L, LUA_REGISTRYINDEX);
	}

	int32_t buyCallback = -1;
	if (LuaScriptInterface::isFunction(L, 4)) {
		buyCallback = luaL_ref(L, LUA_REGISTRYINDEX);
	}

	std::vector<OldShopInfo> items;

	lua_pushnil(L);
	while (lua_next(L, 3) != 0) {
		const auto tableIndex = lua_gettop(L);
		OldShopInfo item;

		uint16_t itemId = static_cast<uint16_t>(getField<uint32_t>(L, tableIndex, "id"));
		int32_t subType = getField<int32_t>(L, tableIndex, "subType");
		if (subType == 0) {
			subType = getField<int32_t>(L, tableIndex, "subtype");
			lua_pop(L, 1);
		}

		uint32_t buyPrice = getField<uint32_t>(L, tableIndex, "buy");
		uint32_t sellPrice = getField<uint32_t>(L, tableIndex, "sell");
		std::string realName = getFieldString(L, tableIndex, "name");

		items.emplace_back(itemId, subType, buyPrice, sellPrice, std::move(realName));
		lua_pop(L, 6);
	}
	lua_pop(L, 1);

	player->closeOldShopWindow(false);
	npcOld->addShopPlayer(player);

	player->setOldShopOwner(npcOld, buyCallback, sellCallback);
	player->openOldShopWindow(npcOld, items);

	pushBoolean(L, true);
	return 1;
}

int NpcOldFunctions::luaNpcOldCloseShopWindow(lua_State* L)
{
	// npcOld:closeOldShopWindow(player)
	Player* player = getPlayer(L, 2);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	NpcOld* npcOld = getUserdata<NpcOld>(L, 1);
	if (!npcOld) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	int32_t buyCallback;
	int32_t sellCallback;

	NpcOld* merchant = player->getOldShopOwner(buyCallback, sellCallback);
	if (merchant == npcOld) {
		player->sendCloseShop();
		if (buyCallback != -1) {
			luaL_unref(L, LUA_REGISTRYINDEX, buyCallback);
		}

		if (sellCallback != -1) {
			luaL_unref(L, LUA_REGISTRYINDEX, sellCallback);
		}

		player->setOldShopOwner(nullptr, -1, -1);
		npcOld->removeShopPlayer(player);
	}

	pushBoolean(L, true);
	return 1;
}
//
int NpcOldFunctions::luaNpcOldSetMasterPos(lua_State* L)
{
	// npcOld:setMasterPos(pos[, radius])
	NpcOld* npcOld = getUserdata<NpcOld>(L, 1);
	if (!npcOld) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	const Position& pos = getPosition(L, 2);
	int32_t radius = getNumber<int32_t>(L, 3, 1);
	npcOld->setMasterPos(pos, radius);
	pushBoolean(L, true);
	return 1;
}

int NpcOldFunctions::luaNpcOldGetCurrency(lua_State* L)
{
	// npcOld:getCurrency()
	NpcOld* npcOld = getUserdata<NpcOld>(L, 1);
	if (!npcOld) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
	}

	lua_pushnumber(L, npcOld->getCurrency());
	return 1;
}

int NpcOldFunctions::luaNpcOldGetSpeechBubble(lua_State* L)
{
	// npcOld:getSpeechBubble()
	NpcOld* npcOld = getUserdata<NpcOld>(L, 1);
	if (!npcOld) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
	}

	lua_pushnumber(L, npcOld->getSpeechBubble());
	return 1;
}

int NpcOldFunctions::luaNpcOldSetSpeechBubble(lua_State* L)
{
	// npcOld:setSpeechBubble(speechBubble)
	NpcOld* npcOld = getUserdata<NpcOld>(L, 1);
	if (!npcOld) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
	}

	npcOld->setSpeechBubble(getNumber<uint8_t>(L, 2));
	return 1;
}

int NpcOldFunctions::luaNpcOldGetName(lua_State* L)
{
	// npcOld:getName()
	NpcOld* npcOld = getUserdata<NpcOld>(L, 1);
	if (!npcOld) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	pushString(L, npcOld->getName());
	return 1;
}

int NpcOldFunctions::luaNpcOldSetName(lua_State* L)
{
	// npcOld:setName(name)
	NpcOld* npcOld = getUserdata<NpcOld>(L, 1);
	const std::string& name = getString(L, 2);
	if (!npcOld) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
	}

	pushString(L, npcOld->setName(name));
	return 1;
}

int NpcOldFunctions::luaNpcOldPlace(lua_State* L)
{
	// npcOld:place(position[, extended = false[, force = true]])
	NpcOld* npcOld = getUserdata<NpcOld>(L, 1);
	if (!npcOld) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const Position& position = getPosition(L, 2);
	bool extended = getBoolean(L, 3, false);
	bool force = getBoolean(L, 4, true);
	if (g_game.placeCreature(npcOld, position, extended, force)) {
		pushUserdata<NpcOld>(L, npcOld);
		setMetatable(L, -1, "NpcOld");
	} else {
		lua_pushnil(L);
	}
	return 1;
}
