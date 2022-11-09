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

#include "items/tile.h"
#include "creatures/monsters/monster.h"
#include "map/house/housetile.h"
#include "map/house/house.h"
#include "game/game.h"

HouseTile::HouseTile(int32_t initX, int32_t initY, int32_t initZ, House* initHouse) :
	DynamicTile(initX, initY, initZ), house(initHouse) {}

void HouseTile::addThing(int32_t index, Thing* thing)
{
	Tile::addThing(index, thing);

	if (!thing->getParent()) {
		return;
	}

	if (Item* item = thing->getItem()) {
		updateHouse(item);
	}
}

void HouseTile::internalAddThing(uint32_t index, Thing* thing)
{
	Tile::internalAddThing(index, thing);

	if (!thing->getParent()) {
		return;
	}

	if (Item* item = thing->getItem()) {
		updateHouse(item);
	}
}

void HouseTile::updateHouse(Item* item)
{
	if (item->getParent() != this) {
		return;
	}

	Door* door = item->getDoor();
	if (door) {
		if (door->getDoorId() != 0) {
			house->addDoor(door);
		}
	} else {
		BedItem* bed = item->getBed();
		if (bed) {
			house->addBed(bed);
		}
	}
}

ReturnValue HouseTile::queryAdd(int32_t index, const Thing& thing, uint32_t count, uint32_t tileFlags, Creature* actor/* = nullptr*/) const
{
	if (const Creature* creature = thing.getCreature()) {
		if (const Player* player = creature->getPlayer()) {
			if (!house->isInvited(player)) {
				return RETURNVALUE_PLAYERISNOTINVITED;
			}
		}
		else if (const Monster* monster = creature->getMonster()) {
			if (monster->isSummon()) {
				if (!house->isInvited(monster->getMaster()->getPlayer())) {
					return RETURNVALUE_NOTPOSSIBLE;
				}
				if (house->isInvited(monster->getMaster()->getPlayer()) && (hasFlag(TILESTATE_BLOCKSOLID) || (hasBitSet(FLAG_PATHFINDING, flags) && hasFlag(TILESTATE_NOFIELDBLOCKPATH)))) {
					return RETURNVALUE_NOTPOSSIBLE;
				}
				else {
					return RETURNVALUE_NOERROR;
				}
			}
		}
	}
	else if (thing.getItem() && actor) {
		Player* actorPlayer = actor->getPlayer();
		if (!house->isInvited(actorPlayer)) {
			return RETURNVALUE_CANNOTTHROW;
		}
	}
	return Tile::queryAdd(index, thing, count, tileFlags, actor);
}

Tile* HouseTile::queryDestination(int32_t& index, const Thing& thing, Item** destItem, uint32_t& tileFlags)
{
	if (const Creature* creature = thing.getCreature()) {
		if (const Player* player = creature->getPlayer()) {
			if (!house->isInvited(player)) {
				const Position& entryPos = house->getEntryPosition();
				Tile* destTile = g_game().map.getTile(entryPos);
				if (!destTile) {
					SPDLOG_ERROR("[HouseTile::queryDestination] - "
                                 "Entry not correct for house name: {} "
                                 "with id: {} not found tile: {}",
                                 house->getName(), house->getId(), entryPos.toString());
					destTile = g_game().map.getTile(player->getTemplePosition());
					if (!destTile) {
						destTile = &(Tile::nullptr_tile);
					}
				}

				index = -1;
				*destItem = nullptr;
				return destTile;
			}
		}
	}

	return Tile::queryDestination(index, thing, destItem, tileFlags);
}

ReturnValue HouseTile::queryRemove(const Thing& thing, uint32_t count, uint32_t flags, Creature* actor /*= nullptr*/) const
{
	const Item* item = thing.getItem();
	if (!item) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (actor && g_configManager().getBoolean(ONLY_INVITED_CAN_MOVE_HOUSE_ITEMS)) {
		Player* actorPlayer = actor->getPlayer();
		if (!house->isInvited(actorPlayer)) {
			return RETURNVALUE_PLAYERISNOTINVITED;
		}
	}
	return Tile::queryRemove(thing, count, flags);
}
