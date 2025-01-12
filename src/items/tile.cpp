/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "items/tile.hpp"

#include "config/configmanager.hpp"
#include "creatures/combat/combat.hpp"
#include "creatures/creature.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/players/player.hpp"
#include "enums/account_type.hpp"
#include "game/game.hpp"
#include "game/movement/teleport.hpp"
#include "game/zones/zone.hpp"
#include "items/containers/mailbox/mailbox.hpp"
#include "items/trashholder.hpp"
#include "lua/creature/movement.hpp"
#include "map/spectators.hpp"
#include "utils/tools.hpp"
#include "game/scheduling/dispatcher.hpp"

auto real_nullptr_tile = std::make_shared<StaticTile>(0xFFFF, 0xFFFF, 0xFF);
const std::shared_ptr<Tile> &Tile::nullptr_tile = real_nullptr_tile;

bool Tile::hasProperty(ItemProperty prop) const {
	switch (prop) {
		case CONST_PROP_BLOCKSOLID:
			return hasFlag(TILESTATE_BLOCKSOLID);
		case CONST_PROP_HASHEIGHT:
			return hasFlag(TILESTATE_HASHEIGHT);
		case CONST_PROP_BLOCKPROJECTILE:
			return hasFlag(TILESTATE_BLOCKPROJECTILE);
		case CONST_PROP_BLOCKPATH:
			return hasFlag(TILESTATE_BLOCKPATH);
		case CONST_PROP_ISVERTICAL:
			return hasFlag(TILESTATE_ISVERTICAL);
		case CONST_PROP_ISHORIZONTAL:
			return hasFlag(TILESTATE_ISHORIZONTAL);
		case CONST_PROP_MOVABLE:
			return hasFlag(TILESTATE_MOVABLE);
		case CONST_PROP_IMMOVABLEBLOCKSOLID:
			return hasFlag(TILESTATE_IMMOVABLEBLOCKSOLID);
		case CONST_PROP_IMMOVABLEBLOCKPATH:
			return hasFlag(TILESTATE_IMMOVABLEBLOCKPATH);
		case CONST_PROP_IMMOVABLENOFIELDBLOCKPATH:
			return hasFlag(TILESTATE_IMMOVABLENOFIELDBLOCKPATH);
		case CONST_PROP_NOFIELDBLOCKPATH:
			return hasFlag(TILESTATE_NOFIELDBLOCKPATH);
		case CONST_PROP_SUPPORTHANGABLE:
			return hasFlag(TILESTATE_SUPPORTS_HANGABLE);
		default:
			return false;
	}
}

bool Tile::hasProperty(const std::shared_ptr<Item> &exclude, ItemProperty prop) const {
	if (!exclude) {
		g_logger().error("[{}]: exclude is nullptr", __FUNCTION__);
		return false;
	}

	assert(exclude);

	if (ground && exclude != ground && ground->hasProperty(prop)) {
		return true;
	}

	if (const TileItemVector* items = getItemList()) {
		for (const auto &item : *items) {
			if (!item) {
				g_logger().error("Tile::hasProperty: tile {} has an item which is nullptr", tilePos.toString());
				continue;
			}
			if (item != exclude && item->hasProperty(prop)) {
				return true;
			}
		}
	}

	return false;
}

bool Tile::hasFlag(uint32_t flag) const {
	return hasBitSet(flag, this->flags);
}

bool Tile::hasHeight(uint32_t n) const {
	uint32_t height = 0;

	if (ground) {
		if (ground->hasProperty(CONST_PROP_HASHEIGHT)) {
			++height;
		}

		if (n == height) {
			return true;
		}
	}

	if (const TileItemVector* items = getItemList()) {
		for (const auto &item : *items) {
			if (item->hasProperty(CONST_PROP_HASHEIGHT)) {
				++height;
			}

			if (n == height) {
				return true;
			}
		}
	}
	return false;
}

size_t Tile::getCreatureCount() const {
	if (const CreatureVector* creatures = getCreatures()) {
		return creatures->size();
	}
	return 0;
}

size_t Tile::getItemCount() const {
	if (const TileItemVector* items = getItemList()) {
		return items->size();
	}
	return 0;
}

uint32_t Tile::getTopItemCount() const {
	if (const TileItemVector* items = getItemList()) {
		return items->getTopItemCount();
	}
	return 0;
}

uint32_t Tile::getDownItemCount() const {
	if (const TileItemVector* items = getItemList()) {
		return items->getDownItemCount();
	}
	return 0;
}

std::string Tile::getDescription(int32_t) {
	return "You dont know why, but you cant see anything!";
}

std::shared_ptr<Teleport> Tile::getTeleportItem() const {
	if (!hasFlag(TILESTATE_TELEPORT)) {
		return nullptr;
	}

	if (const TileItemVector* items = getItemList()) {
		for (const auto &item : std::ranges::reverse_view(*items)) {
			if (item->getTeleport()) {
				return item->getTeleport();
			}
		}
	}
	return nullptr;
}

std::shared_ptr<MagicField> Tile::getFieldItem() const {
	if (!hasFlag(TILESTATE_MAGICFIELD)) {
		return nullptr;
	}

	if (ground && ground->getMagicField()) {
		return ground->getMagicField();
	}

	if (const TileItemVector* items = getItemList()) {
		for (const auto &item : std::ranges::reverse_view(*items)) {
			if (item->getMagicField()) {
				return item->getMagicField();
			}
		}
	}
	return nullptr;
}

std::shared_ptr<TrashHolder> Tile::getTrashHolder() const {
	if (!hasFlag(TILESTATE_TRASHHOLDER)) {
		return nullptr;
	}

	if (ground && ground->getTrashHolder()) {
		return ground->getTrashHolder();
	}

	if (const TileItemVector* items = getItemList()) {
		for (const auto &item : std::ranges::reverse_view(*items)) {
			if (item->getTrashHolder()) {
				return item->getTrashHolder();
			}
		}
	}
	return nullptr;
}

std::shared_ptr<Mailbox> Tile::getMailbox() const {
	if (!hasFlag(TILESTATE_MAILBOX)) {
		return nullptr;
	}

	if (ground && ground->getMailbox()) {
		return ground->getMailbox();
	}

	if (const TileItemVector* items = getItemList()) {
		for (const auto &item : std::ranges::reverse_view(*items)) {
			if (item->getMailbox()) {
				return item->getMailbox();
			}
		}
	}
	return nullptr;
}

std::shared_ptr<BedItem> Tile::getBedItem() const {
	if (!hasFlag(TILESTATE_BED)) {
		return nullptr;
	}

	if (ground && ground->getBed()) {
		return ground->getBed();
	}

	if (const TileItemVector* items = getItemList()) {
		for (const auto &item : std::ranges::reverse_view(*items)) {
			if (item->getBed()) {
				return item->getBed();
			}
		}
	}
	return nullptr;
}

std::shared_ptr<Creature> Tile::getTopCreature() const {
	if (const CreatureVector* creatures = getCreatures()) {
		if (!creatures->empty()) {
			return *creatures->begin();
		}
	}
	return nullptr;
}

std::shared_ptr<Creature> Tile::getBottomCreature() const {
	if (const CreatureVector* creatures = getCreatures()) {
		if (!creatures->empty()) {
			return *creatures->rbegin();
		}
	}
	return nullptr;
}

std::shared_ptr<Creature> Tile::getTopVisibleCreature(const std::shared_ptr<Creature> &creature) const {
	if (const CreatureVector* creatures = getCreatures()) {
		if (creature) {
			const auto &player = creature->getPlayer();
			if (player && player->isAccessPlayer()) {
				return getTopCreature();
			}

			for (const auto &tileCreature : *creatures) {
				if (creature->canSeeCreature(tileCreature)) {
					return tileCreature;
				}
			}
		} else {
			for (const auto &tileCreature : *creatures) {
				if (!tileCreature->isInvisible()) {
					const auto &player = tileCreature->getPlayer();
					if (!player || !player->isInGhostMode()) {
						return tileCreature;
					}
				}
			}
		}
	}
	return nullptr;
}

std::shared_ptr<Creature> Tile::getBottomVisibleCreature(const std::shared_ptr<Creature> &creature) const {
	if (const CreatureVector* creatures = getCreatures()) {
		if (creature) {
			const auto &player = creature->getPlayer();
			if (player && player->isAccessPlayer()) {
				return getBottomCreature();
			}

			for (const auto &reverseCreature : std::ranges::reverse_view(*creatures)) {
				if (creature->canSeeCreature(reverseCreature)) {
					return reverseCreature;
				}
			}
		} else {
			for (const auto &reverseCreature : std::ranges::reverse_view(*creatures)) {
				if (!reverseCreature->isInvisible()) {
					const auto &player = reverseCreature->getPlayer();
					if (!player || !player->isInGhostMode()) {
						return reverseCreature;
					}
				}
			}
		}
	}
	return nullptr;
}

std::shared_ptr<Item> Tile::getTopDownItem() const {
	if (const TileItemVector* items = getItemList()) {
		return items->getTopDownItem();
	}
	return nullptr;
}

std::shared_ptr<Item> Tile::getTopTopItem() const {
	if (const TileItemVector* items = getItemList()) {
		return items->getTopTopItem();
	}
	return nullptr;
}

std::shared_ptr<Item> Tile::getItemByTopOrder(int32_t topOrder) {
	// topOrder:
	// 1: borders
	// 2: ladders, signs, splashes
	// 3: doors etc
	// 4: creatures
	if (TileItemVector* items = getItemList()) {
		for (auto it = ItemVector::const_reverse_iterator(items->getEndTopItem()), end = ItemVector::const_reverse_iterator(items->getBeginTopItem()); it != end; ++it) {
			if (Item::items[(*it)->getID()].alwaysOnTopOrder == topOrder) {
				return (*it);
			}
		}
	}
	return nullptr;
}

std::shared_ptr<Thing> Tile::getTopVisibleThing(const std::shared_ptr<Creature> &creature) {
	const auto &thing = getTopVisibleCreature(creature);
	if (thing) {
		return thing;
	}

	TileItemVector* items = getItemList();
	if (items) {
		for (ItemVector::const_iterator it = items->getBeginDownItem(), end = items->getEndDownItem(); it != end; ++it) {
			const ItemType &iit = Item::items[(*it)->getID()];
			if (!iit.lookThrough) {
				return (*it);
			}
		}

		for (auto it = ItemVector::const_reverse_iterator(items->getEndTopItem()), end = ItemVector::const_reverse_iterator(items->getBeginTopItem()); it != end; ++it) {
			const ItemType &iit = Item::items[(*it)->getID()];
			if (!iit.lookThrough) {
				return (*it);
			}
		}
	}

	return ground;
}

void Tile::onAddTileItem(const std::shared_ptr<Item> &item) {
	if (!item) {
		g_logger().error("Tile::onAddTileItem: item is nullptr");
		return;
	}

	if ((item->hasProperty(CONST_PROP_MOVABLE) || item->getContainer()) || (item->isWrapable() && !item->hasProperty(CONST_PROP_MOVABLE) && !item->hasProperty(CONST_PROP_BLOCKPATH))) {
		const auto it = g_game().browseFields.find(static_self_cast<Tile>());
		if (it != g_game().browseFields.end()) {
			const auto &lockedCylinder = it->second.lock();
			if (lockedCylinder) {
				lockedCylinder->addItemBack(item);
				item->setParent(getTile());
			}
		}
	}

	setTileFlags(item);

	const Position &cylinderMapPos = getPosition();

	const auto spectators = Spectators().find<Creature>(cylinderMapPos, true);

	// send to client
	for (const auto &spectator : spectators) {
		if (const auto &tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendAddTileItem(static_self_cast<Tile>(), cylinderMapPos, item);
		}
	}

	// event methods
	for (const auto &spectator : spectators) {
		spectator->onAddTileItem(static_self_cast<Tile>(), cylinderMapPos);
	}

	if ((!hasFlag(TILESTATE_PROTECTIONZONE) || g_configManager().getBoolean(CLEAN_PROTECTION_ZONES))
	    && item->isCleanable()) {
		if (!this->getHouse()) {
			g_game().addTileToClean(static_self_cast<Tile>());
		}
	}

	if (item->isCarpet() && !item->isMovable()) {
		if (getTopTopItem() && getTopTopItem()->canReceiveAutoCarpet()) {
			return;
		}
		const auto &house = getHouse();
		if (!house) {
			return;
		}

		for (const auto &tile : getSurroundingTiles()) {
			if (!tile || !tile->getGround() || tile->getGround()->getID() != getGround()->getID()) {
				continue;
			}
			const auto &topItem = tile->getTopTopItem();
			if (!topItem || !topItem->canReceiveAutoCarpet()) {
				continue;
			}
			// Check if tile is part of the same house
			if (const auto &tileHouse = tile->getHouse(); !tileHouse || house != tileHouse) {
				continue;
			}

			// Clear any existing carpet
			for (const auto &tileItem : *tile->getItemList()) {
				if (tileItem && tileItem->isCarpet()) {
					tile->removeThing(tileItem, tileItem->getItemCount());
				}
			}

			const auto &carpet = item->clone();
			carpet->setAttribute(ItemAttribute_t::ACTIONID, IMMOVABLE_ACTION_ID);
			tile->addThing(carpet);
		}
	}
}

void Tile::onUpdateTileItem(const std::shared_ptr<Item> &oldItem, const ItemType &oldType, const std::shared_ptr<Item> &newItem, const ItemType &newType) {
	if (!oldItem || !newItem) {
		g_logger().error("Tile::onUpdateTileItem: oldItem or newItem is nullptr");
		return;
	}

	if ((newItem->hasProperty(CONST_PROP_MOVABLE) || newItem->getContainer()) || (newItem->isWrapable() && newItem->hasProperty(CONST_PROP_MOVABLE) && !oldItem->hasProperty(CONST_PROP_BLOCKPATH))) {
		const auto it = g_game().browseFields.find(getTile());
		if (it != g_game().browseFields.end()) {
			const auto &lockedCylinder = it->second.lock();
			if (lockedCylinder) {
				const int32_t index = lockedCylinder->getThingIndex(oldItem);
				if (index != -1) {
					lockedCylinder->replaceThing(index, newItem);
					newItem->setParent(static_self_cast<Tile>());
				}
			}
		}
	} else if ((oldItem->hasProperty(CONST_PROP_MOVABLE) || oldItem->getContainer()) || (oldItem->isWrapable() && !oldItem->hasProperty(CONST_PROP_MOVABLE) && !oldItem->hasProperty(CONST_PROP_BLOCKPATH))) {
		const auto it = g_game().browseFields.find(getTile());
		if (it != g_game().browseFields.end()) {
			const auto &lockedCylinder = it->second.lock();
			if (lockedCylinder) {
				const auto &oldParent = oldItem->getParent();
				lockedCylinder->removeThing(oldItem, oldItem->getItemCount());
				oldItem->setParent(oldParent);
			}
		}
	}

	const Position &cylinderMapPos = getPosition();

	const auto spectators = Spectators().find<Creature>(cylinderMapPos, true);

	// send to client
	for (const auto &spectator : spectators) {
		if (const auto &tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendUpdateTileItem(static_self_cast<Tile>(), cylinderMapPos, newItem);
		}
	}

	// event methods
	for (const auto &spectator : spectators) {
		spectator->onUpdateTileItem(static_self_cast<Tile>(), cylinderMapPos, oldItem, oldType, newItem, newType);
	}
}

void Tile::onRemoveTileItem(const CreatureVector &spectators, const std::vector<int32_t> &oldStackPosVector, const std::shared_ptr<Item> &item) {
	if (!item) {
		g_logger().error("Tile::onRemoveTileItem: item is nullptr");
		return;
	}

	if ((item->hasProperty(CONST_PROP_MOVABLE) || item->getContainer()) || (item->isWrapable() && !item->hasProperty(CONST_PROP_MOVABLE) && !item->hasProperty(CONST_PROP_BLOCKPATH))) {
		const auto it = g_game().browseFields.find(getTile());
		if (it != g_game().browseFields.end()) {
			const auto &lockedCylinder = it->second.lock();
			if (lockedCylinder) {
				lockedCylinder->removeThing(item, item->getItemCount());
			}
		}
	}
	for (const auto &zone : getZones()) {
		zone->itemRemoved(item);
	}

	resetTileFlags(item);

	const Position &cylinderMapPos = getPosition();
	const ItemType &iType = Item::items[item->getID()];

	// send to client
	size_t i = 0;
	for (const auto &spectator : spectators) {
		if (const auto &tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendRemoveTileThing(cylinderMapPos, oldStackPosVector[i++]);
		}
	}

	// event methods
	for (const auto &spectator : spectators) {
		spectator->onRemoveTileItem(static_self_cast<Tile>(), cylinderMapPos, iType, item);
	}

	if (!hasFlag(TILESTATE_PROTECTIONZONE) || g_configManager().getBoolean(CLEAN_PROTECTION_ZONES)) {
		const auto &items = getItemList();
		if (!items || items->empty()) {
			g_game().removeTileToClean(static_self_cast<Tile>());
			return;
		}

		bool ret = false;
		for (const auto &toCheck : *items) {
			if (toCheck->isCleanable()) {
				ret = true;
				break;
			}
		}

		if (!ret) {
			g_game().removeTileToClean(static_self_cast<Tile>());
		}
	}

	if (item->isCarpet() && !item->isMovable()) {
		if (getTopTopItem() && getTopTopItem()->canReceiveAutoCarpet()) {
			return;
		}
		const auto &house = getHouse();
		if (!house) {
			return;
		}

		for (const auto &tile : getSurroundingTiles()) {
			if (!tile || !tile->getGround() || tile->getGround()->getID() != getGround()->getID()) {
				continue;
			}
			const auto &topItem = tile->getTopTopItem();
			if (!topItem || !topItem->canReceiveAutoCarpet()) {
				continue;
			}
			// Check if tile is part of the same house
			if (const auto &tileHouse = tile->getHouse(); !tileHouse || house != tileHouse) {
				continue;
			}

			for (const auto &tileItem : *tile->getItemList()) {
				if (tileItem && tileItem->getID() == item->getID()) {
					tile->removeThing(tileItem, tileItem->getItemCount());
				}
			}
		}
	}
}

void Tile::onUpdateTile(const CreatureVector &spectators) {
	const Position &cylinderMapPos = getPosition();

	// send to clients
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->sendUpdateTile(getTile(), cylinderMapPos);
	}
}

ReturnValue Tile::queryAdd(int32_t, const std::shared_ptr<Thing> &thing, uint32_t, uint32_t tileFlags, const std::shared_ptr<Creature> &) {
	if (!thing) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (hasBitSet(FLAG_NOLIMIT, tileFlags)) {
		return RETURNVALUE_NOERROR;
	}

	if (const auto &creature = thing->getCreature()) {
		if (creature->getNpc()) {
			const ReturnValue returnValue = checkNpcCanWalkIntoTile();
			if (returnValue != RETURNVALUE_NOERROR) {
				return returnValue;
			}
		}

		if (hasBitSet(FLAG_PATHFINDING, tileFlags) && hasFlag(TILESTATE_FLOORCHANGE | TILESTATE_TELEPORT)) {
			return RETURNVALUE_NOTPOSSIBLE;
		}

		if (creature->isMoveLocked() || ground == nullptr) {
			return RETURNVALUE_NOTPOSSIBLE;
		}

		if (const auto &monster = creature->getMonster()) {
			if (hasFlag(TILESTATE_PROTECTIONZONE | TILESTATE_FLOORCHANGE | TILESTATE_TELEPORT) && (!monster->isFamiliar() || (monster->isFamiliar() && monster->getMaster() && monster->getMaster()->getAttackedCreature()))) {
				return RETURNVALUE_NOTPOSSIBLE;
			}

			if (monster->isSummon()) {
				if (ground->getID() >= ITEM_WALKABLE_SEA_START && ground->getID() <= ITEM_WALKABLE_SEA_END) {
					return RETURNVALUE_NOTPOSSIBLE;
				}
			}

			const CreatureVector* creatures = getCreatures();
			if (monster->canPushCreatures() && !monster->isSummon()) {
				if (creatures) {
					for (const auto &tileCreature : *creatures) {
						if (tileCreature->getPlayer() && tileCreature->getPlayer()->isInGhostMode()) {
							continue;
						}

						const auto &creatureMonster = tileCreature->getMonster();
						if (!creatureMonster || !tileCreature->isPushable() || (creatureMonster->isSummon() && creatureMonster->getMaster()->getPlayer())) {
							return RETURNVALUE_NOTPOSSIBLE;
						}
					}
				}
			} else if (creatures && !creatures->empty()) {
				for (const auto &tileCreature : *creatures) {
					if (!tileCreature->isInGhostMode()) {
						return RETURNVALUE_NOTENOUGHROOM;
					}
				}
			}

			if (hasFlag(TILESTATE_IMMOVABLEBLOCKSOLID)) {
				return RETURNVALUE_NOTPOSSIBLE;
			}

			if (hasBitSet(FLAG_PATHFINDING, tileFlags) && hasFlag(TILESTATE_IMMOVABLENOFIELDBLOCKPATH)) {
				return RETURNVALUE_NOTPOSSIBLE;
			}

			if (hasFlag(TILESTATE_BLOCKSOLID) || (hasBitSet(FLAG_PATHFINDING, tileFlags) && hasFlag(TILESTATE_NOFIELDBLOCKPATH))) {
				if (!(monster->canPushItems() || hasBitSet(FLAG_IGNOREBLOCKITEM, tileFlags))) {
					return RETURNVALUE_NOTPOSSIBLE;
				}
			}

			if (hasHarmfulField()) {
				const CombatType_t combatType = getFieldItem()->getCombatType();

				// There is 3 options for a monster to enter a magic field
				// 1) Monster is immune
				if (!monster->isImmune(combatType)) {
					// 1) Monster is able to walk over field type
					// 2) Being attacked while random stepping will make it ignore field damages
					if (hasBitSet(FLAG_IGNOREFIELDDAMAGE, tileFlags)) {
						if (!(monster->getIgnoreFieldDamage() || monster->canWalkOnFieldType(combatType))) {
							return RETURNVALUE_NOTPOSSIBLE;
						}
					} else {
						return RETURNVALUE_NOTPOSSIBLE;
					}
				}
			}

			return RETURNVALUE_NOERROR;
		}

		const CreatureVector* creatures = getCreatures();
		if (const auto &player = creature->getPlayer()) {
			if (creatures && !creatures->empty() && !hasBitSet(FLAG_IGNOREBLOCKCREATURE, tileFlags) && !player->isAccessPlayer()) {
				for (const auto &tileCreature : *creatures) {
					if (!player->canWalkthrough(tileCreature)) {
						return RETURNVALUE_NOTPOSSIBLE;
					}
				}
			}

			if (hasBitSet(FLAG_PATHFINDING, tileFlags) && hasFlag(TILESTATE_BLOCKPATH)) {
				return RETURNVALUE_NOTPOSSIBLE;
			}

			if (player->getParent() == nullptr && hasFlag(TILESTATE_NOLOGOUT)) {
				// player is trying to login to a "no logout" tile
				return RETURNVALUE_NOTPOSSIBLE;
			}

			const auto playerTile = player->getTile();
			// moving from a pz tile to a non-pz tile
			if (playerTile && playerTile->hasFlag(TILESTATE_PROTECTIONZONE)) {
				auto maxOnline = g_configManager().getNumber(MAX_PLAYERS_PER_ACCOUNT);
				if (maxOnline > 1 && player->getAccountType() < ACCOUNT_TYPE_GAMEMASTER && !hasFlag(TILESTATE_PROTECTIONZONE)) {
					const auto maxOutsizePZ = g_configManager().getNumber(MAX_PLAYERS_OUTSIDE_PZ_PER_ACCOUNT);
					auto accountPlayers = g_game().getPlayersByAccount(player->getAccount());
					int countOutsizePZ = 0;
					for (const auto &accountPlayer : accountPlayers) {
						if (accountPlayer == player || accountPlayer->isOffline()) {
							continue;
						}
						if (accountPlayer->getTile() && !accountPlayer->getTile()->hasFlag(TILESTATE_PROTECTIONZONE)) {
							++countOutsizePZ;
						}
					}
					if (countOutsizePZ >= maxOutsizePZ) {
						player->sendCreatureSay(player, TALKTYPE_MONSTER_SAY, fmt::format("You can only have {} character{} from your account outside of a protection zone.", maxOutsizePZ == 1 ? "one" : std::to_string(maxOutsizePZ), maxOutsizePZ > 1 ? "s" : ""), &getPosition());
						return RETURNVALUE_NOTPOSSIBLE;
					}
				}
			}
			if (playerTile && player->isPzLocked()) {
				if (!playerTile->hasFlag(TILESTATE_PVPZONE)) {
					// player is trying to enter a pvp zone while being pz-locked
					if (hasFlag(TILESTATE_PVPZONE)) {
						return RETURNVALUE_PLAYERISPZLOCKEDENTERPVPZONE;
					}
				} else if (!hasFlag(TILESTATE_PVPZONE)) {
					// player is trying to leave a pvp zone while being pz-locked
					return RETURNVALUE_PLAYERISPZLOCKEDLEAVEPVPZONE;
				}

				if ((!playerTile->hasFlag(TILESTATE_NOPVPZONE) && hasFlag(TILESTATE_NOPVPZONE)) || (!playerTile->hasFlag(TILESTATE_PROTECTIONZONE) && hasFlag(TILESTATE_PROTECTIONZONE))) {
					// player is trying to enter a non-pvp/protection zone while being pz-locked
					return RETURNVALUE_PLAYERISPZLOCKED;
				}
			}
		} else if (creatures && !creatures->empty() && !hasBitSet(FLAG_IGNOREBLOCKCREATURE, tileFlags)) {
			for (const auto &tileCreature : *creatures) {
				if (!tileCreature->isInGhostMode()) {
					return RETURNVALUE_NOTENOUGHROOM;
				}
			}
		}

		if (!hasBitSet(FLAG_IGNOREBLOCKITEM, tileFlags)) {
			// If the FLAG_IGNOREBLOCKITEM bit isn't set we dont have to iterate every single item
			if (hasFlag(TILESTATE_BLOCKSOLID)) {
				// NO PVP magic wall or wild growth field check
				if (creature && creature->getPlayer()) {
					if (const auto fieldList = getItemList()) {
						for (const auto &findfield : *fieldList) {
							if (findfield && (findfield->getID() == ITEM_WILDGROWTH_SAFE || findfield->getID() == ITEM_MAGICWALL_SAFE)) {
								if (!creature->isInGhostMode()) {
									g_game().internalRemoveItem(findfield, 1);
								}
								return RETURNVALUE_NOERROR;
							}
						}
					}
				}
				return RETURNVALUE_NOTENOUGHROOM;
			}
		} else {
			// FLAG_IGNOREBLOCKITEM is set
			if (ground) {
				const ItemType &iiType = Item::items[ground->getID()];
				if (iiType.blockSolid && (!iiType.movable || ground->hasAttribute(ItemAttribute_t::UNIQUEID))) {
					return RETURNVALUE_NOTPOSSIBLE;
				}
			}

			if (const auto items = getItemList()) {
				for (const auto &item : *items) {
					const ItemType &iiType = Item::items[item->getID()];
					if (iiType.blockSolid && (!iiType.movable || item->hasAttribute(ItemAttribute_t::UNIQUEID))) {
						return RETURNVALUE_NOTPOSSIBLE;
					}
				}
			}
		}
	} else if (const auto &item = thing->getItem()) {
		const TileItemVector* items = getItemList();
		if (items && items->size() >= 0x3E8) {
			return RETURNVALUE_NOTPOSSIBLE;
		}

		const bool itemIsHangable = item->isHangable();
		if (ground == nullptr && !itemIsHangable) {
			return RETURNVALUE_NOTPOSSIBLE;
		}

		const CreatureVector* creatures = getCreatures();
		if (creatures && !creatures->empty() && item->isBlocking() && !hasBitSet(FLAG_IGNOREBLOCKCREATURE, tileFlags)) {
			for (const auto &tileCreature : *creatures) {
				if (!tileCreature->isInGhostMode()) {
					return RETURNVALUE_NOTENOUGHROOM;
				}
			}
		}

		if (itemIsHangable && hasFlag(TILESTATE_SUPPORTS_HANGABLE)) {
			if (items) {
				for (const auto &tileItem : *items) {
					if (tileItem->isHangable()) {
						return RETURNVALUE_NEEDEXCHANGE;
					}
				}
			}
		} else {
			if (ground) {
				const ItemType &iiType = Item::items[ground->getID()];
				if (iiType.blockSolid) {
					if ((!iiType.pickupable && iiType.type != ITEM_TYPE_TRASHHOLDER) || item->isMagicField() || item->isBlocking()) {
						if (!item->isPickupable() && !item->isCarpet()) {
							return RETURNVALUE_NOTENOUGHROOM;
						}

						if (!iiType.hasHeight) {
							return RETURNVALUE_NOTENOUGHROOM;
						}
					}
				}
			}

			if (items) {
				for (const auto &tileItem : *items) {
					const ItemType &iiType = Item::items[tileItem->getID()];
					if (!iiType.blockSolid || iiType.type == ITEM_TYPE_TRASHHOLDER) {
						continue;
					}

					if (iiType.pickupable && !item->isMagicField() && !item->isBlocking()) {
						continue;
					}

					if (!item->isPickupable()) {
						return RETURNVALUE_NOTENOUGHROOM;
					}

					if (!iiType.hasHeight || iiType.pickupable) {
						return RETURNVALUE_NOTENOUGHROOM;
					}
				}
			}
		}
	}
	return RETURNVALUE_NOERROR;
}

ReturnValue Tile::checkNpcCanWalkIntoTile() const {
	if (hasHarmfulField()) {
		return RETURNVALUE_NOTPOSSIBLE;
	} else {
		return RETURNVALUE_NOERROR;
	}
}

bool Tile::hasHarmfulField() const {
	return hasFlag(TILESTATE_MAGICFIELD) && getFieldItem() && !getFieldItem()->isBlocking() && getFieldItem()->getDamage() > 0;
}

ReturnValue Tile::queryMaxCount(int32_t, const std::shared_ptr<Thing> &, uint32_t count, uint32_t &maxQueryCount, uint32_t) {
	maxQueryCount = std::max<uint32_t>(1, count);
	return RETURNVALUE_NOERROR;
}

ReturnValue Tile::queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t tileFlags, const std::shared_ptr<Creature> & /*= nullptr */) {
	if (!thing) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	const int32_t index = getThingIndex(thing);
	if (index == -1) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	const auto &item = thing->getItem();
	if (item == nullptr) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (count == 0 || (item->isStackable() && count > item->getItemCount())) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (!item->isMovable() && !hasBitSet(FLAG_IGNORENOTMOVABLE, tileFlags)) {
		return RETURNVALUE_NOTMOVABLE;
	}

	return RETURNVALUE_NOERROR;
}

std::shared_ptr<Cylinder> Tile::queryDestination(int32_t &, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item> &destItem, uint32_t &tileFlags) {
	std::shared_ptr<Tile> destTile = nullptr;
	destItem = nullptr;

	if (hasFlag(TILESTATE_FLOORCHANGE_DOWN)) {
		uint16_t dx = tilePos.x;
		uint16_t dy = tilePos.y;
		const uint8_t dz = tilePos.z + 1;

		const auto &southDownTile = g_game().map.getTile(dx, dy - 1, dz);
		if (southDownTile && southDownTile->hasFlag(TILESTATE_FLOORCHANGE_SOUTH_ALT)) {
			dy -= 2;
			destTile = g_game().map.getTile(dx, dy, dz);
		} else {
			const auto &eastDownTile = g_game().map.getTile(dx - 1, dy, dz);
			if (eastDownTile && eastDownTile->hasFlag(TILESTATE_FLOORCHANGE_EAST_ALT)) {
				dx -= 2;
				destTile = g_game().map.getTile(dx, dy, dz);
			} else {
				const auto &downTile = g_game().map.getTile(dx, dy, dz);
				if (downTile) {
					if (downTile->hasFlag(TILESTATE_FLOORCHANGE_NORTH)) {
						++dy;
					}

					if (downTile->hasFlag(TILESTATE_FLOORCHANGE_SOUTH)) {
						--dy;
					}

					if (downTile->hasFlag(TILESTATE_FLOORCHANGE_SOUTH_ALT)) {
						dy -= 2;
					}

					if (downTile->hasFlag(TILESTATE_FLOORCHANGE_EAST)) {
						--dx;
					}

					if (downTile->hasFlag(TILESTATE_FLOORCHANGE_EAST_ALT)) {
						dx -= 2;
					}

					if (downTile->hasFlag(TILESTATE_FLOORCHANGE_WEST)) {
						++dx;
					}

					destTile = g_game().map.getTile(dx, dy, dz);
				}
			}
		}
	} else if (hasFlag(TILESTATE_FLOORCHANGE)) {
		uint16_t dx = tilePos.x;
		uint16_t dy = tilePos.y;
		const uint8_t dz = tilePos.z - 1;

		if (hasFlag(TILESTATE_FLOORCHANGE_NORTH)) {
			--dy;
		}

		if (hasFlag(TILESTATE_FLOORCHANGE_SOUTH)) {
			++dy;
		}

		if (hasFlag(TILESTATE_FLOORCHANGE_EAST)) {
			++dx;
		}

		if (hasFlag(TILESTATE_FLOORCHANGE_WEST)) {
			--dx;
		}

		if (hasFlag(TILESTATE_FLOORCHANGE_SOUTH_ALT)) {
			dy += 2;
		}

		if (hasFlag(TILESTATE_FLOORCHANGE_EAST_ALT)) {
			dx += 2;
		}

		destTile = g_game().map.getTile(dx, dy, dz);
	}

	if (destTile == nullptr) {
		destTile = static_self_cast<Tile>();
	} else {
		tileFlags |= FLAG_NOLIMIT; // Will ignore that there is blocking items/creatures
	}

	if (destTile) {
		const auto &destThing = destTile->getTopDownItem();
		if (destThing) {
			destItem = destThing->getItem();
			const auto &thingItem = thing ? thing->getItem() : nullptr;
			if (!thingItem || thingItem->getMailbox() != destItem->getMailbox()) {
				return destTile;
			}
			const auto &destCylinder = destThing->getCylinder();
			if (destCylinder && !destCylinder->getContainer()) {
				return destThing->getCylinder();
			}
		}
	}
	return destTile;
}

std::vector<std::shared_ptr<Tile>> Tile::getSurroundingTiles() {
	const auto position = getPosition();
	return {
		g_game().map.getTile(position.x - 1, position.y, position.z),
		g_game().map.getTile(position.x + 1, position.y, position.z),
		g_game().map.getTile(position.x, position.y - 1, position.z),
		g_game().map.getTile(position.x, position.y + 1, position.z),
		g_game().map.getTile(position.x - 1, position.y - 1, position.z),
		g_game().map.getTile(position.x + 1, position.y + 1, position.z),
		g_game().map.getTile(position.x + 1, position.y - 1, position.z),
		g_game().map.getTile(position.x - 1, position.y + 1, position.z)
	};
}

void Tile::addThing(const std::shared_ptr<Thing> &thing) {
	addThing(0, thing);
}

void Tile::addThing(int32_t, const std::shared_ptr<Thing> &thing) {
	if (!thing) {
		return; // RETURNVALUE_NOTPOSSIBLE
	}

	const auto &creature = thing->getCreature();
	if (creature) {
		Spectators::clearCache();
		creature->setParent(static_self_cast<Tile>());

		CreatureVector* creatures = makeCreatures();
		creatures->insert(creatures->begin(), creature);
	} else {
		const auto &item = thing->getItem();
		if (item == nullptr) {
			return /*RETURNVALUE_NOTPOSSIBLE*/;
		}

		TileItemVector* items = getItemList();
		if (items && items->size() >= 0xFFFF) {
			return /*RETURNVALUE_NOTPOSSIBLE*/;
		}

		item->setParent(static_self_cast<Tile>());

		const ItemType &itemType = Item::items[item->getID()];
		if (itemType.isGroundTile()) {
			if (ground == nullptr) {
				ground = item;
				onAddTileItem(item);
			} else {
				const ItemType &oldType = Item::items[ground->getID()];

				const auto &oldGround = ground;
				ground->resetParent();
				ground = item;
				resetTileFlags(oldGround);
				setTileFlags(item);
				onUpdateTileItem(oldGround, oldType, item, itemType);
				postRemoveNotification(oldGround, nullptr, 0);
			}
		} else if (item->isAlwaysOnTop()) {
			if (itemType.isSplash() && items) {
				// remove old splash if exists
				for (ItemVector::const_iterator it = items->getBeginTopItem(), end = items->getEndTopItem(); it != end; ++it) {
					// Need to increment the counter to avoid crash
					const std::weak_ptr<Item> &weakSplash = *it;
					if (const auto oldSplash = weakSplash.lock()) {
						if (!Item::items[oldSplash->getID()].isSplash()) {
							continue;
						}

						postRemoveNotification(oldSplash, nullptr, 0);
						removeThing(oldSplash, 1);
						oldSplash->resetParent();
						break;
					}
				}
			}

			bool isInserted = false;

			if (items) {
				for (auto it = items->getBeginTopItem(), end = items->getEndTopItem(); it != end; ++it) {
					// Note: this is different from internalAddThing
					if (itemType.alwaysOnTopOrder <= Item::items[(*it)->getID()].alwaysOnTopOrder) {
						items->insert(it, item);
						isInserted = true;
						break;
					}
				}
			} else {
				items = makeItemList();
			}

			if (!isInserted) {
				items->push_back(item);
			}

			onAddTileItem(item);
		} else {
			if (itemType.isMagicField()) {
				// remove old field item if exists
				if (items) {
					for (auto it = items->getBeginDownItem(), end = items->getEndDownItem(); it != end; ++it) {
						std::weak_ptr<Item> weakField = *it;
						if (const auto oldField = weakField.lock()) {
							auto magicField = oldField->getMagicField();
							if (magicField) {
								if (magicField->isReplaceable()) {
									postRemoveNotification(magicField, nullptr, 0);
									removeThing(magicField, 1);
									magicField->resetParent();
									break;
								} else {
									// This magic field cannot be replaced.
									item->resetParent();
									return;
								}
							}
						}
					}
				}
			}

			items = makeItemList();
			items->insert(items->getBeginDownItem(), item);
			items->increaseDownItemCount();
			onAddTileItem(item);
		}
	}
}

void Tile::updateThing(const std::shared_ptr<Thing> &thing, uint16_t itemId, uint32_t count) {
	if (!thing) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const int32_t index = getThingIndex(thing);
	if (index == -1) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const auto &item = thing->getItem();
	if (item == nullptr) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const ItemType &oldType = Item::items[item->getID()];
	const ItemType &newType = Item::items[itemId];
	resetTileFlags(item);
	item->setID(itemId);
	item->setSubType(count);
	setTileFlags(item);
	onUpdateTileItem(item, oldType, item, newType);
}

void Tile::replaceThing(uint32_t index, const std::shared_ptr<Thing> &thing) {
	if (!thing) {
		return;
	}

	int32_t pos = index;

	const auto &item = thing->getItem();
	if (item == nullptr) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	std::shared_ptr<Item> oldItem = nullptr;
	bool isInserted = false;

	if (ground) {
		if (pos == 0) {
			oldItem = ground;
			ground = item;
			isInserted = true;
		}

		--pos;
	}

	TileItemVector* items = getItemList();
	if (items && !isInserted) {
		const int32_t topItemSize = getTopItemCount();
		if (pos < topItemSize) {
			auto it = items->getBeginTopItem();
			it += pos;

			oldItem = (*it);
			it = items->erase(it);
			items->insert(it, item);
			isInserted = true;
		}

		pos -= topItemSize;
	}

	const CreatureVector* creatures = getCreatures();
	if (creatures) {
		if (!isInserted && pos < static_cast<int32_t>(creatures->size())) {
			return /*RETURNVALUE_NOTPOSSIBLE*/;
		}

		pos -= static_cast<uint32_t>(creatures->size());
	}

	if (items && !isInserted) {
		const int32_t downItemSize = getDownItemCount();
		if (pos < downItemSize) {
			auto it = items->getBeginDownItem() + pos;
			oldItem = *it;
			it = items->erase(it);
			items->insert(it, item);
			isInserted = true;
		}
	}

	if (isInserted) {
		item->setParent(static_self_cast<Tile>());

		resetTileFlags(oldItem);
		setTileFlags(item);
		const ItemType &oldType = Item::items[oldItem->getID()];
		const ItemType &newType = Item::items[item->getID()];
		onUpdateTileItem(oldItem, oldType, item, newType);

		oldItem->resetParent();
		return /*RETURNVALUE_NOERROR*/;
	}
}

void Tile::removeThing(const std::shared_ptr<Thing> &thing, uint32_t count) {
	if (!thing) {
		return;
	}

	const auto &creature = thing->getCreature();
	if (creature) {
		CreatureVector* creatures = getCreatures();
		if (creatures) {
			const auto it = std::ranges::find(*creatures, thing);
			if (it != creatures->end()) {
				Spectators::clearCache();
				creatures->erase(it);
			}
		}
		return;
	}

	const auto &item = thing->getItem();
	if (!item) {
		return;
	}

	const int32_t index = getThingIndex(item);
	if (index == -1) {
		return;
	}

	if (item == ground) {
		ground->resetParent();
		ground = nullptr;

		const auto spectators = Spectators().find<Creature>(getPosition(), true);
		onRemoveTileItem(spectators.data(), std::vector<int32_t>(spectators.size(), 0), item);
		return;
	}

	TileItemVector* items = getItemList();
	if (!items) {
		return;
	}

	if (item->isAlwaysOnTop()) {
		const auto it = std::find(items->getBeginTopItem(), items->getEndTopItem(), item);
		if (it == items->getEndTopItem()) {
			return;
		}

		std::vector<int32_t> oldStackPosVector;

		const auto spectators = Spectators().find<Creature>(getPosition(), true);
		for (const auto &spectator : spectators) {
			if (const auto &tmpPlayer = spectator->getPlayer()) {
				oldStackPosVector.push_back(getStackposOfItem(tmpPlayer, item));
			}
		}

		items->erase(it);
		onRemoveTileItem(spectators.data(), oldStackPosVector, item);
		item->resetParent();
	} else {
		const auto it = std::find(items->getBeginDownItem(), items->getEndDownItem(), item);
		if (it == items->getEndDownItem()) {
			return;
		}

		const ItemType &itemType = Item::items[item->getID()];
		if (itemType.stackable && count != item->getItemCount()) {
			const uint8_t newCount = static_cast<uint8_t>(std::max<int32_t>(0, static_cast<int32_t>(item->getItemCount() - count)));
			item->setItemCount(newCount);
			onUpdateTileItem(item, itemType, item, itemType);
		} else {
			std::vector<int32_t> oldStackPosVector;

			const auto spectators = Spectators().find<Creature>(getPosition(), true);
			for (const auto &spectator : spectators) {
				if (const auto &tmpPlayer = spectator->getPlayer()) {
					oldStackPosVector.push_back(getStackposOfItem(spectator->getPlayer(), item));
				}
			}

			item->resetParent();
			items->erase(it);
			items->decreaseDownItemCount();
			onRemoveTileItem(spectators.data(), oldStackPosVector, item);
		}
	}
}

void Tile::removeCreature(const std::shared_ptr<Creature> &creature) {
	if (!creature) {
		return;
	}

	g_game().map.getMapSector(tilePos.x, tilePos.y)->removeCreature(creature);
	removeThing(creature, 0);
}

int32_t Tile::getThingIndex(const std::shared_ptr<Thing> &thing) const {
	if (!thing) {
		return -1;
	}

	int32_t n = -1;
	if (ground) {
		if (ground == thing) {
			return 0;
		}
		++n;
	}

	const TileItemVector* items = getItemList();
	if (items) {
		const auto &item = thing->getItem();
		if (item && item->isAlwaysOnTop()) {
			for (auto it = items->getBeginTopItem(), end = items->getEndTopItem(); it != end; ++it) {
				++n;
				if (*it == item) {
					return n;
				}
			}
		} else {
			n += items->getTopItemCount();
		}
	}

	if (const CreatureVector* creatures = getCreatures()) {
		if (thing->getCreature()) {
			for (const auto &creature : *creatures) {
				++n;
				if (creature == thing) {
					return n;
				}
			}
		} else {
			n += creatures->size();
		}
	}

	if (items) {
		const auto &item = thing->getItem();
		if (item && !item->isAlwaysOnTop()) {
			for (auto it = items->getBeginDownItem(), end = items->getEndDownItem(); it != end; ++it) {
				++n;
				if (*it == item) {
					return n;
				}
			}
		}
	}
	return -1;
}

int32_t Tile::getClientIndexOfCreature(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &creature) const {
	int32_t n;
	if (ground) {
		n = 1;
	} else {
		n = 0;
	}

	const TileItemVector* items = getItemList();
	if (items) {
		n += items->getTopItemCount();
	}

	if (const CreatureVector* creatures = getCreatures()) {
		for (const auto &reverseCreature : std::ranges::reverse_view(*creatures)) {
			if (reverseCreature == creature) {
				return n;
			} else if (player->canSeeCreature(reverseCreature)) {
				++n;
			}
		}
	}
	return -1;
}

int32_t Tile::getStackposOfCreature(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &creature) const {
	int32_t n;
	if (ground) {
		n = 1;
	} else {
		n = 0;
	}

	const TileItemVector* items = getItemList();
	if (items) {
		n += items->getTopItemCount();
		if (n >= 10) {
			return -1;
		}
	}

	if (const CreatureVector* creatures = getCreatures()) {
		for (const auto &reverseCreature : std::ranges::reverse_view(*creatures)) {
			if (reverseCreature == creature) {
				return n;
			} else if (player->canSeeCreature(reverseCreature)) {
				if (++n >= 10) {
					return -1;
				}
			}
		}
	}
	return -1;
}

int32_t Tile::getStackposOfItem(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item) const {
	int32_t n = 0;
	if (ground) {
		if (ground == item) {
			return n;
		}
		++n;
	}

	const TileItemVector* items = getItemList();
	if (items) {
		if (item->isAlwaysOnTop()) {
			for (auto it = items->getBeginTopItem(), end = items->getEndTopItem(); it != end; ++it) {
				if (*it == item) {
					return n;
				} else if (++n == 10) {
					return -1;
				}
			}
		} else {
			n += items->getTopItemCount();
			if (n >= 10) {
				return -1;
			}
		}
	}

	if (const CreatureVector* creatures = getCreatures()) {
		for (const auto &creature : *creatures) {
			if (player->canSeeCreature(creature)) {
				if (++n >= 10) {
					return -1;
				}
			}
		}
	}

	if (items && !item->isAlwaysOnTop()) {
		for (auto it = items->getBeginDownItem(), end = items->getEndDownItem(); it != end; ++it) {
			if (*it == item) {
				return n;
			} else if (++n >= 10) {
				return -1;
			}
		}
	}
	return -1;
}

size_t Tile::getFirstIndex() const {
	return 0;
}

size_t Tile::getLastIndex() const {
	return getThingCount();
}

uint32_t Tile::getItemTypeCount(uint16_t itemId, int32_t subType /*= -1*/) const {
	uint32_t count = 0;
	if (ground && ground->getID() == itemId) {
		count += Item::countByType(ground, subType);
	}

	const TileItemVector* items = getItemList();
	if (items) {
		for (const auto &item : *items) {
			if (item->getID() == itemId) {
				count += Item::countByType(item, subType);
			}
		}
	}
	return count;
}

std::shared_ptr<Thing> Tile::getThing(size_t index) const {
	if (ground) {
		if (index == 0) {
			return ground;
		}

		--index;
	}

	const TileItemVector* items = getItemList();
	if (items) {
		const uint32_t topItemSize = items->getTopItemCount();
		if (index < topItemSize) {
			return items->at(items->getDownItemCount() + index);
		}
		index -= topItemSize;
	}

	if (const CreatureVector* creatures = getCreatures()) {
		if (index < creatures->size()) {
			return (*creatures)[index];
		}
		index -= creatures->size();
	}

	if (items && index < items->getDownItemCount()) {
		return items->at(index);
	}
	return nullptr;
}

void Tile::postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t link /*= LINK_OWNER*/) {
	if (!thing) {
		return;
	}

	for (const auto &spectator : Spectators().find<Player>(getPosition(), true)) {
		spectator->getPlayer()->postAddNotification(thing, oldParent, index, LINK_NEAR);
	}

	// add a reference to this item, it may be deleted after being added (mailbox for example)
	const auto &creature = thing->getCreature();
	std::shared_ptr<Item> item;
	if (creature) {
		item = nullptr;
	} else {
		item = thing->getItem();
	}

	if (link == LINK_OWNER) {
		if (hasFlag(TILESTATE_TELEPORT)) {
			const auto &teleport = getTeleportItem();
			if (teleport) {
				teleport->addThing(thing);
			}
		} else if (hasFlag(TILESTATE_TRASHHOLDER)) {
			const auto &trashholder = getTrashHolder();
			if (trashholder) {
				trashholder->addThing(thing);
			}
		} else if (hasFlag(TILESTATE_MAILBOX)) {
			const auto &mailbox = getMailbox();
			if (mailbox) {
				mailbox->addThing(thing);
			}
		}

		// calling movement scripts
		if (creature) {
			g_moveEvents().onCreatureMove(creature, static_self_cast<Tile>(), MOVE_EVENT_STEP_IN);
		} else if (item) {
			g_moveEvents().onItemMove(item, static_self_cast<Tile>(), true);
		}
	}
}

void Tile::postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t) {
	if (!thing) {
		return;
	}

	auto spectators = Spectators().find<Player>(getPosition(), true);

	if (getThingCount() > 8) {
		onUpdateTile(spectators.data());
	}

	for (const auto &spectator : spectators) {
		spectator->getPlayer()->postRemoveNotification(thing, newParent, index, LINK_NEAR);
	}

	// calling movement scripts
	const auto &creature = thing->getCreature();
	if (creature) {
		g_moveEvents().onCreatureMove(creature, static_self_cast<Tile>(), MOVE_EVENT_STEP_OUT);
	} else {
		const auto &item = thing->getItem();
		if (item) {
			g_moveEvents().onItemMove(item, static_self_cast<Tile>(), false);
		}
	}
}

void Tile::internalAddThing(const std::shared_ptr<Thing> &thing) {
	internalAddThing(0, thing);
	if (!thing || !thing->getParent()) {
		return;
	}

	if (const auto &house = thing->getTile()->getHouse()) {
		if (const auto &item = thing->getItem()) {
			if (item->getParent().get() != this) {
				return;
			}

			const auto &door = item->getDoor();
			if (door && door->getDoorId() != 0) {
				house->addDoor(door);
			}
		}
	}
}

void Tile::internalAddThing(uint32_t, const std::shared_ptr<Thing> &thing) {
	if (!thing) {
		return;
	}
	for (const auto &zone : getZones()) {
		zone->thingAdded(thing);
	}

	thing->setParent(getTile());

	const auto &creature = thing->getCreature();
	if (creature) {
		Spectators::clearCache();

		CreatureVector* creatures = makeCreatures();
		creatures->insert(creatures->begin(), creature);
	} else {
		const auto &item = thing->getItem();
		if (item == nullptr) {
			return;
		}

		const ItemType &itemType = Item::items[item->getID()];
		if (itemType.isGroundTile()) {
			if (ground == nullptr) {
				ground = item;
				setTileFlags(item);
			}
			return;
		}

		TileItemVector* items = makeItemList();
		if (items->size() >= 0xFFFF) {
			return /*RETURNVALUE_NOTPOSSIBLE*/;
		}

		if (item->isAlwaysOnTop()) {
			bool isInserted = false;
			for (auto it = items->getBeginTopItem(), end = items->getEndTopItem(); it != end; ++it) {
				if (Item::items[(*it)->getID()].alwaysOnTopOrder > itemType.alwaysOnTopOrder) {
					items->insert(it, item);
					isInserted = true;
					break;
				}
			}

			if (!isInserted) {
				items->push_back(item);
			}
		} else {
			items->insert(items->getBeginDownItem(), item);
			items->increaseDownItemCount();
		}

		setTileFlags(item);
	}
}

void Tile::updateTileFlags(const std::shared_ptr<Item> &item) {
	resetTileFlags(item);
	setTileFlags(item);
}

void Tile::setTileFlags(const std::shared_ptr<Item> &item) {
	if (!hasFlag(TILESTATE_FLOORCHANGE)) {
		const auto &it = Item::items[item->getID()];
		if (it.floorChange != 0) {
			setFlag(it.floorChange);
		}
	}

	if (item->hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID)) {
		setFlag(TILESTATE_IMMOVABLEBLOCKSOLID);
	}

	if (item->hasProperty(CONST_PROP_BLOCKPATH)) {
		setFlag(TILESTATE_BLOCKPATH);
	}

	if (item->hasProperty(CONST_PROP_NOFIELDBLOCKPATH)) {
		setFlag(TILESTATE_NOFIELDBLOCKPATH);
	}

	if (item->hasProperty(CONST_PROP_IMMOVABLENOFIELDBLOCKPATH)) {
		setFlag(TILESTATE_IMMOVABLENOFIELDBLOCKPATH);
	}

	if (item->hasProperty(CONST_PROP_SUPPORTHANGABLE)) {
		setFlag(TILESTATE_SUPPORTS_HANGABLE);
	}

	if (item->getTeleport()) {
		setFlag(TILESTATE_TELEPORT);
	}

	if (item->getMagicField()) {
		setFlag(TILESTATE_MAGICFIELD);
	}

	if (item->getMailbox()) {
		setFlag(TILESTATE_MAILBOX);
	}

	if (item->getTrashHolder()) {
		setFlag(TILESTATE_TRASHHOLDER);
	}

	if (item->hasProperty(CONST_PROP_BLOCKSOLID)) {
		setFlag(TILESTATE_BLOCKSOLID);
	}

	if (item->getBed()) {
		setFlag(TILESTATE_BED);
	}

	if (item->hasProperty(CONST_PROP_IMMOVABLEBLOCKPATH)) {
		setFlag(TILESTATE_IMMOVABLEBLOCKPATH);
	}

	if (item->hasProperty(CONST_PROP_MOVABLE)) {
		setFlag(TILESTATE_MOVABLE);
	}

	if (item->hasProperty(CONST_PROP_ISHORIZONTAL)) {
		setFlag(TILESTATE_ISHORIZONTAL);
	}

	if (item->hasProperty(CONST_PROP_ISVERTICAL)) {
		setFlag(TILESTATE_ISVERTICAL);
	}

	if (item->hasProperty(CONST_PROP_BLOCKPROJECTILE)) {
		setFlag(TILESTATE_BLOCKPROJECTILE);
	}

	if (item->hasProperty(CONST_PROP_HASHEIGHT)) {
		setFlag(TILESTATE_HASHEIGHT);
	}

	if (const auto &container = item->getContainer()) {
		if (container->getDepotLocker()) {
			setFlag(TILESTATE_DEPOT);
		}
	}

	if (item->hasProperty(CONST_PROP_SUPPORTHANGABLE)) {
		setFlag(TILESTATE_SUPPORTS_HANGABLE);
	}
}

void Tile::resetTileFlags(const std::shared_ptr<Item> &item) {
	const ItemType &it = Item::items[item->getID()];
	if (it.floorChange != 0) {
		resetFlag(TILESTATE_FLOORCHANGE);
	}

	if (item->hasProperty(CONST_PROP_BLOCKSOLID) && !hasProperty(item, CONST_PROP_BLOCKSOLID)) {
		resetFlag(TILESTATE_BLOCKSOLID);
	}

	if (item->hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) && !hasProperty(item, CONST_PROP_IMMOVABLEBLOCKSOLID)) {
		resetFlag(TILESTATE_IMMOVABLEBLOCKSOLID);
	}

	if (item->hasProperty(CONST_PROP_BLOCKPATH) && !hasProperty(item, CONST_PROP_BLOCKPATH)) {
		resetFlag(TILESTATE_BLOCKPATH);
	}

	if (item->hasProperty(CONST_PROP_NOFIELDBLOCKPATH) && !hasProperty(item, CONST_PROP_NOFIELDBLOCKPATH)) {
		resetFlag(TILESTATE_NOFIELDBLOCKPATH);
	}

	if (item->hasProperty(CONST_PROP_IMMOVABLEBLOCKPATH) && !hasProperty(item, CONST_PROP_IMMOVABLEBLOCKPATH)) {
		resetFlag(TILESTATE_IMMOVABLEBLOCKPATH);
	}

	if (item->hasProperty(CONST_PROP_IMMOVABLENOFIELDBLOCKPATH) && !hasProperty(item, CONST_PROP_IMMOVABLENOFIELDBLOCKPATH)) {
		resetFlag(TILESTATE_IMMOVABLENOFIELDBLOCKPATH);
	}

	if (item->hasProperty(CONST_PROP_MOVABLE) && !hasProperty(item, CONST_PROP_MOVABLE)) {
		resetFlag(TILESTATE_MOVABLE);
	}

	if (item->hasProperty(CONST_PROP_ISHORIZONTAL) && !hasProperty(item, CONST_PROP_ISHORIZONTAL)) {
		resetFlag(TILESTATE_ISHORIZONTAL);
	}

	if (item->hasProperty(CONST_PROP_ISVERTICAL) && !hasProperty(item, CONST_PROP_ISVERTICAL)) {
		resetFlag(TILESTATE_ISVERTICAL);
	}

	if (item->hasProperty(CONST_PROP_BLOCKPROJECTILE) && !hasProperty(item, CONST_PROP_BLOCKPROJECTILE)) {
		resetFlag(TILESTATE_BLOCKPROJECTILE);
	}

	if (item->hasProperty(CONST_PROP_HASHEIGHT) && !hasProperty(item, CONST_PROP_HASHEIGHT)) {
		resetFlag(TILESTATE_HASHEIGHT);
	}

	if (item->getTeleport()) {
		resetFlag(TILESTATE_TELEPORT);
	}

	if (item->getMagicField()) {
		resetFlag(TILESTATE_MAGICFIELD);
	}

	if (item->getMailbox()) {
		resetFlag(TILESTATE_MAILBOX);
	}

	if (item->getTrashHolder()) {
		resetFlag(TILESTATE_TRASHHOLDER);
	}

	if (item->getBed()) {
		resetFlag(TILESTATE_BED);
	}

	if (const auto &container = item->getContainer()) {
		if (container->getDepotLocker()) {
			resetFlag(TILESTATE_DEPOT);
		}
	}

	if (item->hasProperty(CONST_PROP_SUPPORTHANGABLE)) {
		resetFlag(TILESTATE_SUPPORTS_HANGABLE);
	}
}

bool Tile::isMovableBlocking() const {
	return !ground || hasFlag(TILESTATE_BLOCKSOLID);
}

std::shared_ptr<Item> Tile::getUseItem(int32_t index) const {
	const TileItemVector* items = getItemList();
	if (!items || items->empty()) {
		return ground;
	}

	if (index >= 0 && index < static_cast<int32_t>(items->size())) {
		if (const auto &thing = getThing(index)) {
			if (auto thingItem = thing->getItem()) {
				return thingItem;
			}
		}
	}

	if (auto topDownItem = getTopDownItem()) {
		return topDownItem;
	}

	for (auto it = items->rbegin(), end = items->rend(); it != end; ++it) {
		if ((*it)->getDoor()) {
			return (*it)->getItem();
		}
	}

	return !items->empty() ? *items->begin() : nullptr;
}

std::shared_ptr<Item> Tile::getDoorItem() const {
	const TileItemVector* items = getItemList();
	if (!items || items->empty()) {
		return ground;
	}

	if (items) {
		for (const auto &item : *items) {
			const ItemType &it = Item::items[item->getID()];
			if (it.isDoor()) {
				return item;
			}
		}
	}

	return nullptr;
}

void Tile::addZone(const std::shared_ptr<Zone> &zone) {
	if (!zone) {
		return;
	}

	zones.emplace(zone);
	const auto &items = getItemList();
	if (items) {
		for (const auto &item : *items) {
			zone->itemAdded(item);
		}
	}
	const auto &creatures = getCreatures();
	if (creatures) {
		for (const auto &creature : *creatures) {
			zone->creatureAdded(creature);
		}
	}
}

void Tile::clearZones() {
	std::vector<std::shared_ptr<Zone>> zonesToRemove;
	for (const auto &zone : zones) {
		if (zone->isStatic()) {
			continue;
		}
		zonesToRemove.emplace_back(zone);
		const auto &items = getItemList();
		if (items) {
			for (const auto &item : *items) {
				zone->itemRemoved(item);
			}
		}
		const auto &creatures = getCreatures();
		if (creatures) {
			for (const auto &creature : *creatures) {
				zone->creatureRemoved(creature);
			}
		}
	}
	for (const auto &zone : zonesToRemove) {
		zones.erase(zone);
	}
}

void Tile::safeCall(std::function<void(void)> &&action) const {
	if (g_dispatcher().context().isAsync()) {
		g_dispatcher().addEvent([weak_self = std::weak_ptr<const SharedObject>(shared_from_this()), action = std::move(action)] {
			if (weak_self.lock()) {
				action();
			}
		},
		                        g_dispatcher().context().getName());
	} else {
		action();
	}
}
