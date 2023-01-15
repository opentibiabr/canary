/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_ITEMS_ITEMS_CLASSIFICATION_HPP_
#define SRC_ITEMS_ITEMS_CLASSIFICATION_HPP_

// Classification class for forging system and market.
class ItemClassification
{
 public:
	ItemClassification() = default;
	explicit ItemClassification(uint8_t id) :
		id(id) {}
	virtual ~ItemClassification() = default;

	void addTier(uint8_t tierId, uint64_t tierPrice)
	{
		for (auto [tier, price] : tiers) {
			if (tier == tierId) {
				price = tierPrice;
				return;
			}
		}

		tiers.push_back(std::pair<uint8_t, uint64_t>({ tierId, tierPrice }));
	}

	uint8_t id;
	// uint8_t = tier, uint64_t = price
	std::vector<std::pair<uint8_t, uint64_t>> tiers;
};

#endif  // SRC_ITEMS_ITEMS_CLASSIFICATION_HPP_
