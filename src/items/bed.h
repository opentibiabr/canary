/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
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

#ifndef SRC_ITEMS_BED_H_
#define SRC_ITEMS_BED_H_

#include "items/item.h"

class House;
class Player;

class BedItem final : public Item
{
	public:
		explicit BedItem(uint16_t id);

		BedItem* getBed() override {
			return this;
		}
		const BedItem* getBed() const override {
			return this;
		}

		void serializeAttr(PropWriteStream& propWriteStream) const override;

		bool canRemove() const override {
			return house == nullptr;
		}

		const uint32_t& getSleeperGUID() const override {
			return Item::getSleeperGUID();
		}

		void setSleeperGuid(uint32_t newSleeperGuid) override {
			Item::setSleepStart(newSleeperGuid);
		}
		const uint32_t& getSleepStart() const override {
			return Item::getSleepStart();
		}

		void setSleepStart(uint32_t newSleepStart) override {
			Item::setSleepStart(newSleepStart);
		}

		void setHouse(House* h) {
			house = h;
		}

		bool canUse(Player* player);

		bool trySleep(Player* player);
		bool sleep(Player* player);
		void wakeUp(Player* player);

		BedItem* getNextBedItem() const;

	private:
		void updateAppearance(const Player* player);
		void regeneratePlayer(Player* player) const;
		void internalSetSleeper(const Player* player);
		void internalRemoveSleeper();

		House* house = nullptr;
};

#endif  // SRC_ITEMS_BED_H_
