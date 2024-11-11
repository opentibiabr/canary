/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/spawns/spawn_monster.hpp"

#include "config/configmanager.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "game/movement/position.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/scheduling/events_scheduler.hpp"
#include "game/zones/zone.hpp"
#include "lua/callbacks/event_callback.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "lua/creature/events.hpp"
#include "map/spectators.hpp"
#include "utils/pugicast.hpp"

static constexpr int32_t MONSTER_MINSPAWN_INTERVAL = 1000; // 1 second
static constexpr int32_t MONSTER_MAXSPAWN_INTERVAL = 86400000; // 1 day

bool SpawnsMonster::loadFromXML(const std::string &filemonstername) {
	if (isLoaded()) {
		return true;
	}

	pugi::xml_document doc;
	const pugi::xml_parse_result result = doc.load_file(filemonstername.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, filemonstername, result);
		return false;
	}

	this->filemonstername = filemonstername;
	loaded = true;

	std::string boostedNameGet = g_game().getBoostedMonsterName();

	spawnMonsterList.reserve(100000);
	for (const auto &spawnMonsterNode : doc.child("monsters").children()) {
		Position centerPos(
			pugi::cast<uint16_t>(spawnMonsterNode.attribute("centerx").value()),
			pugi::cast<uint16_t>(spawnMonsterNode.attribute("centery").value()),
			pugi::cast<uint16_t>(spawnMonsterNode.attribute("centerz").value())
		);

		int32_t radius;
		pugi::xml_attribute radiusAttribute = spawnMonsterNode.attribute("radius");
		if (radiusAttribute) {
			radius = pugi::cast<int32_t>(radiusAttribute.value());
		} else {
			radius = -1;
		}

		if (!spawnMonsterNode.first_child()) {
			g_logger().warn("[SpawnsMonster::loadFromXml] - Empty spawn at position: {} with radius: {}", centerPos.toString(), radius);
			continue;
		}

		const auto &spawnMonster = spawnMonsterList.emplace_back(std::make_shared<SpawnMonster>(centerPos, radius));
		for (const auto &childMonsterNode : spawnMonsterNode.children()) {
			if (strcasecmp(childMonsterNode.name(), "monster") == 0) {
				pugi::xml_attribute nameAttribute = childMonsterNode.attribute("name");
				if (!nameAttribute) {
					continue;
				}

				Direction dir;

				pugi::xml_attribute directionAttribute = childMonsterNode.attribute("direction");
				if (directionAttribute) {
					dir = static_cast<Direction>(pugi::cast<uint16_t>(directionAttribute.value()));
				} else {
					dir = DIRECTION_NORTH;
				}

				const auto xOffset = pugi::cast<int16_t>(childMonsterNode.attribute("x").value());
				const auto yOffset = pugi::cast<int16_t>(childMonsterNode.attribute("y").value());
				Position pos(
					static_cast<uint16_t>(centerPos.x + xOffset),
					static_cast<uint16_t>(centerPos.y + yOffset),
					centerPos.z
				);

				pugi::xml_attribute weightAttribute = childMonsterNode.attribute("weight");
				uint32_t weight = 1;
				if (weightAttribute) {
					weight = pugi::cast<uint32_t>(weightAttribute.value());
				}

				uint32_t scheduleInterval = g_configManager().getNumber(DEFAULT_RESPAWN_TIME);

				pugi::xml_attribute spawnTimeAttr = childMonsterNode.attribute("spawntime");
				if (spawnTimeAttr) {
					const auto xmlSpawnTime = pugi::cast<uint32_t>(spawnTimeAttr.value());
					if (xmlSpawnTime > 0) {
						scheduleInterval = xmlSpawnTime;
					} else {
						g_logger().warn("Invalid spawntime value '{}' for monster '{}'. Setting to default respawn time: {}", spawnTimeAttr.value(), nameAttribute.value(), scheduleInterval);
					}
				} else {
					g_logger().warn("Missing spawntime attribute for monster '{}'. Setting to default respawn time: {}", nameAttribute.value(), scheduleInterval);
				}

				spawnMonster->addMonster(nameAttribute.as_string(), pos, dir, scheduleInterval * 1000, weight);
			}
		}
	}

	// Clears unused memory that has been reserved
	spawnMonsterList.shrink_to_fit();
	return true;
}

void SpawnsMonster::startup() {
	if (!isLoaded() || isStarted()) {
		return;
	}

	for (const auto &spawnMonster : spawnMonsterList) {
		spawnMonster->startup();
	}

	started = true;
}

void SpawnsMonster::clear() {
	for (const auto &spawnMonster : spawnMonsterList) {
		spawnMonster->stopEvent();
	}
	spawnMonsterList.clear();

	loaded = false;
	started = false;
	filemonstername.clear();
}

bool SpawnsMonster::isStarted() const {
	return started;
}

bool SpawnsMonster::isLoaded() const {
	return loaded;
}

std::vector<std::shared_ptr<SpawnMonster>> &SpawnsMonster::getspawnMonsterList() {
	return spawnMonsterList;
}

bool SpawnsMonster::isInZone(const Position &centerPos, int32_t radius, const Position &pos) {
	if (radius == -1) {
		return true;
	}

	return ((pos.getX() >= centerPos.getX() - radius) && (pos.getX() <= centerPos.getX() + radius) && (pos.getY() >= centerPos.getY() - radius) && (pos.getY() <= centerPos.getY() + radius));
}

void SpawnMonster::startSpawnMonsterCheck() {
	if (checkSpawnMonsterEvent == 0) {
		checkSpawnMonsterEvent = g_dispatcher().scheduleEvent(
			getInterval(), [this] { checkSpawnMonster(); }, "SpawnMonster::checkSpawnMonster"
		);
	}
}

SpawnMonster::~SpawnMonster() {
	stopEvent();
}

// moveable

SpawnMonster::SpawnMonster(SpawnMonster &&rhs) noexcept :
	spawnedMonsterMap(std::move(rhs.spawnedMonsterMap)),
	spawnMonsterMap(std::move(rhs.spawnMonsterMap)),
	centerPos(rhs.centerPos),
	radius(rhs.radius),
	interval(rhs.interval),
	checkSpawnMonsterEvent(rhs.checkSpawnMonsterEvent) { }

SpawnMonster &SpawnMonster::operator=(SpawnMonster &&rhs) noexcept {
	if (this != &rhs) {
		spawnMonsterMap = std::move(rhs.spawnMonsterMap);
		spawnedMonsterMap = std::move(rhs.spawnedMonsterMap);

		checkSpawnMonsterEvent = rhs.checkSpawnMonsterEvent;
		centerPos = rhs.centerPos;
		radius = rhs.radius;
		interval = rhs.interval;
	}
	return *this;
}

bool SpawnMonster::findPlayer(const Position &pos) {
	auto spectators = Spectators().find<Player>(pos);
	return std::ranges::any_of(spectators, [](const auto &spectator) {
		return !spectator->getPlayer()->hasFlag(PlayerFlags_t::IgnoredByMonsters);
	});
}

bool SpawnMonster::isInSpawnMonsterZone(const Position &pos) const {
	return SpawnsMonster::isInZone(centerPos, radius, pos);
}

bool SpawnMonster::spawnMonster(uint32_t spawnMonsterId, spawnBlock_t &sb, const std::shared_ptr<MonsterType> &monsterType, bool startup /*= false*/) {
	if (spawnedMonsterMap.contains(spawnMonsterId)) {
		return false;
	}
	auto monster = std::make_shared<Monster>(monsterType);
	if (startup) {
		// No need to send out events to the surrounding since there is no one out there to listen!
		if (!g_game().internalPlaceCreature(monster, sb.pos, true)) {
			return false;
		}
	} else {
		g_logger().trace("[SpawnMonster] Spawning {} at {}", monsterType->name, sb.pos.toString());
		if (!g_game().placeCreature(monster, sb.pos, false, true)) {
			return false;
		}
	}

	monster->setDirection(sb.direction);
	monster->setSpawnMonster(static_self_cast<SpawnMonster>());
	monster->setMasterPos(sb.pos);

	spawnedMonsterMap[spawnMonsterId] = monster;
	sb.lastSpawn = OTSYS_TIME();
	monster->onSpawn();
	return true;
}

void SpawnMonster::startup(bool delayed) {
	if (g_configManager().getBoolean(RANDOM_MONSTER_SPAWN)) {
		for (auto it = spawnMonsterMap.begin(); it != spawnMonsterMap.end(); ++it) {
			auto &[spawnMonsterId, sb] = *it;
			for (auto &[monsterType, weight] : sb.monsterTypes) {
				if (monsterType->isBoss()) {
					continue;
				}
				for (auto otherIt = std::next(it); otherIt != spawnMonsterMap.end(); ++otherIt) {
					auto &[id, otherSb] = *otherIt;
					if (id == spawnMonsterId) {
						continue;
					}
					if (otherSb.hasBoss()) {
						continue;
					}
					if (otherSb.monsterTypes.contains(monsterType)) {
						weight += otherSb.monsterTypes[monsterType];
					}
					otherSb.monsterTypes.emplace(monsterType, weight);
					sb.monsterTypes.emplace(monsterType, weight);
				}
			}
		}
	}
	for (auto &[spawnMonsterId, sb] : spawnMonsterMap) {
		const auto &mType = sb.getMonsterType();
		if (!mType) {
			continue;
		}
		if (delayed) {
			g_dispatcher().addEvent([this, spawnMonsterId, &sb, mType] { scheduleSpawn(spawnMonsterId, sb, mType, 0, true); }, __FUNCTION__);
		} else {
			scheduleSpawn(spawnMonsterId, sb, mType, 0, true);
		}
	}
}

void SpawnMonster::checkSpawnMonster() {
	if (checkSpawnMonsterEvent == 0) {
		return;
	}

	checkSpawnMonsterEvent = 0;
	cleanup();

	for (auto &[spawnMonsterId, sb] : spawnMonsterMap) {
		if (spawnedMonsterMap.contains(spawnMonsterId)) {
			continue;
		}

		const auto &mType = sb.getMonsterType();
		if (!mType) {
			continue;
		}
		if (!mType->canSpawn(sb.pos) || (mType->info.isBlockable && findPlayer(sb.pos))) {
			sb.lastSpawn = OTSYS_TIME();
			continue;
		}
		if (OTSYS_TIME() < sb.lastSpawn + sb.interval) {
			continue;
		}

		if (mType->info.isBlockable) {
			spawnMonster(spawnMonsterId, sb, mType);
		} else {
			scheduleSpawn(spawnMonsterId, sb, mType, 3 * NONBLOCKABLE_SPAWN_MONSTER_INTERVAL);
		}
	}

	if (spawnedMonsterMap.size() < spawnMonsterMap.size()) {
		checkSpawnMonsterEvent = g_dispatcher().scheduleEvent(
			getInterval(), [this] { checkSpawnMonster(); }, "SpawnMonster::checkSpawnMonster"
		);
	}
}

void SpawnMonster::scheduleSpawn(uint32_t spawnMonsterId, spawnBlock_t &sb, const std::shared_ptr<MonsterType> &mType, uint16_t interval, bool startup /*= false*/) {
	if (interval <= 0) {
		spawnMonster(spawnMonsterId, sb, mType, startup);
	} else {
		g_game().addMagicEffect(sb.pos, CONST_ME_TELEPORT);
		g_dispatcher().scheduleEvent(
			NONBLOCKABLE_SPAWN_MONSTER_INTERVAL, [=, this, &sb] { scheduleSpawn(spawnMonsterId, sb, mType, interval - NONBLOCKABLE_SPAWN_MONSTER_INTERVAL, startup); }, "SpawnMonster::scheduleSpawn"
		);
	}
}

void SpawnMonster::cleanup() {
	for (auto it = spawnedMonsterMap.begin(); it != spawnedMonsterMap.end();) {
		const auto &monster = it->second;
		if (!monster || monster->isRemoved()) {
			auto spawnIt = spawnMonsterMap.find(it->first);
			if (spawnIt != spawnMonsterMap.end()) {
				spawnIt->second.lastSpawn = OTSYS_TIME();
			}
			it = spawnedMonsterMap.erase(it);
		} else {
			++it;
		}
	}
}

const Position &SpawnMonster::getCenterPos() const {
	return centerPos;
}

bool SpawnMonster::addMonster(const std::string &name, const Position &pos, Direction dir, uint32_t scheduleInterval, uint32_t weight /*= 1*/) {
	std::string variant;
	for (const auto &zone : Zone::getZones(pos)) {
		if (!zone->getMonsterVariant().empty()) {
			variant = zone->getMonsterVariant() + "|";
			break;
		}
	}
	const auto &monsterType = g_monsters().getMonsterType(variant + name);
	if (!monsterType) {
		g_logger().error("Can not find {}", name);
		return false;
	}

	const uint32_t eventschedule = g_eventsScheduler().getSpawnMonsterSchedule();
	const std::string boostedMonster = g_game().getBoostedMonsterName();
	int32_t boostedrate = 1;
	if (name == boostedMonster) {
		boostedrate = 2;
	}
	auto rateSpawn = g_configManager().getNumber(RATE_SPAWN);
	// eventschedule is a whole percentage, so we need to multiply by 100 to match the order of magnitude of the other values
	scheduleInterval = scheduleInterval * 100 / std::max(static_cast<uint32_t>(1), (rateSpawn * boostedrate * eventschedule));
	if (scheduleInterval < MONSTER_MINSPAWN_INTERVAL) {
		g_logger().warn("[SpawnsMonster::addMonster] - {} {} spawntime cannot be less than {} seconds, set to {} by default.", name, pos.toString(), MONSTER_MINSPAWN_INTERVAL / 1000, MONSTER_MINSPAWN_INTERVAL / 1000);
		scheduleInterval = MONSTER_MINSPAWN_INTERVAL;
	} else if (scheduleInterval > MONSTER_MAXSPAWN_INTERVAL) {
		g_logger().warn("[SpawnsMonster::addMonster] - {} {} spawntime can not be more than {} seconds, set to {} by default", name, pos.toString(), MONSTER_MAXSPAWN_INTERVAL / 1000, MONSTER_MAXSPAWN_INTERVAL / 1000);
		scheduleInterval = MONSTER_MAXSPAWN_INTERVAL;
	}
	this->interval = std::gcd(this->interval, scheduleInterval);

	spawnBlock_t* sb = nullptr;
	uint32_t spawnMonsterId = spawnMonsterMap.size() + 1;
	for (auto &[id, maybeSb] : spawnMonsterMap) {
		if (maybeSb.pos == pos) {
			sb = &maybeSb;
			spawnMonsterId = id;
			break;
		}
	}
	if (sb) {
		if (sb->monsterTypes.contains(monsterType)) {
			g_logger().error("[SpawnMonster] Monster {} already exists in spawn block at {}", name, pos.toString());
			return false;
		}
		if (monsterType->isBoss() && !sb->monsterTypes.empty()) {
			g_logger().error("[SpawnMonster] Boss monster {} has been added to spawn block with other monsters. This is not allowed.", name);
			return false;
		}
		if (sb->hasBoss()) {
			g_logger().error("[SpawnMonster] Monster {} has been added to spawn block with a boss. This is not allowed.", name);
			return false;
		}
	}
	if (!sb) {
		sb = &spawnMonsterMap.emplace(spawnMonsterId, spawnBlock_t()).first->second;
	}
	sb->monsterTypes.emplace(monsterType, weight);
	sb->pos = pos;
	sb->direction = dir;
	sb->interval = scheduleInterval;
	sb->lastSpawn = 0;
	return true;
}

void SpawnMonster::removeMonster(const std::shared_ptr<Monster> &monster) {
	uint32_t spawnMonsterId = 0;
	for (const auto &[id, m] : spawnedMonsterMap) {
		if (m == monster) {
			spawnMonsterId = id;
			break;
		}
	}
	spawnedMonsterMap.erase(spawnMonsterId);
}

void SpawnMonster::removeMonsters() {
	spawnMonsterMap.clear();
	spawnedMonsterMap.clear();
}

void SpawnMonster::setMonsterVariant(const std::string &variant) {
	for (auto &[monsterId, monsterInfo] : spawnMonsterMap) {
		if (monsterId == 0) {
			continue;
		}

		std::unordered_map<std::shared_ptr<MonsterType>, uint32_t> monsterTypes;
		for (const auto &[monsterType, weight] : monsterInfo.monsterTypes) {
			if (!monsterType || monsterType->typeName.empty()) {
				continue;
			}
			auto variantName = variant + "|" + monsterType->typeName;
			auto variantType = g_monsters().getMonsterType(variantName, true);
			if (variantType) {
				monsterTypes.emplace(variantType, weight);
			}
		}
		monsterInfo.monsterTypes = monsterTypes;
	}
}

void SpawnMonster::stopEvent() {
	if (checkSpawnMonsterEvent != 0) {
		g_dispatcher().stopEvent(checkSpawnMonsterEvent);
		checkSpawnMonsterEvent = 0;
	}
}

std::shared_ptr<MonsterType> spawnBlock_t::getMonsterType() const {
	if (monsterTypes.empty()) {
		return nullptr;
	}
	uint32_t totalWeight = 0;
	for (const auto &[mType, weight] : monsterTypes) {
		if (!mType) {
			continue;
		}
		if (mType->isBoss()) {
			if (monsterTypes.size() > 1) {
				g_logger().warn("[SpawnMonster] Boss monster {} has been added to spawn block with other monsters. This is not allowed.", mType->name);
			}
			return mType;
		}
		totalWeight += weight;
	}
	uint32_t randomWeight = uniform_random(0, totalWeight - 1);
	// order monsters by weight DESC
	std::vector<std::pair<std::shared_ptr<MonsterType>, uint32_t>> orderedMonsterTypes(monsterTypes.begin(), monsterTypes.end());
	std::ranges::sort(orderedMonsterTypes, [](const auto &a, const auto &b) {
		return a.second > b.second;
	});
	for (const auto &[mType, weight] : orderedMonsterTypes) {
		if (randomWeight < weight) {
			return mType;
		}
		randomWeight -= weight;
	}
	return nullptr;
}

bool spawnBlock_t::hasBoss() const {
	return std::ranges::any_of(monsterTypes, [](const auto &pair) {
		const auto &[monsterType, weight] = pair;
		return monsterType->isBoss();
	});
}
