/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_ITEMS_CONTAINERS_DEPOT_DEPOTLOCKER_H_
#define SRC_ITEMS_CONTAINERS_DEPOT_DEPOTLOCKER_H_

#include "items/containers/container.h"
#include "items/containers/inbox/inbox.h"

class DepotLocker final : public Container {
	public:
		explicit DepotLocker(uint16_t type);

		DepotLocker* getDepotLocker() override {
			return this;
		}
		const DepotLocker* getDepotLocker() const override {
			return this;
		}

		void removeInbox(Inbox* inbox);

		// serialization
		Attr_ReadValue readAttr(AttrTypes_t attr, PropStream &propStream) override;

		uint16_t getDepotId() const {
			return depotId;
		}
		void setDepotId(uint16_t newDepotId) {
			this->depotId = newDepotId;
		}

		// cylinder implementations
		ReturnValue queryAdd(int32_t index, const Thing &thing, uint32_t count, uint32_t flags, Creature* actor = nullptr) const override;

		void postAddNotification(Thing* thing, const Cylinder* oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
		void postRemoveNotification(Thing* thing, const Cylinder* newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

		bool canRemove() const override {
			return false;
		}
		bool isRemoved() const override {
			return false;
		}

	private:
		uint16_t depotId;
};

#endif // SRC_ITEMS_CONTAINERS_DEPOT_DEPOTLOCKER_H_
