/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "items/trashholder.hpp"

#include "game/game.hpp"

ReturnValue TrashHolder::queryAdd(int32_t, const std::shared_ptr<Thing> &thing, uint32_t, uint32_t, const std::shared_ptr<Creature> &actor) {
	if (!thing) {
		return RETURNVALUE_NOERROR;
	}

	const auto &item = thing->getItem();
	if (item == nullptr) {
		return RETURNVALUE_NOERROR;
	}
	if (item->hasOwner() && !item->isOwner(actor)) {
		return RETURNVALUE_ITEMISNOTYOURS;
	}
	return RETURNVALUE_NOERROR;
}

ReturnValue TrashHolder::queryMaxCount(int32_t, const std::shared_ptr<Thing> &, uint32_t queryCount, uint32_t &maxQueryCount, uint32_t) {
	maxQueryCount = std::max<uint32_t>(1, queryCount);
	return RETURNVALUE_NOERROR;
}

ReturnValue TrashHolder::queryRemove(const std::shared_ptr<Thing> &, uint32_t, uint32_t, const std::shared_ptr<Creature> & /*= nullptr */) {
	return RETURNVALUE_NOTPOSSIBLE;
}

std::shared_ptr<Cylinder> TrashHolder::queryDestination(int32_t &, const std::shared_ptr<Thing> &, std::shared_ptr<Item> &, uint32_t &) {
	return static_self_cast<TrashHolder>();
}

void TrashHolder::addThing(const std::shared_ptr<Thing> &thing) {
	return addThing(0, thing);
}

void TrashHolder::addThing(int32_t, const std::shared_ptr<Thing> &thing) {
	if (!thing) {
		return;
	}

	const auto &item = thing->getItem();
	if (!item) {
		return;
	}

	if (item.get() == this || !item->hasProperty(CONST_PROP_MOVABLE)) {
		return;
	}

	const ItemType &it = Item::items[id];
	if (item->isHangable() && it.isGroundTile()) {
		const std::shared_ptr<Tile> &tile = std::dynamic_pointer_cast<Tile>(getParent());
		if (tile && tile->hasFlag(TILESTATE_SUPPORTS_HANGABLE)) {
			return;
		}
	}

	if (item->isCarpet() || item->getID() == ITEM_DECORATION_KIT) {
		return;
	}
	g_game().internalRemoveItem(item);

	if (it.magicEffect != CONST_ME_NONE) {
		g_game().addMagicEffect(getPosition(), it.magicEffect);
	}
}

void TrashHolder::updateThing(const std::shared_ptr<Thing> &, uint16_t, uint32_t) {
	//
}

void TrashHolder::replaceThing(uint32_t, const std::shared_ptr<Thing> &) {
	//
}

void TrashHolder::removeThing(const std::shared_ptr<Thing> &, uint32_t) {
	//
}

void TrashHolder::postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t) {
	getParent()->postAddNotification(thing, oldParent, index, LINK_PARENT);
}

void TrashHolder::postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t) {
	getParent()->postRemoveNotification(thing, newParent, index, LINK_PARENT);
}
