#pragma once

#include "world/world_layers.hpp"

// Owned by Game. Declarations survive Lua reload; runtime items remain map-owned.
class WorldLayerRuntime {
public:
	bool prepare();
	bool apply();
	bool isDeclared(const std::string &id) const;

private:
	std::optional<world_layers::Project> project;
	bool applied = false;
};
