/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
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
