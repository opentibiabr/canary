/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "pch.hpp"

#include "items/containers/inbox/inbox.h"
#include "utils/tools.h"

Inbox::Inbox(uint16_t type) : Container(type, 30, false, true)
{
	maxInboxItems = std::numeric_limits<uint16_t>::max();
}

ReturnValue Inbox::queryAdd(int32_t, const Thing& thing, uint32_t,
		uint32_t flags, Creature*) const
{
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

	if (item->getTopParent() != this) { //MY
		if (const Container* container = item->getContainer()) {
			addCount = container->getItemHoldingCount() + 1;
		}
		else {
			addCount = 1;
		}
	}

	if (getItemHoldingCount() + addCount > maxInboxItems) { //MY
		return RETURNVALUE_DEPOTISFULL;
	}

	return RETURNVALUE_NOERROR;
}

void Inbox::postAddNotification(Thing* thing, const Cylinder* oldParent, int32_t index, CylinderLink_t)
{
	Cylinder* localParent = getParent();
	if (localParent != nullptr) {
		localParent->postAddNotification(thing, oldParent, index, LINK_PARENT);
	}
}

void Inbox::postRemoveNotification(Thing* thing, const Cylinder* newParent, int32_t index, CylinderLink_t)
{
	Cylinder* localParent = getParent();
	if (localParent != nullptr) {
		localParent->postRemoveNotification(thing, newParent, index, LINK_PARENT);
	}
}

Cylinder* Inbox::getParent() const
{
	if (parent) {
		return parent->getParent();
	}
	return nullptr;
}
