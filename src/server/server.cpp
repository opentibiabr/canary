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

namespace {
	constexpr auto retryOpenDelay = 15000;
	constexpr std::array<ServicePortNetwork_t, 2> networkProtocols {
		ServicePortNetwork_t::IPv4,
		ServicePortNetwork_t::IPv6
	};

	constexpr size_t networkIndex(ServicePortNetwork_t networkProtocol) {
		return static_cast<size_t>(networkProtocol);
	}
} // namespace

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

bool ServicePort::isNetworkEnabled(ServicePortNetwork_t networkProtocol) const {
#ifdef BUILD_TESTS
	if (enabledNetworksForTest) {
		return (*enabledNetworksForTest)[networkIndex(networkProtocol)];
	}
#endif

	return networkProtocol == ServicePortNetwork_t::IPv4 ? g_configManager().getBoolean(IPV4) : g_configManager().getBoolean(IPV6);
}

bool ServicePort::isBindOnlyGlobalAddress() const {
#ifdef BUILD_TESTS
	if (bindOnlyGlobalAddressForTest) {
		return *bindOnlyGlobalAddressForTest;
	}
#endif

	return g_configManager().getBoolean(BIND_ONLY_GLOBAL_ADDRESS);
}

bool ServicePort::isPendingStart(ServicePortNetwork_t networkProtocol) const {
	return pendingStart[networkIndex(networkProtocol)];
}

void ServicePort::setPendingStart(ServicePortNetwork_t networkProtocol, bool pending) {
	const auto index = networkIndex(networkProtocol);
	pendingStart[index] = pending;
	if (!pending) {
		pendingStartEvents[index] = 0;
	}
}

void ServicePort::scheduleOpenRetry(ServicePortNetwork_t networkProtocol) {
	if (isPendingStart(networkProtocol)) {
		return;
	}

	setPendingStart(networkProtocol, true);
	pendingStartEvents[networkIndex(networkProtocol)] = g_dispatcher().scheduleEvent(
		retryOpenDelay,
		[self = shared_from_this(), port = serverPort, networkProtocol] { ServicePort::openAcceptor(std::weak_ptr<ServicePort>(self), port, networkProtocol); },
		"ServicePort::openAcceptor"
	);
}

void ServicePort::closeAcceptor(ServicePortNetwork_t networkProtocol) const {
	if (auto* serviceAcceptor = getAcceptor(networkProtocol); serviceAcceptor && serviceAcceptor->is_open()) {
		std::error_code error;
		serviceAcceptor->close(error);
	}
}

bool ServicePort::openNetworkAcceptor(ServicePortNetwork_t networkProtocol, const asio::ip::tcp::endpoint &endpoint) {
	auto &serviceAcceptor = networkProtocol == ServicePortNetwork_t::IPv4 ? ipv4Acceptor : ipv6Acceptor;
#ifdef BUILD_TESTS
	if (failedOpenNetworkProtocolForTest && *failedOpenNetworkProtocolForTest == networkProtocol) {
		serviceAcceptor.reset();
		return false;
	}
#endif

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
		g_logger().warn("[ServicePort::open] - Failed to open {} listener on {}:{}: {}", endpoint.address().is_v4() ? "IPv4" : "IPv6", endpoint.address().to_string(), serverPort, e.what());
		serviceAcceptor.reset();
		return false;
	}
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
		if (!isPendingStart(networkProtocol)) {
			closeAcceptor(networkProtocol);
			scheduleOpenRetry(networkProtocol);
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

void ServicePort::openAcceptor(const std::weak_ptr<ServicePort> &weak_service, uint16_t port, ServicePortNetwork_t networkProtocol) {
	if (const auto service = weak_service.lock()) {
		service->serverPort = port;
		service->open(networkProtocol);
	}
}

bool ServicePort::open(ServicePortNetwork_t networkProtocol) {
	setPendingStart(networkProtocol, false);

	std::array<bool, 2> retryOpen {};
	const auto opened = openConfiguredAcceptors(networkProtocol, retryOpen);
	const auto index = networkIndex(networkProtocol);
	if (!opened[index] && retryOpen[index]) {
		scheduleOpenRetry(networkProtocol);
		return false;
	}

	setPendingStart(networkProtocol, false);
	return opened[index];
}

std::array<bool, 2> ServicePort::openConfiguredAcceptors(std::optional<ServicePortNetwork_t> networkProtocol, std::array<bool, 2> &retryOpen) {
	std::array<bool, 2> opened {};
	retryOpen = {};

	const bool ipv4Enabled = isNetworkEnabled(ServicePortNetwork_t::IPv4);
	const bool ipv6Enabled = isNetworkEnabled(ServicePortNetwork_t::IPv6);
	if (!ipv4Enabled && !ipv6Enabled) {
		g_logger().error("[ServicePort::open] - Both IPV4 and IPV6 are disabled for port {}", serverPort);
		return opened;
	}

	auto shouldOpenProtocol = [&](ServicePortNetwork_t currentProtocol) {
		if (networkProtocol && *networkProtocol != currentProtocol) {
			return false;
		}

		return currentProtocol == ServicePortNetwork_t::IPv4 ? ipv4Enabled : ipv6Enabled;
	};

	for (const auto currentProtocol : networkProtocols) {
		retryOpen[networkIndex(currentProtocol)] = shouldOpenProtocol(currentProtocol);
	}

	if (networkProtocol && !shouldOpenProtocol(*networkProtocol)) {
		return opened;
	}

	auto disableRetryForSelectedProtocols = [&] {
		for (const auto currentProtocol : networkProtocols) {
			if (shouldOpenProtocol(currentProtocol)) {
				retryOpen[networkIndex(currentProtocol)] = false;
			}
		}
	};

	if (isBindOnlyGlobalAddress()) {
		const auto configuredBindAddress = g_configManager().getString(IP);
		std::vector<asio::ip::address> bindAddresses;

		auto addResolvedBindAddress = [&](const asio::ip::address &address) {
			if (address.is_v4()) {
				if (shouldOpenProtocol(ServicePortNetwork_t::IPv4) && std::ranges::none_of(bindAddresses, [](const asio::ip::address &bindAddress) { return bindAddress.is_v4(); })) {
					bindAddresses.emplace_back(address);
				}
			} else if (address.is_v6()) {
				if (shouldOpenProtocol(ServicePortNetwork_t::IPv6) && std::ranges::none_of(bindAddresses, [](const asio::ip::address &bindAddress) { return bindAddress.is_v6(); })) {
					bindAddresses.emplace_back(address);
				}
			}
		};

		std::error_code parseError;
		const auto literalAddress = asio::ip::address::from_string(configuredBindAddress, parseError);

		std::error_code resolveError;
		asio::ip::tcp::resolver resolver(io_service);
		const auto resolvedEndpoints = resolver.resolve(configuredBindAddress, std::to_string(serverPort), resolveError);
		if (!resolveError) {
			for (const auto &entry : resolvedEndpoints) {
				addResolvedBindAddress(entry.endpoint().address());
			}
		} else if (!parseError) {
			addResolvedBindAddress(literalAddress);
		} else {
			g_logger().warn("[ServicePort::open] - Failed to resolve bind address '{}' for port {}: {}; literal parse error: {}", configuredBindAddress, serverPort, resolveError.message(), parseError.message());
		}

		if (bindAddresses.empty()) {
			g_logger().warn("[ServicePort::open] - No bind address found for '{}' on port {} with IPV4={} and IPV6={}", configuredBindAddress, serverPort, ipv4Enabled, ipv6Enabled);
			disableRetryForSelectedProtocols();
			return opened;
		}

		const bool hasIPv4BindAddress = std::ranges::any_of(bindAddresses, [](const asio::ip::address &bindAddress) { return bindAddress.is_v4(); });
		const bool hasIPv6BindAddress = std::ranges::any_of(bindAddresses, [](const asio::ip::address &bindAddress) { return bindAddress.is_v6(); });

		if (shouldOpenProtocol(ServicePortNetwork_t::IPv4) && !hasIPv4BindAddress) {
			retryOpen[networkIndex(ServicePortNetwork_t::IPv4)] = false;
			if (!parseError) {
				g_logger().warn("[ServicePort::open] - Configured bind address '{}' is {}, but IPV4 is enabled - IPv4 will not be bound", configuredBindAddress, literalAddress.is_v4() ? "IPv4" : "IPv6");
			} else {
				g_logger().warn("[ServicePort::open] - Configured bind address '{}' did not resolve to an IPv4 address, but IPV4 is enabled - IPv4 will not be bound", configuredBindAddress);
			}
		}

		if (shouldOpenProtocol(ServicePortNetwork_t::IPv6) && !hasIPv6BindAddress) {
			retryOpen[networkIndex(ServicePortNetwork_t::IPv6)] = false;
			if (!parseError) {
				g_logger().warn("[ServicePort::open] - Configured bind address '{}' is {}, but IPV6 is enabled - IPv6 will not be bound", configuredBindAddress, literalAddress.is_v4() ? "IPv4" : "IPv6");
			} else {
				g_logger().warn("[ServicePort::open] - Configured bind address '{}' did not resolve to an IPv6 address, but IPV6 is enabled - IPv6 will not be bound", configuredBindAddress);
			}
		}

		for (const auto &bindAddress : bindAddresses) {
			if (bindAddress.is_v4()) {
				opened[networkIndex(ServicePortNetwork_t::IPv4)] = openNetworkAcceptor(ServicePortNetwork_t::IPv4, asio::ip::tcp::endpoint(bindAddress, serverPort)) || opened[networkIndex(ServicePortNetwork_t::IPv4)];
			} else if (bindAddress.is_v6()) {
				opened[networkIndex(ServicePortNetwork_t::IPv6)] = openNetworkAcceptor(ServicePortNetwork_t::IPv6, asio::ip::tcp::endpoint(bindAddress, serverPort)) || opened[networkIndex(ServicePortNetwork_t::IPv6)];
			}
		}
	} else {
		if (shouldOpenProtocol(ServicePortNetwork_t::IPv4)) {
			opened[networkIndex(ServicePortNetwork_t::IPv4)] = openNetworkAcceptor(ServicePortNetwork_t::IPv4, asio::ip::tcp::endpoint(asio::ip::address_v4::any(), serverPort));
		}
		if (shouldOpenProtocol(ServicePortNetwork_t::IPv6)) {
			opened[networkIndex(ServicePortNetwork_t::IPv6)] = openNetworkAcceptor(ServicePortNetwork_t::IPv6, asio::ip::tcp::endpoint(asio::ip::address_v6::any(), serverPort));
		}
	}

	return opened;
}

void ServicePort::open(uint16_t port) {
	close();
	ipv4Acceptor.reset();
	ipv6Acceptor.reset();

	serverPort = port;
	pendingStart.fill(false);
	pendingStartEvents.fill(0);

	std::array<bool, 2> retryOpen {};
	const auto opened = openConfiguredAcceptors(std::nullopt, retryOpen);
	for (const auto networkProtocol : networkProtocols) {
		const auto index = networkIndex(networkProtocol);
		if (!opened[index] && retryOpen[index]) {
			scheduleOpenRetry(networkProtocol);
		}
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

#ifdef BUILD_TESTS
void ServicePort::setEnabledNetworksForTest(bool ipv4Enabled, bool ipv6Enabled) {
	enabledNetworksForTest = std::array<bool, 2> { ipv4Enabled, ipv6Enabled };
}

void ServicePort::setBindOnlyGlobalAddressForTest(bool bindOnlyGlobalAddress) {
	bindOnlyGlobalAddressForTest = bindOnlyGlobalAddress;
}

void ServicePort::setOpenNetworkAcceptorFailureForTest(std::optional<ServicePortNetwork_t> networkProtocol) {
	failedOpenNetworkProtocolForTest = networkProtocol;
}

bool ServicePort::hasPendingStartForTest(ServicePortNetwork_t networkProtocol) const {
	return isPendingStart(networkProtocol);
}

bool ServicePort::isAcceptorOpenForTest(ServicePortNetwork_t networkProtocol) const {
	const auto* serviceAcceptor = getAcceptor(networkProtocol);
	return serviceAcceptor && serviceAcceptor->is_open();
}

uint64_t ServicePort::getPendingStartEventForTest(ServicePortNetwork_t networkProtocol) const {
	return pendingStartEvents[networkIndex(networkProtocol)];
}
#endif
