/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "zone.hpp"
#include "game/game.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/npcs/npc.hpp"
#include "creatures/players/player.hpp"
#include "game/scheduling/dispatcher.hpp"

phmap::parallel_flat_hash_map<std::string, std::shared_ptr<Zone>> Zone::zones = {};
const static std::shared_ptr<Zone> nullZone = nullptr;

std::shared_ptr<Zone> Zone::addZone(const std::string &name) {
	if (name == "default") {
		g_logger().error("Zone name {} is reserved", name);
		return nullZone;
	}
	if (zones[name]) {
		g_logger().error("Zone {} already exists", name);
		return nullZone;
	}
	zones[name] = std::make_shared<Zone>(name);
	return zones[name];
}

void Zone::addArea(Area area) {
	for (const Position &pos : area) {
		positions.insert(pos);
		Tile* tile = g_game().map.getTile(pos);
		if (tile) {
			for (auto item : *tile->getItemList()) {
				itemAdded(item);
			}
			for (auto creature : *tile->getCreatures()) {
				creatureAdded(creature);
			}
		}
	}
}

void Zone::subtractArea(Area area) {
	for (const Position &pos : area) {
		positions.erase(pos);
		Tile* tile = g_game().map.getTile(pos);
		if (tile) {
			for (auto item : *tile->getItemList()) {
				itemRemoved(item);
			}
			for (auto creature : *tile->getCreatures()) {
				creatureRemoved(creature);
			}
		}
	}
}

bool Zone::isPositionInZone(const Position &pos) const {
	return positions.contains(pos);
}

Position Zone::getRemoveDestination(Creature* creature /* = nullptr */) const {
	if (!creature || !creature->getPlayer()) {
		return Position();
	}
	if (removeDestination != Position()) {
		return removeDestination;
	}
	if (creature->getPlayer()) {
		return creature->getPlayer()->getTown()->getTemplePosition();
	}
	return Position();
}

std::shared_ptr<Zone> Zone::getZone(const std::string &name) {
	return zones[name];
}

const phmap::parallel_flat_hash_set<Position> &Zone::getPositions() const {
	return positions;
}

const phmap::parallel_flat_hash_set<Tile*> &Zone::getTiles() const {
	static phmap::parallel_flat_hash_set<Tile*> tiles;
	tiles.clear();
	for (const auto &position : positions) {
		Tile* tile = g_game().map.getTile(position);
		if (tile) {
			tiles.insert(tile);
		}
	}
	return tiles;
}

const phmap::parallel_flat_hash_set<Creature*> &Zone::getCreatures() const {
	static phmap::parallel_flat_hash_set<Creature*> creatures;
	creatures.clear();
	for (const auto creatureId : creaturesCache) {
		auto creature = g_game().getCreatureByID(creatureId);
		if (creature) {
			creatures.insert(creature);
		}
	}
	return creatures;
}

const phmap::parallel_flat_hash_set<Player*> &Zone::getPlayers() const {
	static phmap::parallel_flat_hash_set<Player*> players;
	players.clear();
	for (const auto playerId : playersCache) {
		auto player = g_game().getPlayerByID(playerId);
		if (player) {
			players.insert(player);
		}
	}
	return players;
}

const phmap::parallel_flat_hash_set<Monster*> &Zone::getMonsters() const {
	static phmap::parallel_flat_hash_set<Monster*> monsters;
	monsters.clear();
	for (const auto monsterId : monstersCache) {
		auto monster = g_game().getMonsterByID(monsterId);
		if (monster) {
			monsters.insert(monster);
		}
	}
	return monsters;
}

const phmap::parallel_flat_hash_set<Npc*> &Zone::getNpcs() const {
	static phmap::parallel_flat_hash_set<Npc*> npcs;
	npcs.clear();
	for (const auto npcId : npcsCache) {
		auto npc = g_game().getNpcByID(npcId);
		if (npc) {
			npcs.insert(npc);
		}
	}
	return npcs;
}

const phmap::parallel_flat_hash_set<Item*> &Zone::getItems() const {
	return itemsCache;
}

void Zone::removePlayers() const {
	for (auto player : getPlayers()) {
		g_game().internalTeleport(player, getRemoveDestination(player));
	}
}

void Zone::removeMonsters() const {
	for (auto monster : getMonsters()) {
		g_game().removeCreature(monster);
	}
}

void Zone::removeNpcs() const {
	for (auto npc : getNpcs()) {
		g_game().removeCreature(npc);
	}
}

void Zone::clearZones() {
	zones.clear();
}

phmap::parallel_flat_hash_set<std::shared_ptr<Zone>> Zone::getZones(const Position postion) {
	phmap::parallel_flat_hash_set<std::shared_ptr<Zone>> zonesSet;
	for (const auto &[_, zone] : zones) {
		if (zone && zone->isPositionInZone(postion)) {
			zonesSet.insert(zone);
		}
	}
	return zonesSet;
}

const phmap::parallel_flat_hash_set<std::shared_ptr<Zone>> &Zone::getZones() {
	static phmap::parallel_flat_hash_set<std::shared_ptr<Zone>> zonesSet;
	zonesSet.clear();
	for (const auto &[_, zone] : zones) {
		if (zone) {
			zonesSet.insert(zone);
		}
	}
	return zonesSet;
}

void Zone::creatureAdded(Creature* creature) {
	if (!creature) {
		return;
	}

	uint32_t id = 0;
	if (creature->getPlayer()) {
		id = creature->getPlayer()->getID();
		auto [_, playerInserted] = playersCache.insert(id);
		if (playerInserted) {
			g_logger().trace("Player {} (ID: {}) added to zone {}", creature->getName(), id, name);
		}
	}
	if (creature->getMonster()) {
		id = creature->getMonster()->getID();
		auto [_, monsterInserted] = monstersCache.insert(id);
		if (monsterInserted) {
			g_logger().trace("Monster {} (ID: {}) added to zone {}", creature->getName(), id, name);
		}
	}
	if (creature->getNpc()) {
		id = creature->getNpc()->getID();
		auto [_, npcInserted] = npcsCache.insert(id);
		if (npcInserted) {
			g_logger().trace("Npc {} (ID: {}) added to zone {}", creature->getName(), id, name);
		}
	}

	if (id != 0) {
		creaturesCache.insert(id);
	}
}

void Zone::creatureRemoved(Creature* creature) {
	if (!creature) {
		return;
	}
	creaturesCache.erase(creature->getID());
	if (creature->getPlayer()) {
		if (playersCache.erase(creature->getID())) {
			g_logger().trace("Player {} (ID: {}) removed from zone {}", creature->getName(), creature->getID(), name);
		}
	}
	if (creature->getMonster()) {
		if (monstersCache.erase(creature->getID())) {
			g_logger().trace("Monster {} (ID: {}) removed from zone {}", creature->getName(), creature->getID(), name);
		}
	}
	if (creature->getNpc()) {
		if (npcsCache.erase(creature->getID())) {
			g_logger().trace("Npc {} (ID: {}) removed from zone {}", creature->getName(), creature->getID(), name);
		}
	}
}

void Zone::thingAdded(Thing* thing) {
	if (!thing) {
		return;
	}

	if (thing->getItem()) {
		itemAdded(thing->getItem());
	} else if (thing->getCreature()) {
		creatureAdded(thing->getCreature());
	}
}

void Zone::itemAdded(Item* item) {
	if (!item) {
		return;
	}
	itemsCache.insert(item);
}

void Zone::itemRemoved(Item* item) {
	if (!item) {
		return;
	}
	itemsCache.erase(item);
}
