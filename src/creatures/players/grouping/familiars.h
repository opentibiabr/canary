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

#ifndef SRC_CREATURES_PLAYERS_GROUPING_FAMILIARS_H_
#define SRC_CREATURES_PLAYERS_GROUPING_FAMILIARS_H_

#include "declarations.hpp"

class Familiars {
	public:
		static Familiars& getInstance() {
			static Familiars instance;
			return instance;
		}
		bool loadFromXml();
		const std::vector<Familiar>& getFamiliars(uint16_t vocation) const {
			return familiars[vocation];
		}
		const Familiar* getFamiliarByLookType(uint16_t vocation, uint16_t lookType) const;
	private:
		std::vector<Familiar> familiars[VOCATION_LAST + 1];
};

#endif  // SRC_CREATURES_PLAYERS_GROUPING_FAMILIARS_H_
