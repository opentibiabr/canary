#include "pch.hpp"

#include <boost/ut.hpp>

#include "utils/batch_update.hpp"
#include "creatures/players/player.hpp"
#include "items/containers/container.hpp"
#include "items/item.hpp"

using namespace boost::ut;

namespace {

	class FakeContainer : public Container {
	public:
		using Container::Container;
		int beginCount { 0 };
		int endCount { 0 };

		void beginBatchUpdate() override {
			++beginCount;
			Container::beginBatchUpdate();
		}

		void endBatchUpdate(Player* actor) override {
			++endCount;
			Container::endBatchUpdate(actor);
		}
	};

} // namespace

suite<"batch_update"> batchUpdateTest = [] {
	test("deduplicates containers and balances begin/end calls") = [] {
		Player player;
		FakeContainer c1(ITEM_REWARD_CONTAINER, 10);
		{
			BatchUpdate batch(&player);
			batch.add(&c1);
			batch.add(&c1);
			expect(eq(c1.beginCount, 1));
		}
		expect(eq(c1.endCount, 1));
	};
};
