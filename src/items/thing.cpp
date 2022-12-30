/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "items/thing.h"
#include "items/tile.h"

const Position& Thing::getPosition() const
{
	const Tile* tile = getTile();
	if (!tile) {
		return Tile::nullptr_tile.getPosition();
	}
	return tile->getPosition();
}

Tile* Thing::getTile()
{
	return dynamic_cast<Tile*>(this);
}

const Tile* Thing::getTile() const
{
	return dynamic_cast<const Tile*>(this);
}
