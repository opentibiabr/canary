#include <boost/ut.hpp>
#include "pch.hpp"
#include "lib/thread/thread_pool.hpp"

using namespace boost::ut;

constexpr auto sum(auto... values) { return (values + ...); }

suite aaa = [] {
	"exception"_test = [] {
		LogWithSpdLog logger{};
		logger.info("I'm a test and I work");

		expect(throws([] { throw 0; })) << "throws any exception";
	};
};
