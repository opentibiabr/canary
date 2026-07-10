/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monster_pathfinding.hpp"

#include "map/utils/astarnodes.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <cstdlib>
#endif

namespace {
	constexpr int_fast32_t NORMAL_WALK_COST = 10;
	constexpr int_fast32_t CREATURE_TILE_COST = NORMAL_WALK_COST * 4;
	constexpr int_fast32_t HARMFUL_FIELD_COST = NORMAL_WALK_COST * 18;

	constexpr int_fast32_t ALL_NEIGHBORS[8][2] = {
		{ -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 }, { 1, 1 }, { -1, 1 }
	};

	constexpr int_fast32_t DIRECTION_NEIGHBORS[8][5][2] = {
		{ { -1, 0 }, { 0, 1 }, { 1, 0 }, { 1, 1 }, { -1, 1 } },
		{ { -1, 0 }, { 0, 1 }, { 0, -1 }, { -1, -1 }, { -1, 1 } },
		{ { -1, 0 }, { 1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 } },
		{ { 0, 1 }, { 1, 0 }, { 0, -1 }, { 1, -1 }, { 1, 1 } },
		{ { 1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 }, { 1, 1 } },
		{ { -1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 }, { -1, 1 } },
		{ { 0, 1 }, { 1, 0 }, { 1, -1 }, { 1, 1 }, { -1, 1 } },
		{ { -1, 0 }, { 0, 1 }, { -1, -1 }, { 1, 1 }, { -1, 1 } }
	};

	[[nodiscard]] bool isProjectileBlocked(const NavRegionSnapshot &navigation, const Position &position) {
		const auto* cell = navigation.getCell(position);
		return !cell || cell->hasFlag(NavCellFlag::BlockProjectile);
	}

	void appendDirection(std::vector<Direction> &directions, int_fast32_t dx, int_fast32_t dy) {
		if (dx == 1) {
			if (dy == 1) {
				directions.emplace_back(DIRECTION_NORTHWEST);
			} else if (dy == -1) {
				directions.emplace_back(DIRECTION_SOUTHWEST);
			} else {
				directions.emplace_back(DIRECTION_WEST);
			}
		} else if (dx == -1) {
			if (dy == 1) {
				directions.emplace_back(DIRECTION_NORTHEAST);
			} else if (dy == -1) {
				directions.emplace_back(DIRECTION_SOUTHEAST);
			} else {
				directions.emplace_back(DIRECTION_EAST);
			}
		} else if (dy == 1) {
			directions.emplace_back(DIRECTION_NORTH);
		} else if (dy == -1) {
			directions.emplace_back(DIRECTION_SOUTH);
		}
	}
}

bool MonsterPathfinder::canEnter(const NavCell &cell, const MonsterPathTraits &traits) {
	if (traits.isSummon && cell.houseId != 0) {
		const bool invited = std::ranges::binary_search(traits.summonInvitedHouseIds, cell.houseId);
		const bool noFieldPathBlocked = cell.hasFlag(NavCellFlag::FloorChangeWest) && cell.hasFlag(NavCellFlag::NoFieldBlockPath);
		return invited && !cell.hasFlag(NavCellFlag::BlockSolid) && !noFieldPathBlocked;
	}
	if (traits.moveLocked || !cell.hasFlag(NavCellFlag::HasGround) || cell.hasFlag(NavCellFlag::FloorChange) || cell.hasFlag(NavCellFlag::Teleport)) {
		return false;
	}
	if (cell.hasFlag(NavCellFlag::ProtectionZone) && !traits.canEnterProtectionZone) {
		return false;
	}
	if (traits.isSummon && cell.hasFlag(NavCellFlag::WalkableSea)) {
		return false;
	}

	if (traits.canPushCreatures && !traits.isSummon) {
		if (cell.hasUnpushableCreature) {
			return false;
		}
	} else if (cell.blockingCreatures != 0) {
		return false;
	}

	if (cell.hasFlag(NavCellFlag::ImmovableBlockSolid) || cell.hasFlag(NavCellFlag::ImmovableNoFieldBlockPath)) {
		return false;
	}
	if ((cell.hasFlag(NavCellFlag::BlockSolid) || cell.hasFlag(NavCellFlag::NoFieldBlockPath)) && !traits.canPushItems) {
		return false;
	}

	if (cell.hasFlag(NavCellFlag::HarmfulField)) {
		const auto combatType = static_cast<size_t>(cell.harmfulFieldCombatType);
		if (combatType >= traits.fieldAllowed.size() || !traits.fieldAllowed[combatType]) {
			return false;
		}
	}
	return true;
}

int_fast32_t MonsterPathfinder::getTileWalkCost(const NavCell &cell, const MonsterPathTraits &traits) {
	const bool hasVisibleCreature = traits.canSeeInvisibility ? cell.blockingCreatures != 0 : cell.hasNonInvisibleCreature;
	int_fast32_t cost = hasVisibleCreature ? CREATURE_TILE_COST : 0;
	if (cell.hasFlag(NavCellFlag::HarmfulField)) {
		const auto combatType = static_cast<size_t>(cell.harmfulFieldCombatType);
		if (combatType < traits.fieldPenalty.size() && traits.fieldPenalty[combatType]) {
			cost += HARMFUL_FIELD_COST;
		}
	}
	return cost;
}

bool MonsterPathfinder::isInRange(const MonsterPathRequest &request, const Position &testPosition) {
	const auto &params = request.params;
	if (params.fullPathSearch) {
		if (testPosition.x > request.target.x + params.maxTargetDist || testPosition.x < request.target.x - params.maxTargetDist || testPosition.y > request.target.y + params.maxTargetDist || testPosition.y < request.target.y - params.maxTargetDist) {
			return false;
		}
	} else {
		const int_fast32_t dx = Position::getOffsetX(request.start, request.target);
		const int32_t dxMax = dx >= 0 ? params.maxTargetDist : 0;
		const int32_t dxMin = dx <= 0 ? params.maxTargetDist : 0;
		if (testPosition.x > request.target.x + dxMax || testPosition.x < request.target.x - dxMin) {
			return false;
		}

		const int_fast32_t dy = Position::getOffsetY(request.start, request.target);
		const int32_t dyMax = dy >= 0 ? params.maxTargetDist : 0;
		const int32_t dyMin = dy <= 0 ? params.maxTargetDist : 0;
		if (testPosition.y > request.target.y + dyMax || testPosition.y < request.target.y - dyMin) {
			return false;
		}
	}
	return true;
}

bool MonsterPathfinder::matchesTarget(const MonsterPathRequest &request, const Position &testPosition, int32_t &bestMatchDistance) {
	if (!isInRange(request, testPosition)) {
		return false;
	}
	if (request.params.clearSight && !isSightClear(*request.navigation, testPosition, request.target)) {
		return false;
	}

	const int32_t testDistance = std::max(Position::getDistanceX(request.target, testPosition), Position::getDistanceY(request.target, testPosition));
	if (request.params.maxTargetDist == 1) {
		return testDistance >= request.params.minTargetDist && testDistance <= request.params.maxTargetDist;
	}
	if (testDistance > request.params.maxTargetDist || testDistance < request.params.minTargetDist) {
		return false;
	}
	if (testDistance == request.params.maxTargetDist) {
		bestMatchDistance = 0;
		return true;
	}
	if (testDistance > bestMatchDistance) {
		bestMatchDistance = testDistance;
		return true;
	}
	return false;
}

bool MonsterPathfinder::isSightClear(const NavRegionSnapshot &navigation, const Position &from, const Position &to) {
	if (from.z != to.z) {
		return false;
	}
	if (Position::areInRange<1, 1>(from, to)) {
		return true;
	}

	Position start = from;
	Position destination = to;
	int32_t distanceX = Position::getDistanceX(start, destination);
	int32_t distanceY = Position::getDistanceY(start, destination);
	if (start.y == destination.y) {
		const uint16_t delta = start.x < destination.x ? 0x0001 : 0xFFFF;
		while (--distanceX > 0) {
			start.x += delta;
			if (isProjectileBlocked(navigation, start)) {
				return false;
			}
		}
	} else if (start.x == destination.x) {
		const uint16_t delta = start.y < destination.y ? 0x0001 : 0xFFFF;
		while (--distanceY > 0) {
			start.y += delta;
			if (isProjectileBlocked(navigation, start)) {
				return false;
			}
		}
	} else {
		uint16_t errorAdjustment;
		uint16_t errorAccumulator = 0;
		uint16_t deltaX = 0x0001;
		uint16_t deltaY = 0x0001;

		if (distanceY > distanceX) {
			errorAdjustment = (static_cast<uint32_t>(distanceX) << 16) / static_cast<uint32_t>(distanceY);
			if (start.y > destination.y) {
				std::swap(start.x, destination.x);
				std::swap(start.y, destination.y);
			}
			if (start.x > destination.x) {
				deltaX = 0xFFFF;
				errorAccumulator -= errorAdjustment;
			}

			while (--distanceY > 0) {
				uint16_t xIncrease = 0;
				const uint16_t previousError = errorAccumulator;
				errorAccumulator += errorAdjustment;
				if (errorAccumulator <= previousError) {
					xIncrease = deltaX;
				}
				Position testPosition(start.x + xIncrease, start.y + deltaY, start.z);
				if (isProjectileBlocked(navigation, testPosition)) {
					return Position::areInRange<1, 1>(start, destination);
				}
				start.x += xIncrease;
				start.y += deltaY;
			}
		} else {
			errorAdjustment = (static_cast<uint32_t>(distanceY) << 16) / static_cast<uint32_t>(distanceX);
			if (start.x > destination.x) {
				std::swap(start.x, destination.x);
				std::swap(start.y, destination.y);
			}
			if (start.y > destination.y) {
				deltaY = 0xFFFF;
				errorAccumulator -= errorAdjustment;
			}

			while (--distanceX > 0) {
				uint16_t yIncrease = 0;
				const uint16_t previousError = errorAccumulator;
				errorAccumulator += errorAdjustment;
				if (errorAccumulator <= previousError) {
					yIncrease = deltaY;
				}
				Position testPosition(start.x + deltaX, start.y + yIncrease, start.z);
				if (isProjectileBlocked(navigation, testPosition)) {
					return Position::areInRange<1, 1>(start, destination);
				}
				start.x += deltaX;
				start.y += yIncrease;
			}
		}
	}
	return true;
}

MonsterPathResult MonsterPathfinder::find(const MonsterPathRequest &request, std::stop_token stopToken) {
	MonsterPathResult result;
	result.endpoint = request.start;
	if (!request.navigation || request.start.z != request.target.z || request.params.maxSearchDist <= 0 || request.params.maxSearchDist > request.navigation->getRadius()) {
		return result;
	}
	if (stopToken.stop_requested()) {
		result.status = MonsterPathStatus::Cancelled;
		return result;
	}

	const auto* startCell = request.navigation->getCell(request.start);
	if (!startCell) {
		return result;
	}

	Position position = request.start;
	Position endpoint;
	AStarNodes nodes(position.x, position.y, getTileWalkCost(*startCell, request.traits));
	int32_t bestMatch = 0;
	const int_fast32_t startDistanceX = std::abs(request.target.getX() - position.getX());
	const int_fast32_t startDistanceY = std::abs(request.target.getY() - position.getY());
	uint_fast16_t directionCount = 0;
	const AStarNode* found = nullptr;

	do {
		if (stopToken.stop_requested()) {
			result.status = MonsterPathStatus::Cancelled;
			return result;
		}

		AStarNode* node = nodes.getBestNode();
		if (!node) {
			if (found) {
				break;
			}
			return result;
		}

		const int_fast32_t x = node->x;
		const int_fast32_t y = node->y;
		position.x = static_cast<uint16_t>(x);
		position.y = static_cast<uint16_t>(y);
		if (matchesTarget(request, position, bestMatch)) {
			found = node;
			endpoint = position;
			if (bestMatch == 0) {
				break;
			}
		}

		++directionCount;
		uint_fast32_t neighborCount;
		const int_fast32_t* neighbors;
		if (node->parent) {
			const int_fast32_t offsetX = node->parent->x - x;
			const int_fast32_t offsetY = node->parent->y - y;
			Direction incomingDirection;
			if (offsetY == 0) {
				incomingDirection = offsetX == -1 ? DIRECTION_WEST : DIRECTION_EAST;
			} else if (offsetX == 0) {
				incomingDirection = offsetY == -1 ? DIRECTION_NORTH : DIRECTION_SOUTH;
			} else if (offsetY == -1) {
				incomingDirection = offsetX == -1 ? DIRECTION_NORTHWEST : DIRECTION_NORTHEAST;
			} else {
				incomingDirection = offsetX == -1 ? DIRECTION_SOUTHWEST : DIRECTION_SOUTHEAST;
			}
			neighbors = *DIRECTION_NEIGHBORS[incomingDirection];
			neighborCount = 5;
		} else {
			neighbors = *ALL_NEIGHBORS;
			neighborCount = 8;
		}

		const int_fast32_t currentCost = node->f;
		for (uint_fast32_t index = 0; index < neighborCount; ++index) {
			position.x = static_cast<uint16_t>(x + *neighbors++);
			position.y = static_cast<uint16_t>(y + *neighbors++);
			if (Position::getDistanceX(request.start, position) > request.params.maxSearchDist || Position::getDistanceY(request.start, position) > request.params.maxSearchDist) {
				continue;
			}
			if (request.params.keepDistance && !isInRange(request, position)) {
				continue;
			}

			int_fast32_t extraCost;
			AStarNode* neighborNode = nodes.getNodeByPosition(position.x, position.y);
			if (neighborNode) {
				extraCost = neighborNode->c;
			} else {
				const auto* cell = request.navigation->getCell(position);
				if (!cell || (position != request.start && !canEnter(*cell, request.traits))) {
					continue;
				}
				extraCost = getTileWalkCost(*cell, request.traits);
			}

			const int_fast32_t newCost = currentCost + AStarNodes::getMapWalkCost(node, position) + extraCost;
			if (neighborNode) {
				if (neighborNode->f <= newCost) {
					continue;
				}
				neighborNode->f = newCost;
				neighborNode->parent = node;
				nodes.openNode(neighborNode);
			} else {
				const int_fast32_t distanceX = std::abs(request.target.getX() - position.getX());
				const int_fast32_t distanceY = std::abs(request.target.getY() - position.getY());
				const auto heuristic = ((distanceX - startDistanceX) * 8) + ((distanceY - startDistanceY) * 8) + (std::max(distanceX, distanceY) * 8);
				if (!nodes.createOpenNode(node, position.x, position.y, newCost, heuristic, extraCost)) {
					if (found) {
						break;
					}
					return result;
				}
			}
		}
		nodes.closeNode(node);
	} while (true);

	if (!found) {
		return result;
	}

	result.endpoint = endpoint;
	result.directions.reserve(directionCount);
	int_fast32_t previousX = endpoint.x;
	int_fast32_t previousY = endpoint.y;
	found = found->parent;
	while (found) {
		const int_fast32_t dx = found->x - previousX;
		const int_fast32_t dy = found->y - previousY;
		previousX = found->x;
		previousY = found->y;
		appendDirection(result.directions, dx, dy);
		found = found->parent;
	}
	result.status = MonsterPathStatus::Found;
	return result;
}
