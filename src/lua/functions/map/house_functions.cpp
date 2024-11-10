/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/map/house_functions.hpp"

#include "config/configmanager.hpp"
#include "items/bed.hpp"
#include "game/game.hpp"
#include "game/movement/position.hpp"
#include "io/iologindata.hpp"
#include "map/house/house.hpp"
#include "creatures/players/player.hpp"

int HouseFunctions::luaHouseCreate(lua_State* L) {
	// House(id)
	if (const auto &house = g_game().map.houses.getHouse(getNumber<uint32_t>(L, 2))) {
		pushUserdata<House>(L, house);
		setMetatable(L, -1, "House");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int HouseFunctions::luaHouseGetId(lua_State* L) {
	// house:getId()
	if (const auto &house = getUserdataShared<House>(L, 1)) {
		lua_pushnumber(L, house->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int HouseFunctions::luaHouseGetName(lua_State* L) {
	// house:getName()
	if (const auto &house = getUserdataShared<House>(L, 1)) {
		pushString(L, house->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int HouseFunctions::luaHouseGetTown(lua_State* L) {
	// house:getTown()
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	if (const auto &town = g_game().map.towns.getTown(house->getTownId())) {
		pushUserdata<Town>(L, town);
		setMetatable(L, -1, "Town");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int HouseFunctions::luaHouseGetExitPosition(lua_State* L) {
	// house:getExitPosition()
	if (const auto &house = getUserdataShared<House>(L, 1)) {
		pushPosition(L, house->getEntryPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int HouseFunctions::luaHouseGetRent(lua_State* L) {
	// house:getRent()
	if (const auto &house = getUserdataShared<House>(L, 1)) {
		lua_pushnumber(L, house->getRent());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int HouseFunctions::luaHouseGetPrice(lua_State* L) {
	// house:getPrice()
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		reportErrorFunc("House not found");
		lua_pushnumber(L, 0);
		return 1;
	}

	lua_pushnumber(L, house->getPrice());
	return 1;
}

int HouseFunctions::luaHouseGetOwnerGuid(lua_State* L) {
	// house:getOwnerGuid()
	if (const auto &house = getUserdataShared<House>(L, 1)) {
		lua_pushnumber(L, house->getOwner());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int HouseFunctions::luaHouseSetHouseOwner(lua_State* L) {
	// house:setHouseOwner(guid[, updateDatabase = true])
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		reportErrorFunc("House not found");
		lua_pushnil(L);
		return 1;
	}

	const uint32_t guid = getNumber<uint32_t>(L, 2);
	const bool updateDatabase = getBoolean(L, 3, true);
	house->setOwner(guid, updateDatabase);
	pushBoolean(L, true);
	return 1;
}

int HouseFunctions::luaHouseSetNewOwnerGuid(lua_State* L) {
	// house:setNewOwnerGuid(guid[, updateDatabase = true])
	const auto &house = getUserdataShared<House>(L, 1);
	if (house) {
		auto isTransferOnRestart = g_configManager().getBoolean(TOGGLE_HOUSE_TRANSFER_ON_SERVER_RESTART);
		if (isTransferOnRestart && house->hasNewOwnership()) {
			const auto &player = g_game().getPlayerByGUID(house->getOwner());
			if (player) {
				player->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot leave this house. Ownership is already scheduled to be transferred upon the next server restart.");
			}
			lua_pushnil(L);
			return 1;
		}

		const auto guid = getNumber<uint32_t>(L, 2, 0);
		house->setNewOwnerGuid(guid, false);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int HouseFunctions::luaHouseHasItemOnTile(lua_State* L) {
	// house:hasItemOnTile()
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		reportErrorFunc("House not found");
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, house->hasItemOnTile());
	return 1;
}

int HouseFunctions::luaHouseHasNewOwnership(lua_State* L) {
	// house:hasNewOwnership(guid)
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		reportErrorFunc("House not found");
		lua_pushnil(L);
		return 1;
	}

	auto isTransferOnRestart = g_configManager().getBoolean(TOGGLE_HOUSE_TRANSFER_ON_SERVER_RESTART);
	pushBoolean(L, isTransferOnRestart && house->hasNewOwnership());
	return 1;
}

int HouseFunctions::luaHouseStartTrade(lua_State* L) {
	// house:startTrade(player, tradePartner)
	const auto &house = getUserdataShared<House>(L, 1);
	const auto &player = getUserdataShared<Player>(L, 2);
	const auto &tradePartner = getUserdataShared<Player>(L, 3);

	if (!player || !tradePartner || !house) {
		lua_pushnil(L);
		return 1;
	}

	if (!Position::areInRange<2, 2, 0>(tradePartner->getPosition(), player->getPosition())) {
		lua_pushnumber(L, RETURNVALUE_TRADEPLAYERFARAWAY);
		return 1;
	}

	if (house->getOwner() != player->getGUID()) {
		lua_pushnumber(L, RETURNVALUE_YOUDONTOWNTHISHOUSE);
		return 1;
	}

	if (g_game().map.houses.getHouseByPlayerId(tradePartner->getGUID())) {
		lua_pushnumber(L, RETURNVALUE_TRADEPLAYERALREADYOWNSAHOUSE);
		return 1;
	}

	if (IOLoginData::hasBiddedOnHouse(tradePartner->getGUID())) {
		lua_pushnumber(L, RETURNVALUE_TRADEPLAYERHIGHESTBIDDER);
		return 1;
	}

	const auto &transferItem = house->getTransferItem();
	if (!transferItem) {
		lua_pushnumber(L, RETURNVALUE_YOUCANNOTTRADETHISHOUSE);
		return 1;
	}

	auto isTransferOnRestart = g_configManager().getBoolean(TOGGLE_HOUSE_TRANSFER_ON_SERVER_RESTART);
	if (isTransferOnRestart && house->hasNewOwnership()) {
		tradePartner->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot buy this house. Ownership is already scheduled to be transferred upon the next server restart.");
		player->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot sell this house. Ownership is already scheduled to be transferred upon the next server restart.");
		lua_pushnumber(L, RETURNVALUE_YOUCANNOTTRADETHISHOUSE);
		return 1;
	}

	transferItem->getParent()->setParent(player);
	if (!g_game().internalStartTrade(player, tradePartner, transferItem)) {
		house->resetTransferItem();
	}

	lua_pushnumber(L, RETURNVALUE_NOERROR);
	return 1;
}

int HouseFunctions::luaHouseGetBeds(lua_State* L) {
	// house:getBeds()
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto &beds = house->getBeds();
	lua_createtable(L, beds.size(), 0);

	int index = 0;
	for (const auto &bedItem : beds) {
		pushUserdata<Item>(L, bedItem);
		setItemMetatable(L, -1, bedItem);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int HouseFunctions::luaHouseGetBedCount(lua_State* L) {
	// house:getBedCount()
	if (const auto &house = getUserdataShared<House>(L, 1)) {
		lua_pushnumber(L, house->getBedCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int HouseFunctions::luaHouseGetDoors(lua_State* L) {
	// house:getDoors()
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto &doors = house->getDoors();
	lua_createtable(L, doors.size(), 0);

	int index = 0;
	for (const auto &door : doors) {
		pushUserdata<Item>(L, door);
		setItemMetatable(L, -1, door);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int HouseFunctions::luaHouseGetDoorCount(lua_State* L) {
	// house:getDoorCount()
	if (const auto &house = getUserdataShared<House>(L, 1)) {
		lua_pushnumber(L, house->getDoors().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int HouseFunctions::luaHouseGetDoorIdByPosition(lua_State* L) {
	// house:getDoorIdByPosition(position)
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto &door = house->getDoorByPosition(getPosition(L, 2));
	if (door) {
		lua_pushnumber(L, door->getDoorId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int HouseFunctions::luaHouseGetTiles(lua_State* L) {
	// house:getTiles()
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto &tiles = house->getTiles();
	lua_newtable(L);

	int index = 0;
	for (const auto &tile : tiles) {
		pushUserdata<Tile>(L, tile);
		setMetatable(L, -1, "Tile");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int HouseFunctions::luaHouseGetItems(lua_State* L) {
	// house:getItems()
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto &tiles = house->getTiles();
	lua_newtable(L);

	int index = 0;
	for (const auto &tile : tiles) {
		const TileItemVector* itemVector = tile->getItemList();
		if (itemVector) {
			for (const auto &item : *itemVector) {
				pushUserdata<Item>(L, item);
				setItemMetatable(L, -1, item);
				lua_rawseti(L, -2, ++index);
			}
		}
	}
	return 1;
}

int HouseFunctions::luaHouseGetTileCount(lua_State* L) {
	// house:getTileCount()
	if (const auto &house = getUserdataShared<House>(L, 1)) {
		lua_pushnumber(L, house->getTiles().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int HouseFunctions::luaHouseCanEditAccessList(lua_State* L) {
	// house:canEditAccessList(listId, player)
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t listId = getNumber<uint32_t>(L, 2);

	const auto &player = getPlayer(L, 3);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	pushBoolean(L, house->canEditAccessList(listId, player));
	return 1;
}

int HouseFunctions::luaHouseGetAccessList(lua_State* L) {
	// house:getAccessList(listId)
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	std::string list;
	const uint32_t listId = getNumber<uint32_t>(L, 2);
	if (house->getAccessList(listId, list)) {
		pushString(L, list);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int HouseFunctions::luaHouseSetAccessList(lua_State* L) {
	// house:setAccessList(listId, list)
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t listId = getNumber<uint32_t>(L, 2);
	const std::string &list = getString(L, 3);
	house->setAccessList(listId, list);
	pushBoolean(L, true);
	return 1;
}

int HouseFunctions::luaHouseKickPlayer(lua_State* L) {
	// house:kickPlayer(player, targetPlayer)
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto &player = getPlayer(L, 2);
	if (!player) {
		reportErrorFunc("Player is nullptr");
		return 1;
	}

	const auto &targetPlayer = getPlayer(L, 3);
	if (!targetPlayer) {
		reportErrorFunc("Target player is nullptr");
		return 1;
	}

	pushBoolean(L, house->kickPlayer(player, targetPlayer));
	return 1;
}

int HouseFunctions::luaHouseIsInvited(lua_State* L) {
	// house:isInvited(player)
	const auto &house = getUserdataShared<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto &player = getPlayer(L, 2);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	pushBoolean(L, house->isInvited(player));
	return 1;
}
