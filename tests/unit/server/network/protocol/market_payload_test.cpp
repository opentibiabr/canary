#include "pch.hpp"

#include <gtest/gtest.h>

#include "server/network/message/networkmessage.hpp"
#include "server/network/protocol/market_payload.hpp"

namespace {
	constexpr uint8_t NEXT_PACKET_SENTINEL = 0xA5;
}

TEST(MarketPayloadTest, SaturatesLockerAmountsAndPreservesNextPacketBoundary) {
	constexpr std::array<uint32_t, 4> amounts = {
		0,
		1,
		std::numeric_limits<uint16_t>::max(),
		static_cast<uint32_t>(std::numeric_limits<uint16_t>::max()) + 1,
	};

	NetworkMessage msg;
	for (const auto amount : amounts) {
		MarketPayload::writeLockerAmount(msg, amount);
	}
	msg.addByte(NEXT_PACKET_SENTINEL);

	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	EXPECT_EQ(msg.get<uint16_t>(), 0);
	EXPECT_EQ(msg.get<uint16_t>(), 1);
	EXPECT_EQ(msg.get<uint16_t>(), std::numeric_limits<uint16_t>::max());
	EXPECT_EQ(msg.get<uint16_t>(), std::numeric_limits<uint16_t>::max());
	EXPECT_EQ(msg.getByte(), NEXT_PACKET_SENTINEL);
	EXPECT_FALSE(msg.canRead(1));
}

TEST(MarketPayloadTest, WritesLockerRecordsWithExactCountAndBoundary) {
	constexpr std::array entries {
		MarketPayload::LockerEntry { .itemId = 100, .tier = 0, .amount = 1, .hasTier = false },
		MarketPayload::LockerEntry { .itemId = 200, .tier = 7, .amount = std::numeric_limits<uint32_t>::max(), .hasTier = true },
	};

	NetworkMessage msg;
	MarketPayload::LockerWriter writer(msg);
	ASSERT_TRUE(writer.valid());
	for (const auto &entry : entries) {
		ASSERT_EQ(writer.add(entry), MarketPayload::AddLockerResult::Added);
	}
	writer.finish();
	msg.addByte(NEXT_PACKET_SENTINEL);

	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	ASSERT_EQ(msg.get<uint16_t>(), entries.size());
	EXPECT_EQ(msg.get<uint16_t>(), entries[0].itemId);
	EXPECT_EQ(msg.get<uint16_t>(), entries[0].amount);
	EXPECT_EQ(msg.get<uint16_t>(), entries[1].itemId);
	EXPECT_EQ(msg.getByte(), entries[1].tier);
	EXPECT_EQ(msg.get<uint16_t>(), std::numeric_limits<uint16_t>::max());
	EXPECT_EQ(msg.getByte(), NEXT_PACKET_SENTINEL);
	EXPECT_FALSE(msg.canRead(1));
}

TEST(MarketPayloadTest, WritesEmptyLockerSnapshotAndPreservesNextPacketBoundary) {
	NetworkMessage msg;
	MarketPayload::LockerWriter writer(msg);
	ASSERT_TRUE(writer.valid());
	writer.finish();
	msg.addByte(NEXT_PACKET_SENTINEL);

	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	EXPECT_EQ(msg.get<uint16_t>(), 0);
	EXPECT_EQ(msg.getByte(), NEXT_PACKET_SENTINEL);
	EXPECT_FALSE(msg.canRead(1));
}

TEST(MarketPayloadTest, StopsLockerSnapshotBeforeCapacityWithoutPartialRecords) {
	constexpr MarketPayload::LockerEntry entry { .itemId = 100, .tier = 0, .amount = 1, .hasTier = false };
	NetworkMessage msg;
	MarketPayload::LockerWriter writer(msg);
	ASSERT_TRUE(writer.valid());

	auto result = MarketPayload::AddLockerResult::Added;
	while ((result = writer.add(entry)) == MarketPayload::AddLockerResult::Added) {
	}
	EXPECT_EQ(result, MarketPayload::AddLockerResult::MessageFull);
	ASSERT_GT(writer.count(), 10000);
	writer.finish();
	ASSERT_TRUE(msg.canAdd(1));
	msg.addByte(NEXT_PACKET_SENTINEL);

	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	const auto count = msg.get<uint16_t>();
	EXPECT_EQ(count, writer.count());
	for (uint16_t index = 0; index < count; ++index) {
		EXPECT_EQ(msg.get<uint16_t>(), entry.itemId);
		EXPECT_EQ(msg.get<uint16_t>(), entry.amount);
	}
	EXPECT_EQ(msg.getByte(), NEXT_PACKET_SENTINEL);
	EXPECT_FALSE(msg.canRead(1));
}

TEST(MarketPayloadTest, StopsTieredLockerSnapshotAtAnExactRecordBoundary) {
	constexpr MarketPayload::LockerEntry entry { .itemId = 200, .tier = 7, .amount = 1, .hasTier = true };
	NetworkMessage msg;
	MarketPayload::LockerWriter writer(msg);
	ASSERT_TRUE(writer.valid());

	auto result = MarketPayload::AddLockerResult::Added;
	while ((result = writer.add(entry)) == MarketPayload::AddLockerResult::Added) {
	}
	EXPECT_EQ(result, MarketPayload::AddLockerResult::MessageFull);
	ASSERT_GT(writer.count(), 10000);
	writer.finish();

	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	const auto count = msg.get<uint16_t>();
	EXPECT_EQ(count, writer.count());
	for (uint16_t index = 0; index < count; ++index) {
		EXPECT_EQ(msg.get<uint16_t>(), entry.itemId);
		EXPECT_EQ(msg.getByte(), entry.tier);
		EXPECT_EQ(msg.get<uint16_t>(), entry.amount);
	}
	EXPECT_FALSE(msg.canRead(1));
}
