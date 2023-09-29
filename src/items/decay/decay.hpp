/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/item.hpp"

class Decay {
public:
	Decay() = default;

	Decay(const Decay &) = delete;
	void operator=(const Decay &) = delete;

	static Decay &getInstance() {
		return inject<Decay>();
	}

	void startDecay(std::shared_ptr<Item> item);
	void stopDecay(std::shared_ptr<Item> item);

private:
	void checkDecay();
	void internalDecayItem(std::shared_ptr<Item> item);

	uint32_t eventId { 0 };
	// order is important, so we use an std::map
	std::map<int64_t, std::vector<std::shared_ptr<Item>>> decayMap;
};

constexpr auto g_decay = Decay::getInstance;
