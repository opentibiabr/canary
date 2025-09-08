#include "pch.hpp"

#include <boost/ut.hpp>

#include "lib/logging/in_memory_logger.hpp"

#include "server/network/message/networkmessage.hpp"
#include "utils/tools.hpp"

using namespace boost::ut;

// Define a test suite for NetworkMessage
suite<"networkmessage"> networkMessageTest = [] {
	di::extension::injector<> injector {};
	DI::setTestContainer(&InMemoryLogger::install(injector));
	auto &logger = dynamic_cast<InMemoryLogger &>(injector.create<Logger &>());

	test("NetworkMessage::addByte and getByte") = [&]() {
		NetworkMessage msg;
		uint8_t byteToAdd = 100;
		msg.addByte(byteToAdd);
		msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
		auto byte = msg.getByte();
		expect(eq(byte, byteToAdd)) << "Expected: " << byteToAdd << ", Got: " << byte;
	};

	test("NetworkMessage::addString and getString") = [&]() {
		NetworkMessage msg;
		std::string testStr = "TestString";
		msg.addString(testStr);
		msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
		std::string retrievedStr = msg.getString();
		expect(eq(retrievedStr, testStr)) << "Expected: \"" << testStr << "\", Got: \"" << retrievedStr << "\"";
	};

	test("NetworkMessage::addString should handle empty string") = [&]() {
		NetworkMessage msg;
		msg.addString("");
		msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
		expect(eq(msg.getString(), std::string {})) << "Expected to retrieve an empty string";
	};

	test("NetworkMessage::addString should fail with oversized string") = [&]() {
		NetworkMessage msg;
		std::string oversizedString(NETWORKMESSAGE_MAXSIZE + 1, 'a');
		msg.addString(oversizedString);
		msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
		expect(eq(msg.getString(), std::string {})) << "Expected to retrieve an empty string due to oversized input";
	};

	test("NetworkMessage::canAdd should return false when exceeding max size") = [&]() {
		NetworkMessage msg;
		expect(not msg.canAdd(NETWORKMESSAGE_MAXSIZE)) << "Should have enough space in buffer";
		expect(not msg.canAdd(NETWORKMESSAGE_MAXSIZE + 1)) << "Should not be able to add data exceeding the max buffer size";
	};

	test("NetworkMessage::addDouble and getDouble") = [&]() {
		NetworkMessage msg;
		double testValue = 123.123;
		uint8_t precision = 3;
		msg.addDouble(testValue, precision);
		msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
		double retrievedValue = msg.getDouble();
		expect(abs(retrievedValue - testValue) < 1e-6) << "Expected: " << testValue << ", Got: " << retrievedValue;
	};

	test("NetworkMessage::addPosition and getPosition") = [&]() {
		NetworkMessage msg;
		Position pos { 100, 200, 7 };
		msg.addPosition(pos);
		msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
		Position retrievedPos = msg.getPosition();
		expect(eq(retrievedPos, pos)) << "Expected to retrieve the same position values";
	};

	test("NetworkMessage::reset should clear buffer") = [&]() {
		NetworkMessage msg;
		msg.addByte(0x64);
		msg.reset();
		expect(eq(msg.getLength(), 0)) << "Expected the message length to be zero after reset";
	};

	test("NetworkMessage::append should merge messages correctly") = [&]() {
		NetworkMessage msg1, msg2;

		// Adding initial byte and string to msg1
		msg1.addByte(1); // Byte value 1
		msg1.addString("Hello"); // String value "Hello"
		// Adding initial byte and string to msg2
		msg2.addByte(2); // Byte value 2
		msg2.addString("World"); // String value "World"
		// Append msg2 to msg1
		msg1.append(msg2);
		msg1.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION); // Reset read position to start
		// Verify the first byte (msg1)
		uint8_t byte1 = msg1.getByte();
		expect(eq(byte1, 1)) << "Expected the first byte of the first message (1)";
		// Verify the first string (msg1)
		std::string str1 = msg1.getString();
		expect(eq(str1, std::string("Hello"))) << "Expected the first string of the first message";
		// Verify the second byte (msg2)
		uint8_t byte2 = msg1.getByte();
		expect(eq(byte2, 2)) << "Expected the first byte of the second message (2)";
		// Verify the second string (msg2)
		std::string str2 = msg1.getString();
		expect(eq(str2, std::string("World"))) << "Expected the first string of the second message";
	};

	test("NetworkMessage::getString should handle out-of-bounds access safely") = [&]() {
		NetworkMessage msg;
		std::string testStr = "Short";
		msg.addString(testStr);

		// Move the position to simulate incomplete data read
		msg.setBufferPosition(msg.getBufferPosition() + 10);
		expect(eq(msg.getString(), std::string {})) << "Expected empty string due to out-of-bounds access";
	};

	test("NetworkMessage::decodeHeader should correctly decode the header") = [&]() {
		NetworkMessage msg;
		msg.addByte(0x12);
		msg.addByte(0x34);

		msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
		int32_t header = msg.decodeHeader();
		expect(eq(header, 0x3412)) << "Expected header to be decoded correctly";
	};

	test("NetworkMessage::addBytes and validate content") = [&]() {
		NetworkMessage msg;
		std::string testData = "testBytes";

		// Add bytes to the buffer
		msg.addBytes(testData.data(), testData.size());
		// Set buffer position to the initial position for reading the added data
		msg.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
		// Verify the content of the buffer before extracting the data
		auto buffer = msg.getBuffer();
		std::string extractedData(buffer + NetworkMessage::INITIAL_BUFFER_POSITION, buffer + NetworkMessage::INITIAL_BUFFER_POSITION + testData.size());
		// Check if the extracted data matches the added data
		expect(eq(extractedData, testData)) << "Expected the same bytes added";
	};
};
