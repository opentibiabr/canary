/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 */

#include "server/network/connection/connection.hpp"
#include "server/network/message/outputmessage.hpp"
#include "server/network/protocol/protocol.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "lib/logging/in_memory_logger.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <gtest/gtest.h>
	#include <array>
	#include <iostream>
	#include <mutex>
	#include <string>
	#include <thread>
	#include <utility>
	#include <vector>
#endif

namespace {
	class LoopbackDispatcher final : public Dispatcher {
	public:
		LoopbackDispatcher() :
			LoopbackDispatcher(std::make_unique<ThreadPool>(g_logger(), 1)) { }

	private:
		explicit LoopbackDispatcher(std::unique_ptr<ThreadPool> pool) :
			Dispatcher(*pool), threadPool(std::move(pool)) { }

		std::unique_ptr<ThreadPool> threadPool;
	};

	class LoopbackProtocol final : public Protocol {
	public:
		explicit LoopbackProtocol(const Connection_ptr &connection) :
			Protocol(connection) {
			setRawMessages(true);
		}

		void onRecvFirstMessage(NetworkMessage &) override { }

		void onSendMessage(const OutputMessage_ptr &message) override {
			++preparedMessages;
			if (checkMessageOwnership) {
				// The queue and the preparing worker must each retain this message.
				EXPECT_EQ(2, message.use_count());
			}
			if (preparedMessages == closeOnPreparation) {
				getConnection()->close(true);
			}
			Protocol::onSendMessage(message);
		}

		void release() override {
			++releaseCount;
		}

		size_t preparedMessages = 0;
		size_t closeOnPreparation = 0;
		size_t releaseCount = 0;
		bool checkMessageOwnership = false;
	};
}

class ConnectionWriteDiagnosticsTest : public ::testing::Test {
protected:
	void SetUp() override {
		previousContainer = DI::getTestContainer();
		injector = std::make_unique<di::extension::injector<>>();
		InMemoryLogger::install(*injector);
		injector->install(di::bind<Dispatcher>.to<LoopbackDispatcher>().in(di::singleton));
		DI::setTestContainer(injector.get());
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
		DI::setTestContainer(previousContainer);
		injector.reset();
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

	void reportFailedWrite() {
		connection->onWriteOperation(asio::error::bad_descriptor, 0, 3, true);
	}

	void reportUnacceptedWrite() {
		const auto unaccepted = ConnectionManager::getInstance().createConnection(io, nullptr);
		unaccepted->onWriteOperation(asio::error::bad_descriptor, 0, 3, true);
	}

	std::shared_ptr<LoopbackProtocol> useQueuedProtocol(size_t closeOnPreparation = 0) {
		auto protocol = std::make_shared<LoopbackProtocol>(connection);
		protocol->closeOnPreparation = closeOnPreparation;
		connection->protocol = protocol;
		return protocol;
	}

	void queuePublicSend() {
		auto message = OutputMessagePool::getOutputMessage();
		message->addByte(0x31);
		message->addByte(0x72);
		message->addByte(0xA5);
		connection->send(message);
	}

	void runQueuedWork() {
		io.restart();
		io.run_for(std::chrono::seconds(2));
		for (const auto &[level, diagnostic] : writeDiagnostics()) {
			std::cout << "Queued-write diagnostic: " << diagnostic << '\n';
		}
	}

	void completeWriteAfterClose() {
		connection->onWriteOperation({}, 3, 3, true);
	}

	void executeProtocolRelease() {
		// Exercise the real admitted task synchronously; this fixture does not
		// start the server dispatcher or claim to test its consumer thread.
		auto &dispatcher = g_dispatcher();
		const auto &thread = dispatcher.getThreadTask();
		auto tasks = [&] {
			std::scoped_lock lock(thread->mutex);
			return std::exchange(thread->tasks[static_cast<size_t>(DispatcherLane::ProtocolInput)], {});
		}();
		ASSERT_EQ(1, tasks.size());
		for (auto &task : tasks) {
			EXPECT_EQ("Connection::dispatchProtocolRelease", task.getContext());
			dispatcher.releaseDispatcherSlot(task);
			EXPECT_TRUE(task.execute());
		}
		EXPECT_TRUE(thread->tasks[static_cast<size_t>(DispatcherLane::WorldCommit)].empty());
	}

	void expectReadErrorRetained(void (Connection::*read)(const std::error_code &)) {
		const std::error_code expected = asio::error::eof;
		(connection.get()->*read)(expected);
		(connection.get()->*read)(asio::error::operation_aborted);
		EXPECT_EQ(expected, connection->firstReadError);
	}

	void expectProxyReadErrorRetained() {
		expectReadErrorRetained(&Connection::parseProxyIdentification);
	}

	void expectPacketReadErrorRetained() {
		expectReadErrorRetained(&Connection::parsePacket);
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
	std::unique_ptr<di::extension::injector<>> injector;
	di::extension::injector<>* previousContainer = nullptr;
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

TEST_F(ConnectionWriteDiagnosticsTest, WriteFailureRetainsPeerAndReportsClosureWithBoundedWarnings) {
	queueMessage();
	closeBeforeWrite();
	reportFailedWrite();
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
	EXPECT_NE(std::string::npos, diagnostic.find("socket_open_at_write=true, socket_open_now=false"));
	EXPECT_NE(std::string::npos, diagnostic.find("bytes_written=0/3, queued_messages=1"));
	EXPECT_NE(std::string::npos, diagnostic.find("closeBeforeWrite"));
	EXPECT_NE(std::string::npos, diagnostic.find("forced_close=true"));
	EXPECT_EQ(std::string::npos, diagnostic.find("age_ms=-1"));
	expectDrained();

	// A burst must not restore the original per-failure warning spam.
	for (int attempt = 0; attempt < 10; ++attempt) {
		queueMessage();
		reportFailedWrite();
	}
	// A new connection shares the warning budget and can lack accepted/close metadata.
	reportUnacceptedWrite();
	const auto unacceptedDiagnostics = writeDiagnostics();
	ASSERT_FALSE(unacceptedDiagnostics.empty());
	const auto &unacceptedDiagnostic = unacceptedDiagnostics.back().second;
	EXPECT_NE(std::string::npos, unacceptedDiagnostic.find("age_ms=-1"));
	EXPECT_NE(std::string::npos, unacceptedDiagnostic.find("close_requested_by=none, close_line=0"));
	size_t warnings = 0;
	for (const auto &[entryLevel, entryMessage] : writeDiagnostics()) {
		warnings += entryLevel == "warning";
	}
	EXPECT_EQ(1, warnings);
	std::cout << "Injected completion diagnostic: " << diagnostic << '\n';

	// The next warning accounts for the suppressed burst. The first read failure
	// must also survive the cancellation callback that follows socket closure.
	std::this_thread::sleep_for(std::chrono::milliseconds(5100));
	simulateReadFailure();
	queueMessage();
	reportFailedWrite();
	const auto nextDiagnostics = writeDiagnostics();
	ASSERT_FALSE(nextDiagnostics.empty());
	const auto &[nextLevel, nextDiagnostic] = nextDiagnostics.back();
	EXPECT_EQ("warning", nextLevel);
	EXPECT_NE(std::string::npos, nextDiagnostic.find("suppressed_since_last_warning=11"));
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

TEST_F(ConnectionWriteDiagnosticsTest, QueuedSendCancelledBeforeWorkerDoesNotPrepareOrWrite) {
	const auto protocol = useQueuedProtocol();
	queuePublicSend();
	closeBeforeWrite();
	runQueuedWork();
	EXPECT_EQ(0, protocol->preparedMessages);
	EXPECT_TRUE(writeDiagnostics().empty());
	expectDrained();
	EXPECT_FALSE(socketOpen());
}

TEST_F(ConnectionWriteDiagnosticsTest, CloseDuringPreparationDoesNotStartWrite) {
	const auto protocol = useQueuedProtocol(1);
	queuePublicSend();
	runQueuedWork();
	EXPECT_EQ(1, protocol->preparedMessages);
	EXPECT_TRUE(writeDiagnostics().empty());
	expectDrained();
	EXPECT_FALSE(socketOpen());
}

TEST_F(ConnectionWriteDiagnosticsTest, CloseDuringNextPreparationDoesNotStartAnotherWrite) {
	const auto protocol = useQueuedProtocol(2);
	queuePublicSend();
	queuePublicSend();
	runQueuedWork();
	EXPECT_EQ(2, protocol->preparedMessages);
	EXPECT_TRUE(writeDiagnostics().empty());
	expectDrained();
	EXPECT_FALSE(socketOpen());
	std::error_code error;
	EXPECT_EQ(3, peer.available(error));
	EXPECT_FALSE(error);
}

TEST_F(ConnectionWriteDiagnosticsTest, SuccessfulCompletionAfterForceCloseDoesNotPrepareNextMessage) {
	const auto protocol = useQueuedProtocol();
	queueMessage();
	queueMessage();
	closeBeforeWrite();
	completeWriteAfterClose();
	runQueuedWork();
	EXPECT_EQ(0, protocol->preparedMessages);
	EXPECT_TRUE(writeDiagnostics().empty());
	expectDrained();
	EXPECT_FALSE(socketOpen());
}

TEST_F(ConnectionWriteDiagnosticsTest, GracefulCloseCanEscalateToForcedClose) {
	const auto protocol = useQueuedProtocol();
	queuePublicSend();
	closeGracefully();
	ASSERT_TRUE(socketOpen());
	closeBeforeWrite();
	EXPECT_FALSE(socketOpen());
	runQueuedWork();
	EXPECT_EQ(0, protocol->preparedMessages);
	EXPECT_TRUE(writeDiagnostics().empty());
	expectDrained();
	EXPECT_EQ(0, protocol->releaseCount);
	executeProtocolRelease();
	EXPECT_EQ(1, protocol->releaseCount);
}

TEST_F(ConnectionWriteDiagnosticsTest, WorkerRetainsMessageDuringPreparation) {
	const auto protocol = useQueuedProtocol();
	protocol->checkMessageOwnership = true;
	queuePublicSend();
	runQueuedWork();
	EXPECT_EQ(1, protocol->preparedMessages);
	expectDrained();
	std::error_code error;
	EXPECT_EQ(3, peer.available(error));
	EXPECT_FALSE(error);
}

TEST_F(ConnectionWriteDiagnosticsTest, CompletionRetainsNextMessageDuringPreparation) {
	const auto protocol = useQueuedProtocol();
	protocol->checkMessageOwnership = true;
	queuePublicSend();
	queuePublicSend();
	runQueuedWork();
	EXPECT_EQ(2, protocol->preparedMessages);
	expectDrained();
	std::error_code error;
	EXPECT_EQ(6, peer.available(error));
	EXPECT_FALSE(error);
}

TEST_F(ConnectionWriteDiagnosticsTest, ProxyReadErrorSurvivesCancellation) {
	expectProxyReadErrorRetained();
}

TEST_F(ConnectionWriteDiagnosticsTest, PacketReadErrorSurvivesCancellation) {
	expectPacketReadErrorRetained();
}

TEST_F(ConnectionWriteDiagnosticsTest, QueuedGracefulCloseSendsAllMessages) {
	const auto protocol = useQueuedProtocol();
	queuePublicSend();
	queuePublicSend();
	closeGracefully();
	ASSERT_TRUE(socketOpen());
	runQueuedWork();
	EXPECT_EQ(2, protocol->preparedMessages);
	EXPECT_TRUE(writeDiagnostics().empty());
	expectDrained();
	EXPECT_FALSE(socketOpen());
	std::array<uint8_t, 6> received {};
	std::error_code error;
	ASSERT_EQ(6, peer.available(error));
	ASSERT_FALSE(error);
	ASSERT_EQ(6, asio::read(peer, asio::buffer(received), error));
	EXPECT_FALSE(error);
	EXPECT_EQ((std::array<uint8_t, 6> { 0x31, 0x72, 0xA5, 0x31, 0x72, 0xA5 }), received);
}
