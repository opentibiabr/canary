/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/npcs/spawns/spawn_npc.hpp"

#include "creatures/npcs/npc.hpp"
#include "creatures/npcs/npcs.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "lua/callbacks/event_callback.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "lua/creature/events.hpp"
#include "map/spectators.hpp"
#include "utils/pugicast.hpp"

static constexpr int32_t MINSPAWN_INTERVAL = 1000; // 1 second
static constexpr int32_t MAXSPAWN_INTERVAL = 86400000; // 1 day

bool SpawnsNpc::loadFromXml(const std::string &fileNpcName) {
	if (isLoaded()) {
		return true;
	}

	pugi::xml_document doc;
	const pugi::xml_parse_result result = doc.load_file(fileNpcName.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, fileNpcName, result);
		return false;
	}

	setFileName(fileNpcName);
	setLoaded(true);

	for (const auto &spawnNode : doc.child("npcs").children()) {
		Position centerPos(
			pugi::cast<uint16_t>(spawnNode.attribute("centerx").value()),
			pugi::cast<uint16_t>(spawnNode.attribute("centery").value()),
			pugi::cast<uint16_t>(spawnNode.attribute("centerz").value())
		);

		int32_t radius;
		pugi::xml_attribute radiusAttribute = spawnNode.attribute("radius");
		if (radiusAttribute) {
			radius = pugi::cast<int32_t>(radiusAttribute.value());
		} else {
			radius = -1;
		}

		if (!spawnNode.first_child()) {
			g_logger().warn("[SpawnsNpc::loadFromXml] - Empty spawn at position: {} with radius: {}", centerPos.toString(), radius);
			continue;
		}

		const auto &spawnNpc = spawnNpcList.emplace_back(std::make_shared<SpawnNpc>(centerPos, radius));

		for (const auto &childNode : spawnNode.children()) {
			if (strcasecmp(childNode.name(), "npc") == 0) {
				pugi::xml_attribute nameAttribute = childNode.attribute("name");
				if (!nameAttribute) {
					continue;
				}

				Direction dir;

				pugi::xml_attribute directionAttribute = childNode.attribute("direction");
				if (directionAttribute) {
					dir = static_cast<Direction>(pugi::cast<uint16_t>(directionAttribute.value()));
				} else {
					dir = DIRECTION_NORTH;
				}

				const auto xOffset = pugi::cast<int16_t>(childNode.attribute("x").value());
				const auto yOffset = pugi::cast<int16_t>(childNode.attribute("y").value());
				Position pos(
					static_cast<uint16_t>(centerPos.x + xOffset),
					static_cast<uint16_t>(centerPos.y + yOffset),
					centerPos.z
				);
				const int64_t interval = pugi::cast<int64_t>(childNode.attribute("spawntime").value()) * 1000;
				if (interval >= MINSPAWN_INTERVAL && interval <= MAXSPAWN_INTERVAL) {
					spawnNpc->addNpc(nameAttribute.as_string(), pos, dir, static_cast<uint32_t>(interval));
				} else {
					if (interval <= MINSPAWN_INTERVAL) {
						g_logger().warn("[SpawnsNpc::loadFromXml] - {} {} spawntime can not be less than {} seconds", nameAttribute.as_string(), pos.toString(), MINSPAWN_INTERVAL / 1000);
					} else {
						g_logger().warn("[SpawnsNpc::loadFromXml] - {} {} spawntime can not be more than {} seconds", nameAttribute.as_string(), pos.toString(), MAXSPAWN_INTERVAL / 1000);
					}
				}
			}
		}
	}
	return true;
}

void SpawnsNpc::startup() {
	if (!isLoaded() || isStarted()) {
		return;
	}

	for (const auto &spawnNpc : spawnNpcList) {
		spawnNpc->startup();
	}

	setStarted(true);
}

void SpawnsNpc::clear() {
	for (const auto &spawnNpc : spawnNpcList) {
		spawnNpc->stopEvent();
	}
	spawnNpcList.clear();

	setLoaded(false);
	setStarted(false);
	fileName.clear();
}

bool SpawnsNpc::isStarted() const {
	return started;
}

bool SpawnsNpc::setStarted(bool setStarted) {
	return started = setStarted;
}

bool SpawnsNpc::isLoaded() const {
	return loaded;
}

bool SpawnsNpc::setLoaded(bool setLoaded) {
	return loaded = setLoaded;
}

std::string SpawnsNpc::setFileName(std::string setName) {
	return fileName = std::move(setName);
}

std::vector<std::shared_ptr<SpawnNpc>> &SpawnsNpc::getSpawnNpcList() {
	return spawnNpcList;
}

bool SpawnsNpc::isInZone(const Position &centerPos, int32_t radius, const Position &pos) {
	if (radius == -1) {
		return true;
	}

	return ((pos.getX() >= centerPos.getX() - radius) && (pos.getX() <= centerPos.getX() + radius) && (pos.getY() >= centerPos.getY() - radius) && (pos.getY() <= centerPos.getY() + radius));
}

void SpawnNpc::startSpawnNpcCheck() {
	if (checkSpawnNpcEvent == 0) {
		checkSpawnNpcEvent = g_dispatcher().scheduleEvent(
			getInterval(), [this] { checkSpawnNpc(); }, "SpawnNpc::checkSpawnNpc"
		);
	}
}

SpawnNpc::~SpawnNpc() {
	for (const auto &[spawnId, npc] : spawnedNpcMap) {
		if (spawnId == 0) {
			continue;
		}

		npc->setSpawnNpc(nullptr);
	}
}

bool SpawnNpc::findPlayer(const Position &pos) {
	auto spectators = Spectators().find<Player>(pos);
	return std::ranges::any_of(spectators, [](const auto &spectator) {
		return !spectator->getPlayer()->hasFlag(PlayerFlags_t::IgnoredByNpcs);
	});
}

bool SpawnNpc::isInSpawnNpcZone(const Position &pos) const {
	return SpawnsNpc::isInZone(centerPos, radius, pos);
}

bool SpawnNpc::spawnNpc(uint32_t spawnId, const std::shared_ptr<NpcType> &npcType, const Position &pos, Direction dir, bool startup /*= false*/) {
	auto npc = std::make_shared<Npc>(npcType);
	if (startup) {
		// No need to send out events to the surrounding since there is no one out there to listen!
		if (!g_game().internalPlaceCreature(npc, pos, true, false)) {
			return false;
		}
	} else {
		if (!g_game().placeCreature(npc, pos, false, true)) {
			return false;
		}
	}

	npc->setDirection(dir);
	npc->setSpawnNpc(static_self_cast<SpawnNpc>());
	npc->setMasterPos(pos);

	spawnedNpcMap.insert(spawned_pair(spawnId, npc));
	spawnNpcMap[spawnId].lastSpawnNpc = OTSYS_TIME();
	return true;
}

uint32_t SpawnNpc::getInterval() const {
	return interval;
}

void SpawnNpc::startup() {
	for (const auto &[spawnId, npcInfo] : spawnNpcMap) {
		if (spawnId == 0) {
			continue;
		}

		const auto &[pos, npcType, lastSpawnNpc, _, direction] = npcInfo;
		spawnNpc(spawnId, npcType, pos, direction, true);
	}
}

void SpawnNpc::checkSpawnNpc() {
	checkSpawnNpcEvent = 0;

	cleanup();

	for (auto &[spawnId, npcInfo] : spawnNpcMap) {
		if (spawnedNpcMap.contains(spawnId)) {
			continue;
		}

		auto &[pos, npcType, lastSpawnNpc, mapInterval, direction] = npcInfo;
		if (!npcType->canSpawn(pos)) {
			lastSpawnNpc = OTSYS_TIME();
			continue;
		}

		if (OTSYS_TIME() >= lastSpawnNpc + mapInterval) {
			if (findPlayer(pos)) {
				lastSpawnNpc = OTSYS_TIME();
				continue;
			}

			scheduleSpawnNpc(spawnId, npcInfo, 3 * NONBLOCKABLE_SPAWN_NPC_INTERVAL);
		}
	}

	if (spawnedNpcMap.size() < spawnNpcMap.size()) {
		checkSpawnNpcEvent = g_dispatcher().scheduleEvent(
			getInterval(), [this] { checkSpawnNpc(); }, __FUNCTION__
		);
	}
}

void SpawnNpc::scheduleSpawnNpc(uint32_t spawnId, spawnBlockNpc_t &sb, uint16_t interval) {
	if (interval <= 0) {
		spawnNpc(spawnId, sb.npcType, sb.pos, sb.direction);
	} else {
		g_game().addMagicEffect(sb.pos, CONST_ME_TELEPORT);
		g_dispatcher().scheduleEvent(
			1400, [=, this, &sb] { scheduleSpawnNpc(spawnId, sb, interval - NONBLOCKABLE_SPAWN_NPC_INTERVAL); }, __FUNCTION__
		);
	}
}

void SpawnNpc::cleanup() {
	auto it = spawnedNpcMap.begin();
	while (it != spawnedNpcMap.end()) {
		uint32_t spawnId = it->first;
		const auto &npc = it->second;
		if (npc->isRemoved()) {
			spawnNpcMap[spawnId].lastSpawnNpc = OTSYS_TIME();
			it = spawnedNpcMap.erase(it);
		} else {
			++it;
		}
	}
}

bool SpawnNpc::addNpc(const std::string &name, const Position &pos, Direction dir, uint32_t scheduleInterval) {
	const auto &npcType = g_npcs().getNpcType(name);
	if (!npcType) {
		g_logger().error("Can not find {}", name);
		return false;
	}

	this->interval = std::min(this->interval, scheduleInterval);

	spawnBlockNpc_t sb;
	sb.npcType = npcType;
	sb.pos = pos;
	sb.direction = dir;
	sb.interval = scheduleInterval;
	sb.lastSpawnNpc = 0;

	const uint32_t spawnId = spawnNpcMap.size() + 1;
	spawnNpcMap[spawnId] = sb;
	return true;
}

void SpawnNpc::removeNpc(const std::shared_ptr<Npc> &npc) {
	for (auto it = spawnedNpcMap.begin(), end = spawnedNpcMap.end(); it != end; ++it) {
		if (it->second == npc) {
			spawnedNpcMap.erase(it);
			break;
		}
	}
}

void SpawnNpc::stopEvent() {
	if (checkSpawnNpcEvent != 0) {
		g_dispatcher().stopEvent(checkSpawnNpcEvent);
		checkSpawnNpcEvent = 0;
	}
}
