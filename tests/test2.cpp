#include <boost/ut.hpp>
#include "game/movement/position.h"
#include "utils/tools.h"

using namespace boost::ut;

Direction getDirectionTo2(const Position &centerPos, const Position &targetPos) {
	int32_t dx = Position::getOffsetX(centerPos, targetPos);
	int32_t dy = Position::getOffsetY(centerPos, targetPos);

	if (dx < 0 && dy < 0) {
		return DIRECTION_SOUTHEAST;
	}

	if (dx > 0 && dy < 0) {
		return DIRECTION_SOUTHWEST;
	}

	if (dx < 0 && dy > 0) {
		return DIRECTION_NORTHEAST;
	}

	if (dx > 0 && dy > 0) {
		return DIRECTION_NORTHWEST;
	}

	if (dx < 0) {
		return DIRECTION_EAST;
	}

	if (dx > 0) {
		return DIRECTION_WEST;
	}

	if (dy > 0) {
		return DIRECTION_NORTH;
	}

	return DIRECTION_SOUTH;
}

suite<"suite_Name"> errors = [] {
	for (uint16_t i = 0; i <= 15; i++) {
		for (uint16_t j = 0; j <= 15; j++) {
			test(fmt::format("Testing distance uneven diagonal (({}, {}) > ({}, {}))", i, j, 7, 7)) = [i, j] {
				Position pos1{i, j, 0};
				Position pos2{7, 7, 0};

				Direction expected = getDirectionTo2(pos1, pos2);
				Direction result = getDirectionTo(pos1, pos2, false);

				expect(eq(expected, result)) << fmt::format("{} != {}", static_cast<uint8_t>(expected), static_cast<uint8_t>(result));
			};
		}
	}
};
