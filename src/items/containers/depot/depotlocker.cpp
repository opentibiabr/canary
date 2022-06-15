/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "otpch.h"

#include "items/containers/depot/depotlocker.h"

DepotLocker::DepotLocker(uint16_t type) : Container(type, 4) {}

ReturnValue DepotLocker::queryAdd(int32_t, const Thing&, uint32_t, uint32_t, Creature*) const
{
	return RETURNVALUE_NOTENOUGHROOM;
}

void DepotLocker::postAddNotification(Thing* thing, const Cylinder* oldParent, int32_t index, CylinderLink_t)
{
	if (parent != nullptr) {
		parent->postAddNotification(thing, oldParent, index, LINK_PARENT);
	}
}

void DepotLocker::postRemoveNotification(Thing* thing, const Cylinder* newParent, int32_t index, CylinderLink_t)
{
	if (parent != nullptr) {
		parent->postRemoveNotification(thing, newParent, index, LINK_PARENT);
	}
}

void DepotLocker::removeInbox(Inbox* inbox)
{
	auto cit = std::ranges::find(itemlist.begin(), itemlist.end(), inbox);
	if (cit == itemlist.end()) {
		return;
	}
	itemlist.erase(cit);
}
