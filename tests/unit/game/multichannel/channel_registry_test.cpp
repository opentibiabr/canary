/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/channel_registry.hpp"

#include "injection_fixture.hpp"

#include <gtest/gtest.h>
#include <fstream>

namespace {
	ChannelInfo makeChannel(int32_t id, const std::string &name, bool enabled = true, bool maintenance = false, int32_t sortOrder = 0) {
		ChannelInfo info;
		info.id = id;
		info.name = name;
		info.pvpType = "pvp";
		info.externalHost = "127.0.0.1";
		info.gamePort = 7172 + id;
		info.statusPort = 7171;
		info.enabled = enabled;
		info.maintenance = maintenance;
		info.sortOrder = sortOrder;
		return info;
	}
} // namespace

class ChannelRegistryTest : public ::testing::Test {
protected:
	InjectionFixture fixture_ {};
};

TEST_F(ChannelRegistryTest, GetChannelReturnsNulloptWhenMissing) {
	g_channelRegistry().setChannelsForTesting({ makeChannel(1, "Channel 1") });
	EXPECT_FALSE(g_channelRegistry().getChannel(99).has_value());
	ASSERT_TRUE(g_channelRegistry().getChannel(1).has_value());
	EXPECT_EQ("Channel 1", g_channelRegistry().getChannel(1)->name);
}

TEST_F(ChannelRegistryTest, LoginListExcludesDisabledAndMaintenanceChannels) {
	g_channelRegistry().setChannelsForTesting({
		makeChannel(1, "Channel 1", /*enabled=*/true, /*maintenance=*/false, 0),
		makeChannel(2, "Channel 2", /*enabled=*/false, /*maintenance=*/false, 1),
		makeChannel(3, "Channel 3", /*enabled=*/true, /*maintenance=*/true, 2),
	});

	const auto selectable = g_channelRegistry().getLoginListChannels();
	ASSERT_EQ(1u, selectable.size());
	EXPECT_EQ(1, selectable.front().id);
}

TEST_F(ChannelRegistryTest, LoginListIsSortedBySortOrderThenId) {
	g_channelRegistry().setChannelsForTesting({
		makeChannel(3, "Channel 3", true, false, 5),
		makeChannel(1, "Channel 1", true, false, 10),
		makeChannel(2, "Channel 2", true, false, 5),
	});

	const auto selectable = g_channelRegistry().getLoginListChannels();
	ASSERT_EQ(3u, selectable.size());
	EXPECT_EQ(3, selectable[0].id); // sortOrder 5, lowest id first
	EXPECT_EQ(2, selectable[1].id); // sortOrder 5
	EXPECT_EQ(1, selectable[2].id); // sortOrder 10
}

TEST_F(ChannelRegistryTest, InvalidPvpTypeIsRejected) {
	ChannelInfo invalid = makeChannel(1, "Channel 1");
	invalid.pvpType = "free-for-all";
	EXPECT_FALSE(invalid.isValidPvpType());

	ChannelInfo valid = makeChannel(1, "Channel 1");
	for (const auto &type : { "no-pvp", "pvp", "pvp-enforced" }) {
		valid.pvpType = type;
		EXPECT_TRUE(valid.isValidPvpType());
	}
}

TEST_F(ChannelRegistryTest, SizeReflectsFullRegistryNotJustSelectable) {
	g_channelRegistry().setChannelsForTesting({
		makeChannel(1, "Channel 1", true),
		makeChannel(2, "Channel 2", false),
	});
	EXPECT_EQ(2u, g_channelRegistry().size());
	EXPECT_EQ(1u, g_channelRegistry().getLoginListChannels().size());
}

TEST(ChannelRegistryHashTest, SameContentProducesSameHash) {
	const std::string dataA = "the quick brown fox";
	const std::string dataB = "the quick brown fox";
	const auto hashA = ChannelRegistry::hashBytes(reinterpret_cast<const unsigned char*>(dataA.data()), dataA.size());
	const auto hashB = ChannelRegistry::hashBytes(reinterpret_cast<const unsigned char*>(dataB.data()), dataB.size());
	EXPECT_EQ(hashA, hashB);
	EXPECT_EQ(16u, hashA.size());
}

TEST(ChannelRegistryHashTest, DifferentContentProducesDifferentHash) {
	const std::string dataA = "channel one map data";
	const std::string dataB = "channel two map data";
	const auto hashA = ChannelRegistry::hashBytes(reinterpret_cast<const unsigned char*>(dataA.data()), dataA.size());
	const auto hashB = ChannelRegistry::hashBytes(reinterpret_cast<const unsigned char*>(dataB.data()), dataB.size());
	EXPECT_NE(hashA, hashB);
}

TEST(ChannelRegistryHashTest, ComputeFileHashMatchesInMemoryHashOfSameBytes) {
	const std::string path = "/tmp/channel_registry_hash_test_fixture.bin";
	const std::string contents = "otbm-fixture-bytes-for-hash-test";
	{
		std::ofstream file(path, std::ios::binary | std::ios::trunc);
		file << contents;
	}

	const auto fileHash = ChannelRegistry::computeFileHash(path);
	const auto memoryHash = ChannelRegistry::hashBytes(reinterpret_cast<const unsigned char*>(contents.data()), contents.size());
	EXPECT_EQ(memoryHash, fileHash);
	EXPECT_FALSE(fileHash.empty());

	std::remove(path.c_str());
}

TEST(ChannelRegistryHashTest, MissingFileReturnsEmptyHash) {
	EXPECT_TRUE(ChannelRegistry::computeFileHash("/tmp/does-not-exist-channel-registry-fixture.bin").empty());
}
