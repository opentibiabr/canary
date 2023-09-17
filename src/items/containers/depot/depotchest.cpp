/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/containers/depot/depotchest.hpp"
#include "utils/tools.hpp"

DepotChest::DepotChest(uint16_t type) :
	Container(type) {
	maxDepotItems = 2000;
	maxSize = 32;
	pagination = true;
}

ReturnValue DepotChest::queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature> actor /* = nullptr*/) {
	std::shared_ptr<Item> item = thing->getItem();
	if (item == nullptr) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	bool skipLimit = hasBitSet(FLAG_NOLIMIT, flags);
	if (!skipLimit) {
		int32_t addCount = 0;

		if ((item->isStackable() && item->getItemCount() != count)) {
			addCount = 1;
		}

		if (item->getTopParent().get() != this) {
			if (std::shared_ptr<Container> container = item->getContainer()) {
				addCount = container->getItemHoldingCount() + 1;
			} else {
				addCount = 1;
			}
		}

		if (std::shared_ptr<Cylinder> localParent = getRealParent()) {
			if (localParent->getContainer()->getItemHoldingCount() + addCount > maxDepotItems) {
				return RETURNVALUE_DEPOTISFULL;
			}
		} else if (getItemHoldingCount() + addCount > maxDepotItems) {
			return RETURNVALUE_DEPOTISFULL;
		}
	}

	return Container::queryAdd(index, thing, count, flags, actor);
}

void DepotChest::postAddNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> oldParent, int32_t index, CylinderLink_t) {
	std::shared_ptr<Cylinder> localParent = getParent();
	if (localParent != nullptr) {
		localParent->postAddNotification(thing, oldParent, index, LINK_PARENT);
	}
}

void DepotChest::postRemoveNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> newParent, int32_t index, CylinderLink_t) {
	std::shared_ptr<Cylinder> localParent = getParent();
	if (localParent != nullptr) {
		localParent->postRemoveNotification(thing, newParent, index, LINK_PARENT);
	}
}

std::shared_ptr<Cylinder> DepotChest::getParent() {
	auto parentLocked = m_parent.lock();
	if (parentLocked && parentLocked->getParent()) {
		return parentLocked->getParent()->getParent();
	}
	return nullptr;
}
