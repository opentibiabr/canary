/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/player.hpp"
#include "creatures/players/components/player_storage.hpp"
#include "creatures/appearance/outfit/outfit.hpp"
#include "creatures/players/grouping/familiars.hpp"
#include "utils/const.hpp"

#include "lib/logging/in_memory_logger.hpp"

class PlayerStorageTest : public ::testing::Test {
protected:
	static void SetUpTestSuite() {
		InMemoryLogger::install(injector);
		DI::setTestContainer(&injector);
	}

private:
	inline static di::extension::injector<> injector {};
};

TEST_F(PlayerStorageTest, AddAndGetStorageValue) {
	auto player = std::make_shared<Player>();
	auto &storage = player->storage();
	const uint32_t key = 50000;

	storage.ingest({});
	storage.add(key, 42, true);

	EXPECT_TRUE(storage.has(key));
	EXPECT_EQ(42, storage.get(key));
	EXPECT_EQ(std::size_t { 1 }, storage.getStorageMap().size());
	auto delta = storage.delta();
	EXPECT_EQ(std::size_t { 1 }, delta.upserts.size());
	EXPECT_EQ(42, delta.upserts.at(key));
	storage.clearDirty();
}

TEST_F(PlayerStorageTest, RemoveStorageValue) {
	auto player = std::make_shared<Player>();
	auto &storage = player->storage();
	const uint32_t key = 50001;

	storage.ingest({});
	storage.add(key, 7, true);
	EXPECT_TRUE(storage.has(key));

	EXPECT_TRUE(storage.remove(key));
	EXPECT_FALSE(storage.has(key));
	auto delta = storage.delta();
	EXPECT_EQ(std::size_t { 1 }, delta.deletions.size());
	EXPECT_NE(delta.deletions.end(), std::ranges::find(delta.deletions, key));
	storage.clearDirty();
}

TEST_F(PlayerStorageTest, PassthroughRangeIsPersistedMounts) {
	auto player = std::make_shared<Player>();
	auto &storage = player->storage();
	const uint32_t key = PSTRG_MOUNTS_RANGE_START + 1;

	storage.ingest({});
	storage.add(key, 123, true);

	EXPECT_TRUE(storage.has(key));
	EXPECT_EQ(123, storage.get(key));
	EXPECT_EQ(std::size_t { 1 }, storage.getModifiedKeys().count(key));
}

TEST_F(PlayerStorageTest, PassthroughRangeIsPersistedWingEffectAuraShader) {
	auto player = std::make_shared<Player>();
	auto &storage = player->storage();

	storage.ingest({});
	constexpr std::array<uint32_t, 4> keys {
		PSTRG_WING_RANGE_START + 1,
		PSTRG_EFFECT_RANGE_START + 1,
		PSTRG_AURA_RANGE_START + 1,
		PSTRG_SHADER_RANGE_START + 1,
	};

	int value = 10;
	for (auto k : keys) {
		storage.add(k, value, true);
		value++;
		EXPECT_TRUE(storage.has(k));
		EXPECT_EQ(value - 1, storage.get(k));
		EXPECT_EQ(std::size_t { 1 }, storage.getModifiedKeys().count(k));
	}
}

TEST_F(PlayerStorageTest, OutfitsSideEffectOnlyViaPublicApi) {
	auto player = std::make_shared<Player>();
	auto &storage = player->storage();

	storage.ingest({});
	const auto beforeOutfits = player->getOutfits().size();
	const uint32_t key = PSTRG_OUTFITS_RANGE_START + 1;
	const uint32_t lookType = 50u;
	const uint8_t addons = 3u;

	storage.add(key, (lookType << 16) | addons, true);
	EXPECT_EQ(beforeOutfits + 1, player->getOutfits().size());
	const auto &outfits = player->getOutfits();
	auto it = std::ranges::find_if(outfits, [&](const auto &entry) { return entry.lookType == lookType; });
	ASSERT_NE(outfits.end(), it);
	EXPECT_EQ(addons, it->addons & addons);
}

TEST_F(PlayerStorageTest, FamiliarsSideEffectDoesNotPersistEntry) {
	auto player = std::make_shared<Player>();
	auto &storage = player->storage();

	storage.ingest({});
	const auto before = player->getFamiliars().size();
	const uint32_t key = PSTRG_FAMILIARS_RANGE_START + 1;
	const uint32_t lookType = 77u;

	storage.add(key, (lookType << 16), true);

	EXPECT_EQ(before + 1, player->getFamiliars().size());
	EXPECT_EQ(std::size_t { 0 }, storage.getStorageMap().size());
}

TEST_F(PlayerStorageTest, UnknownReservedKeyPersists) {
	auto player = std::make_shared<Player>();
	auto &storage = player->storage();

	storage.ingest({});
	const uint32_t key = PSTRG_RESERVED_RANGE_START + 900000u;

	storage.add(key, 321, true);

	EXPECT_TRUE(storage.has(key));
	EXPECT_EQ(321, storage.get(key));
}

TEST_F(PlayerStorageTest, GetReturnsMinusOneForMissingKey) {
	auto player = std::make_shared<Player>();
	auto &storage = player->storage();

	storage.ingest({});
	EXPECT_EQ(-1, storage.get(999999u));
	EXPECT_FALSE(storage.has(999999u));
}
