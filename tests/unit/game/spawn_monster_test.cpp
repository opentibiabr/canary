/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monsters.hpp"
#include "creatures/monsters/spawns/spawn_monster.hpp"
#include "utils/tools.hpp"

#include <algorithm>
#include <random>
#include <vector>

namespace {
	std::shared_ptr<MonsterType> makeMonsterType(const std::string &name, bool isBoss = false) {
		auto monsterType = std::make_shared<MonsterType>(name);
		if (isBoss) {
			monsterType->info.bosstiaryClass = "spawn-block-test";
		}
		return monsterType;
	}

	std::shared_ptr<MonsterType> pickExpectedMonster(
		const std::vector<std::pair<std::shared_ptr<MonsterType>, uint32_t>> &orderedMonsterTypes,
		const uint32_t totalWeight,
		std::mt19937 &randomGenerator
	) {
		std::uniform_int_distribution<int32_t> randomDist;
		auto randomWeight = randomDist(randomGenerator, std::uniform_int_distribution<int32_t>::param_type(0, static_cast<int32_t>(totalWeight - 1)));

		for (const auto &[monsterType, weight] : orderedMonsterTypes) {
			if (randomWeight < static_cast<int32_t>(weight)) {
				return monsterType;
			}
			randomWeight -= static_cast<int32_t>(weight);
		}
		return nullptr;
	}
}

TEST(SpawnMonsterTest, ReturnsMonsterForSingleEntryRegardlessOfWeight) {
	spawnBlock_t spawnBlock;
	const auto bossMonster = makeMonsterType("boss", true);
	spawnBlock.monsterTypes.emplace(bossMonster, 0);

	EXPECT_EQ(bossMonster, spawnBlock.getMonsterType());
}

TEST(SpawnMonsterTest, ReturnsNullForZeroTotalWeight) {
	spawnBlock_t spawnBlock;
	spawnBlock.monsterTypes.emplace(makeMonsterType("rat"), 0);
	spawnBlock.monsterTypes.emplace(makeMonsterType("orc"), 0);

	EXPECT_FALSE(spawnBlock.getMonsterType());
}

TEST(SpawnMonsterTest, SelectsMonstersByWeightsWithControlledRng) {
	auto &randomGenerator = getRandomGenerator();
	const auto originalSeed = randomGenerator;
	randomGenerator.seed(1337);

	const auto lightMonster = makeMonsterType("light");
	const auto heavyMonster = makeMonsterType("heavy");
	const auto tinyMonster = makeMonsterType("tiny");
	const auto nullMonster = makeMonsterType("null");

	spawnBlock_t spawnBlock;
	spawnBlock.monsterTypes.emplace(lightMonster, 1);
	spawnBlock.monsterTypes.emplace(heavyMonster, 5);
	spawnBlock.monsterTypes.emplace(tinyMonster, 3);
	spawnBlock.monsterTypes.emplace(nullMonster, 0);

	std::vector<std::pair<std::shared_ptr<MonsterType>, uint32_t>> orderedMonsterTypes;
	for (const auto &[monsterType, weight] : spawnBlock.monsterTypes) {
		orderedMonsterTypes.emplace_back(monsterType, weight);
	}
	std::sort(orderedMonsterTypes.begin(), orderedMonsterTypes.end(), [](const auto &lhs, const auto &rhs) {
		return lhs.second > rhs.second;
	});

	uint32_t totalWeight = 0;
	for (const auto &monsterType : orderedMonsterTypes) {
		totalWeight += monsterType.second;
	}
	size_t heavyHits = 0;
	size_t lightHits = 0;
	size_t tinyHits = 0;
	size_t nullHits = 0;
	size_t missHits = 0;

	std::mt19937 expectedGenerator = randomGenerator;
	for (size_t i = 0; i < 1200; i++) {
		const auto selectedMonster = spawnBlock.getMonsterType();
		const auto expectedMonster = pickExpectedMonster(orderedMonsterTypes, totalWeight, expectedGenerator);
		EXPECT_EQ(expectedMonster, selectedMonster);

		if (selectedMonster == heavyMonster) {
			++heavyHits;
		} else if (selectedMonster == lightMonster) {
			++lightHits;
		} else if (selectedMonster == tinyMonster) {
			++tinyHits;
		} else if (selectedMonster == nullMonster) {
			++nullHits;
		} else {
			++missHits;
		}
	}

	EXPECT_EQ(0u, missHits);
	EXPECT_EQ(0u, nullHits);
	EXPECT_GT(heavyHits, 0u);
	EXPECT_GT(lightHits + tinyHits, 0u);

	randomGenerator = originalSeed;
}
