/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/channel_context.hpp"

#include <gtest/gtest.h>

namespace {
	std::vector<char*> makeArgv(std::vector<std::string> &storage) {
		std::vector<char*> argv;
		argv.reserve(storage.size());
		for (auto &value : storage) {
			argv.push_back(value.data());
		}
		return argv;
	}
} // namespace

TEST(ChannelContextTest, FallsBackToSingleChannelWhenNothingIsSet) {
	std::vector<std::string> storage { "canary" };
	auto argv = makeArgv(storage);
	EXPECT_EQ(1, ChannelContext::resolveFrom(std::span<char*>(argv.data(), argv.size()), nullptr));
}

TEST(ChannelContextTest, UsesEnvironmentWhenCliArgumentIsAbsent) {
	std::vector<std::string> storage { "canary" };
	auto argv = makeArgv(storage);
	EXPECT_EQ(3, ChannelContext::resolveFrom(std::span<char*>(argv.data(), argv.size()), "3"));
}

TEST(ChannelContextTest, CliArgumentTakesPriorityOverEnvironment) {
	std::vector<std::string> storage { "canary", "--channel-id=2" };
	auto argv = makeArgv(storage);
	EXPECT_EQ(2, ChannelContext::resolveFrom(std::span<char*>(argv.data(), argv.size()), "3"));
}

TEST(ChannelContextTest, MalformedCliArgumentFallsThroughToEnvironment) {
	std::vector<std::string> storage { "canary", "--channel-id=not-a-number" };
	auto argv = makeArgv(storage);
	EXPECT_EQ(3, ChannelContext::resolveFrom(std::span<char*>(argv.data(), argv.size()), "3"));
}

TEST(ChannelContextTest, MalformedEnvironmentFallsBackToSingleChannel) {
	std::vector<std::string> storage { "canary" };
	auto argv = makeArgv(storage);
	EXPECT_EQ(1, ChannelContext::resolveFrom(std::span<char*>(argv.data(), argv.size()), "not-a-number"));
}

TEST(ChannelContextTest, RejectsZeroAndNegativeChannelIds) {
	std::vector<std::string> storage { "canary", "--channel-id=0" };
	auto argv = makeArgv(storage);
	EXPECT_EQ(1, ChannelContext::resolveFrom(std::span<char*>(argv.data(), argv.size()), nullptr));

	std::vector<std::string> negativeStorage { "canary", "--channel-id=-1" };
	auto negativeArgv = makeArgv(negativeStorage);
	EXPECT_EQ(1, ChannelContext::resolveFrom(std::span<char*>(negativeArgv.data(), negativeArgv.size()), nullptr));
}

TEST(ChannelContextTest, ResolveFromIsPureAndStatelessAcrossCalls) {
	// resolveFrom() takes no instance state, so repeated calls with different
	// inputs must never be affected by previous calls (unlike the instance
	// method resolve(), which intentionally caches its first result).
	std::vector<std::string> storage { "canary" };
	auto argv = makeArgv(storage);
	const std::span<char*> arguments(argv.data(), argv.size());

	EXPECT_EQ(5, ChannelContext::resolveFrom(arguments, "5"));
	EXPECT_EQ(7, ChannelContext::resolveFrom(arguments, "7"));
}
