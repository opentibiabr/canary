/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

struct TierInfo {
	uint64_t priceToUpgrade = 0;
	uint8_t corePriceToFuse = 0;
};

// Classification class for forging system and market.
class ItemClassification {
public:
	ItemClassification() = default;
	explicit ItemClassification(uint8_t id) :
		id(id) { }
	virtual ~ItemClassification() = default;

	void addTier(uint8_t tierId, uint64_t tierPrice, uint8_t corePrice) {
		auto &table = tiers[tierId];
		table.priceToUpgrade = tierPrice;
		table.corePriceToFuse = corePrice;
	}

	uint8_t id;
	std::map<uint8_t, TierInfo> tiers;
};
