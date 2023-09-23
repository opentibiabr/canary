#include "pch.hpp"

#include <boost/ut.hpp>

#include "utils/tools.hpp"

using namespace boost::ut;

suite<"utils"> replaceStringTest = [] {
	struct ReplaceStringTestCase {
		std::string subject, search, replace, expected;

		[[nodiscard]] std::string toString() const {
			return fmt::format("replace {} in {} by {}", search, subject, replace);
		}
	};

	std::vector replaceStringTestCases {
		ReplaceStringTestCase { "", "", "", "" },
		ReplaceStringTestCase { "all together", " ", "_", "all_together" },
		ReplaceStringTestCase { "beautiful", "u", "", "beatifl" },
		ReplaceStringTestCase { "empty_empty_empty_", "empty_", "", "" },
		ReplaceStringTestCase { "I am someone", "someone", "Lucas", "I am Lucas" },
		ReplaceStringTestCase { "[[123[[[[[[124[[asf[[ccc[[[", "[[", "\\[[", "\\[[123\\[[\\[[\\[[124\\[[asf\\[[ccc\\[[[" },
	};

	for (const auto &replaceStringTestCase : replaceStringTestCases) {
		test(replaceStringTestCase.toString()) = [&replaceStringTestCase] {
			auto [subject, search, replace, expected] = replaceStringTestCase;
			replaceString(subject, search, replace);
			expect(eq(expected, subject)) << fmt::format("{} != {}", expected, subject);
		};
	}
};
