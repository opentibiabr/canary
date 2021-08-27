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

#include "declarations.hpp"

#include "creatures/npcs/spawns/spawn_npc_xml.hpp"
#include "creatures/npcs/xml_npc.hpp"
#include "game/game.h"
#include "config/configmanager.h"
#include "game/scheduling/scheduler.h"

#include "utils/pugicast.h"
#include "lua/creature/events.h"

#include <boost/algorithm/string.hpp>

extern ConfigManager g_config;
extern Game g_game;

static constexpr int32_t MINSPAWN_INTERVAL = 1000;

bool SpawnsNpcOld::loadFromXml(const std::string& fromFilename)
{
	if (isLoaded()) {
		return true;
	}

	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file(fromFilename.c_str());
	if (!result) {
		printXMLError("SpawnsNpcOld::loadFromXml", fromFilename, result);
		return false;
	}

	setFileName(fromFilename);
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
			SPDLOG_WARN("[SpawnsNpcOld::loadFromXml] - Empty spawn at position: {} with radius: {}", centerPos.toString(), radius);
			continue;
		}

		for (auto childNode : spawnNode.children()) {
			if (strcasecmp(childNode.name(), "npc") == 0) {
				pugi::xml_attribute nameAttribute = childNode.attribute("name");
				// If tag npc not have tag: name, then not load npc
				if (!nameAttribute) {
					SPDLOG_WARN("[SpawnsNpcOld::loadFromXml] - the npc tag is missing tag 'name' or is wrong");
					continue;
				}

				// If tag npc not have tag: type, then not load npc
				pugi::xml_attribute typeAttribute = childNode.attribute("type");
				if (!typeAttribute) {
					SPDLOG_WARN("[SpawnsNpcOld::loadFromXml] - Npc with name {} is missing tag 'type', is necessary to add a type (xml or lua)", nameAttribute.as_string());
					continue;
				}
				// Not load npc if have the "lua" tag
				std::string luaType = childNode.attribute("type").as_string("lua");
				if (boost::iequals(luaType, "lua")) {
					continue;
				}

				NpcOld* npc = NpcOld::createNpc(nameAttribute.as_string());
				if (!npc) {
					continue;
				}
				pugi::xml_attribute directionAttribute = childNode.attribute("direction");
				if (directionAttribute) {
					npc->setDirection(static_cast<Direction>(pugi::cast<uint16_t>(directionAttribute.value())));
				}

				npc->setMasterPos(Position(
					centerPos.x + pugi::cast<uint16_t>(childNode.attribute("x").value()),
					centerPos.y + pugi::cast<uint16_t>(childNode.attribute("y").value()),
					centerPos.z
				), radius);
				oldNpcList.push_front(npc);
			}
		}
	}
	return true;
}

bool SpawnsNpcOld::loadCustomSpawnXml(const std::string& customFileName)
{
	if (!isLoaded()) {
		SPDLOG_ERROR("[SpawnsNpcOld::loadCustomSpawnXml] - "
                     "Trying to load custom spawn xml before game startup, "
                     "fileName: {}", customFileName);
		return false;
	}

	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file(customFileName.c_str());
	if (!result) {
		printXMLError("Error - SpawnsNpcOld::loadCustomSpawnXml", customFileName, result);
		return false;
	}

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
			SPDLOG_WARN("Empty spawn at position: {} with radius: {}", centerPos.toString(), radius);
			continue;
		}

		for (auto childNode : spawnNode.children()) {
			if (strcasecmp(childNode.name(), "npc") == 0) {
				pugi::xml_attribute nameAttribute = childNode.attribute("name");
				if (!nameAttribute) {
					continue;
				}

				NpcOld* npc = NpcOld::createNpc(nameAttribute.as_string());
				if (!npc) {
					continue;
				}

				pugi::xml_attribute directionAttribute = childNode.attribute("direction");
				if (directionAttribute) {
					npc->setDirection(static_cast<Direction>(pugi::cast<uint16_t>(directionAttribute.value())));
				}

				npc->setMasterPos(Position(
					centerPos.x + pugi::cast<uint16_t>(childNode.attribute("x").value()),
					centerPos.y + pugi::cast<uint16_t>(childNode.attribute("y").value()),
					centerPos.z
					), radius);

				customNpcList.push_front(npc);
			}
		}

		for (NpcOld* npc : customNpcList) {
			g_game.placeCreature(npc, npc->getMasterPos(), false, true);
		}
	}

	return true;
}

void SpawnsNpcOld::startup()
{
	if (!isLoaded() || isStarted()) {
		return;
	}

	for (NpcOld* npcOld : oldNpcList) {
		g_game.placeCreature(npcOld, npcOld->getMasterPos(), false, true);
	}
	oldNpcList.clear();

	started = true;
}

void SpawnsNpcOld::clear()
{
	setLoaded(false);
	setStarted(false);
	filename.clear();
}

bool SpawnsNpcOld::isInZone(const Position& centerPos, int32_t radius, const Position& pos)
{
	if (radius == -1) {
		return true;
	}

	return ((pos.getX() >= centerPos.getX() - radius) && (pos.getX() <= centerPos.getX() + radius) &&
	        (pos.getY() >= centerPos.getY() - radius) && (pos.getY() <= centerPos.getY() + radius));
}
