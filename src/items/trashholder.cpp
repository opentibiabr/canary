/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "items/trashholder.h"
#include "game/game.h"

ReturnValue TrashHolder::queryAdd(int32_t, const Thing&, uint32_t, uint32_t, Creature*) const
{
	return RETURNVALUE_NOERROR;
}

ReturnValue TrashHolder::queryMaxCount(int32_t, const Thing&, uint32_t queryCount, uint32_t& maxQueryCount, uint32_t) const
{
	maxQueryCount = std::max<uint32_t>(1, queryCount);
	return RETURNVALUE_NOERROR;
}

ReturnValue TrashHolder::queryRemove(const Thing&, uint32_t, uint32_t, Creature* /*= nullptr*/) const
{
	return RETURNVALUE_NOTPOSSIBLE;
}

Cylinder* TrashHolder::queryDestination(int32_t&, const Thing&, Item**, uint32_t&)
{
	return this;
}

void TrashHolder::addThing(Thing* thing)
{
	return addThing(0, thing);
}

void TrashHolder::addThing(int32_t, Thing* thing)
{
	Item* item = thing->getItem();
	if (!item) {
		return;
	}

	if (item == this || !item->hasProperty(CONST_PROP_MOVEABLE)) {
		return;
	}

	const ItemType& it = Item::items[id];
	if (item->isHangable() && it.isGroundTile()) {
		Tile* tile = dynamic_cast<Tile*>(getParent());
		if (tile && tile->hasFlag(TILESTATE_SUPPORTS_HANGABLE)) {
			return;
		}
	}

	g_game().internalRemoveItem(item);

	if (it.magicEffect != CONST_ME_NONE) {
		g_game().addMagicEffect(getPosition(), it.magicEffect);
	}
}

void TrashHolder::updateThing(Thing*, uint16_t, uint32_t)
{
	//
}

void TrashHolder::replaceThing(uint32_t, Thing*)
{
	//
}

void TrashHolder::removeThing(Thing*, uint32_t)
{
	//
}

void TrashHolder::postAddNotification(Thing* thing, const Cylinder* oldParent, int32_t index, CylinderLink_t)
{
	getParent()->postAddNotification(thing, oldParent, index, LINK_PARENT);
}

void TrashHolder::postRemoveNotification(Thing* thing, const Cylinder* newParent, int32_t index, CylinderLink_t)
{
	getParent()->postRemoveNotification(thing, newParent, index, LINK_PARENT);
}
