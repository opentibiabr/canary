/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "map/house/housetile.hpp"

#include "config/configmanager.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "items/tile.hpp"
#include "map/house/house.hpp"
#include "utils/tools.hpp"

HouseTile::HouseTile(const Position &position, std::shared_ptr<House> newHouse) :
	DynamicTile(position.x, position.y, position.z), house(std::move(newHouse)) { }

HouseTile::HouseTile(int32_t initX, int32_t initY, int32_t initZ, std::shared_ptr<House> initHouse) :
	DynamicTile(initX, initY, initZ), house(std::move(initHouse)) { }

void HouseTile::addThing(int32_t index, const std::shared_ptr<Thing> &thing) {
	Tile::addThing(index, thing);

	if (!thing || !thing->getParent()) {
		return;
	}

	if (const auto &item = thing->getItem()) {
		updateHouse(item);
	}
}

void HouseTile::internalAddThing(uint32_t index, const std::shared_ptr<Thing> &thing) {
	Tile::internalAddThing(index, thing);

	if (!thing || !thing->getParent()) {
		return;
	}

	if (const auto &item = thing->getItem()) {
		updateHouse(item);
	}
}

void HouseTile::updateHouse(const std::shared_ptr<Item> &item) const {
	if (item->getParent().get() != this) {
		return;
	}

	const auto &door = item->getDoor();
	if (door) {
		if (door->getDoorId() != 0) {
			house->addDoor(door);
		}
	} else {
		const auto &bed = item->getBed();
		if (bed) {
			house->addBed(bed);
		}
	}
}

ReturnValue HouseTile::queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t tileFlags, const std::shared_ptr<Creature> &actor /* = nullptr*/) {
	if (const auto &creature = thing->getCreature()) {
		if (const auto &player = creature->getPlayer()) {
			if (!house->isInvited(player)) {
				return RETURNVALUE_PLAYERISNOTINVITED;
			}
		} else if (const auto &monster = creature->getMonster()) {
			if (monster->isSummon()) {
				if (!house->isInvited(monster->getMaster()->getPlayer())) {
					return RETURNVALUE_NOTPOSSIBLE;
				}
				if (house->isInvited(monster->getMaster()->getPlayer()) && (hasFlag(TILESTATE_BLOCKSOLID) || (hasBitSet(FLAG_PATHFINDING, flags) && hasFlag(TILESTATE_NOFIELDBLOCKPATH)))) {
					return RETURNVALUE_NOTPOSSIBLE;
				} else {
					return RETURNVALUE_NOERROR;
				}
			}
		}
	} else if (thing->getItem() && actor) {
		const auto &actorPlayer = actor->getPlayer();
		if (house && (!house->isInvited(actorPlayer) || house->getHouseAccessLevel(actorPlayer) == HOUSE_GUEST) && g_configManager().getBoolean(ONLY_INVITED_CAN_MOVE_HOUSE_ITEMS)) {
			return RETURNVALUE_CANNOTTHROW;
		}
	}
	return Tile::queryAdd(index, thing, count, tileFlags, actor);
}

std::shared_ptr<Cylinder> HouseTile::queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item> &destItem, uint32_t &tileFlags) {
	if (const auto &creature = thing->getCreature()) {
		if (const auto &player = creature->getPlayer()) {
			if (!house->isInvited(player)) {
				const Position &entryPos = house->getEntryPosition();
				auto destTile = g_game().map.getTile(entryPos);
				if (!destTile) {
					g_logger().error("[HouseTile::queryDestination] - "
					                 "Entry not correct for house name: {} "
					                 "with id: {} not found tile: {}",
					                 house->getName(), house->getId(), entryPos.toString());
					destTile = g_game().map.getTile(player->getTemplePosition());
					if (!destTile) {
						destTile = Tile::nullptr_tile;
					}
				}

				index = -1;
				destItem = nullptr;
				return destTile;
			}
		}
	}

	return Tile::queryDestination(index, thing, destItem, tileFlags);
}

ReturnValue HouseTile::queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor /*= nullptr */) {
	const auto &item = thing->getItem();
	if (!item) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (actor && g_configManager().getBoolean(ONLY_INVITED_CAN_MOVE_HOUSE_ITEMS)) {
		const auto &actorPlayer = actor->getPlayer();
		if (house && !house->isInvited(actorPlayer)) {
			return RETURNVALUE_NOTPOSSIBLE;
		} else if (house && house->getHouseAccessLevel(actorPlayer) == HOUSE_GUEST) {
			return RETURNVALUE_NOTMOVABLE;
		}
	}
	return Tile::queryRemove(thing, count, flags);
}
