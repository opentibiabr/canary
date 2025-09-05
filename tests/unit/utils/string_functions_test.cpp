#include "pch.hpp"

#include <boost/ut.hpp>

#include "utils/tools.hpp"

using namespace boost::ut;

suite<"utils"> replaceStringTest = [] {
	struct ReplaceStringTestCase {
		std::string subject, search, replace, expected;

		[[nodiscard]] std::string toString() const {
			return fmt::format("replace '{}' in '{}' by '{}'", search, subject, replace);
		}
	};

	static const std::vector<ReplaceStringTestCase> replaceStringTestCases {
		{ "", "", "", "" },
		{ "all together", " ", "_", "all_together" },
		{ "beautiful", "u", "", "beatifl" },
		{ "empty_empty_empty_", "empty_", "", "" },
		{ "I am someone", "someone", "Lucas", "I am Lucas" },
		{ "[[123[[[[[[124[[asf[[ccc[[[", "[[", "\\[[", "\\[[123\\[[\\[[\\[[124\\[[asf\\[[ccc\\[[[" },
	};

	for (const auto &replaceStringTestCase : replaceStringTestCases) {
		test("replaceString") = [replaceStringTestCase] {
			auto [subject, search, replace, expected] = replaceStringTestCase;
			replaceString(subject, search, replace);
			expect(eq(expected, subject)) << fmt::format("FAILED: {}", replaceStringTestCase.toString());
		};
	}
};
