/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/network/network_message_functions.hpp"
#include "lua/functions/lua_functions_loader.hpp"
#include "server/network/message/networkmessage.hpp"

namespace {
	struct LuaNetworkMessageTestState {
		std::unique_ptr<lua_State, decltype(&lua_close)> L { luaL_newstate(), &lua_close };

		LuaNetworkMessageTestState() {
			NetworkMessageFunctions::init(L.get());
		}
	};

	void pushNetworkMessage(lua_State* L, const std::shared_ptr<NetworkMessage> &message) {
		Lua::pushUserdata<NetworkMessage>(L, message);
		Lua::setMetatable(L, -1, "NetworkMessage");
	}

	void pushGetUnreadBytesFunction(lua_State* L) {
		lua_getglobal(L, "NetworkMessage");
		lua_getfield(L, -1, "getUnreadBytes");
		lua_remove(L, -2);
	}
} // namespace

TEST(NetworkMessageFunctionsTest, GetUnreadBytesReturnsRemainingPayloadBytes) {
	LuaNetworkMessageTestState state;
	auto message = std::make_shared<NetworkMessage>();

	message->addByte(0xD0);
	message->add<uint16_t>(0x1234);
	message->addByte(0x01);
	message->setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);

	EXPECT_EQ(message->getLength(), 4);
	EXPECT_EQ(message->getBufferPosition(), NetworkMessage::INITIAL_BUFFER_POSITION);

	pushGetUnreadBytesFunction(state.L.get());
	pushNetworkMessage(state.L.get(), message);

	ASSERT_EQ(lua_pcall(state.L.get(), 1, 1, 0), LUA_OK) << lua_tostring(state.L.get(), -1);
	ASSERT_TRUE(lua_isnumber(state.L.get(), -1));
	EXPECT_EQ(static_cast<uint32_t>(lua_tointeger(state.L.get(), -1)), message->getLength());
	lua_pop(state.L.get(), 1);

	message->getByte();
	const auto consumedBytes = message->getBufferPosition() - NetworkMessage::INITIAL_BUFFER_POSITION;
	EXPECT_EQ(consumedBytes, 1);

	pushGetUnreadBytesFunction(state.L.get());
	pushNetworkMessage(state.L.get(), message);

	ASSERT_EQ(lua_pcall(state.L.get(), 1, 1, 0), LUA_OK) << lua_tostring(state.L.get(), -1);
	ASSERT_TRUE(lua_isnumber(state.L.get(), -1));
	EXPECT_EQ(static_cast<uint32_t>(lua_tointeger(state.L.get(), -1)), message->getLength() - consumedBytes);
	lua_pop(state.L.get(), 1);
}

TEST(NetworkMessageFunctionsTest, GetUnreadBytesClampsPastEndPositionToZero) {
	LuaNetworkMessageTestState state;
	auto message = std::make_shared<NetworkMessage>();

	message->addByte(0xD0);
	message->addByte(0x01);
	message->setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION + message->getLength() + 10);

	EXPECT_GT(message->getBufferPosition(), NetworkMessage::INITIAL_BUFFER_POSITION + message->getLength());

	pushGetUnreadBytesFunction(state.L.get());
	pushNetworkMessage(state.L.get(), message);

	ASSERT_EQ(lua_pcall(state.L.get(), 1, 1, 0), LUA_OK) << lua_tostring(state.L.get(), -1);
	ASSERT_TRUE(lua_isnumber(state.L.get(), -1));
	EXPECT_EQ(static_cast<uint32_t>(lua_tointeger(state.L.get(), -1)), 0);
	lua_pop(state.L.get(), 1);
}

TEST(NetworkMessageFunctionsTest, GetUnreadBytesReturnsNilForInvalidUserdata) {
	LuaNetworkMessageTestState state;

	pushGetUnreadBytesFunction(state.L.get());
	lua_pushnil(state.L.get());

	ASSERT_EQ(lua_pcall(state.L.get(), 1, 1, 0), LUA_OK) << lua_tostring(state.L.get(), -1);
	EXPECT_TRUE(lua_isnil(state.L.get(), -1));
	lua_pop(state.L.get(), 1);
}
