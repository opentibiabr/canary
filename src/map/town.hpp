/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/movement/position.hpp"
#include "utils/tools.hpp"

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

using TownMap = std::map<uint32_t, std::shared_ptr<Town>>;

class Towns {
public:
	Towns() = default;
	~Towns() = default;

	// non-copyable
	Towns(const Towns &) = delete;
	Towns &operator=(const Towns &) = delete;

	bool addTown(uint32_t townId, const std::shared_ptr<Town> &town) {
		return townMap.emplace(townId, town).second;
	}

	std::shared_ptr<Town> getTown(const std::string &townName) const {
		for (const auto &[townId, town] : townMap) {
			if (townId == 0) {
				continue;
			}

			if (caseInsensitiveCompare(townName, town->getName())) {
				return town;
			}
		}
		return nullptr;
	}

	std::shared_ptr<Town> getTown(uint32_t townId) const {
		const auto it = townMap.find(townId);
		if (it == townMap.end()) {
			return nullptr;
		}
		return it->second;
	}

	std::shared_ptr<Town> getOrCreateTown(uint32_t townId) {
		auto town = getTown(townId);
		if (!town) {
			addTown(townId, town = std::make_shared<Town>(townId));
		}
		return town;
	}

	const TownMap &getTowns() const {
		return townMap;
	}

private:
	TownMap townMap;
};
