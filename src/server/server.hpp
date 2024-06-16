/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lib/logging/logger.hpp"
#include "server/network/connection/connection.hpp"
#include "server/signals.hpp"

class Protocol;

class ServiceBase {
public:
	virtual bool is_single_socket() const = 0;
	virtual bool is_checksummed() const = 0;
	virtual uint8_t get_protocol_identifier() const = 0;
	virtual const char* get_protocol_name() const = 0;

	virtual Protocol_ptr make_protocol(const Connection_ptr &c) const = 0;
};

template <typename ProtocolType>
class Service final : public ServiceBase {
public:
	bool is_single_socket() const override {
		return ProtocolType::SERVER_SENDS_FIRST;
	}
	bool is_checksummed() const override {
		return ProtocolType::USE_CHECKSUM;
	}
	uint8_t get_protocol_identifier() const override {
		return ProtocolType::PROTOCOL_IDENTIFIER;
	}
	const char* get_protocol_name() const override {
		return ProtocolType::protocol_name();
	}

	Protocol_ptr make_protocol(const Connection_ptr &c) const override {
		return std::make_shared<ProtocolType>(c);
	}
};

class ServicePort : public std::enable_shared_from_this<ServicePort> {
public:
	explicit ServicePort(asio::io_context &init_io_service) :
		io_context(init_io_service), deadline_timer(init_io_service) { }
	~ServicePort();

	// non-copyable
	ServicePort(const ServicePort &) = delete;
	ServicePort &operator=(const ServicePort &) = delete;

	static void openAcceptor(const std::weak_ptr<ServicePort>& weak_service, uint16_t port);
	void open(uint16_t port);
	void close();
	bool is_single_socket() const;
	std::string get_protocol_names() const;

	bool add_service(const Service_ptr &new_svc);
	Protocol_ptr make_protocol(bool checksummed, NetworkMessage &msg, const Connection_ptr &connection) const;

	void onStopServer();
	void onAccept(const Connection_ptr& connection, const std::error_code &error);

private:
	void accept();

	asio::io_context &io_context;
	asio::high_resolution_timer deadline_timer;
	std::unique_ptr<asio::ip::tcp::acceptor> acceptor;
	std::vector<Service_ptr> services;

	uint16_t serverPort = 0;
	bool pendingStart = false;
};

class ServiceManager {
public:
	ServiceManager() : io_context(), work(asio::make_work_guard(io_context)) {
		unsigned int num_threads = 4;
		for (unsigned int i = 0; i < num_threads; ++i) {
			threads.emplace_back([this] { io_context.run(); });
		}
	}

	~ServiceManager();

	// non-copyable
	ServiceManager(const ServiceManager &) = delete;
	ServiceManager &operator=(const ServiceManager &) = delete;

	static ServiceManager &getInstance();

	void run();
	void stop();

	template <typename ProtocolType>
	bool add(uint16_t port);

	bool is_running() const {
		return !acceptors.empty();
	}

private:
	void die();

	std::map<uint16_t, ServicePort_ptr> acceptors;

	asio::io_context io_context;
	std::vector<std::thread> threads;
	std::optional<asio::executor_work_guard<asio::io_context::executor_type>> work; // Usando executor_work_guard

	Signals signals { io_context };
	asio::high_resolution_timer death_timer { io_context };
	bool running = false;
};

constexpr auto g_ServiceManager = ServiceManager::getInstance;

template <typename ProtocolType>
bool ServiceManager::add(uint16_t port) {
	if (port == 0) {
		g_logger().error("[ServiceManager::add] - "
						 "No port provided for service {}, service disabled",
						 ProtocolType::protocol_name());
		return false;
	}

	ServicePort_ptr service_port;

	auto foundServicePort = acceptors.find(port);

	if (foundServicePort == acceptors.end()) {
		service_port = std::make_shared<ServicePort>(io_context);
		service_port->open(port);
		acceptors[port] = service_port;
	} else {
		service_port = foundServicePort->second;

		if (service_port->is_single_socket() || ProtocolType::SERVER_SENDS_FIRST) {
			g_logger().error("[ServiceManager::add] - "
							 "{} and {} cannot use the same port {}",
							 ProtocolType::protocol_name(), service_port->get_protocol_names(), port);
			return false;
		}
	}

	return service_port->add_service(std::make_shared<Service<ProtocolType>>());
}
