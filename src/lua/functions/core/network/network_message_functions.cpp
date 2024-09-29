/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/network/network_message_functions.hpp"
#include "creatures/players/player.hpp"
#include "server/network/protocol/protocolstatus.hpp"

int NetworkMessageFunctions::luaNetworkMessageCreate(lua_State* L) {
	// NetworkMessage()
	pushUserdata<NetworkMessage>(L, std::make_shared<NetworkMessage>());
	setMetatable(L, -1, "NetworkMessage");
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageGetByte(lua_State* L) {
	// networkMessage:getByte()
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->getByte());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageGetU16(lua_State* L) {
	// networkMessage:getU16()
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<uint16_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageGetU32(lua_State* L) {
	// networkMessage:getU32()
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<uint32_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageGetU64(lua_State* L) {
	// networkMessage:getU64()
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<uint64_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageGetString(lua_State* L) {
	// networkMessage:getString()
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		pushString(L, message->getString());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageGetPosition(lua_State* L) {
	// networkMessage:getPosition()
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		pushPosition(L, message->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddByte(lua_State* L) {
	// networkMessage:addByte(number)
	uint8_t number = getNumber<uint8_t>(L, 2);
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->addByte(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddU16(lua_State* L) {
	// networkMessage:addU16(number)
	uint16_t number = getNumber<uint16_t>(L, 2);
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<uint16_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddU32(lua_State* L) {
	// networkMessage:addU32(number)
	uint32_t number = getNumber<uint32_t>(L, 2);
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<uint32_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddU64(lua_State* L) {
	// networkMessage:addU64(number)
	uint64_t number = getNumber<uint64_t>(L, 2);
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<uint64_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAdd8(lua_State* L) {
	// networkMessage:add8(number)
	auto number = getNumber<int8_t>(L, 2);
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<int8_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAdd16(lua_State* L) {
	// networkMessage:add16(number)
	auto number = getNumber<int16_t>(L, 2);
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<int16_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAdd32(lua_State* L) {
	// networkMessage:add32(number)
	auto number = getNumber<int32_t>(L, 2);
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<int32_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAdd64(lua_State* L) {
	// networkMessage:add64(number)
	auto number = getNumber<int64_t>(L, 2);
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->add<int64_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddString(lua_State* L) {
	// networkMessage:addString(string, function)
	const std::string &string = getString(L, 2);
	const std::string &function = getString(L, 3);
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->addString(string, std::source_location::current(), function);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddPosition(lua_State* L) {
	// networkMessage:addPosition(position)
	const Position &position = getPosition(L, 2);
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->addPosition(position);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddDouble(lua_State* L) {
	// networkMessage:addDouble(number)
	double number = getNumber<double>(L, 2);
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->addDouble(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageAddItem(lua_State* L) {
	// networkMessage:addItem(item, player)
	std::shared_ptr<Item> item = getUserdataShared<Item>(L, 2);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Player> player = getUserdataShared<Player>(L, 3);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message && player->client) {
		player->client->AddItem(*message, item);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageReset(lua_State* L) {
	// networkMessage:reset()
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->reset();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageSkipBytes(lua_State* L) {
	// networkMessage:skipBytes(number)
	int16_t number = getNumber<int16_t>(L, 2);
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (message) {
		message->skipBytes(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NetworkMessageFunctions::luaNetworkMessageSendToPlayer(lua_State* L) {
	// networkMessage:sendToPlayer(player)
	const auto &message = getUserdataShared<NetworkMessage>(L, 1);
	if (!message) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Player> player = getPlayer(L, 2);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	player->sendNetworkMessage(*message);
	pushBoolean(L, true);
	return 1;
}
