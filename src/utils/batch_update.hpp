/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef PRECOMPILED_HEADERS
	#include <memory>
	#include <vector>
#endif

#include "lua/global/shared_object.hpp"

class Player;
class Container;

class BatchUpdate : public SharedObject {
public:
	explicit BatchUpdate(const std::shared_ptr<Player> &actor);
	BatchUpdate(const BatchUpdate &) = delete;
	BatchUpdate &operator=(const BatchUpdate &) = delete;
	BatchUpdate(BatchUpdate &&) = delete;
	BatchUpdate &operator=(BatchUpdate &&) = delete;
	bool add(const std::shared_ptr<Container> &container);
	void addContainers(const std::vector<std::shared_ptr<Container>> &containerVector);

private:
	struct State {
		explicit State(const std::shared_ptr<Player> &actor);
		~State();
		State(const State &) = delete;
		State &operator=(const State &) = delete;
		State(State &&) = delete;
		State &operator=(State &&) = delete;

		std::weak_ptr<Player> actor;
		std::vector<std::weak_ptr<Container>> cached;
	};

	State m_state;
};
