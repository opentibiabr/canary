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
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "lua/creature/events.hpp"
#include "lua/callbacks/event_callback.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "utils/pugicast.hpp"
#include "map/spectators.hpp"

static constexpr int32_t MINSPAWN_INTERVAL = 1000; // 1 second
static constexpr int32_t MAXSPAWN_INTERVAL = 86400000; // 1 day

bool SpawnsNpc::loadFromXml(const std::string &fileNpcName) {
	if (isLoaded()) {
		return true;
	}

	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file(fileNpcName.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, fileNpcName, result);
		return false;
	}

	setFileName(fileNpcName);
	setLoaded(true);

	for (auto spawnNode : doc.child("npcs").children()) {
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

		for (auto childNode : spawnNode.children()) {
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

				auto xOffset = pugi::cast<int16_t>(childNode.attribute("x").value());
				auto yOffset = pugi::cast<int16_t>(childNode.attribute("y").value());
				Position pos(
					static_cast<uint16_t>(centerPos.x + xOffset),
					static_cast<uint16_t>(centerPos.y + yOffset),
					centerPos.z
				);
				int64_t interval = pugi::cast<int64_t>(childNode.attribute("spawntime").value()) * 1000;
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
	for (const auto &it : spawnedNpcMap) {
		auto npc = it.second;
		npc->setSpawnNpc(nullptr);
	}
}

bool SpawnNpc::findPlayer(const Position &pos) {
	auto spectators = Spectators().find<Player>(pos);
	return std::ranges::any_of(spectators, [](const auto &spectator) {
		return !spectator->getPlayer()->hasFlag(PlayerFlags_t::IgnoredByNpcs);
	});
}

bool SpawnNpc::isInSpawnNpcZone(const Position &pos) {
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

	g_events().eventNpcOnSpawn(npc, pos);
	g_callbacks().executeCallback(EventCallback_t::npcOnSpawn, &EventCallback::npcOnSpawn, npc, pos);
	return true;
}

void SpawnNpc::startup() {
	for (const auto &it : spawnNpcMap) {
		uint32_t spawnId = it.first;
		const spawnBlockNpc_t &sb = it.second;
		spawnNpc(spawnId, sb.npcType, sb.pos, sb.direction, true);
	}
}

void SpawnNpc::checkSpawnNpc() {
	checkSpawnNpcEvent = 0;

	cleanup();

	for (auto &it : spawnNpcMap) {
		uint32_t spawnId = it.first;
		if (spawnedNpcMap.find(spawnId) != spawnedNpcMap.end()) {
			continue;
		}

		spawnBlockNpc_t &sb = it.second;
		if (!sb.npcType->canSpawn(sb.pos)) {
			sb.lastSpawnNpc = OTSYS_TIME();
			continue;
		}

		if (OTSYS_TIME() >= sb.lastSpawnNpc + sb.interval) {
			if (findPlayer(sb.pos)) {
				sb.lastSpawnNpc = OTSYS_TIME();
				continue;
			}

			scheduleSpawnNpc(spawnId, sb, 3 * NONBLOCKABLE_SPAWN_NPC_INTERVAL);
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
		auto npc = it->second;
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

	uint32_t spawnId = spawnNpcMap.size() + 1;
	spawnNpcMap[spawnId] = sb;
	return true;
}

void SpawnNpc::removeNpc(std::shared_ptr<Npc> npc) {
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
