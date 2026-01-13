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
	bool add(const std::shared_ptr<Container> &container);
	void addContainers(const std::vector<std::shared_ptr<Container>> &containerVector);
	~BatchUpdate();

private:
	std::weak_ptr<Player> m_actor;
	std::vector<std::weak_ptr<Container>> m_cached;
};
