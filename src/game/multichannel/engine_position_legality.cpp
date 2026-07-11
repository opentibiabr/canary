/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/engine_position_legality.hpp"

#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "game/zones/zone.hpp"
#include "items/tile.hpp"
#include "map/house/house.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <cctype>
#endif

namespace {
	bool startsWithCaseInsensitive(const std::string &value, const char* prefix) {
		const std::string_view prefixView(prefix);
		if (value.size() < prefixView.size()) {
			return false;
		}
		return std::ranges::equal(value.substr(0, prefixView.size()), prefixView, [](char a, char b) {
			return std::tolower(static_cast<unsigned char>(a)) == std::tolower(static_cast<unsigned char>(b));
		});
	}

	bool hasZoneWithPrefix(const Position &position, const char* prefix) {
		for (const auto &zone : Zone::getZones(position)) {
			if (zone && startsWithCaseInsensitive(zone->getName(), prefix)) {
				return true;
			}
		}
		return false;
	}
} // namespace

EnginePositionLegality::EnginePositionLegality(std::shared_ptr<Player> arrivingPlayer) :
	player(std::move(arrivingPlayer)) { }

bool EnginePositionLegality::tileExists(const Position &position) const {
	const auto &tile = g_game().map.getTile(position);
	if (!tile || !player) {
		return false;
	}
	// Same check the normal movement/teleport path uses to decide whether a
	// creature may actually be placed on a tile (docs/multichannel/
	// ARCHITECTURE.md §6) - reused rather than reimplemented so this can
	// never silently disagree with the engine's own definition of
	// "walkable" (blocking items/creatures, floor changes, etc.).
	return tile->queryAdd(0, player, 1, 0) == RETURNVALUE_NOERROR;
}

bool EnginePositionLegality::isInaccessibleHouse(const Position &position) const {
	const auto &tile = g_game().map.getTile(position);
	if (!tile || !player) {
		return false;
	}
	const auto &house = tile->getHouse();
	if (!house) {
		return false;
	}
	return !house->isInvited(player);
}

bool EnginePositionLegality::isRestrictedInstance(const Position &position) const {
	return hasZoneWithPrefix(position, RestrictedInstanceZonePrefix);
}

bool EnginePositionLegality::isNoChannelSwitchZone(const Position &position) const {
	return hasZoneWithPrefix(position, NoChannelSwitchZonePrefix);
}

bool EnginePositionLegality::requiresSpecialEntryCondition(const Position &position) const {
	return hasZoneWithPrefix(position, SpecialEntryZonePrefix);
}
