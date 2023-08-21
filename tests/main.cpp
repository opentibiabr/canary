#include <boost/ut.hpp>

using namespace boost::ut;

int main() {
	"Template"_test = [] {
		expect(true) << "I'm a test and I work.";
	};
}
