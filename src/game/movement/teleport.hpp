/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/cylinder.hpp"
#include "items/item.hpp"

class Tile;

class Teleport final : public Item, public Cylinder {
public:
	explicit Teleport(uint16_t type) :
		Item(type) {};

	std::shared_ptr<Teleport> getTeleport() override {
		return static_self_cast<Teleport>();
	}

	std::shared_ptr<Cylinder> getCylinder() override {
		return getTeleport();
	}

	// serialization
	Attr_ReadValue readAttr(AttrTypes_t attr, PropStream &propStream) override;
	void serializeAttr(PropWriteStream &propWriteStream) const override;

	const Position &getDestPos() const {
		return destPos;
	}
	void setDestPos(Position pos) {
		destPos = pos;
	}

	bool checkInfinityLoop(const std::shared_ptr<Tile> &destTile);

	// cylinder implementations
	ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;
	ReturnValue queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) override;
	ReturnValue queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;
	std::shared_ptr<Cylinder> queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item> &destItem, uint32_t &flags) override;

	void addThing(const std::shared_ptr<Thing> &thing) override;
	void addThing(int32_t index, const std::shared_ptr<Thing> &thing) override;

	void updateThing(const std::shared_ptr<Thing> &thing, uint16_t itemId, uint32_t count) override;
	void replaceThing(uint32_t index, const std::shared_ptr<Thing> &thing) override;

	void removeThing(const std::shared_ptr<Thing> &thing, uint32_t count) override;

	void postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
	void postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

private:
	Position destPos;
};
