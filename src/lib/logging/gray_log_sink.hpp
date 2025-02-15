/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <spdlog/sinks/base_sink.h>
#include <asio.hpp>
#include <nlohmann/json.hpp>
#include <chrono>
#include <iostream>
#include "gray_log_sink_options.hpp"

class GrayLogSink : public spdlog::sinks::base_sink<std::mutex> {
public:
	GrayLogSink(const GrayLogSinkOptions &options) :
		_io_context(),
		_socket(_io_context, asio::ip::udp::v4()),
		_endpoint(asio::ip::make_address(options.hostNameOrAddress), options.port),
		_options(options) { }

protected:
	void sink_it_(const spdlog::details::log_msg &msg) override {
		try {

			if (spdlog::level::from_str(_options.level) > msg.level) {
				return;
			}

			nlohmann::json gelf_message;
			gelf_message["version"] = "1.0";
			gelf_message["host"] = _options.source;
			gelf_message["short_message"] = std::string(msg.payload.begin(), msg.payload.end());

			auto now = std::chrono::system_clock::now();
			auto duration = now.time_since_epoch();
			double timestamp = std::chrono::duration_cast<std::chrono::seconds>(duration).count() + (std::chrono::duration_cast<std::chrono::microseconds>(duration).count() % 1000000) / 1e6;

			gelf_message["timestamp"] = timestamp;
			gelf_message["level"] = mapLogLevel(msg.level);

			std::string serialized_message = gelf_message.dump();

			_socket.send_to(asio::buffer(serialized_message), _endpoint);
		} catch (const std::exception &ex) {
			std::cerr << "Graylog sink send message error: " << ex.what() << std::endl;
		}
	}

	void flush_() override {
	}

private:
	asio::io_context _io_context;
	asio::ip::udp::socket _socket;
	asio::ip::udp::endpoint _endpoint;
	GrayLogSinkOptions _options;

	int mapLogLevel(spdlog::level::level_enum level) {
		switch (level) {
			case spdlog::level::trace:
				return 7; // Debug
			case spdlog::level::debug:
				return 7; // Debug
			case spdlog::level::info:
				return 6; // Informational
			case spdlog::level::warn:
				return 4; // Warning
			case spdlog::level::err:
				return 3; // Error
			case spdlog::level::critical:
				return 2; // Critical
			default:
				return 1; // Alert
		}
	}
};
