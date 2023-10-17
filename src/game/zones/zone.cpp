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
	}
	refresh();
}

void Zone::subtractArea(Area area) {
	for (const Position &pos : area) {
		positions.erase(pos);
		std::shared_ptr<Tile> tile = g_game().map.getTile(pos);
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

Position Zone::getRemoveDestination(const std::shared_ptr<Creature> &creature /* = nullptr */) const {
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

std::vector<std::shared_ptr<Tile>> Zone::getTiles() const {
	std::vector<std::shared_ptr<Tile>> tiles;
	tiles.reserve(positions.size());

	for (const auto &position : positions) {
		if (const auto &tile = g_game().map.getTile(position)) {
			tiles.emplace_back(tile);
		}
	}
	return tiles;
}

std::vector<std::shared_ptr<Creature>> Zone::getCreatures() const {
	std::vector<std::shared_ptr<Creature>> creatures;
	creatures.reserve(creaturesCache.size());

	for (const auto creatureId : creaturesCache) {
		if (const auto &creature = g_game().getCreatureByID(creatureId)) {
			creatures.emplace_back(creature);
		}
	}
	return creatures;
}

std::vector<std::shared_ptr<Player>> Zone::getPlayers() const {
	std::vector<std::shared_ptr<Player>> players;
	players.reserve(playersCache.size());

	for (const auto playerId : playersCache) {
		if (const auto &player = g_game().getPlayerByID(playerId)) {
			players.emplace_back(player);
		}
	}
	return players;
}

std::vector<std::shared_ptr<Monster>> Zone::getMonsters() const {
	std::vector<std::shared_ptr<Monster>> monsters;
	monsters.reserve(monstersCache.size());

	for (const auto monsterId : monstersCache) {
		if (const auto &monster = g_game().getMonsterByID(monsterId)) {
			monsters.emplace_back(monster);
		}
	}
	return monsters;
}

std::vector<std::shared_ptr<Npc>> Zone::getNpcs() const {
	std::vector<std::shared_ptr<Npc>> npcs;
	npcs.reserve(npcsCache.size());

	for (const auto npcId : npcsCache) {
		if (const auto &npc = g_game().getNpcByID(npcId)) {
			npcs.emplace_back(npc);
		}
	}
	return npcs;
}

void Zone::removePlayers() const {
	for (const auto &player : getPlayers()) {
		g_game().internalTeleport(player, getRemoveDestination(player));
	}
}

void Zone::removeMonsters() const {
	for (const auto &monster : getMonsters()) {
		g_game().removeCreature(monster);
	}
}

void Zone::removeNpcs() const {
	for (const auto &npc : getNpcs()) {
		g_game().removeCreature(npc);
	}
}

void Zone::clearZones() {
	zones.clear();
}

std::vector<std::shared_ptr<Zone>> Zone::getZones(const Position postion) {
	stdext::vector_set<std::shared_ptr<Zone>> zonesSet;
	zonesSet.reserve(zones.size());

	for (const auto &[_, zone] : zones) {
		if (zone && zone->isPositionInZone(postion)) {
			zonesSet.emplace(zone);
		}
	}
	return zonesSet.data();
}

std::vector<std::shared_ptr<Zone>> Zone::getZones() {
	stdext::vector_set<std::shared_ptr<Zone>> zonesSet;
	zonesSet.reserve(zones.size());

	for (const auto &[_, zone] : zones) {
		if (zone) {
			zonesSet.emplace(zone);
		}
	}
	return zonesSet.data();
}

void Zone::creatureAdded(const std::shared_ptr<Creature> &creature) {
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

void Zone::creatureRemoved(const std::shared_ptr<Creature> &creature) {
	if (!creature) {
		return;
	}
	creaturesCache.erase(creature->getID());
	if (creature->getPlayer() && playersCache.erase(creature->getID())) {
		g_logger().trace("Player {} (ID: {}) removed from zone {}", creature->getName(), creature->getID(), name);
	}
	if (creature->getMonster() && monstersCache.erase(creature->getID())) {
		g_logger().trace("Monster {} (ID: {}) removed from zone {}", creature->getName(), creature->getID(), name);
	}
	if (creature->getNpc() && npcsCache.erase(creature->getID())) {
		g_logger().trace("Npc {} (ID: {}) removed from zone {}", creature->getName(), creature->getID(), name);
	}
}

void Zone::thingAdded(const std::shared_ptr<Thing> &thing) {
	if (!thing) {
		return;
	}

	if (thing->getItem()) {
		itemAdded(thing->getItem());
	} else if (thing->getCreature()) {
		creatureAdded(thing->getCreature());
	}
}

void Zone::itemAdded(const std::shared_ptr<Item> &item) {
	if (!item) {
		return;
	}
	itemsCache.insert(item);
}

void Zone::itemRemoved(const std::shared_ptr<Item> &item) {
	if (!item) {
		return;
	}
	itemsCache.erase(item);
}

void Zone::refresh() {
	creaturesCache.clear();
	monstersCache.clear();
	npcsCache.clear();
	playersCache.clear();
	itemsCache.clear();

	for (const auto &position : positions) {
		const auto tile = g_game().map.getTile(position);
		if (!tile) {
			continue;
		}
		const auto &items = tile->getItemList();
		if (!items) {
			continue;
		}
		for (const auto &item : *items) {
			itemAdded(item);
		}
		const auto &creatures = tile->getCreatures();
		if (!creatures) {
			continue;
		}
		for (const auto &creature : *creatures) {
			creatureAdded(creature);
		}
	}
}
