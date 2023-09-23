/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/containers/container.hpp"

class Reward : public Container {
public:
	explicit Reward();

	std::shared_ptr<Reward> getReward() final {
		return static_self_cast<Reward>();
	}

	// cylinder implementations
	ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature> actor = nullptr) final;

	void postAddNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) final;
	void postRemoveNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> newParent, int32_t index, CylinderLink_t link = LINK_OWNER) final;

	// overrides
	bool canRemove() const final {
		return true;
	}

	std::shared_ptr<Cylinder> getParent() final;
	std::shared_ptr<Cylinder> getRealParent() final {
		return m_parent.lock();
	}
};
