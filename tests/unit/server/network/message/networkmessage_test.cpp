#include "pch.hpp"

#include <gtest/gtest.h>

#include "lib/logging/in_memory_logger.hpp"

#include "server/network/message/networkmessage.hpp"
#include "utils/tools.hpp"

TEST(NetworkMessageTest, AddByteAndGetByte) {
	NetworkMessage msg;
	uint8_t byteToAdd = 100;
	msg.addByte(byteToAdd);
	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	auto byte = msg.getByte();
	EXPECT_EQ(byteToAdd, byte);
}

TEST(NetworkMessageTest, AddStringAndGetString) {
	NetworkMessage msg;
	std::string testStr = "TestString";
	msg.addString(testStr);
	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	std::string retrievedStr = msg.getString();
	EXPECT_EQ(testStr, retrievedStr);
}

TEST(NetworkMessageTest, AddStringHandlesEmptyString) {
	NetworkMessage msg;
	msg.addString("");
	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	EXPECT_EQ(std::string {}, msg.getString());
}

TEST(NetworkMessageTest, AddStringFailsWithOversizedString) {
	NetworkMessage msg;
	std::string oversizedString(NETWORKMESSAGE_MAXSIZE + 1, 'a');
	msg.addString(oversizedString);
	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	EXPECT_EQ(std::string {}, msg.getString());
}

TEST(NetworkMessageTest, CanAddReturnsFalseWhenExceedingMaxSize) {
	NetworkMessage msg;
	EXPECT_FALSE(msg.canAdd(NETWORKMESSAGE_MAXSIZE));
	EXPECT_FALSE(msg.canAdd(NETWORKMESSAGE_MAXSIZE + 1));
}

TEST(NetworkMessageTest, AddDoubleAndGetDouble) {
	NetworkMessage msg;
	double testValue = 123.123;
	uint8_t precision = 3;
	msg.addDouble(testValue, precision);
	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	double retrievedValue = msg.getDouble();
	EXPECT_NEAR(testValue, retrievedValue, 1e-6);
}

TEST(NetworkMessageTest, AddPositionAndGetPosition) {
	NetworkMessage msg;
	Position pos { 100, 200, 7 };
	msg.addPosition(pos);
	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	Position retrievedPos = msg.getPosition();
	EXPECT_EQ(pos, retrievedPos);
}

TEST(NetworkMessageTest, ResetClearsBuffer) {
	NetworkMessage msg;
	msg.addByte(0x64);
	msg.reset();
	EXPECT_EQ(0, msg.getLength());
}

TEST(NetworkMessageTest, AppendMergesMessages) {
	NetworkMessage msg1;
	NetworkMessage msg2;

	msg1.addByte(1);
	msg1.addString("Hello");
	msg2.addByte(2);
	msg2.addString("World");

	msg1.append(msg2);
	msg1.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);

	uint8_t byte1 = msg1.getByte();
	EXPECT_EQ(1, byte1);
	std::string str1 = msg1.getString();
	EXPECT_EQ(std::string("Hello"), str1);
	uint8_t byte2 = msg1.getByte();
	EXPECT_EQ(2, byte2);
	std::string str2 = msg1.getString();
	EXPECT_EQ(std::string("World"), str2);
}

TEST(NetworkMessageTest, GetStringHandlesOutOfBoundsAccess) {
	NetworkMessage msg;
	std::string testStr = "Short";
	msg.addString(testStr);
	msg.setBufferPosition(msg.getBufferPosition() + 10);
	EXPECT_EQ(std::string {}, msg.getString());
}

TEST(NetworkMessageTest, DecodeHeaderDecodesHeader) {
	NetworkMessage msg;
	msg.addByte(0x12);
	msg.addByte(0x34);
	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	int32_t header = msg.decodeHeader();
	EXPECT_EQ(0x3412, header);
}

TEST(NetworkMessageTest, AddBytesValidatesContent) {
	NetworkMessage msg;
	std::string testData = "testBytes";
	msg.addBytes(testData.data(), testData.size());
	msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	auto buffer = msg.getBuffer();
	std::string extractedData(
		buffer + NetworkMessage::INITIAL_BUFFER_POSITION,
		buffer + NetworkMessage::INITIAL_BUFFER_POSITION + testData.size()
	);
	EXPECT_EQ(testData, extractedData);
}
