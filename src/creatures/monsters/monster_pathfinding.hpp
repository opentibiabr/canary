/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/creatures_definitions.hpp"
#include "map/navigation_snapshot.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <memory>
	#include <stop_token>
	#include <vector>
#endif

struct MonsterPathTraits {
	std::array<bool, COMBAT_COUNT> fieldAllowed {};
	std::array<bool, COMBAT_COUNT> fieldPenalty {};
	std::vector<uint32_t> summonInvitedHouseIds;
	bool canPushItems = false;
	bool canPushCreatures = false;
	bool isSummon = false;
	bool canEnterProtectionZone = false;
	bool canSeeInvisibility = false;
	bool moveLocked = false;
};

struct MonsterPathRequest {
	std::shared_ptr<const NavRegionSnapshot> navigation;
	Position start;
	Position target;
	FindPathParams params;
	MonsterPathTraits traits;
};

enum class MonsterPathStatus : uint8_t {
	Found,
	NotFound,
	Cancelled
};

struct MonsterPathResult {
	MonsterPathStatus status = MonsterPathStatus::NotFound;
	Position endpoint;
	std::vector<Direction> directions;

	[[nodiscard]] bool found() const {
		return status == MonsterPathStatus::Found;
	}
};

class MonsterPathfinder final {
public:
	[[nodiscard]] static MonsterPathResult find(const MonsterPathRequest &request, std::stop_token stopToken = {});
	[[nodiscard]] static bool canEnter(const NavCell &cell, const MonsterPathTraits &traits);
	[[nodiscard]] static bool isSightClear(const NavRegionSnapshot &navigation, const Position &from, const Position &to);

private:
	[[nodiscard]] static bool isInRange(const MonsterPathRequest &request, const Position &testPosition);
	[[nodiscard]] static bool matchesTarget(const MonsterPathRequest &request, const Position &testPosition, int32_t &bestMatchDistance);
	[[nodiscard]] static int_fast32_t getTileWalkCost(const NavCell &cell, const MonsterPathTraits &traits);
};
