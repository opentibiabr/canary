/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/network/network_message_functions.hpp"

#include "server/network/protocol/protocolgame.hpp"
#include "creatures/players/player.hpp"
#include "server/network/protocol/protocolstatus.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void NetworkMessageFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "NetworkMessage", "", NetworkMessageFunctions::luaNetworkMessageCreate);
	Lua::registerMetaMethod(L, "NetworkMessage", "__eq", Lua::luaUserdataCompare);
	Lua::registerMethod(L, "NetworkMessage", "delete", Lua::luaGarbageCollection);

	Lua::registerMethod(L, "NetworkMessage", "getByte", NetworkMessageFunctions::luaNetworkMessageGetByte);
	Lua::registerMethod(L, "NetworkMessage", "getU16", NetworkMessageFunctions::luaNetworkMessageGetU16);
	Lua::registerMethod(L, "NetworkMessage", "getU32", NetworkMessageFunctions::luaNetworkMessageGetU32);
	Lua::registerMethod(L, "NetworkMessage", "getU64", NetworkMessageFunctions::luaNetworkMessageGetU64);
	Lua::registerMethod(L, "NetworkMessage", "getString", NetworkMessageFunctions::luaNetworkMessageGetString);
	Lua::registerMethod(L, "NetworkMessage", "getPosition", NetworkMessageFunctions::luaNetworkMessageGetPosition);

	Lua::registerMethod(L, "NetworkMessage", "addByte", NetworkMessageFunctions::luaNetworkMessageAddByte);
	Lua::registerMethod(L, "NetworkMessage", "addU16", NetworkMessageFunctions::luaNetworkMessageAddU16);
	Lua::registerMethod(L, "NetworkMessage", "addU32", NetworkMessageFunctions::luaNetworkMessageAddU32);
	Lua::registerMethod(L, "NetworkMessage", "addU64", NetworkMessageFunctions::luaNetworkMessageAddU64);
	Lua::registerMethod(L, "NetworkMessage", "add8", NetworkMessageFunctions::luaNetworkMessageAdd8);
	Lua::registerMethod(L, "NetworkMessage", "add16", NetworkMessageFunctions::luaNetworkMessageAdd16);
	Lua::registerMethod(L, "NetworkMessage", "add32", NetworkMessageFunctions::luaNetworkMessageAdd32);
	Lua::registerMethod(L, "NetworkMessage", "add64", NetworkMessageFunctions::luaNetworkMessageAdd64);
	Lua::registerMethod(L, "NetworkMessage", "addString", NetworkMessageFunctions::luaNetworkMessageAddString);
	Lua::registerMethod(L, "NetworkMessage", "addPosition", NetworkMessageFunctions::luaNetworkMessageAddPosition);
	Lua::registerMethod(L, "NetworkMessage", "addDouble", NetworkMessageFunctions::luaNetworkMessageAddDouble);
	Lua::registerMethod(L, "NetworkMessage", "addItem", NetworkMessageFunctions::luaNetworkMessageAddItem);

	Lua::registerMethod(L, "NetworkMessage", "reset", NetworkMessageFunctions::luaNetworkMessageReset);
	Lua::registerMethod(L, "NetworkMessage", "skipBytes", NetworkMessageFunctions::luaNetworkMessageSkipBytes);
	Lua::registerMethod(L, "NetworkMessage", "sendToPlayer", NetworkMessageFunctions::luaNetworkMessageSendToPlayer);
}

int NetworkMessageFunctions::luaNetworkMessageCreate(lua_State* L) {
	// NetworkMessage()
	Lua::pushUserdata<NetworkMessage>(L, std::make_shared<NetworkMessage>());
	Lua::setMetatable(L, -1, "NetworkMessage");
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageGetByte(lua_State* L) {
	// networkMessage:getByte()
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->getByte());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageGetU16(lua_State* L) {
	// networkMessage:getU16()
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<uint16_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageGetU32(lua_State* L) {
	// networkMessage:getU32()
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<uint32_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageGetU64(lua_State* L) {
	// networkMessage:getU64()
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<uint64_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageGetString(lua_State* L) {
	// networkMessage:Lua::getString()
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		Lua::pushString(L, message->getString());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageGetPosition(lua_State* L) {
	// networkMessage:Lua::getPosition()
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		Lua::pushPosition(L, message->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddByte(lua_State* L) {
	// networkMessage:addByte(number)
	const uint8_t number = Lua::getNumber<uint8_t>(L, 2);
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->addByte(number);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddU16(lua_State* L) {
	// networkMessage:addU16(number)
	const uint16_t number = Lua::getNumber<uint16_t>(L, 2);
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<uint16_t>(number);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddU32(lua_State* L) {
	// networkMessage:addU32(number)
	const uint32_t number = Lua::getNumber<uint32_t>(L, 2);
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<uint32_t>(number);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddU64(lua_State* L) {
	// networkMessage:addU64(number)
	const uint64_t number = Lua::getNumber<uint64_t>(L, 2);
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<uint64_t>(number);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAdd8(lua_State* L) {
	// networkMessage:add8(number)
	const auto number = Lua::getNumber<int8_t>(L, 2);
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<int8_t>(number);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAdd16(lua_State* L) {
	// networkMessage:add16(number)
	const auto number = Lua::getNumber<int16_t>(L, 2);
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<int16_t>(number);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAdd32(lua_State* L) {
	// networkMessage:add32(number)
	const auto number = Lua::getNumber<int32_t>(L, 2);
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<int32_t>(number);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAdd64(lua_State* L) {
	// networkMessage:add64(number)
	const auto number = Lua::getNumber<int64_t>(L, 2);
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<int64_t>(number);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddString(lua_State* L) {
	// networkMessage:addString(string, function)
	const std::string &string = Lua::getString(L, 2);
	const std::string &function = Lua::getString(L, 3);
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->addString(string, std::source_location::current(), function);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddPosition(lua_State* L) {
	// networkMessage:addPosition(position)
	const Position &position = Lua::getPosition(L, 2);
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->addPosition(position);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddDouble(lua_State* L) {
	// networkMessage:addDouble(number)
	const double number = Lua::getNumber<double>(L, 2);
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->addDouble(number);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddItem(lua_State* L) {
	// networkMessage:addItem(item, player)
	const auto &item = Lua::getUserdataShared<Item>(L, 2);
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const auto &player = Lua::getUserdataShared<Player>(L, 3);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message && player->client) {
		player->client->AddItem(*message, item);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageReset(lua_State* L) {
	// networkMessage:reset()
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->reset();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageSkipBytes(lua_State* L) {
	// networkMessage:skipBytes(number)
	const int16_t number = Lua::getNumber<int16_t>(L, 2);
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->skipBytes(number);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageSendToPlayer(lua_State* L) {
	// networkMessage:sendToPlayer(player)
	const auto &message = Lua::getUserdataShared<NetworkMessage>(L, 1);
	if (!message) {
		lua_pushnil(L);
		return 1;
	}

	const auto &player = Lua::getPlayer(L, 2);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	player->sendNetworkMessage(*message);
	Lua::pushBoolean(L, true);
	return 1;
}
