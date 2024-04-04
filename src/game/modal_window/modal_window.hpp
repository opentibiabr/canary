/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <list>
	#include <string>
	#include <utility>
	#include <cstdint>
#endif

struct ModalWindow {
	std::list<std::pair<std::string, uint8_t>> buttons, choices;
	std::string title, message;
	uint32_t id;
	uint8_t defaultEnterButton, defaultEscapeButton;
	bool priority;

	ModalWindow(uint32_t newId, std::string newTitle, std::string newMessage) :
		title(std::move(newTitle)),
		message(std::move(newMessage)),
		id(newId),
		defaultEnterButton(0xFF),
		defaultEscapeButton(0xFF),
		priority(false) { }
};
