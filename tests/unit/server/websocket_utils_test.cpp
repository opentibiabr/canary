#include "server/network/websocket/websocket_utils.hpp"

#include <gtest/gtest.h>

TEST(WebSocketUtils, Rfc6455AcceptKey) {
	const auto accept = websocket_utils::computeAcceptKey("dGhlIHNhbXBsZSBub25jZQ==");
	EXPECT_EQ(accept, "s3pPLMBiTxaQ9kYGzzhZRbK+xOo=");
}

TEST(WebSocketUtils, ParseUpgradeRequestRootPath) {
	const std::string request =
		"GET / HTTP/1.1\r\n"
		"Host: localhost:7174\r\n"
		"Upgrade: websocket\r\n"
		"Connection: Upgrade\r\n"
		"Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\n"
		"Sec-WebSocket-Version: 13\r\n"
		"\r\n";

	std::string key;
	std::string path;
	ASSERT_TRUE(websocket_utils::parseUpgradeRequest(request, key, path));
	EXPECT_EQ(path, "/");
	EXPECT_EQ(key, "dGhlIHNhbXBsZSBub25jZQ==");
}

TEST(WebSocketUtils, RejectNonRootPath) {
	const std::string request =
		"GET /game HTTP/1.1\r\n"
		"Host: localhost:7174\r\n"
		"Upgrade: websocket\r\n"
		"Connection: Upgrade\r\n"
		"Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\n"
		"Sec-WebSocket-Version: 13\r\n"
		"\r\n";

	std::string key;
	std::string path;
	ASSERT_TRUE(websocket_utils::parseUpgradeRequest(request, key, path));
	EXPECT_EQ(path, "/game");
}

TEST(WebSocketUtils, RoundTripBinaryFrame) {
	const uint8_t payload[] = { 0x01, 0x02, 0x03, 0x04 };
	const auto frame = websocket_utils::buildFrame(0x2, payload, sizeof(payload));
	ASSERT_GE(frame.size(), 2u);
	EXPECT_EQ(frame[0], 0x82);

	// Server frames are unmasked; decodeFrame requires client masking.
	std::vector<uint8_t> clientFrame = frame;
	clientFrame[1] = static_cast<uint8_t>(clientFrame[1] | 0x80);
	const uint8_t mask[4] = { 0x11, 0x22, 0x33, 0x44 };
	clientFrame.insert(clientFrame.begin() + 2, mask, mask + 4);
	for (size_t i = 0; i < sizeof(payload); ++i) {
		clientFrame[6 + i] ^= mask[i % 4];
	}

	const auto decoded = websocket_utils::decodeFrame(clientFrame.data(), clientFrame.size());
	EXPECT_EQ(decoded.result, websocket_utils::FrameResult::Binary);
	ASSERT_EQ(decoded.payload.size(), sizeof(payload));
	EXPECT_EQ(decoded.payload[0], 0x01);
	EXPECT_EQ(decoded.payload[3], 0x04);
}
