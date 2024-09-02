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

class DepotChest final : public Container {
public:
	explicit DepotChest(uint16_t type);

	// serialization
	void setMaxDepotItems(uint32_t maxitems) {
		maxDepotItems = maxitems;
	}

	// cylinder implementations
	ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;

	void postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
	void postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

	bool isDepotChest() const override {
		return true;
	}

	// overrides
	bool canRemove() const override {
		return false;
	}
	bool isRemoved() override {
		return false;
	}

	std::shared_ptr<Cylinder> getParent() override;
	std::shared_ptr<Cylinder> getRealParent() override {
		return m_parent.lock();
	}

private:
	uint32_t maxDepotItems;
};
