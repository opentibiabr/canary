/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/server.hpp"

#include "server/network/message/outputmessage.hpp"
#include "config/configmanager.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "creatures/players/management/ban.hpp"

ServiceManager::~ServiceManager() {
	try {
		stop();
	} catch (std::exception &exception) {
		g_logger().error("{} - Catch exception error: {}", __FUNCTION__, exception.what());
	}
}

void ServiceManager::die() {
	io_service.stop();
}

void ServiceManager::run() {
	if (running) {
		g_logger().error("ServiceManager is already running!", __FUNCTION__);
		return;
	}

	assert(!running);
	running = true;
	io_service.run();
}

void ServiceManager::stop() {
	if (!running) {
		return;
	}

	running = false;

	for (auto &servicePortIt : acceptors) {
		try {
			io_service.post([servicePort = servicePortIt.second] { servicePort->onStopServer(); });
		} catch (const std::system_error &e) {
			g_logger().warn("[ServiceManager::stop] - Network error: {}", e.what());
		}
	}

	acceptors.clear();

	death_timer.expires_from_now(std::chrono::seconds(3));
	death_timer.async_wait([this](const std::error_code &err) {
		die();
	});
}

ServicePort::~ServicePort() {
	close();
}

bool ServicePort::is_single_socket() const {
	return !services.empty() && services.front()->is_single_socket();
}

std::string ServicePort::get_protocol_names() const {
	if (services.empty()) {
		return {};
	}

	std::string str = services.front()->get_protocol_name();
	for (size_t i = 1; i < services.size(); ++i) {
		str.push_back(',');
		str.push_back(' ');
		str.append(services[i]->get_protocol_name());
	}
	return str;
}

asio::ip::tcp::acceptor* ServicePort::getAcceptor(ServicePortNetwork_t networkProtocol) const {
	return networkProtocol == ServicePortNetwork_t::IPv4 ? ipv4Acceptor.get() : ipv6Acceptor.get();
}

void ServicePort::accept(ServicePortNetwork_t networkProtocol) {
	auto* serviceAcceptor = getAcceptor(networkProtocol);
	if (!serviceAcceptor) {
		return;
	}

	auto connection = ConnectionManager::getInstance().createConnection(io_service, shared_from_this());
	serviceAcceptor->async_accept(connection->getSocket(), [self = shared_from_this(), connection, networkProtocol](const std::error_code &error) {
		self->onAccept(connection, error, networkProtocol);
	});
}

void ServicePort::onAccept(const Connection_ptr &connection, const std::error_code &error, ServicePortNetwork_t networkProtocol) {
	if (!error) {
		if (services.empty()) {
			return;
		}

		const auto remoteIp = connection->getIPString();
		if (!remoteIp.empty() && inject<Ban>().acceptConnection(remoteIp)) {
			const Service_ptr service = services.front();
			if (service->is_single_socket()) {
				connection->accept(service->make_protocol(connection));
			} else {
				connection->acceptInternal();
			}
		} else {
			connection->close(FORCE_CLOSE);
		}

		accept(networkProtocol);
	} else if (error != asio::error::operation_aborted) {
		if (!pendingStart) {
			close();
			pendingStart = true;
			g_dispatcher().scheduleEvent(
				15000, [self = shared_from_this(), serverPort = serverPort] { ServicePort::openAcceptor(std::weak_ptr<ServicePort>(self), serverPort); }, "ServicePort::openAcceptor"
			);
		}
	}
}

Protocol_ptr ServicePort::make_protocol(bool checksummed, NetworkMessage &msg, const Connection_ptr &connection) const {
	const uint8_t protocolID = msg.getByte();
	for (auto &service : services) {
		if (protocolID != service->get_protocol_identifier()) {
			continue;
		}

		if ((checksummed && service->is_checksummed()) || !service->is_checksummed()) {
			return service->make_protocol(connection);
		}
	}
	return nullptr;
}

void ServicePort::onStopServer() const {
	close();
}

void ServicePort::openAcceptor(const std::weak_ptr<ServicePort> &weak_service, uint16_t port) {
	if (const auto service = weak_service.lock()) {
		service->open(port);
	}
}

void ServicePort::open(uint16_t port) {
	close();
	ipv4Acceptor.reset();
	ipv6Acceptor.reset();

	serverPort = port;
	pendingStart = false;

	const bool ipv4Enabled = g_configManager().getBoolean(IPV4);
	const bool ipv6Enabled = g_configManager().getBoolean(IPV6);
	if (!ipv4Enabled && !ipv6Enabled) {
		g_logger().error("[ServicePort::open] - Both IPV4 and IPV6 are disabled for port {}", serverPort);
		return;
	}

	auto openNetworkAcceptor = [this](ServicePortNetwork_t networkProtocol, const asio::ip::tcp::endpoint &endpoint) -> bool {
		auto &serviceAcceptor = networkProtocol == ServicePortNetwork_t::IPv4 ? ipv4Acceptor : ipv6Acceptor;
		try {
			serviceAcceptor = std::make_unique<asio::ip::tcp::acceptor>(io_service);
			serviceAcceptor->open(endpoint.protocol());
			if (endpoint.address().is_v6()) {
				serviceAcceptor->set_option(asio::ip::v6_only(true));
			}
			serviceAcceptor->set_option(asio::socket_base::reuse_address(true));
			serviceAcceptor->bind(endpoint);
			serviceAcceptor->listen();
			serviceAcceptor->set_option(asio::ip::tcp::no_delay(true));

			accept(networkProtocol);
			return true;
		} catch (const std::system_error &e) {
			g_logger().warn(
				"[ServicePort::open] - Failed to open {} listener on {}:{}: {}",
				endpoint.address().is_v4() ? "IPv4" : "IPv6", endpoint.address().to_string(), serverPort, e.what()
			);
			serviceAcceptor.reset();
			return false;
		}
	};

	bool opened = false;
	if (g_configManager().getBoolean(BIND_ONLY_GLOBAL_ADDRESS)) {
		std::error_code error;
		const auto bindAddress = asio::ip::address::from_string(g_configManager().getString(IP), error);
		if (error) {
			g_logger().warn("[ServicePort::open] - Invalid bind address '{}': {}", g_configManager().getString(IP), error.message());
		} else if (bindAddress.is_v4()) {
			if (ipv4Enabled) {
				opened = openNetworkAcceptor(ServicePortNetwork_t::IPv4, asio::ip::tcp::endpoint(bindAddress, serverPort));
			} else {
				g_logger().warn("[ServicePort::open] - Configured bind address '{}' is IPv4, but IPV4 is disabled", bindAddress.to_string());
			}
		} else if (bindAddress.is_v6()) {
			if (ipv6Enabled) {
				opened = openNetworkAcceptor(ServicePortNetwork_t::IPv6, asio::ip::tcp::endpoint(bindAddress, serverPort));
			} else {
				g_logger().warn("[ServicePort::open] - Configured bind address '{}' is IPv6, but IPV6 is disabled", bindAddress.to_string());
			}
		}
	} else {
		if (ipv4Enabled) {
			opened = openNetworkAcceptor(ServicePortNetwork_t::IPv4, asio::ip::tcp::endpoint(asio::ip::address_v4::any(), serverPort)) || opened;
		}
		if (ipv6Enabled) {
			opened = openNetworkAcceptor(ServicePortNetwork_t::IPv6, asio::ip::tcp::endpoint(asio::ip::address_v6::any(), serverPort)) || opened;
		}
	}

	if (!opened) {
		pendingStart = true;
		g_dispatcher().scheduleEvent(
			15000,
			[self = shared_from_this(), port] { ServicePort::openAcceptor(std::weak_ptr<ServicePort>(self), port); }, "ServicePort::openAcceptor"
		);
	}
}

void ServicePort::close() const {
	for (auto* serviceAcceptor : { ipv4Acceptor.get(), ipv6Acceptor.get() }) {
		if (serviceAcceptor && serviceAcceptor->is_open()) {
			std::error_code error;
			serviceAcceptor->close(error);
		}
	}
}

bool ServicePort::add_service(const Service_ptr &new_svc) {
	if (std::ranges::any_of(services, [](const Service_ptr &svc) { return svc->is_single_socket(); })) {
		return false;
	}

	services.emplace_back(new_svc);
	return true;
}
