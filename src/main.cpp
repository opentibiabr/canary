/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "canary_server.hpp"
#include "lib/di/container.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <string_view>
#endif

namespace {
	constexpr std::string_view GenerateLuaApiDocsOnlyArgument = "--generate-lua-api-docs-only";

	bool hasArgument(const int argc, char* argv[], const std::string_view expectedArgument) {
		for (int index = 1; index < argc; ++index) {
			if (std::string_view(argv[index]) == expectedArgument) {
				return true;
			}
		}
		return false;
	}
}

int main(int argc, char* argv[]) {
	auto &server = inject<CanaryServer>();
	if (hasArgument(argc, argv, GenerateLuaApiDocsOnlyArgument)) {
		return server.generateLuaApiDocsOnly();
	}

	return server.run();
}
