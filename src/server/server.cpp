/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
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

#include <asio/error.hpp>
#include <asio/ip/address_v4.hpp>
#include <asio/ip/v6_only.hpp>
#include <algorithm>
#include <cctype>
#include <system_error>

namespace {

	enum class NetworkBindMode {
		IPv4Only,
		IPv6Only,
		IPv6WithFallback,
	};

	NetworkBindMode getNetworkBindMode() {
		std::string mode = g_configManager().getString(NETWORK_BIND_MODE);
		std::transform(mode.begin(), mode.end(), mode.begin(), [](unsigned char ch) {
			return static_cast<char>(std::tolower(ch));
		});

		if (mode == "ipv6" || mode == "ipv6_only") {
			return NetworkBindMode::IPv6Only;
		}

		if (mode == "ipv6fallback" || mode == "ipv6_with_fallback" || mode == "dualstack") {
			return NetworkBindMode::IPv6WithFallback;
		}

		static bool warned = false;
		if (!mode.empty() && mode != "ipv4" && !warned) {
			g_logger().warn(
				"[ServicePort] - Unknown networkBindMode '{}', falling back to IPv4", mode
			);
			warned = true;
		}

		return NetworkBindMode::IPv4Only;
	}

	asio::ip::address getListenAddress(NetworkBindMode mode) {
		if (g_configManager().getBoolean(BIND_ONLY_GLOBAL_ADDRESS)) {
			return asio::ip::address::from_string(g_configManager().getString(IP));
		}

		if (mode == NetworkBindMode::IPv6Only || mode == NetworkBindMode::IPv6WithFallback) {
			return asio::ip::address_v6::any();
		}

		return asio::ip::address_v4::any();
	}

	void scheduleOpenAcceptor(const std::weak_ptr<ServicePort> &service, uint16_t port) {
		if (const auto lockedService = service.lock()) {
			lockedService->open(port);
		}
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

void ServicePort::accept() {
	if (!acceptor) {
		return;
	}

	auto connection = ConnectionManager::getInstance().createConnection(io_service, shared_from_this());
	acceptor->async_accept(connection->getSocket(), [self = shared_from_this(), connection](const std::error_code &error) { self->onAccept(connection, error); });
}

void ServicePort::onAccept(const Connection_ptr &connection, const std::error_code &error) {
	if (!error) {
		if (services.empty()) {
			return;
		}

		const auto remote_ip = connection->getIP();
		if (inject<Ban>().acceptConnection(remote_ip)) {
			const Service_ptr service = services.front();
			if (service->is_single_socket()) {
				connection->accept(service->make_protocol(connection));
			} else {
				connection->acceptInternal();
			}
		} else {
			connection->close(FORCE_CLOSE);
		}

		accept();
	} else if (error != asio::error::operation_aborted) {
		if (!pendingStart) {
			close();
			pendingStart = true;
			g_dispatcher().scheduleEvent(
				15000,
				[self = std::weak_ptr<ServicePort>(shared_from_this()), port = serverPort] {
					scheduleOpenAcceptor(self, port);
				},
				"ServicePort::openAcceptor"
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

	serverPort = port;
	pendingStart = false;

	try {
		const auto mode = getNetworkBindMode();
		const auto address = getListenAddress(mode);

		const auto createAcceptor = [&](const asio::ip::address &bindAddress) {
			auto newAcceptor = std::make_unique<asio::ip::tcp::acceptor>(io_service, asio::ip::tcp::endpoint(bindAddress, serverPort));

			if (bindAddress.is_v6()) {
				asio::ip::v6_only option;
				newAcceptor->get_option(option);
				if (option.value()) {
					std::error_code error;
					newAcceptor->set_option(asio::ip::v6_only(false), error);
					if (error) {
						g_logger().warn("[ServicePort::open] - Failed to enable dual-stack mode: {}", error.message());
					}
				}
			}

			newAcceptor->set_option(asio::ip::tcp::no_delay(true));

			return newAcceptor;
		};

		try {
			acceptor = createAcceptor(address);
		} catch (const std::system_error &error) {
			const bool canFallbackToIPv4 = mode == NetworkBindMode::IPv6WithFallback && !g_configManager().getBoolean(BIND_ONLY_GLOBAL_ADDRESS) && address.is_v6();
			if (canFallbackToIPv4) {
				g_logger().info(
					"[ServicePort::open] - Failed to bind IPv6 endpoint ({}), falling back to IPv4",
					error.code().message()
				);
				acceptor = createAcceptor(asio::ip::address_v4::any());
			} else {
				throw;
			}
		}

		accept();
	} catch (const std::system_error &e) {
		g_logger().warn("[ServicePort::open] - Error code: {}", e.what());

		pendingStart = true;
		g_dispatcher().scheduleEvent(
			15000,
			[self = std::weak_ptr<ServicePort>(shared_from_this()), port] { scheduleOpenAcceptor(self, port); },
			"ServicePort::openAcceptor"
		);
	}
}

void ServicePort::close() const {
	if (acceptor && acceptor->is_open()) {
		std::error_code error;
		acceptor->close(error);
	}
}

bool ServicePort::add_service(const Service_ptr &new_svc) {
	if (std::ranges::any_of(services, [](const Service_ptr &svc) { return svc->is_single_socket(); })) {
		return false;
	}

	services.emplace_back(new_svc);
	return true;
}
