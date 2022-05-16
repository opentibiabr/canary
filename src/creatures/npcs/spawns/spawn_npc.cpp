/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include "creatures/npcs/spawns/spawn_npc.h"
#include "game/game.h"
#include "creatures/npcs/npc.h"
#include "game/scheduling/scheduler.h"

#include "lua/creature/events.h"


static constexpr int32_t MINSPAWN_INTERVAL = 1000; // 1 second
static constexpr int32_t MAXSPAWN_INTERVAL = 86400000; // 1 day

bool SpawnsNpc::loadFromXml(const std::string& fileNpcName)
{
	if (isLoaded()) {
		return true;
	}

	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file(fileNpcName.c_str());
	if (!result) {
		printXMLError("SpawnsNpc::loadFromXml", fileNpcName, result);
		return false;
	}

	setFileName(fileNpcName);
	setLoaded(true);

	for (auto spawnNode : doc.child("npcs").children()) {
		Position centerPos(
			static_cast<uint16_t>(spawnNode.attribute("centerx").as_int()),
			static_cast<uint16_t>(spawnNode.attribute("centery").as_int()),
			static_cast<uint8_t>(spawnNode.attribute("centerz").as_int())
		);

		int32_t radius;
		pugi::xml_attribute radiusAttribute = spawnNode.attribute("radius");
		if (radiusAttribute) {
			radius = radiusAttribute.as_int();
		} else {
			radius = -1;
		}

		if (!spawnNode.first_child()) {
			SPDLOG_WARN("[SpawnsNpc::loadFromXml] - Empty spawn at position: {} with radius: {}", centerPos.toString(), radius);
			continue;
		}

		spawnNpcList.emplace_front(centerPos, radius);
		SpawnNpc& spawnNpc = spawnNpcList.front();

		for (auto childNode : spawnNode.children()) {
			if (strcasecmp(childNode.name(), "npc") == 0) {
				pugi::xml_attribute nameAttribute = childNode.attribute("name");
				const std::string npcName = nameAttribute.as_string();
				if (!nameAttribute || npcName.empty()) {
					SPDLOG_WARN("[SpawnsNpc::loadFromXml] - Missing or empty tag 'name' on npc position {}", centerPos.toString());
					continue;
				}

				pugi::xml_attribute directionAttribute = childNode.attribute("direction");
				const std::string directionString = directionAttribute.as_string();
				if (!isNumber(directionAttribute.as_string())) {
					SPDLOG_WARN("[SpawnsNpc::loadFromXml] - Invalid direction with npc name {}", npcName);
					continue;
				}

				Direction dir;
				if (directionAttribute) {
					dir = static_cast<Direction>(directionAttribute.as_int());
				} else {
					dir = DIRECTION_NORTH;
				}

				Position pos(
					centerPos.x + static_cast<uint16_t>(childNode.attribute("x").as_int()),
					centerPos.y + static_cast<uint16_t>(childNode.attribute("y").as_int()),
					centerPos.z
				);
				int64_t interval = static_cast<int64_t>(childNode.attribute("spawntime").as_int()) * 1000;
				if (interval >= MINSPAWN_INTERVAL && interval <= MAXSPAWN_INTERVAL) {
					spawnNpc.addNpc(nameAttribute.as_string(), pos, dir, static_cast<uint32_t>(interval));
				} else {
					if (interval <= MINSPAWN_INTERVAL) {
						SPDLOG_WARN("[SpawnsNpc::loadFromXml] - {} {} spawntime can not be less than {} seconds", nameAttribute.as_string(), pos.toString(), MINSPAWN_INTERVAL / 1000);
					} else {
						SPDLOG_WARN("[SpawnsNpc::loadFromXml] - {} {} spawntime can not be more than {} seconds", nameAttribute.as_string(), pos.toString(), MAXSPAWN_INTERVAL / 1000);
					}
				}
			}
		}
	}
	return true;
}

void SpawnsNpc::startup()
{
	if (!isLoaded() || isStarted()) {
		return;
	}

	for (SpawnNpc& spawnNpc : spawnNpcList) {
		spawnNpc.startup();
	}

	setStarted(true);
}

void SpawnsNpc::clear()
{
	for (SpawnNpc& spawnNpc : spawnNpcList) {
		spawnNpc.stopEvent();
	}
	spawnNpcList.clear();

	setLoaded(false);
	setStarted(false);
	fileName.clear();
}

bool SpawnsNpc::isInZone(const Position& centerPos, int32_t radius, const Position& pos)
{
	if (radius == -1) {
		return true;
	}

	return ((pos.getX() >= centerPos.getX() - radius) && (pos.getX() <= centerPos.getX() + radius) &&
            (pos.getY() >= centerPos.getY() - radius) && (pos.getY() <= centerPos.getY() + radius));
}

void SpawnNpc::startSpawnNpcCheck()
{
	if (checkSpawnNpcEvent == 0) {
		checkSpawnNpcEvent = g_scheduler().addEvent(createSchedulerTask(getInterval(), std::bind_front(&SpawnNpc::checkSpawnNpc, this)));
	}
}

SpawnNpc::~SpawnNpc()
{
	for (const auto& it : spawnedNpcMap) {
		Npc* npc = it.second;
		npc->setSpawnNpc(nullptr);
		npc->decrementReferenceCounter();
	}
}

bool SpawnNpc::findPlayer(const Position& pos)
{
	SpectatorHashSet spectators;
	g_game().map.getSpectators(spectators, pos, false, true);
	for (Creature* spectator : spectators) {
		if (!spectator->getPlayer()->hasCustomFlag(PlayerCustomFlag_IgnoredByNpcs)) {
			return true;
		}
	}
	return false;
}

bool SpawnNpc::isInSpawnNpcZone(const Position& pos)
{
	return SpawnsNpc::isInZone(centerPos, radius, pos);
}

bool SpawnNpc::spawnNpc(uint32_t spawnId, NpcType* npcType, const Position& pos, Direction dir, bool startup /*= false*/)
{
	std::unique_ptr<Npc> npc_ptr(new Npc(npcType));
	if (startup) {
		// No need to send out events to the surrounding since there is no one out there to listen!
		if (!g_game().internalPlaceCreature(npc_ptr.get(), pos, true, false, true)) {
			return false;
		}
	} else {
		if (!g_game().placeCreature(npc_ptr.get(), pos, false, true)) {
			return false;
		}
	}

	Npc* npc = npc_ptr.release();
	npc->setDirection(dir);
	npc->setSpawnNpc(this);
	npc->setMasterPos(pos);
	npc->incrementReferenceCounter();

	spawnedNpcMap.insert(spawned_pair(spawnId, npc));
	spawnNpcMap[spawnId].lastSpawnNpc = OTSYS_TIME();
	g_events().eventNpcOnSpawn(npc, pos);
	return true;
}

void SpawnNpc::startup()
{
	for (const auto& it : spawnNpcMap) {
		uint32_t spawnId = it.first;
		const spawnBlockNpc_t& sb = it.second;
		spawnNpc(spawnId, sb.npcType, sb.pos, sb.direction, true);
	}
}

void SpawnNpc::checkSpawnNpc()
{
	checkSpawnNpcEvent = 0;

	cleanup();

	for (auto& it : spawnNpcMap) {
		uint32_t spawnId = it.first;
		if (spawnedNpcMap.contains(spawnId)) {
			continue;
		}

		spawnBlockNpc_t& sb = it.second;
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
		checkSpawnNpcEvent = g_scheduler().addEvent(createSchedulerTask(getInterval(), std::bind_front(&SpawnNpc::checkSpawnNpc, this)));
	}
}

void SpawnNpc::scheduleSpawnNpc(uint32_t spawnId, spawnBlockNpc_t& sb, uint16_t interval)
{
	if (interval <= 0) {
		spawnNpc(spawnId, sb.npcType, sb.pos, sb.direction);
	} else {
		g_game().addMagicEffect(sb.pos, CONST_ME_TELEPORT);
		g_scheduler().addEvent(createSchedulerTask(1400, std::bind_front(&SpawnNpc::scheduleSpawnNpc, this, spawnId, sb, interval - NONBLOCKABLE_SPAWN_NPC_INTERVAL)));
	}
}

void SpawnNpc::cleanup()
{
	for (auto [id, npc] : spawnedNpcMap) {
		if (npc->isRemoved()) {
			spawnNpcMap[id].lastSpawnNpc = OTSYS_TIME();
			npc->decrementReferenceCounter();
			spawnedNpcMap.clear();
		}
	}
}

bool SpawnNpc::addNpc(const std::string& name, const Position& pos, Direction dir, uint32_t scheduleInterval)
{
	NpcType* npcType = g_npcs().getNpcType(name);
	if (!npcType) {
		SPDLOG_ERROR("Can not find {}", name);
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

void SpawnNpc::removeNpc(Npc* npc)
{
	for (auto it = spawnedNpcMap.begin(), end = spawnedNpcMap.end(); it != end; ++it) {
		if (it->second == npc) {
			npc->decrementReferenceCounter();
			spawnedNpcMap.erase(it);
			break;
		}
	}
}

void SpawnNpc::stopEvent()
{
	if (checkSpawnNpcEvent != 0) {
		g_scheduler().stopEvent(checkSpawnNpcEvent);
		checkSpawnNpcEvent = 0;
	}
}
