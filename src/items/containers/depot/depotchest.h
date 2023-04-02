/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_ITEMS_CONTAINERS_DEPOT_DEPOTCHEST_H_
#define SRC_ITEMS_CONTAINERS_DEPOT_DEPOTCHEST_H_

#include "items/containers/container.h"

class DepotChest final : public Container {
	public:
		explicit DepotChest(uint16_t type);

		// serialization
		void setMaxDepotItems(uint32_t maxitems) {
			maxDepotItems = maxitems;
		}

		// cylinder implementations
		ReturnValue queryAdd(int32_t index, const Thing &thing, uint32_t count, uint32_t flags, Creature* actor = nullptr) const override;

		void postAddNotification(Thing* thing, const Cylinder* oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
		void postRemoveNotification(Thing* thing, const Cylinder* newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

		bool isDepotChest() const override {
			return true;
		}

		// overrides
		bool canRemove() const override {
			return false;
		}
		bool isRemoved() const override {
			return false;
		}

		Cylinder* getParent() const override;
		Cylinder* getRealParent() const override {
			return parent;
		}

	private:
		uint32_t maxDepotItems;
};

#endif // SRC_ITEMS_CONTAINERS_DEPOT_DEPOTCHEST_H_
