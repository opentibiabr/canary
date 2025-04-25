/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/zones/zone.hpp"

#include "game/game.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/npcs/npc.hpp"
#include "creatures/players/player.hpp"
#include "utils/pugicast.hpp"
#include "kv/kv.hpp"

phmap::parallel_flat_hash_map<std::string, std::shared_ptr<Zone>> Zone::zones = {};
phmap::parallel_flat_hash_map<uint32_t, std::shared_ptr<Zone>> Zone::zonesByID = {};
const static std::shared_ptr<Zone> nullZone = nullptr;

std::shared_ptr<Zone> Zone::addZone(const std::string &name, uint32_t zoneID /* = 0 */) {
	if (name == "default") {
		g_logger().error("Zone name {} is reserved", name);
		return nullZone;
	}
	if (zoneID != 0 && zonesByID.contains(zoneID)) {
		g_logger().trace("[Zone::addZone] Found with ID {} while adding {}, linking them together...", zoneID, name);
		auto zone = zonesByID[zoneID];
		zone->name = name;
		zones[name] = zone;
		return zone;
	}

	if (zones[name]) {
		g_logger().error("Zone {} already exists", name);
		return nullZone;
	}
	zones[name] = std::make_shared<Zone>(name, zoneID);
	if (zoneID != 0) {
		zonesByID[zoneID] = zones[name];
	}
	return zones[name];
}

void Zone::addArea(Area area) {
	for (const auto &pos : area) {
		addPosition(pos);
	}
	refresh();
}

void Zone::subtractArea(Area area) {
	for (const auto &pos : area) {
		removePosition(pos);
	}
	refresh();
}

bool Zone::contains(const Position &pos) const {
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

std::shared_ptr<Zone> Zone::getZone(uint32_t zoneID) {
	if (zoneID == 0) {
		return nullZone;
	}
	if (zonesByID.contains(zoneID)) {
		return zonesByID[zoneID];
	}
	auto zone = std::make_shared<Zone>(zoneID);
	zonesByID[zoneID] = zone;
	return zone;
}

std::vector<Position> Zone::getPositions() const {
	std::vector<Position> result;
	for (const auto &pos : positions) {
		result.push_back(pos);
	}
	return result;
}

std::vector<std::shared_ptr<Creature>> Zone::getCreatures() {
	return weak::lock(creaturesCache);
}

std::vector<std::shared_ptr<Player>> Zone::getPlayers() {
	return weak::lock(playersCache);
}

std::vector<std::shared_ptr<Monster>> Zone::getMonsters() {
	return weak::lock(monstersCache);
}

std::vector<std::shared_ptr<Npc>> Zone::getNpcs() {
	return weak::lock(npcsCache);
}

std::vector<std::shared_ptr<Item>> Zone::getItems() {
	return weak::lock(itemsCache);
}

void Zone::removePlayers() {
	for (const auto &player : getPlayers()) {
		g_game().internalTeleport(player, getRemoveDestination(player));
		// Remove icon from player (soul war quest)
		if (player->hasIcon("goshnars-hatred-damage")) {
			player->removeIcon("goshnars-hatred-damage");
		}
	}
}

void Zone::removeMonsters() {
	for (const auto &monster : getMonsters()) {
		g_game().removeCreature(monster->getCreature());
	}
}

void Zone::removeNpcs() {
	for (const auto &npc : getNpcs()) {
		g_game().removeCreature(npc->getCreature());
	}
}

void Zone::clearZones() {
	for (const auto &[_, zone] : zones) {
		// do not clear zones loaded from the map (id > 0)
		if (!zone || zone->isStatic()) {
			continue;
		}
		zone->refresh();
	}
	zones.clear();
	for (const auto &[_, zone] : zonesByID) {
		zones[zone->name] = zone;
	}
}

std::vector<std::shared_ptr<Zone>> Zone::getZones(const Position position) {
	Benchmark bm_getZones;
	std::vector<std::shared_ptr<Zone>> result;
	for (const auto &[_, zone] : zones) {
		if (zone && zone->contains(position)) {
			result.push_back(zone);
		}
	}
	auto duration = bm_getZones.duration();
	if (duration > 100) {
		g_logger().warn("Listed {} zones for position {} in {} milliseconds", result.size(), position.toString(), duration);
	}
	return result;
}

std::vector<std::shared_ptr<Zone>> Zone::getZones() {
	Benchmark bm_getZones;
	std::vector<std::shared_ptr<Zone>> result;
	for (const auto &[_, zone] : zones) {
		if (zone) {
			result.push_back(zone);
		}
	}
	auto duration = bm_getZones.duration();
	if (duration > 100) {
		g_logger().warn("Listed {} zones in {} milliseconds", result.size(), duration);
	}
	return result;
}

void Zone::creatureAdded(const std::shared_ptr<Creature> &creature) {
	if (!creature) {
		return;
	}

	if (const auto &player = creature->getPlayer()) {
		playersCache.insert(player);
	} else if (const auto &monster = creature->getMonster()) {
		monstersCache.insert(monster);
	} else if (const auto &npc = creature->getNpc()) {
		npcsCache.insert(npc);
	}

	creaturesCache.insert(creature);
}

void Zone::creatureRemoved(const std::shared_ptr<Creature> &creature) {
	if (!creature) {
		return;
	}
	creaturesCache.erase(creature);
	playersCache.erase(creature->getPlayer());
	monstersCache.erase(creature->getMonster());
	npcsCache.erase(creature->getNpc());
}

void Zone::thingAdded(const std::shared_ptr<Thing> &thing) {
	if (!thing) {
		return;
	}

	if (const auto &item = thing->getItem()) {
		itemAdded(item);
	} else if (const auto &creature = thing->getCreature()) {
		creatureAdded(creature);
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
	Benchmark bm_refresh;
	creaturesCache.clear();
	monstersCache.clear();
	npcsCache.clear();
	playersCache.clear();
	itemsCache.clear();

	for (const auto &position : getPositions()) {
		g_game().map.refreshZones(position);
	}
	g_logger().trace("Refreshed zone '{}' in {} milliseconds", name, bm_refresh.duration());
}

void Zone::setMonsterVariant(const std::string &variant) {
	monsterVariant = variant;
	g_logger().debug("Zone {} monster variant set to {}", name, variant);
	for (const auto &spawnMonster : g_game().map.spawnsMonster.getspawnMonsterList()) {
		if (!contains(spawnMonster->getCenterPos())) {
			continue;
		}
		spawnMonster->setMonsterVariant(variant);
	}

	removeMonsters();
}

bool Zone::loadFromXML(const std::string &fileName, uint16_t shiftID /* = 0 */) {
	pugi::xml_document doc;
	g_logger().debug("Loading zones from {}", fileName);
	pugi::xml_parse_result result = doc.load_file(fileName.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, fileName, result);
		return false;
	}

	for (auto zoneNode : doc.child("zones").children()) {
		auto name = zoneNode.attribute("name").value();
		auto zoneId = pugi::cast<uint32_t>(zoneNode.attribute("zoneid").value()) << shiftID;
		addZone(name, zoneId);
	}
	return true;
}
