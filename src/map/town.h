/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#ifndef SRC_MAP_TOWN_H_
#define SRC_MAP_TOWN_H_

#include "game/movement/position.h"

class Town {
	public:
		explicit Town(uint32_t initId) :
			id(initId) { }

		const Position &getTemplePosition() const {
			return templePosition;
		}
		const std::string &getName() const {
			return name;
		}

		void setTemplePos(Position pos) {
			templePosition = pos;
		}
		void setName(std::string newName) {
			this->name = std::move(newName);
		}
		uint32_t getID() const {
			return id;
		}

	private:
		uint32_t id;
		std::string name;
		Position templePosition;
};

using TownMap = std::map<uint32_t, Town>;

class Towns {
	public:
		Towns() = default;

		// non-copyable
		Towns(const Towns &) = delete;
		Towns &operator=(const Towns &) = delete;

		Town* addTown(uint32_t townId) {
			return &townMap.try_emplace(townId, townId).first->second;
		}

		Town* getTown(const std::string &townName) {
			for (auto &it : townMap) {
				if (strcasecmp(townName.c_str(), it.second.getName().c_str()) == 0) {
					return &it.second;
				}
			}
			return nullptr;
		}

		Town* getTown(uint32_t townId) {
			auto it = townMap.find(townId);
			if (it == townMap.end()) {
				return nullptr;
			}
			return &it->second;
		}

		TownMap &getTowns() {
			return townMap;
		}

	private:
		TownMap townMap;
};

#endif // SRC_MAP_TOWN_H_
