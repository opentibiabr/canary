/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/game.hpp"

#include "game/game_definitions.hpp"

namespace {
	constexpr uint8_t entriesPerPage = 20;
	constexpr uint32_t entriesAcrossThreePages = 41;
} // namespace

TEST(HighscoresMultiPageRegressionTest, CalculatesTotalPagesForHighscoreRequestTypes) {
	for (const auto requestType : { HIGHSCORE_GETENTRIES, HIGHSCORE_OURRANK }) {
		(void)requestType;
		EXPECT_EQ(3, Game::calculateHighscorePages(entriesAcrossThreePages, entriesPerPage));
	}
}

TEST(HighscoresMultiPageRegressionTest, RoundsExactPageBoundaries) {
	EXPECT_EQ(2, Game::calculateHighscorePages(40, entriesPerPage));
}

TEST(HighscoresMultiPageRegressionTest, HandlesEmptyResults) {
	EXPECT_EQ(0, Game::calculateHighscorePages(0, entriesPerPage));
}
