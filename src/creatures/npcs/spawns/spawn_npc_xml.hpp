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

#ifndef SRC_CREATURES_NPCS_SPAWNS_SPAWN_NPC_XML_HPP_
#define SRC_CREATURES_NPCS_SPAWNS_SPAWN_NPC_XML_HPP_

#include "declarations.hpp"

#include "items/tile.h"
#include "game/movement/position.h"

class NpcOld;

class SpawnsNpcOld
{
	public:
		static bool isInZone(const Position& centerPos, int32_t radius, const Position& pos);

		// This Load file "data/world/mapname-npc-old.xml"
		bool loadFromXml(const std::string& filename);
		// Get old npc spawn file name
		std::string getFileName() {
			return filename;
		}
		// Set old npc spawn file name
		std::string setFileName(std::string setFileName) {
			return filename = setFileName;
		}
		void startup();
		void clear();

		// Check if is started if (isStarted()) or if (!isStarted())
		bool isStarted() const {
			return started;
		}
		// Set to started: setStarted(true or false)
		bool setStarted(bool setStarted) {
			return started = setStarted;
		}
		// Check if is loaded: if (isLoaded()) or if (!isLoaded())
		bool isLoaded() const {
			return loaded;
		}
		// Set to loaded: setLoaded(true or false)
		bool setLoaded(bool setLoaded) {
			return loaded = setLoaded;
		}

		bool loadCustomSpawnXml(const std::string& customFileName);

	private:
		Position centerPos;
		int32_t radius;

		// List of the npcs for the map load
		std::forward_list<NpcOld*> oldNpcList;
		std::forward_list<NpcOld*> customNpcList;
		std::string filename;
		bool loaded = false;
		bool started = false;
};

static constexpr int32_t NONBLOCKABLE_SPAWN_INTERVAL = 1400;

#endif // SRC_CREATURES_NPCS_SPAWNS_SPAWN_NPC_XML_HPP_
