/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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
