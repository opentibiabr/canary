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
#include "game/game.h"
#include "creatures/monsters/monster.h"
#include "creatures/npcs/npc.h"
#include "creatures/players/player.h"

phmap::btree_map<std::string, std::shared_ptr<Zone>> Zone::zones = {};
const static std::shared_ptr<Zone> nullZone = nullptr;

const std::shared_ptr<Zone> &Zone::addZone(const std::string &name) {
	if (name == "default") {
		spdlog::error("Zone name {} is reserved", name);
		return nullZone;
	}
	if (zones[name]) {
		spdlog::error("Zone {} already exists", name);
		return nullZone;
	}
	zones[name] = std::make_shared<Zone>(name);
	return zones[name];
}

void Zone::addArea(Area area) {
	for (const auto &[name, zone] : zones) {
		for (Area a : zone->areas) {
			if (zone.get() == this) {
				continue;
			}
			if (a.intersects(area)) {
				spdlog::error("Zone {} intersects with zone {}", this->name, name);
				return;
			}
		}
	}
	areas.push_back(area);
	for (const Position &pos : area) {
		positions.insert(pos);
		Tile* tile = g_game().map.getTile(pos);
		if (tile) {
			tiles.insert(tile);
		}
	}
}

bool Zone::isPositionInZone(const Position &pos) const {
	return positions.contains(pos);
}

const std::shared_ptr<Zone> &Zone::getZone(const Position &postion) {
	for (auto &[name, zone] : zones) {
		if (zone->isPositionInZone(postion)) {
			return zone;
		}
	}
	return nullZone;
}

const std::shared_ptr<Zone> &Zone::getZone(const std::string &name) {
	return zones[name];
}

const phmap::btree_set<Position> &Zone::getPositions() const {
	return positions;
}

const phmap::btree_set<Tile*> &Zone::getTiles() const {
	return tiles;
}

const phmap::btree_set<Creature*> &Zone::getCreatures() const {
	return creatures;
}

const phmap::btree_set<Player*> &Zone::getPlayers() const {
	return players;
}

const phmap::btree_set<Monster*> &Zone::getMonsters() const {
	return monsters;
}

const phmap::btree_set<Npc*> &Zone::getNpcs() const {
	return npcs;
}

const phmap::btree_set<Item*> &Zone::getItems() const {
	return items;
}

const void Zone::removeMonsters() {
	// copy monsters because removeCreature will remove monster from monsters
	phmap::btree_set<Monster*> monstersCopy = monsters;
	for (auto monster : monstersCopy) {
		g_game().removeCreature(monster);
	}
}

const void Zone::removeNpcs() {
	// copy npcs because removeCreature will remove npc from npcs
	phmap::btree_set<Npc*> npcsCopy = npcs;
	for (auto npc : npcsCopy) {
		g_game().removeCreature(npc);
	}
}

void Zone::clearZones() {
	zones.clear();
}

const std::vector<std::shared_ptr<Zone>> &Zone::getZones() {
	static std::vector<std::shared_ptr<Zone>> zonesVector;
	zonesVector.clear();
	for (const auto &[_, zone] : zones) {
		zonesVector.push_back(zone);
	}
	return zonesVector;
}

void Zone::creatureAdded(Creature* creature) {
	creatures.insert(creature);
	if (creature->getPlayer()) {
		players.insert(creature->getPlayer());
	}
	if (creature->getMonster()) {
		monsters.insert(creature->getMonster());
	}
	if (creature->getNpc()) {
		npcs.insert(creature->getNpc());
	}
}

void Zone::creatureRemoved(Creature* creature) {
	creatures.erase(creature);
	if (creature->getPlayer()) {
		players.erase(creature->getPlayer());
	}
	if (creature->getMonster()) {
		monsters.erase(creature->getMonster());
	}
	if (creature->getNpc()) {
		npcs.erase(creature->getNpc());
	}
}

void Zone::itemAdded(Item* item) {
	items.insert(item);
}

void Zone::itemRemoved(Item* item) {
	items.erase(item);
}
