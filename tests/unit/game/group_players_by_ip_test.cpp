/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/player.hpp"
#include "game/game.hpp"

namespace {
	std::shared_ptr<Player> makeGroupedIpTestPlayer(uint32_t guid, std::string ipAddress, int32_t idleTime) {
		auto player = std::make_shared<Player>();
		player->setName(std::string("GroupedIpPlayer") + std::to_string(guid));
		player->setGUID(guid);
		player->setID();
		player->setTestIPString(std::move(ipAddress));
		player->setTestIdleTime(idleTime);
		return player;
	}
} // namespace

TEST(GameGroupPlayersByIPTest, GroupsIPv4AndIPv6AndSkipsEmptyOrIdlePlayers) {
	constexpr int32_t idleThresholdMs = 15 * 60 * 1000;
	Game game;

	game.addPlayer(makeGroupedIpTestPlayer(1, "192.0.2.10", 0));
	game.addPlayer(makeGroupedIpTestPlayer(2, "192.0.2.10", idleThresholdMs));
	game.addPlayer(makeGroupedIpTestPlayer(3, "2001:db8::10", 0));
	game.addPlayer(makeGroupedIpTestPlayer(4, "", 0));
	game.addPlayer(makeGroupedIpTestPlayer(5, "198.51.100.10", idleThresholdMs + 1));

	const auto groupedPlayers = game.groupPlayersByIP();

	ASSERT_EQ(2u, groupedPlayers.size());
	ASSERT_TRUE(groupedPlayers.contains("192.0.2.10"));
	ASSERT_TRUE(groupedPlayers.contains("2001:db8::10"));
	EXPECT_EQ(2u, groupedPlayers.at("192.0.2.10").size());
	EXPECT_EQ(1u, groupedPlayers.at("2001:db8::10").size());
	EXPECT_FALSE(groupedPlayers.contains(""));
	EXPECT_FALSE(groupedPlayers.contains("198.51.100.10"));
}
