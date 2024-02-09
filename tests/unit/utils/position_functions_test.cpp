#include "pch.hpp"

#include <boost/ut.hpp>

#include "utils/tools.hpp"

import game_movement;

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
		GetDirectionToTestCase { Position {}, Position {}, Direction::South, Direction::South },
		GetDirectionToTestCase { Position { 0, 0, 0 }, Position { 0, 0, 0 }, Direction::South, Direction::South },
		GetDirectionToTestCase { Position { 100, 100, 100 }, Position { 100, 100, 100 }, Direction::South, Direction::South },
		GetDirectionToTestCase { Position { 125, 1123, 5 }, Position { 125, 1153, 5 }, Direction::South, Direction::South },
		GetDirectionToTestCase { Position { 5555, 3212, 15 }, Position { 5555, 3211, 15 }, Direction::North, Direction::North },
		GetDirectionToTestCase { Position { 32132, 65000, 11 }, Position { 31512, 65000, 11 }, Direction::West, Direction::West },
		GetDirectionToTestCase { Position { 5123, 6554, 7 }, Position { 40000, 6554, 7 }, Direction::East, Direction::East },
		GetDirectionToTestCase { Position { 25200, 33173, 8 }, Position { 5200, 13173, 7 }, Direction::NorthWest, Direction::NorthWest },
		GetDirectionToTestCase { Position { 22137, 6, 9 }, Position { 22141, 2, 15 }, Direction::NorthEast, Direction::NorthEast },
		GetDirectionToTestCase { Position { 32011, 2197, 1 }, Position { 32135, 2321, 13 }, Direction::SouthEast, Direction::SouthEast },
		GetDirectionToTestCase { Position { 13121, 5213, 5 }, Position { 5213, 13121, 5 }, Direction::SouthWest, Direction::SouthWest },

		GetDirectionToTestCase { Position { 123, 122, 0 }, Position { 0, 0, 0 }, Direction::NorthWest, Direction::West },
		GetDirectionToTestCase { Position { 122, 123, 0 }, Position { 0, 0, 0 }, Direction::NorthWest, Direction::North },
		GetDirectionToTestCase { Position { 0, 122, 0 }, Position { 123, 0, 0 }, Direction::NorthEast, Direction::East },
		GetDirectionToTestCase { Position { 0, 123, 0 }, Position { 122, 0, 0 }, Direction::NorthEast, Direction::North },
		GetDirectionToTestCase { Position { 0, 0, 0 }, Position { 123, 122, 0 }, Direction::SouthEast, Direction::East },
		GetDirectionToTestCase { Position { 0, 0, 0 }, Position { 122, 123, 0 }, Direction::SouthEast, Direction::South },
		GetDirectionToTestCase { Position { 123, 0, 0 }, Position { 0, 122, 0 }, Direction::SouthWest, Direction::West },
		GetDirectionToTestCase { Position { 122, 0, 0 }, Position { 0, 123, 0 }, Direction::SouthWest, Direction::South },
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
