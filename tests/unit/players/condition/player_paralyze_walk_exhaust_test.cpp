/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/combat/condition.hpp"
#include "creatures/players/player.hpp"
#include "items/tile.hpp"
#include "utils/tools.hpp"

namespace {
	class TestParalyzeCondition final : public Condition {
	public:
		explicit TestParalyzeCondition(ConditionId_t conditionId, int32_t ticks = 5000) :
			Condition(conditionId, CONDITION_PARALYZE, ticks) { }

		void endCondition(std::shared_ptr<Creature>) override { }

		void addCondition(std::shared_ptr<Creature>, std::shared_ptr<Condition> condition) override {
			setTicks(condition->getTicks());
		}

		std::shared_ptr<Condition> clone() const override {
			return std::make_shared<TestParalyzeCondition>(getId(), getTicks());
		}
	};
}

class PlayerParalyzeWalkExhaustTest : public ::testing::Test {
protected:
	void SetUp() override {
		UPDATE_OTSYS_TIME();
	}

	static std::shared_ptr<Condition> createParalyzeCondition(ConditionId_t conditionId = CONDITIONID_DEFAULT) {
		auto condition = std::make_shared<TestParalyzeCondition>(conditionId);
		EXPECT_NE(nullptr, condition);
		return condition;
	}

	static std::shared_ptr<Player> createPlayerAt(const std::shared_ptr<Tile> &tile) {
		auto player = std::make_shared<Player>();
		player->setParent(tile);
		return player;
	}

	static void triggerBaseDiagonalStep(const std::shared_ptr<Player> &player, const std::shared_ptr<Tile> &oldTile, const std::shared_ptr<Tile> &newTile) {
		player->Creature::onCreatureMove(player, newTile, newTile->getPosition(), oldTile, oldTile->getPosition(), false);
	}

	static void triggerPlayerDiagonalStep(const std::shared_ptr<Player> &player, const std::shared_ptr<Tile> &oldTile, const std::shared_ptr<Tile> &newTile) {
		player->onCreatureMove(player, newTile, newTile->getPosition(), oldTile, oldTile->getPosition(), false);
	}

	static void expireWalkExhaust(const std::shared_ptr<Player> &player) {
		player->setWalkExhaust(-1);
	}
};

TEST_F(PlayerParalyzeWalkExhaustTest, IdleParalyzeDoesNotBlockPlayerActions) {
	auto oldTile = std::make_shared<DynamicTile>(Position(100, 100, 7));
	auto player = createPlayerAt(oldTile);

	ASSERT_TRUE(player->addCondition(createParalyzeCondition()));

	EXPECT_FALSE(player->walkExhausted());
}

TEST_F(PlayerParalyzeWalkExhaustTest, ParalyzedDiagonalMovementBlocksActionsDuringWalkDelay) {
	auto oldTile = std::make_shared<DynamicTile>(Position(100, 100, 7));
	auto newTile = std::make_shared<DynamicTile>(Position(101, 101, 7));
	auto player = createPlayerAt(oldTile);

	ASSERT_TRUE(player->addCondition(createParalyzeCondition()));
	EXPECT_FALSE(player->walkExhausted());

	triggerPlayerDiagonalStep(player, oldTile, newTile);

	EXPECT_TRUE(player->walkExhausted());

	expireWalkExhaust(player);
	EXPECT_FALSE(player->walkExhausted());
}

TEST_F(PlayerParalyzeWalkExhaustTest, ParalyzeAppliedDuringActiveStepBlocksActionsDuringWalkDelay) {
	auto oldTile = std::make_shared<DynamicTile>(Position(100, 100, 7));
	auto newTile = std::make_shared<DynamicTile>(Position(101, 101, 7));
	auto player = createPlayerAt(oldTile);

	triggerBaseDiagonalStep(player, oldTile, newTile);
	ASSERT_TRUE(player->addCondition(createParalyzeCondition()));

	EXPECT_TRUE(player->walkExhausted());

	expireWalkExhaust(player);
	EXPECT_FALSE(player->walkExhausted());
}

TEST_F(PlayerParalyzeWalkExhaustTest, CombatParalyzeRefreshDuringActiveStepBlocksActionsDuringWalkDelay) {
	auto oldTile = std::make_shared<DynamicTile>(Position(100, 100, 7));
	auto newTile = std::make_shared<DynamicTile>(Position(101, 101, 7));
	auto player = createPlayerAt(oldTile);

	ASSERT_TRUE(player->addCombatCondition(createParalyzeCondition(CONDITIONID_COMBAT)));
	EXPECT_FALSE(player->walkExhausted()); // idle combat paralyze must not block

	expireWalkExhaust(player);
	EXPECT_FALSE(player->walkExhausted());

	triggerBaseDiagonalStep(player, oldTile, newTile);
	ASSERT_TRUE(player->addCombatCondition(createParalyzeCondition(CONDITIONID_COMBAT)));

	EXPECT_TRUE(player->walkExhausted());

	expireWalkExhaust(player);
	EXPECT_FALSE(player->walkExhausted());
}
