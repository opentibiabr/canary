/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class HouseFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "House", "", HouseFunctions::luaHouseCreate);
		registerMetaMethod(L, "House", "__eq", HouseFunctions::luaUserdataCompare);

		registerMethod(L, "House", "getId", HouseFunctions::luaHouseGetId);
		registerMethod(L, "House", "getName", HouseFunctions::luaHouseGetName);
		registerMethod(L, "House", "getTown", HouseFunctions::luaHouseGetTown);
		registerMethod(L, "House", "getExitPosition", HouseFunctions::luaHouseGetExitPosition);
		registerMethod(L, "House", "getRent", HouseFunctions::luaHouseGetRent);
		registerMethod(L, "House", "getPrice", HouseFunctions::luaHouseGetPrice);

		registerMethod(L, "House", "getOwnerGuid", HouseFunctions::luaHouseGetOwnerGuid);
		registerMethod(L, "House", "setHouseOwner", HouseFunctions::luaHouseSetHouseOwner);
		registerMethod(L, "House", "setNewOwnerGuid", HouseFunctions::luaHouseSetNewOwnerGuid);
		registerMethod(L, "House", "hasItemOnTile", HouseFunctions::luaHouseHasItemOnTile);
		registerMethod(L, "House", "hasNewOwnership", HouseFunctions::luaHouseHasNewOwnership);
		registerMethod(L, "House", "startTrade", HouseFunctions::luaHouseStartTrade);

		registerMethod(L, "House", "getBeds", HouseFunctions::luaHouseGetBeds);
		registerMethod(L, "House", "getBedCount", HouseFunctions::luaHouseGetBedCount);

		registerMethod(L, "House", "getDoors", HouseFunctions::luaHouseGetDoors);
		registerMethod(L, "House", "getDoorCount", HouseFunctions::luaHouseGetDoorCount);
		registerMethod(L, "House", "getDoorIdByPosition", HouseFunctions::luaHouseGetDoorIdByPosition);

		registerMethod(L, "House", "getTiles", HouseFunctions::luaHouseGetTiles);
		registerMethod(L, "House", "getItems", HouseFunctions::luaHouseGetItems);
		registerMethod(L, "House", "getTileCount", HouseFunctions::luaHouseGetTileCount);

		registerMethod(L, "House", "canEditAccessList", HouseFunctions::luaHouseCanEditAccessList);
		registerMethod(L, "House", "getAccessList", HouseFunctions::luaHouseGetAccessList);
		registerMethod(L, "House", "setAccessList", HouseFunctions::luaHouseSetAccessList);

		registerMethod(L, "House", "kickPlayer", HouseFunctions::luaHouseKickPlayer);
		registerMethod(L, "House", "isInvited", HouseFunctions::luaHouseIsInvited);
	}

private:
	static int luaHouseCreate(lua_State* L);

	static int luaHouseGetId(lua_State* L);
	static int luaHouseGetName(lua_State* L);
	static int luaHouseGetTown(lua_State* L);
	static int luaHouseGetExitPosition(lua_State* L);
	static int luaHouseGetRent(lua_State* L);
	static int luaHouseGetPrice(lua_State* L);

	static int luaHouseGetOwnerGuid(lua_State* L);
	static int luaHouseSetHouseOwner(lua_State* L);
	static int luaHouseSetNewOwnerGuid(lua_State* L);
	static int luaHouseHasItemOnTile(lua_State* L);
	static int luaHouseHasNewOwnership(lua_State* L);
	static int luaHouseStartTrade(lua_State* L);

	static int luaHouseGetBeds(lua_State* L);
	static int luaHouseGetBedCount(lua_State* L);

	static int luaHouseGetDoors(lua_State* L);
	static int luaHouseGetDoorCount(lua_State* L);
	static int luaHouseGetDoorIdByPosition(lua_State* L);

	static int luaHouseGetTiles(lua_State* L);
	static int luaHouseGetItems(lua_State* L);
	static int luaHouseGetTileCount(lua_State* L);

	static int luaHouseCanEditAccessList(lua_State* L);
	static int luaHouseGetAccessList(lua_State* L);
	static int luaHouseSetAccessList(lua_State* L);

	static int luaHouseKickPlayer(lua_State* L);
	static int luaHouseIsInvited(lua_State* L);
};
