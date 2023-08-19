#include <boost/ut.hpp>

using namespace boost::ut;

suite<"suite_Name"> errors = [] {
	"exception"_test = [] {
		expect(throws([] { throw 0; })) << "throws any exception";
	};
};
