/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <gtest/gtest.h>

#include "creatures/players/player.hpp"

TEST(PlayerIPTest, DetectsIPv4AddressFamily) {
	Player player;
	player.setTestIPString("192.0.2.1");

	EXPECT_EQ("192.0.2.1", player.getIPString());
	EXPECT_EQ("192.0.2.1", player.getIPAddress());
	EXPECT_EQ(4, player.getIPFamily());
	EXPECT_TRUE(player.isIPv4());
	EXPECT_FALSE(player.isIPv6());
}

TEST(PlayerIPTest, DetectsIPv6AddressFamily) {
	Player player;
	player.setTestIPString("2001:db8::1");

	EXPECT_EQ("2001:db8::1", player.getIPString());
	EXPECT_EQ("2001:db8::1", player.getIPAddress());
	EXPECT_EQ(6, player.getIPFamily());
	EXPECT_FALSE(player.isIPv4());
	EXPECT_TRUE(player.isIPv6());
}

TEST(PlayerIPTest, ReturnsEmptyFamilyWithoutClientOrTestAddress) {
	Player player;

	EXPECT_TRUE(player.getIPString().empty());
	EXPECT_TRUE(player.getIPAddress().empty());
	EXPECT_EQ(0, player.getIPFamily());
	EXPECT_FALSE(player.isIPv4());
	EXPECT_FALSE(player.isIPv6());
}

TEST(PlayerIPTest, LegacyTestIPv4OverrideFeedsStringAndFamilyHelpers) {
	Player player;
	player.setTestIP(0x010200C0u);

	EXPECT_EQ(0x010200C0u, player.getIP());
	EXPECT_EQ("192.0.2.1", player.getIPString());
	EXPECT_EQ("192.0.2.1", player.getIPAddress());
	EXPECT_EQ(4, player.getIPFamily());
	EXPECT_TRUE(player.isIPv4());
	EXPECT_FALSE(player.isIPv6());
}
