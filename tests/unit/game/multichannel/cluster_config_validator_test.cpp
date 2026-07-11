/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/cluster_config_validator.hpp"

#include <algorithm>
#include <gtest/gtest.h>

namespace {
	ClusterConfigValidationInput validInput() {
		ClusterConfigValidationInput input;
		input.multiChannelEnabled = true;
		input.sessionLeaseTtlMs = 30000;
		input.sessionHeartbeatIntervalMs = 5000;
		input.channelSwitchPartyPolicy = "deny";
		input.pvpChannelExitPolicy = "combat-or-skull";
		input.redisClientCompiledIn = true;

		ChannelInfo channel;
		channel.id = 1;
		channel.name = "Channel 1";
		channel.pvpType = "no-pvp";
		channel.enabled = true;
		input.currentChannel = channel;
		return input;
	}

	bool contains(const std::vector<ClusterConfigValidationError> &errors, ClusterConfigValidationError target) {
		return std::ranges::find(errors, target) != errors.end();
	}
} // namespace

TEST(ClusterConfigValidatorTest, SingleChannelModeIsAlwaysValidNoOp) {
	ClusterConfigValidationInput input;
	input.multiChannelEnabled = false;
	// Deliberately leave every other field at its invalid default - must
	// still be valid, since validation is a no-op when disabled.
	const auto result = ClusterConfigValidator::validate(input);
	EXPECT_TRUE(result.valid);
	EXPECT_TRUE(result.errors.empty());
}

TEST(ClusterConfigValidatorTest, ValidInputPasses) {
	const auto result = ClusterConfigValidator::validate(validInput());
	EXPECT_TRUE(result.valid);
	EXPECT_TRUE(result.errors.empty());
}

TEST(ClusterConfigValidatorTest, RejectsLeaseTtlNotGreaterThanHeartbeat) {
	auto input = validInput();
	input.sessionLeaseTtlMs = 5000;
	input.sessionHeartbeatIntervalMs = 5000;
	const auto result = ClusterConfigValidator::validate(input);
	EXPECT_FALSE(result.valid);
	EXPECT_TRUE(contains(result.errors, ClusterConfigValidationError::LeaseTtlNotGreaterThanHeartbeat));
}

TEST(ClusterConfigValidatorTest, WarnsButDoesNotFailWhenMarginIsThin) {
	auto input = validInput();
	input.sessionLeaseTtlMs = 6000;
	input.sessionHeartbeatIntervalMs = 5000; // > but < 2x
	const auto result = ClusterConfigValidator::validate(input);
	EXPECT_TRUE(result.valid);
	EXPECT_FALSE(result.warnings.empty());
}

TEST(ClusterConfigValidatorTest, RejectsInvalidPartyPolicy) {
	auto input = validInput();
	input.channelSwitchPartyPolicy = "not-a-policy";
	const auto result = ClusterConfigValidator::validate(input);
	EXPECT_FALSE(result.valid);
	EXPECT_TRUE(contains(result.errors, ClusterConfigValidationError::InvalidPartyPolicy));
}

TEST(ClusterConfigValidatorTest, RejectsInvalidPvpExitPolicy) {
	auto input = validInput();
	input.pvpChannelExitPolicy = "not-a-policy";
	const auto result = ClusterConfigValidator::validate(input);
	EXPECT_FALSE(result.valid);
	EXPECT_TRUE(contains(result.errors, ClusterConfigValidationError::InvalidPvpExitPolicy));
}

TEST(ClusterConfigValidatorTest, RejectsWhenRedisClientNotCompiledIn) {
	auto input = validInput();
	input.redisClientCompiledIn = false;
	const auto result = ClusterConfigValidator::validate(input);
	EXPECT_FALSE(result.valid);
	EXPECT_TRUE(contains(result.errors, ClusterConfigValidationError::RedisClientNotCompiledIn));
}

TEST(ClusterConfigValidatorTest, RejectsWhenCurrentChannelIsMissing) {
	auto input = validInput();
	input.currentChannel.reset();
	const auto result = ClusterConfigValidator::validate(input);
	EXPECT_FALSE(result.valid);
	EXPECT_TRUE(contains(result.errors, ClusterConfigValidationError::CurrentChannelMissing));
}

TEST(ClusterConfigValidatorTest, RejectsWhenCurrentChannelIsDisabled) {
	auto input = validInput();
	input.currentChannel->enabled = false;
	const auto result = ClusterConfigValidator::validate(input);
	EXPECT_FALSE(result.valid);
	EXPECT_TRUE(contains(result.errors, ClusterConfigValidationError::CurrentChannelDisabled));
}

TEST(ClusterConfigValidatorTest, RejectsWhenCurrentChannelHasInvalidPvpType) {
	auto input = validInput();
	input.currentChannel->pvpType = "free-for-all";
	const auto result = ClusterConfigValidator::validate(input);
	EXPECT_FALSE(result.valid);
	EXPECT_TRUE(contains(result.errors, ClusterConfigValidationError::CurrentChannelInvalidPvpType));
}

TEST(ClusterConfigValidatorTest, CollectsMultipleErrorsAtOnce) {
	auto input = validInput();
	input.channelSwitchPartyPolicy = "bad";
	input.pvpChannelExitPolicy = "bad";
	input.redisClientCompiledIn = false;
	const auto result = ClusterConfigValidator::validate(input);
	EXPECT_FALSE(result.valid);
	EXPECT_GE(result.errors.size(), 3u);
}

TEST(ClusterConfigValidatorTest, DescribeReturnsNonEmptyStringForEveryError) {
	const std::vector<ClusterConfigValidationError> allErrors = {
		ClusterConfigValidationError::LeaseTtlNotGreaterThanHeartbeat,
		ClusterConfigValidationError::InvalidPartyPolicy,
		ClusterConfigValidationError::InvalidPvpExitPolicy,
		ClusterConfigValidationError::RedisClientNotCompiledIn,
		ClusterConfigValidationError::CurrentChannelMissing,
		ClusterConfigValidationError::CurrentChannelDisabled,
		ClusterConfigValidationError::CurrentChannelInvalidPvpType,
	};
	for (const auto &error : allErrors) {
		EXPECT_FALSE(describeClusterConfigValidationError(error).empty());
	}
}
