#include "zone.hpp"

#include "game/game.h"
#include "creatures/monsters/monster.h"
#include "creatures/npcs/npc.h"
#include "creatures/players/player.h"

phmap::btree_map<std::string, std::shared_ptr<Zone>> Zone::zones = {};

std::shared_ptr<Zone> Zone::addZone(const std::string &name) {
	if (zones[name]) {
		spdlog::error("Zone {} already exists", name);
		return nullptr;
	}
	zones[name] = std::make_shared<Zone>(name);
	return zones[name];
}

void Zone::addArea(Area area) {
	for (auto &[name, zone] : zones) {
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
}

bool Zone::isPositionInZone(const Position &pos) const {
	for (Area area : areas) {
		if (area.contains(pos)) {
			return true;
		}
	}
	return false;
}

std::shared_ptr<Zone> Zone::getZone(const Position &postion) {
	for (auto &[name, zone] : zones) {
		if (zone->isPositionInZone(postion)) {
			return zone;
		}
	}
	return nullptr;
}

std::shared_ptr<Zone> Zone::getZone(const std::string &name) {
	return zones[name];
}

phmap::btree_set<Position> Zone::getPositions() const {
	phmap::btree_set<Position> positions;
	for (Area area : areas) {
		for (int x = area.from.x; x <= area.to.x; x++) {
			for (int y = area.from.y; y <= area.to.y; y++) {
				for (int z = area.from.z; z <= area.to.z; z++) {
					positions.insert(Position(x, y, z));
				}
			}
		}
	}
	return positions;
}

phmap::btree_set<Tile*> Zone::getTiles() const {
	phmap::btree_set<Tile*> tiles;
	for (Position pos : getPositions()) {
		Tile* tile = g_game().map.getTile(pos);
		if (tile) {
			tiles.insert(tile);
		}
	}
	return tiles;
}

phmap::btree_set<Creature*> Zone::getCreatures() const {
	phmap::btree_set<Creature*> zoneCreatures;
	for (Tile* tile : getTiles()) {
		const auto creatures = tile->getCreatures();
		if (!creatures) {
			continue;
		}
		for (auto creature : *creatures) {
			zoneCreatures.insert(creature);
		}
	}
	return zoneCreatures;
}

phmap::btree_set<Player*> Zone::getPlayers() const {
	phmap::btree_set<Player*> zonePlayers;
	for (Creature* creature : getCreatures()) {
		if (creature->getPlayer()) {
			zonePlayers.insert(creature->getPlayer());
		}
	}
	return zonePlayers;
}

phmap::btree_set<Monster*> Zone::getMonsters() const {
	phmap::btree_set<Monster*> zoneMonsters;
	for (Creature* creature : getCreatures()) {
		if (creature->getMonster()) {
			zoneMonsters.insert(creature->getMonster());
		}
	}
	return zoneMonsters;
}

phmap::btree_set<Npc*> Zone::getNpcs() const {
	phmap::btree_set<Npc*> zoneNpcs;
	for (Creature* creature : getCreatures()) {
		if (creature->getNpc()) {
			zoneNpcs.insert(creature->getNpc());
		}
	}
	return zoneNpcs;
}

phmap::btree_set<Item*> Zone::getItems() const {
	phmap::btree_set<Item*> zoneItems;
	for (Tile* tile : getTiles()) {
		auto items = tile->getItemList();
		for (auto item : *items) {
			zoneItems.insert(item);
		}
	}
	return zoneItems;
}

void Zone::removeMonsters() {
	for (auto monster : getMonsters()) {
		g_game().removeCreature(monster);
	}
}

void Zone::removeNpcs() {
	for (auto npc : getNpcs()) {
		g_game().removeCreature(npc);
	}
}

void Zone::clearZones() {
	zones.clear();
}

std::vector<std::shared_ptr<Zone>> Zone::getZones() {
	std::vector<std::shared_ptr<Zone>> result;
	for (auto &[name, zone] : zones) {
		result.push_back(zone);
	}
	return result;
}
