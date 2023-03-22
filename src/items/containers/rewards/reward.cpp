/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/containers/rewards/reward.h"

Reward::Reward() :
	Container(ITEM_REWARD_CONTAINER) {
	maxSize = 32;
	unlocked = false;
	pagination = true;
}

ReturnValue Reward::queryAdd(int32_t, const Thing &thing, uint32_t, uint32_t, Creature* actor /* = nullptr*/) const {
	if (actor) {
		return RETURNVALUE_NOTPOSSIBLE;
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

	return RETURNVALUE_NOERROR;
}

void Reward::postAddNotification(Thing* thing, const Cylinder* oldParent, int32_t index, CylinderLink_t) {
	Cylinder* localParent = getParent();
	if (localParent != nullptr) {
		localParent->postAddNotification(thing, oldParent, index, LINK_PARENT);
	}
}

void Reward::postRemoveNotification(Thing* thing, const Cylinder* newParent, int32_t index, CylinderLink_t) {
	Cylinder* localParent = getParent();
	if (localParent != nullptr) {
		localParent->postRemoveNotification(thing, newParent, index, LINK_PARENT);
	}
}

Cylinder* Reward::getParent() const {
	if (parent) {
		return parent->getParent();
	}
	return nullptr;
}
