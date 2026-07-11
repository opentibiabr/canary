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
	#include <span>
	#include <string>
#endif

// Resolves and holds the identity of the channel this process represents.
// config.lua is shared by every process in a cluster (see
// docs/multichannel/ARCHITECTURE.md §3.1), so the channel id can never live
// there — it is resolved once, per process, from the command line or the
// environment, with a safe single-channel fallback.
class ChannelContext {
public:
	ChannelContext() = default;

	// Singleton - ensures we don't accidentally copy it.
	ChannelContext(const ChannelContext &) = delete;
	ChannelContext &operator=(const ChannelContext &) = delete;

	static constexpr int32_t DefaultSingleChannelId = 1;
	static constexpr std::string_view CliArgumentPrefix = "--channel-id=";
	static constexpr std::string_view EnvironmentVariableName = "CANARY_CHANNEL_ID";

	static ChannelContext &getInstance();

	// Resolution priority: CLI argument > environment variable > fallback (1).
	// Safe to call multiple times; the result of the first call is kept.
	int32_t resolve(std::span<char*> arguments);

	// Resolves purely from the environment (used by tests and by callers that
	// don't have argv, e.g. code paths that only ever run in single-channel
	// mode and never parse arguments).
	int32_t resolve();

	[[nodiscard]] int32_t getChannelId() const {
		return channelId;
	}

	[[nodiscard]] bool isResolved() const {
		return resolved;
	}

	// Test-only: reset resolution so a unit test can exercise resolve() again
	// with different inputs.
	void resetForTesting() {
		resolved = false;
		channelId = DefaultSingleChannelId;
	}

	// Pure helper, exposed for unit testing without touching process argv/env.
	static int32_t resolveFrom(std::span<char*> arguments, const char* environmentValue);

private:
	int32_t channelId = DefaultSingleChannelId;
	bool resolved = false;
};

constexpr auto g_channelContext = ChannelContext::getInstance;
