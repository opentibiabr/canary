/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_ITEMS_CONTAINERS_INBOX_INBOX_H_
#define SRC_ITEMS_CONTAINERS_INBOX_INBOX_H_

#include "items/containers/container.h"

class Inbox final : public Container {
	public:
		explicit Inbox(uint16_t type);

		void setMaxInboxItems(uint32_t maxitems) {
			maxInboxItems = maxitems;
		}

		// cylinder implementations
		ReturnValue queryAdd(int32_t index, const Thing &thing, uint32_t count, uint32_t flags, Creature* actor = nullptr) const override;

		void postAddNotification(Thing* thing, const Cylinder* oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
		void postRemoveNotification(Thing* thing, const Cylinder* newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

		bool isInbox() const override {
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
		uint32_t maxInboxItems;
};

#endif // SRC_ITEMS_CONTAINERS_INBOX_INBOX_H_
