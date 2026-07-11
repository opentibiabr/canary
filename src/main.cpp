/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "canary_server.hpp"
#include "game/multichannel/channel_context.hpp"
#include "lib/di/container.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <span>
	#include <string_view>
#endif

namespace {
	constexpr std::string_view GenerateLuaApiDocsOnlyArgument = "--generate-lua-api-docs-only";

	bool hasArgument(const std::span<char*> arguments, const std::string_view expectedArgument) {
		for (std::size_t index = 1; index < arguments.size(); ++index) {
			if (std::string_view(arguments[index]) == expectedArgument) {
				return true;
			}
		}
		return false;
	}
}

int main(int argc, char* argv[]) {
	auto &server = inject<CanaryServer>();
	const std::span<char*> arguments(argv, static_cast<std::size_t>(argc));

	// Resolves this process's multi-channel cluster identity (--channel-id
	// CLI arg > CANARY_CHANNEL_ID env > single-channel fallback) before
	// anything else runs, since config.lua is shared by every process in a
	// cluster and can't carry a process-specific id (see
	// docs/multichannel/ARCHITECTURE.md §3.1). A no-op concern in
	// single-channel installs - nothing reads the resolved id unless
	// multiChannelEnabled is true.
	g_channelContext().resolve(arguments);

	if (hasArgument(arguments, GenerateLuaApiDocsOnlyArgument)) {
		return server.generateLuaApiDocsOnly();
	}

	return server.run();
}
