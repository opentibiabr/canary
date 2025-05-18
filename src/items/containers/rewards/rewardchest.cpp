/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "items/containers/rewards/rewardchest.hpp"

RewardChest::RewardChest(uint16_t type) :
	Container(type) {
	maxSize = 32;
	unlocked = false;
	pagination = true;
}

ReturnValue RewardChest::queryAdd(int32_t, const std::shared_ptr<Thing> &, uint32_t, uint32_t, const std::shared_ptr<Creature> &actor /* = nullptr*/) {
	if (actor) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	return RETURNVALUE_NOERROR;
}

void RewardChest::postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t) {
	const auto &parentLocked = m_parent.lock();
	if (parentLocked) {
		parentLocked->postAddNotification(thing, oldParent, index, LINK_PARENT);
	}
}

void RewardChest::postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t) {
	const auto &parentLocked = m_parent.lock();
	if (parentLocked) {
		parentLocked->postRemoveNotification(thing, newParent, index, LINK_PARENT);
	}
}

// Second argument is disabled by default because not need to send to client in the RewardChest
void RewardChest::removeItem(const std::shared_ptr<Thing> &thing, bool /* sendToClient = false*/) {
	if (thing == nullptr) {
		return;
	}

	const auto &itemToRemove = thing->getItem();
	if (itemToRemove == nullptr) {
		return;
	}

	const auto it = std::ranges::find(itemlist.begin(), itemlist.end(), itemToRemove);
	if (it != itemlist.end()) {
		itemlist.erase(it);
		itemToRemove->resetParent();
	}
}
