/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/connection/connection.hpp"

#include <asio/ip/address.hpp>

TEST(ConnectionIPTest, ReturnsLegacyIPv4ValueAndStringForIPv4Peer) {
	asio::io_service ioService;
	Connection connection(ioService, nullptr);
	const auto address = asio::ip::make_address("127.0.0.1");

	connection.setTestRemoteAddress(address);

	EXPECT_EQ(htonl(address.to_v4().to_uint()), connection.getIP());
	EXPECT_EQ("127.0.0.1", connection.getIPString());
}

TEST(ConnectionIPTest, ReturnsZeroLegacyIPAndStringForIPv6Peer) {
	asio::io_service ioService;
	Connection connection(ioService, nullptr);
	const auto address = asio::ip::make_address("::1");

	connection.setTestRemoteAddress(address);

	EXPECT_EQ(0u, connection.getIP());
	EXPECT_EQ("::1", connection.getIPString());
}
