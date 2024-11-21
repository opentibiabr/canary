/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/tile.hpp"

class House;

class HouseTile final : public DynamicTile {
public:
	using Tile::addThing;

	HouseTile(const Position &position, std::shared_ptr<House> house);
	HouseTile(int32_t x, int32_t y, int32_t z, std::shared_ptr<House> house);

	// cylinder implementations
	ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;

	std::shared_ptr<Cylinder> queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item> &destItem, uint32_t &flags) override;

	ReturnValue queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;

	void addThing(int32_t index, const std::shared_ptr<Thing> &thing) override;
	void internalAddThing(uint32_t index, const std::shared_ptr<Thing> &thing) override;

	std::shared_ptr<House> getHouse() override {
		return house;
	}

private:
	void updateHouse(const std::shared_ptr<Item> &item) const;

	std::shared_ptr<House> house;
};
