/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/containers/container.hpp"
#include "items/containers/inbox/inbox.hpp"

class DepotLocker final : public Container {
public:
	explicit DepotLocker(uint16_t type, uint16_t size);

	std::shared_ptr<DepotLocker> getDepotLocker() override {
		return static_self_cast<DepotLocker>();
	}

	void removeInbox(std::shared_ptr<Inbox> inbox);

	// serialization
	Attr_ReadValue readAttr(AttrTypes_t attr, PropStream &propStream) override;

	uint16_t getDepotId() const {
		return depotId;
	}
	void setDepotId(uint16_t newDepotId) {
		this->depotId = newDepotId;
	}

	// cylinder implementations
	ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature> actor = nullptr) override;

	void postAddNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
	void postRemoveNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

	bool canRemove() const override {
		return false;
	}
	bool isRemoved() override {
		return false;
	}

private:
	uint16_t depotId;
};
