/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/zones/zone.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
#endif

#include "game/game.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/npcs/npc.hpp"
#include "creatures/players/player.hpp"
#include "utils/pugicast.hpp"
#include "kv/kv.hpp"

phmap::parallel_flat_hash_map<std::string, std::shared_ptr<Zone>> Zone::zones = {};
phmap::parallel_flat_hash_map<uint32_t, std::shared_ptr<Zone>> Zone::zonesByID = {};
phmap::parallel_flat_hash_map<Position, std::vector<std::shared_ptr<Zone>>> Zone::zonesByPosition = {};
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
		zone->indexPositions();
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

void Zone::addPosition(const Position &position) {
	if (!positions.emplace(position).second || name.empty()) {
		return;
	}

	indexPosition(position);
}

void Zone::removePosition(const Position &position) {
	if (positions.erase(position) == 0 || name.empty()) {
		return;
	}

	unindexPosition(position);
}

bool Zone::contains(const Position &pos) const {
	return positions.contains(pos);
}

void Zone::indexPosition(const Position &position) {
	auto self = shared_from_this();
	auto &zonesAtPosition = zonesByPosition[position];
	for (const auto &zone : zonesAtPosition) {
		if (zone.get() == this) {
			return;
		}
	}
	zonesAtPosition.emplace_back(std::move(self));
}

void Zone::indexPositions() {
	if (name.empty()) {
		return;
	}

	for (const auto &position : positions) {
		indexPosition(position);
	}
}

void Zone::unindexPosition(const Position &position) {
	const auto it = zonesByPosition.find(position);
	if (it == zonesByPosition.end()) {
		return;
	}

	auto &zonesAtPosition = it->second;
	const auto removed = std::ranges::remove_if(zonesAtPosition, [this](const auto &zone) {
		return !zone || zone.get() == this;
	});
	zonesAtPosition.erase(removed.begin(), removed.end());

	if (zonesAtPosition.empty()) {
		zonesByPosition.erase(it);
	}
}

void Zone::unindexPositions() {
	for (const auto &position : positions) {
		unindexPosition(position);
	}
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
	std::scoped_lock lock(cacheMutex);
	return weak::lock(creaturesCache);
}

std::vector<std::shared_ptr<Player>> Zone::getPlayers() {
	std::scoped_lock lock(cacheMutex);
	return weak::lock(playersCache);
}

std::vector<std::shared_ptr<Monster>> Zone::getMonsters() {
	std::scoped_lock lock(cacheMutex);
	return weak::lock(monstersCache);
}

std::vector<std::shared_ptr<Npc>> Zone::getNpcs() {
	std::scoped_lock lock(cacheMutex);
	return weak::lock(npcsCache);
}

std::vector<std::shared_ptr<Item>> Zone::getItems() {
	std::scoped_lock lock(cacheMutex);
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
		zone->unindexPositions();
		zone->refresh();
	}
	zones.clear();
	for (const auto &[_, zone] : zonesByID) {
		zones[zone->name] = zone;
	}
}

std::vector<std::shared_ptr<Zone>> Zone::getZones(const Position position) {
	std::vector<std::shared_ptr<Zone>> result;
	if (const auto it = zonesByPosition.find(position); it != zonesByPosition.end()) {
		result.reserve(it->second.size());
		for (const auto &zone : it->second) {
			if (!zone) {
				continue;
			}
			result.push_back(zone);
		}
	}
	return result;
}

std::vector<std::shared_ptr<Zone>> Zone::getZones() {
	std::vector<std::shared_ptr<Zone>> result;
	for (const auto &[_, zone] : zones) {
		if (zone) {
			result.push_back(zone);
		}
	}
	return result;
}

void Zone::creatureAdded(const std::shared_ptr<Creature> &creature) {
	if (!creature) {
		return;
	}

	const auto player = creature->getPlayer();
	const auto monster = creature->getMonster();
	const auto npc = creature->getNpc();
	std::scoped_lock lock(cacheMutex);
	if (player) {
		playersCache.insert(player);
	} else if (monster) {
		monstersCache.insert(monster);
	} else if (npc) {
		npcsCache.insert(npc);
	}

	creaturesCache.insert(creature);
}

void Zone::creatureRemoved(const std::shared_ptr<Creature> &creature) {
	if (!creature) {
		return;
	}

	const auto player = creature->getPlayer();
	const auto monster = creature->getMonster();
	const auto npc = creature->getNpc();
	std::scoped_lock lock(cacheMutex);
	creaturesCache.erase(std::weak_ptr<Creature>(creature));
	if (player) {
		playersCache.erase(std::weak_ptr<Player>(player));
	}
	if (monster) {
		monstersCache.erase(std::weak_ptr<Monster>(monster));
	}
	if (npc) {
		npcsCache.erase(std::weak_ptr<Npc>(npc));
	}
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
	std::scoped_lock lock(cacheMutex);
	itemsCache.insert(item);
}

void Zone::itemRemoved(const std::shared_ptr<Item> &item) {
	if (!item) {
		return;
	}
	std::scoped_lock lock(cacheMutex);
	itemsCache.erase(std::weak_ptr<Item>(item));
}

void Zone::refresh() {
	Benchmark bm_refresh;
	{
		std::scoped_lock lock(cacheMutex);
		creaturesCache.clear();
		monstersCache.clear();
		npcsCache.clear();
		playersCache.clear();
		itemsCache.clear();
	}

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
