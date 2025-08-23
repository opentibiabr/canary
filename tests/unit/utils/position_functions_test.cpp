#include "pch.hpp"

#include <boost/ut.hpp>

#include "game/movement/position.hpp"
#include "utils/tools.hpp"

using namespace boost::ut;

suite<"utils"> getDirectionToTest = [] {
	struct GetDirectionToTestCase {
		Position from, to;
		Direction expected, expectedForExactDiagonal;

		[[nodiscard]] std::string toString() const {
			return fmt::format("from {} to {}", from.toString(), to.toString());
		}
	};

	std::vector getDirectionToTestCases {
		GetDirectionToTestCase { Position {}, Position {}, DIRECTION_NONE, DIRECTION_NONE },
		GetDirectionToTestCase { Position { 0, 0, 0 }, Position { 0, 0, 0 }, DIRECTION_NONE, DIRECTION_NONE },
		GetDirectionToTestCase { Position { 100, 100, 100 }, Position { 100, 100, 100 }, DIRECTION_NONE, DIRECTION_NONE },
		GetDirectionToTestCase { Position { 125, 1123, 5 }, Position { 125, 1153, 5 }, DIRECTION_SOUTH, DIRECTION_SOUTH },
		GetDirectionToTestCase { Position { 5555, 3212, 15 }, Position { 5555, 3211, 15 }, DIRECTION_NORTH, DIRECTION_NORTH },
		GetDirectionToTestCase { Position { 32132, 65000, 11 }, Position { 31512, 65000, 11 }, DIRECTION_WEST, DIRECTION_WEST },
		GetDirectionToTestCase { Position { 5123, 6554, 7 }, Position { 40000, 6554, 7 }, DIRECTION_EAST, DIRECTION_EAST },
		GetDirectionToTestCase { Position { 25200, 33173, 8 }, Position { 5200, 13173, 7 }, DIRECTION_NORTHWEST, DIRECTION_NORTHWEST },
		GetDirectionToTestCase { Position { 22137, 6, 9 }, Position { 22141, 2, 15 }, DIRECTION_NORTHEAST, DIRECTION_NORTHEAST },
		GetDirectionToTestCase { Position { 32011, 2197, 1 }, Position { 32135, 2321, 13 }, DIRECTION_SOUTHEAST, DIRECTION_SOUTHEAST },
		GetDirectionToTestCase { Position { 13121, 5213, 5 }, Position { 5213, 13121, 5 }, DIRECTION_SOUTHWEST, DIRECTION_SOUTHWEST },

		GetDirectionToTestCase { Position { 123, 122, 0 }, Position { 0, 0, 0 }, DIRECTION_NORTHWEST, DIRECTION_WEST },
		GetDirectionToTestCase { Position { 122, 123, 0 }, Position { 0, 0, 0 }, DIRECTION_NORTHWEST, DIRECTION_NORTH },
		GetDirectionToTestCase { Position { 0, 122, 0 }, Position { 123, 0, 0 }, DIRECTION_NORTHEAST, DIRECTION_EAST },
		GetDirectionToTestCase { Position { 0, 123, 0 }, Position { 122, 0, 0 }, DIRECTION_NORTHEAST, DIRECTION_NORTH },
		GetDirectionToTestCase { Position { 0, 0, 0 }, Position { 123, 122, 0 }, DIRECTION_SOUTHEAST, DIRECTION_EAST },
		GetDirectionToTestCase { Position { 0, 0, 0 }, Position { 122, 123, 0 }, DIRECTION_SOUTHEAST, DIRECTION_SOUTH },
		GetDirectionToTestCase { Position { 123, 0, 0 }, Position { 0, 122, 0 }, DIRECTION_SOUTHWEST, DIRECTION_WEST },
		GetDirectionToTestCase { Position { 122, 0, 0 }, Position { 0, 123, 0 }, DIRECTION_SOUTHWEST, DIRECTION_SOUTH },
	};

	for (auto getDirectionToTestCase : getDirectionToTestCases) {
		test("getDirectionTo " + getDirectionToTestCase.toString()) = [getDirectionToTestCase] {
			auto [from, to, expected, expectedForExactDiagonal] = getDirectionToTestCase;

			auto result = getDirectionTo(from, to);
			expect(eq(expectedForExactDiagonal, result)) << fmt::format("[exact diagonal] {} != {}", static_cast<uint8_t>(expectedForExactDiagonal), static_cast<uint8_t>(result));

			result = getDirectionTo(from, to, false);
			expect(eq(expected, result)) << fmt::format("[non-exact diagonal] {} != {}", static_cast<uint8_t>(expected), static_cast<uint8_t>(result));
		};
	}
};
