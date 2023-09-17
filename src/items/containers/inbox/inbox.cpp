/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/containers/inbox/inbox.hpp"
#include "utils/tools.hpp"

Inbox::Inbox(uint16_t type) :
	Container(type, 30, false, true) {
	maxInboxItems = std::numeric_limits<uint16_t>::max();
}

ReturnValue Inbox::queryAdd(int32_t, const std::shared_ptr<Thing> &thing, uint32_t, uint32_t flags, std::shared_ptr<Creature>) {
	int32_t addCount = 0;

	if (!hasBitSet(FLAG_NOLIMIT, flags)) {
		return RETURNVALUE_CONTAINERNOTENOUGHROOM;
	}

	std::shared_ptr<Item> item = thing->getItem();
	if (!item) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (item.get() == this) {
		return RETURNVALUE_THISISIMPOSSIBLE;
	}

	if (!item->isPickupable()) {
		return RETURNVALUE_CANNOTPICKUP;
	}

	if (item->getTopParent().get() != this) { // MY
		if (std::shared_ptr<Container> container = item->getContainer()) {
			addCount = container->getItemHoldingCount() + 1;
		} else {
			addCount = 1;
		}
	}

	if (getItemHoldingCount() + addCount > maxInboxItems) { // MY
		return RETURNVALUE_DEPOTISFULL;
	}

	return RETURNVALUE_NOERROR;
}

void Inbox::postAddNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> oldParent, int32_t index, CylinderLink_t) {
	std::shared_ptr<Cylinder> localParent = getParent();
	if (localParent != nullptr) {
		localParent->postAddNotification(thing, oldParent, index, LINK_PARENT);
	}
}

void Inbox::postRemoveNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> newParent, int32_t index, CylinderLink_t) {
	std::shared_ptr<Cylinder> localParent = getParent();
	if (localParent != nullptr) {
		localParent->postRemoveNotification(thing, newParent, index, LINK_PARENT);
	}
}

std::shared_ptr<Cylinder> Inbox::getParent() {
	auto parentLocked = m_parent.lock();
	if (parentLocked) {
		return parentLocked->getParent();
	}
	return nullptr;
}
