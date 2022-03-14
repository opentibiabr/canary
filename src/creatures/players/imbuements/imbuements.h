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

#ifndef SRC_CREATURES_PLAYERS_IMBUEMENTS_IMBUEMENTS_H_
#define SRC_CREATURES_PLAYERS_IMBUEMENTS_IMBUEMENTS_H_

#include "declarations.hpp"
#include "creatures/players/imbuements/imbuement.h"
#include "creatures/players/player.h"
#include "utils/tools.h"

class Player;
class Item;

class Imbuement;

struct BaseImbuement {
	BaseImbuement(uint16_t initId, std::string initName, uint32_t initProtectionPrice, uint32_t initPrice, uint32_t initRemoveCost, int32_t initDuration, uint8_t initPercent) :
		id(initId), name(std::move(initName)), protectionPrice(initProtectionPrice), price(initPrice), removeCost(initRemoveCost), duration(initDuration), percent(initPercent) {}

	uint16_t id;
	std::string name;
	uint32_t protectionPrice;
	uint32_t price;
	uint32_t removeCost;
	int32_t duration;
	uint8_t percent;
};

struct CategoryImbuement {
	CategoryImbuement(uint16_t initId, std::string initName, bool initAgressive) :
		id(initId), name(std::move(initName)), agressive(initAgressive) {}

	uint16_t id;
	std::string name;
	bool agressive;
};

class Imbuements {
	public:
		bool loadFromXml(bool reloading = false);
		bool reload();

		Imbuement* getImbuement(uint16_t id);

		BaseImbuement* getBaseByID(uint16_t id);
		CategoryImbuement* getCategoryByID(uint16_t id);
		std::vector<Imbuement*> getImbuements(const Player* player, Item* item);

	protected:
		friend class Imbuement;
		bool loaded = false;

	private:
		std::map<uint32_t, Imbuement> imbuementMap;

		std::vector<BaseImbuement> basesImbuement;
		std::vector<CategoryImbuement> categoriesImbuement;

		uint32_t runningid = 0;
};

#endif  // SRC_CREATURES_PLAYERS_IMBUEMENTS_IMBUEMENTS_H_
