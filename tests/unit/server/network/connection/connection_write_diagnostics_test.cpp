/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 */

#include "server/network/connection/connection.hpp"
#include "server/network/message/outputmessage.hpp"
#include "lib/logging/in_memory_logger.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <gtest/gtest.h>
	#include <array>
	#include <iostream>
	#include <string>
	#include <thread>
	#include <vector>
#endif

class ConnectionWriteDiagnosticsTest : public ::testing::Test {
protected:
	void SetUp() override {
		logger = &dynamic_cast<InMemoryLogger &>(g_logger());
		logger->reset();
		connection = ConnectionManager::getInstance().createConnection(io, nullptr);
		asio::ip::tcp::acceptor acceptor(io, { asio::ip::address_v4::loopback(), 0 });
		peer.connect(acceptor.local_endpoint());
		acceptor.accept(connection->socket);
		peerPort = peer.local_endpoint().port();
		serverPort = acceptor.local_endpoint().port();
		connection->getIP();
	}

	void TearDown() override {
		connection->close(true);
		std::error_code error;
		peer.close(error);
		io.restart();
		io.poll();
		connection.reset();
	}

	OutputMessage_ptr queueMessage() {
		auto message = OutputMessagePool::getOutputMessage();
		message->addByte(0x31);
		message->addByte(0x72);
		message->addByte(0xA5);
		connection->messageQueue.push_back(message);
		return message;
	}

	void startWrite(const OutputMessage_ptr &message) {
		connection->internalSend(message);
		io.restart();
		io.run_for(std::chrono::seconds(2));
	}

	void closeBeforeWrite() {
		connection->close(true);
	}

	void expectDrained() {
		EXPECT_TRUE(connection->messageQueue.empty());
	}

	bool socketOpen() const {
		return connection->socket.is_open();
	}

	void closeGracefully() {
		connection->close();
	}

	void simulateReadFailure() {
		connection->parseHeader(asio::error::eof);
		connection->parseHeader(asio::error::operation_aborted);
	}

	void reportAbortedWrite() {
		connection->onWriteOperation(asio::error::operation_aborted, 1, 3, true);
	}

	std::vector<std::pair<std::string, std::string>> writeDiagnostics() const {
		std::vector<std::pair<std::string, std::string>> diagnostics;
		for (size_t index = 0; index < logger->logCount(); ++index) {
			auto entry = logger->getLogEntry(index);
			if (entry.second.find("[Connection::onWriteOperation]") != std::string::npos) {
				diagnostics.push_back(std::move(entry));
			}
		}
		return diagnostics;
	}

	asio::io_context io;
	asio::ip::tcp::socket peer { io };
	Connection_ptr connection;
	InMemoryLogger* logger = nullptr;
	uint16_t peerPort = 0;
	uint16_t serverPort = 0;
};

TEST_F(ConnectionWriteDiagnosticsTest, SuccessfulWritePreservesPayload) {
	startWrite(queueMessage());
	std::array<uint8_t, 3> received {};
	std::error_code error;
	ASSERT_EQ(3, peer.available(error));
	ASSERT_FALSE(error);
	ASSERT_EQ(3, asio::read(peer, asio::buffer(received), error));
	EXPECT_FALSE(error);
	EXPECT_EQ((std::array<uint8_t, 3> { 0x31, 0x72, 0xA5 }), received);
	expectDrained();
	EXPECT_TRUE(socketOpen());
	EXPECT_TRUE(writeDiagnostics().empty());
}

TEST_F(ConnectionWriteDiagnosticsTest, GracefulCloseDrainsQueuedWrite) {
	const auto message = queueMessage();
	closeGracefully();
	ASSERT_TRUE(socketOpen());
	startWrite(message);
	std::array<uint8_t, 3> received {};
	std::error_code error;
	ASSERT_EQ(3, peer.available(error));
	ASSERT_FALSE(error);
	ASSERT_EQ(3, asio::read(peer, asio::buffer(received), error));
	EXPECT_FALSE(error);
	EXPECT_EQ((std::array<uint8_t, 3> { 0x31, 0x72, 0xA5 }), received);
	expectDrained();
	EXPECT_FALSE(socketOpen());
	EXPECT_TRUE(writeDiagnostics().empty());
}

TEST_F(ConnectionWriteDiagnosticsTest, ClosedSocketRetainsPeerAndReportsLateWriteWithBoundedWarnings) {
	const auto message = queueMessage();
	closeBeforeWrite();
	startWrite(message);
	const auto diagnostics = writeDiagnostics();
	ASSERT_EQ(1, diagnostics.size());
	const auto &[level, diagnostic] = diagnostics.front();
	EXPECT_EQ("warning", level);
	const std::error_code badDescriptor = asio::error::bad_descriptor;
	EXPECT_NE(std::string::npos, diagnostic.find("code=" + std::to_string(badDescriptor.value())));
	EXPECT_NE(std::string::npos, diagnostic.find("category=" + std::string(badDescriptor.category().name())));
	EXPECT_NE(std::string::npos, diagnostic.find("connection_id="));
	EXPECT_NE(std::string::npos, diagnostic.find("remote=127.0.0.1:" + std::to_string(peerPort)));
	EXPECT_NE(std::string::npos, diagnostic.find("local_port=" + std::to_string(serverPort)));
	EXPECT_NE(std::string::npos, diagnostic.find("state=CONNECTION_STATE_CLOSED"));
	EXPECT_NE(std::string::npos, diagnostic.find("received_first=false"));
	EXPECT_NE(std::string::npos, diagnostic.find("socket_open_at_write=false, socket_open_now=false"));
	EXPECT_NE(std::string::npos, diagnostic.find("bytes_written=0/3, queued_messages=1"));
	EXPECT_NE(std::string::npos, diagnostic.find("closeBeforeWrite"));
	EXPECT_NE(std::string::npos, diagnostic.find("forced_close=true"));
	expectDrained();

	// A burst must not restore the original per-failure warning spam.
	for (int attempt = 0; attempt < 10; ++attempt) {
		startWrite(queueMessage());
	}
	size_t warnings = 0;
	for (const auto &[entryLevel, entryMessage] : writeDiagnostics()) {
		warnings += entryLevel == "warning";
	}
	EXPECT_EQ(1, warnings);
	std::cout << "Loopback diagnostic: " << diagnostic << '\n';

	// The next warning accounts for the suppressed burst. The first read failure
	// must also survive the cancellation callback that follows socket closure.
	std::this_thread::sleep_for(std::chrono::milliseconds(5100));
	simulateReadFailure();
	startWrite(queueMessage());
	const auto nextDiagnostics = writeDiagnostics();
	ASSERT_FALSE(nextDiagnostics.empty());
	const auto &[nextLevel, nextDiagnostic] = nextDiagnostics.back();
	EXPECT_EQ("warning", nextLevel);
	EXPECT_NE(std::string::npos, nextDiagnostic.find("suppressed_since_last_warning=10"));
	const std::error_code eof = asio::error::eof;
	EXPECT_NE(std::string::npos, nextDiagnostic.find("first_read_error=" + std::string(eof.category().name()) + ":" + std::to_string(eof.value())));
}

TEST_F(ConnectionWriteDiagnosticsTest, CancellationDoesNotProduceWarning) {
	queueMessage();
	reportAbortedWrite();
	for (const auto &[level, diagnostic] : writeDiagnostics()) {
		EXPECT_EQ("debug", level);
	}
	expectDrained();
	EXPECT_FALSE(socketOpen());
}
