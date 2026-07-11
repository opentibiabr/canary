/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/channel_context.hpp"

#include "lib/di/container.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <charconv>
	#include <cstdlib>
#endif

ChannelContext &ChannelContext::getInstance() {
	return inject<ChannelContext>();
}

namespace {
	bool parseChannelId(std::string_view text, int32_t &out) {
		if (text.empty()) {
			return false;
		}
		int32_t value = 0;
		const auto* begin = text.data();
		const auto* end = text.data() + text.size();
		const auto result = std::from_chars(begin, end, value);
		if (result.ec != std::errc {} || result.ptr != end || value <= 0) {
			return false;
		}
		out = value;
		return true;
	}
} // namespace

int32_t ChannelContext::resolveFrom(std::span<char*> arguments, const char* environmentValue) {
	for (std::size_t index = 1; index < arguments.size(); ++index) {
		const std::string_view argument(arguments[index]);
		if (argument.starts_with(CliArgumentPrefix)) {
			int32_t value = DefaultSingleChannelId;
			const auto valueText = argument.substr(CliArgumentPrefix.size());
			if (parseChannelId(valueText, value)) {
				return value;
			}
			// Malformed --channel-id argument: fall through to env/fallback
			// rather than silently starting under the wrong identity.
			break;
		}
	}

	if (environmentValue != nullptr) {
		int32_t value = DefaultSingleChannelId;
		if (parseChannelId(environmentValue, value)) {
			return value;
		}
	}

	return DefaultSingleChannelId;
}

int32_t ChannelContext::resolve(std::span<char*> arguments) {
	if (resolved) {
		return channelId;
	}
	channelId = resolveFrom(arguments, std::getenv(EnvironmentVariableName.data()));
	resolved = true;
	return channelId;
}

int32_t ChannelContext::resolve() {
	if (resolved) {
		return channelId;
	}
	std::array<char*, 1> empty { nullptr };
	channelId = resolveFrom(std::span<char*>(empty.data(), 0), std::getenv(EnvironmentVariableName.data()));
	resolved = true;
	return channelId;
}
