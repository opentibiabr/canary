/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

struct HighscoreCategory {
	HighscoreCategory(std::string name, uint8_t id) :
		m_name(std::move(name)),
		m_id(id) { }

	std::string m_name;
	uint8_t m_id;
};
