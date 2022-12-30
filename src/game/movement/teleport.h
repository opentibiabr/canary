/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_GAME_MOVEMENT_TELEPORT_H_
#define SRC_GAME_MOVEMENT_TELEPORT_H_

#include "items/tile.h"

class Teleport final : public Item, public Cylinder
{
	public:
		explicit Teleport(uint16_t type) : Item(type) {};

		Teleport* getTeleport() override {
			return this;
		}
		const Teleport* getTeleport() const override {
			return this;
		}

		//serialization
		Attr_ReadValue readAttr(AttrTypes_t attr, PropStream& propStream) override;
		void serializeAttr(PropWriteStream& propWriteStream) const override;

		const Position& getDestPos() const {
			return destPos;
		}
		void setDestPos(Position pos) {
			destPos = std::move(pos);
		}

		bool checkInfinityLoop(Tile* destTile);

		//cylinder implementations
		ReturnValue queryAdd(int32_t index, const Thing& thing, uint32_t count,
				uint32_t flags, Creature* actor = nullptr) const override;
		ReturnValue queryMaxCount(int32_t index, const Thing& thing, uint32_t count,
				uint32_t& maxQueryCount, uint32_t flags) const override;
		ReturnValue queryRemove(const Thing& thing, uint32_t count, uint32_t flags, Creature* actor = nullptr) const override;
		Cylinder* queryDestination(int32_t& index, const Thing& thing, Item** destItem,
				uint32_t& flags) override;

		void addThing(Thing* thing) override;
		void addThing(int32_t index, Thing* thing) override;

		void updateThing(Thing* thing, uint16_t itemId, uint32_t count) override;
		void replaceThing(uint32_t index, Thing* thing) override;

		void removeThing(Thing* thing, uint32_t count) override;

		void postAddNotification(Thing* thing, const Cylinder* oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
		void postRemoveNotification(Thing* thing, const Cylinder* newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

	private:
		Position destPos;
};

#endif  // SRC_GAME_MOVEMENT_TELEPORT_H_
