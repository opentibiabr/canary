/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "items/thing.hpp"

#include "items/tile.hpp"

const Position &Thing::getPosition() {
	const auto &tile = getTile();
	if (!tile) {
		return Tile::nullptr_tile->getPosition();
	}
	return tile->getPosition();
}
