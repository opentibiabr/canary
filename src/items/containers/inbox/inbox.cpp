/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/containers/inbox/inbox.h"
#include "utils/tools.h"

Inbox::Inbox(uint16_t type) :
	Container(type, 30, false, true) {
	maxInboxItems = std::numeric_limits<uint16_t>::max();
}

ReturnValue Inbox::queryAdd(int32_t, const Thing &thing, uint32_t, uint32_t flags, Creature*) const {
	int32_t addCount = 0;

	if (!hasBitSet(FLAG_NOLIMIT, flags)) {
		return RETURNVALUE_CONTAINERNOTENOUGHROOM;
	}

	const Item* item = thing.getItem();
	if (!item) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (item == this) {
		return RETURNVALUE_THISISIMPOSSIBLE;
	}

	if (!item->isPickupable()) {
		return RETURNVALUE_CANNOTPICKUP;
	}

	if (item->getTopParent() != this) { // MY
		if (const Container* container = item->getContainer()) {
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

void Inbox::postAddNotification(Thing* thing, const Cylinder* oldParent, int32_t index, CylinderLink_t) {
	Cylinder* localParent = getParent();
	if (localParent != nullptr) {
		localParent->postAddNotification(thing, oldParent, index, LINK_PARENT);
	}
}

void Inbox::postRemoveNotification(Thing* thing, const Cylinder* newParent, int32_t index, CylinderLink_t) {
	Cylinder* localParent = getParent();
	if (localParent != nullptr) {
		localParent->postRemoveNotification(thing, newParent, index, LINK_PARENT);
	}
}

Cylinder* Inbox::getParent() const {
	if (parent) {
		return parent->getParent();
	}
	return nullptr;
}
