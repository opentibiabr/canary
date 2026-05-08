/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <array>
#include <optional>

#include "lib/metrics/metrics.hpp"
#include "server/network/connection/connection.hpp"
#include "server/signals.hpp"

class Protocol;

class ServiceBase {
public:
	virtual ~ServiceBase() = default;
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

enum class ServicePortNetwork_t : uint8_t {
	IPv4,
	IPv6,
};

class ServicePort : public std::enable_shared_from_this<ServicePort> {
public:
	explicit ServicePort(asio::io_service &init_io_service) :
		io_service(init_io_service) { }
	~ServicePort();

	// non-copyable
	ServicePort(const ServicePort &) = delete;
	ServicePort &operator=(const ServicePort &) = delete;

	static void openAcceptor(const std::weak_ptr<ServicePort> &weak_service, uint16_t port);
	void open(uint16_t port);
	void close() const;
	bool is_single_socket() const;
	std::string get_protocol_names() const;

	bool add_service(const Service_ptr &new_svc);
	Protocol_ptr make_protocol(bool checksummed, NetworkMessage &msg, const Connection_ptr &connection) const;

	void onStopServer() const;
	void onAccept(const Connection_ptr &connection, const std::error_code &error, ServicePortNetwork_t networkProtocol);

#ifdef BUILD_TESTS
	void setEnabledNetworksForTest(bool ipv4Enabled, bool ipv6Enabled);
	void setBindOnlyGlobalAddressForTest(bool bindOnlyGlobalAddress);
	void setOpenNetworkAcceptorFailureForTest(std::optional<ServicePortNetwork_t> networkProtocol);
	[[nodiscard]] bool hasPendingStartForTest(ServicePortNetwork_t networkProtocol) const;
	[[nodiscard]] bool isAcceptorOpenForTest(ServicePortNetwork_t networkProtocol) const;
	[[nodiscard]] uint64_t getPendingStartEventForTest(ServicePortNetwork_t networkProtocol) const;
#endif

private:
	void accept(ServicePortNetwork_t networkProtocol);
	asio::ip::tcp::acceptor* getAcceptor(ServicePortNetwork_t networkProtocol) const;
	void closeAcceptor(ServicePortNetwork_t networkProtocol) const;
	bool open(ServicePortNetwork_t networkProtocol);
	std::array<bool, 2> openConfiguredAcceptors(std::optional<ServicePortNetwork_t> networkProtocol, std::array<bool, 2> &retryOpen);
	bool openNetworkAcceptor(ServicePortNetwork_t networkProtocol, const asio::ip::tcp::endpoint &endpoint);
	bool isNetworkEnabled(ServicePortNetwork_t networkProtocol) const;
	bool isBindOnlyGlobalAddress() const;
	bool isPendingStart(ServicePortNetwork_t networkProtocol) const;
	void setPendingStart(ServicePortNetwork_t networkProtocol, bool pending);
	void scheduleOpenRetry(ServicePortNetwork_t networkProtocol);
	static void openAcceptor(const std::weak_ptr<ServicePort> &weak_service, uint16_t port, ServicePortNetwork_t networkProtocol);

	asio::io_service &io_service;
	std::unique_ptr<asio::ip::tcp::acceptor> ipv4Acceptor;
	std::unique_ptr<asio::ip::tcp::acceptor> ipv6Acceptor;
	std::vector<Service_ptr> services;

	uint16_t serverPort = 0;
	std::array<bool, 2> pendingStart {};
	std::array<uint64_t, 2> pendingStartEvents {};

#ifdef BUILD_TESTS
	std::optional<std::array<bool, 2>> enabledNetworksForTest;
	std::optional<bool> bindOnlyGlobalAddressForTest;
	std::optional<ServicePortNetwork_t> failedOpenNetworkProtocolForTest;
#endif
};

class ServiceManager {
public:
	ServiceManager() = default;
	~ServiceManager();

	// non-copyable
	ServiceManager(const ServiceManager &) = delete;
	ServiceManager &operator=(const ServiceManager &) = delete;

	void run();
	void stop();

	template <typename ProtocolType>
	bool add(uint16_t port);

	bool is_running() const {
		return acceptors.empty() == false;
	}

private:
	void die();

	phmap::flat_hash_map<uint16_t, ServicePort_ptr> acceptors;

	asio::io_service io_service;
	Signals signals { io_service };
	asio::high_resolution_timer death_timer { io_service };
	bool running = false;
};

template <typename ProtocolType>
bool ServiceManager::add(uint16_t port) {
	if (port == 0) {
		g_logger().error("[ServiceManager::add] - "
		                 "No port provided for service {}, service disabled",
		                 ProtocolType::protocol_name());
		return false;
	}

	ServicePort_ptr service_port;

	const auto foundServicePort = acceptors.find(port);

	if (foundServicePort == acceptors.end()) {
		service_port = std::make_shared<ServicePort>(io_service);
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
