/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/item.hpp"

class House;
class Player;

class BedItem final : public Item {
public:
	explicit BedItem(uint16_t id);

	std::shared_ptr<BedItem> getBed() override {
		return static_self_cast<BedItem>();
	}

	Attr_ReadValue readAttr(AttrTypes_t attr, PropStream &propStream) override;
	void serializeAttr(PropWriteStream &propWriteStream) const override;

	bool canRemove() const override {
		return true;
	}

	uint32_t getSleeper() const {
		return sleeperGUID;
	}

	void setHouse(const std::shared_ptr<House> &h) {
		house = h;
	}

	bool canUse(std::shared_ptr<Player> player);

	bool isBedComplete(std::shared_ptr<BedItem> nextBedItem);

	bool trySleep(std::shared_ptr<Player> player);
	bool sleep(std::shared_ptr<Player> player);
	void wakeUp(std::shared_ptr<Player> player);

	std::shared_ptr<BedItem> getNextBedItem();

	friend class MapCache;

private:
	void updateAppearance(std::shared_ptr<Player> player);
	void regeneratePlayer(std::shared_ptr<Player> player) const;
	void internalSetSleeper(std::shared_ptr<Player> player);
	void internalRemoveSleeper();

	std::shared_ptr<House> house;
	uint64_t sleepStart;
	uint32_t sleeperGUID;
};
