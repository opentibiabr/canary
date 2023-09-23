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

class NetworkMessageFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "NetworkMessage", "", NetworkMessageFunctions::luaNetworkMessageCreate);
		registerMetaMethod(L, "NetworkMessage", "__eq", NetworkMessageFunctions::luaUserdataCompare);
		registerMethod(L, "NetworkMessage", "delete", luaGarbageCollection);

		registerMethod(L, "NetworkMessage", "getByte", NetworkMessageFunctions::luaNetworkMessageGetByte);
		registerMethod(L, "NetworkMessage", "getU16", NetworkMessageFunctions::luaNetworkMessageGetU16);
		registerMethod(L, "NetworkMessage", "getU32", NetworkMessageFunctions::luaNetworkMessageGetU32);
		registerMethod(L, "NetworkMessage", "getU64", NetworkMessageFunctions::luaNetworkMessageGetU64);
		registerMethod(L, "NetworkMessage", "getString", NetworkMessageFunctions::luaNetworkMessageGetString);
		registerMethod(L, "NetworkMessage", "getPosition", NetworkMessageFunctions::luaNetworkMessageGetPosition);

		registerMethod(L, "NetworkMessage", "addByte", NetworkMessageFunctions::luaNetworkMessageAddByte);
		registerMethod(L, "NetworkMessage", "addU16", NetworkMessageFunctions::luaNetworkMessageAddU16);
		registerMethod(L, "NetworkMessage", "addU32", NetworkMessageFunctions::luaNetworkMessageAddU32);
		registerMethod(L, "NetworkMessage", "addU64", NetworkMessageFunctions::luaNetworkMessageAddU64);
		registerMethod(L, "NetworkMessage", "add8", NetworkMessageFunctions::luaNetworkMessageAdd8);
		registerMethod(L, "NetworkMessage", "add16", NetworkMessageFunctions::luaNetworkMessageAdd16);
		registerMethod(L, "NetworkMessage", "add32", NetworkMessageFunctions::luaNetworkMessageAdd32);
		registerMethod(L, "NetworkMessage", "add64", NetworkMessageFunctions::luaNetworkMessageAdd64);
		registerMethod(L, "NetworkMessage", "addString", NetworkMessageFunctions::luaNetworkMessageAddString);
		registerMethod(L, "NetworkMessage", "addPosition", NetworkMessageFunctions::luaNetworkMessageAddPosition);
		registerMethod(L, "NetworkMessage", "addDouble", NetworkMessageFunctions::luaNetworkMessageAddDouble);
		registerMethod(L, "NetworkMessage", "addItem", NetworkMessageFunctions::luaNetworkMessageAddItem);

		registerMethod(L, "NetworkMessage", "reset", NetworkMessageFunctions::luaNetworkMessageReset);
		registerMethod(L, "NetworkMessage", "skipBytes", NetworkMessageFunctions::luaNetworkMessageSkipBytes);
		registerMethod(L, "NetworkMessage", "sendToPlayer", NetworkMessageFunctions::luaNetworkMessageSendToPlayer);
	}

private:
	static int luaNetworkMessageCreate(lua_State* L);

	static int luaNetworkMessageGetByte(lua_State* L);
	static int luaNetworkMessageGetU16(lua_State* L);
	static int luaNetworkMessageGetU32(lua_State* L);
	static int luaNetworkMessageGetU64(lua_State* L);
	static int luaNetworkMessageGetString(lua_State* L);
	static int luaNetworkMessageGetPosition(lua_State* L);

	static int luaNetworkMessageAddByte(lua_State* L);
	static int luaNetworkMessageAddU16(lua_State* L);
	static int luaNetworkMessageAddU32(lua_State* L);
	static int luaNetworkMessageAddU64(lua_State* L);
	static int luaNetworkMessageAdd8(lua_State* L);
	static int luaNetworkMessageAdd16(lua_State* L);
	static int luaNetworkMessageAdd32(lua_State* L);
	static int luaNetworkMessageAdd64(lua_State* L);
	static int luaNetworkMessageAddString(lua_State* L);
	static int luaNetworkMessageAddPosition(lua_State* L);
	static int luaNetworkMessageAddDouble(lua_State* L);
	static int luaNetworkMessageAddItem(lua_State* L);

	static int luaNetworkMessageReset(lua_State* L);
	static int luaNetworkMessageSkipBytes(lua_State* L);
	static int luaNetworkMessageSendToPlayer(lua_State* L);
};
