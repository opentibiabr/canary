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
	constexpr uint32_t kActiveIPGroupA = 0x0A000001u;
	constexpr uint32_t kActiveIPGroupB = 0x0A000002u;
	constexpr uint32_t kZeroIP = 0u;

	std::shared_ptr<Player> createTestPlayer(uint32_t guid, uint32_t ip, int32_t idleTime) {
		auto player = std::make_shared<Player>();
		player->setName(std::string("Player") + std::to_string(guid));
		player->setGUID(guid);
		player->setID();
		player->setTestIP(ip);
		player->setTestIdleTime(idleTime);
		return player;
	}
} // namespace

TEST(GamePlayerStatsTest, FiltersInactivePlayersAndCapsPerIpOnlineCount) {
	constexpr int32_t kIdleThresholdMs = 15 * 60 * 1000;
	Game game;

	game.addPlayer(createTestPlayer(1, kActiveIPGroupA, 0)); // 1
	game.addPlayer(createTestPlayer(2, kActiveIPGroupA, 0)); // 2
	game.addPlayer(createTestPlayer(3, kActiveIPGroupA, 0)); // 3
	game.addPlayer(createTestPlayer(4, kActiveIPGroupA, 0)); // 4
	game.addPlayer(createTestPlayer(5, kActiveIPGroupA, 0)); // 5
	game.addPlayer(createTestPlayer(6, kActiveIPGroupA, 0)); // 6 => cap at 4
	game.addPlayer(createTestPlayer(7, kActiveIPGroupB, 0)); // contributes as second unique IP
	game.addPlayer(createTestPlayer(10, kActiveIPGroupB, kIdleThresholdMs)); // boundary: still counted (<= threshold)
	game.addPlayer(createTestPlayer(8, kActiveIPGroupB, kIdleThresholdMs + 1)); // idle threshold breached
	game.addPlayer(createTestPlayer(9, kZeroIP, 0)); // zero IP excluded

	const auto playerStats = game.getPlayerStats();

	EXPECT_EQ(6u, playerStats.filteredOnlinePlayers);
	EXPECT_EQ(2u, playerStats.totalUniqueIPs);
}
