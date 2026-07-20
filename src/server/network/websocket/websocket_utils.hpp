/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <string>
	#include <string_view>
	#include <vector>
#endif

namespace websocket_utils {
	[[nodiscard]] std::string computeAcceptKey(std::string_view clientKey);

	[[nodiscard]] bool parseUpgradeRequest(
		std::string_view request,
		std::string &outClientKey,
		std::string &outPath
	);

	[[nodiscard]] std::string buildUpgradeResponse(std::string_view acceptKey);

	/** Build a server→client unmasked binary (or close/pong) frame. */
	[[nodiscard]] std::vector<uint8_t> buildFrame(uint8_t opcode, const uint8_t* payload, size_t payloadLength);

	enum class FrameResult : uint8_t {
		NeedMoreData,
		Binary,
		Ping,
		Pong,
		Close,
		Error,
	};

	struct DecodedFrame {
		FrameResult result = FrameResult::NeedMoreData;
		std::vector<uint8_t> payload;
		size_t consumedBytes = 0;
	};

	/** Decode one frame from the front of buffer. Does not erase consumed bytes. */
	[[nodiscard]] DecodedFrame decodeFrame(const uint8_t* data, size_t size);
}
