/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <cstdint>

namespace ForgeTransferPolicy {
	[[nodiscard]] constexpr bool hasMatchingClassification(uint8_t donorClassification, uint8_t receiveClassification) {
		return donorClassification > 0 && donorClassification == receiveClassification;
	}

	[[nodiscard]] constexpr bool isValidDonorTier(uint8_t donorTier, bool convergence) {
		return convergence ? donorTier >= 1 : donorTier >= 2;
	}

	[[nodiscard]] constexpr uint8_t resourceTier(uint8_t donorTier) {
		return donorTier;
	}

	[[nodiscard]] constexpr uint8_t resultTier(uint8_t donorTier, bool convergence) {
		return convergence ? donorTier : static_cast<uint8_t>(donorTier - 1);
	}
}
