/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/movement/teleport.hpp"

#include "creatures/creature.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"

Attr_ReadValue Teleport::readAttr(AttrTypes_t attr, PropStream &propStream) {
	if (attr == ATTR_TELE_DEST) {
		if (!propStream.read<uint16_t>(destPos.x) || !propStream.read<uint16_t>(destPos.y) || !propStream.read<uint8_t>(destPos.z)) {
			return ATTR_READ_ERROR;
		}
		return ATTR_READ_CONTINUE;
	}
	return Item::readAttr(attr, propStream);
}

void Teleport::serializeAttr(PropWriteStream &propWriteStream) const {
	Item::serializeAttr(propWriteStream);

	propWriteStream.write<uint8_t>(ATTR_TELE_DEST);
	propWriteStream.write<uint16_t>(destPos.x);
	propWriteStream.write<uint16_t>(destPos.y);
	propWriteStream.write<uint8_t>(destPos.z);
}

ReturnValue Teleport::queryAdd(int32_t, const std::shared_ptr<Thing> &, uint32_t, uint32_t, const std::shared_ptr<Creature> &) {
	return RETURNVALUE_NOTPOSSIBLE;
}

ReturnValue Teleport::queryMaxCount(int32_t, const std::shared_ptr<Thing> &, uint32_t, uint32_t &, uint32_t) {
	return RETURNVALUE_NOTPOSSIBLE;
}

ReturnValue Teleport::queryRemove(const std::shared_ptr<Thing> &, uint32_t, uint32_t, const std::shared_ptr<Creature> & /*= nullptr */) {
	return RETURNVALUE_NOERROR;
}

std::shared_ptr<Cylinder> Teleport::queryDestination(int32_t &, const std::shared_ptr<Thing> &, std::shared_ptr<Item> &, uint32_t &) {
	return getTeleport();
}

bool Teleport::checkInfinityLoop(const std::shared_ptr<Tile> &destTile) {
	if (!destTile) {
		return false;
	}

	if (std::shared_ptr<Teleport> teleport = destTile->getTeleportItem()) {
		const Position &nextDestPos = teleport->getDestPos();
		if (getPosition() == nextDestPos) {
			return true;
		}
		return checkInfinityLoop(g_game().map.getTile(nextDestPos));
	}
	return false;
}

void Teleport::addThing(const std::shared_ptr<Thing> &thing) {
	return addThing(0, thing);
}

void Teleport::addThing(int32_t, const std::shared_ptr<Thing> &thing) {
	if (!thing) {
		return;
	}

	const std::shared_ptr<Tile> &destTile = g_game().map.getTile(destPos);
	if (!destTile) {
		return;
	}

	// Prevent infinity loop
	if (checkInfinityLoop(destTile)) {
		const Position &pos = getPosition();
		g_logger().warn("[Teleport:addThing] - "
		                "Infinity loop teleport at position: {}",
		                pos.toString());
		return;
	}

	const MagicEffectClasses effect = Item::items[id].magicEffect;

	if (const std::shared_ptr<Creature> &creature = thing->getCreature()) {
		Position origPos = creature->getPosition();
		g_game().internalCreatureTurn(creature, origPos.x > destPos.x ? DIRECTION_WEST : DIRECTION_EAST);
		g_dispatcher().addWalkEvent([=] {
			g_game().map.moveCreature(creature, destTile);
			if (effect != CONST_ME_NONE) {
				g_game().addMagicEffect(origPos, effect);
				g_game().addMagicEffect(destTile->getPosition(), effect);
			}
		});
	} else if (const auto &item = thing->getItem()) {
		if (effect != CONST_ME_NONE) {
			g_game().addMagicEffect(destTile->getPosition(), effect);
			g_game().addMagicEffect(item->getPosition(), effect);
		}
		g_game().internalMoveItem(getTile(), destTile, INDEX_WHEREEVER, item, item->getItemCount(), nullptr);
	}
}

void Teleport::updateThing(const std::shared_ptr<Thing> &, uint16_t, uint32_t) {
	//
}

void Teleport::replaceThing(uint32_t, const std::shared_ptr<Thing> &) {
	//
}

void Teleport::removeThing(const std::shared_ptr<Thing> &, uint32_t) {
	//
}

void Teleport::postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t) {
	getParent()->postAddNotification(thing, oldParent, index, LINK_PARENT);
}

void Teleport::postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t) {
	getParent()->postRemoveNotification(thing, newParent, index, LINK_PARENT);
}
