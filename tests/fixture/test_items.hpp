#pragma once

#include "items/item.hpp"

namespace {
	inline void seedFallbackTestItems() {
		auto &items = Item::items.getItems();
		constexpr uint16_t kFallbackRewardContainer = 1987;
		constexpr uint16_t kMaxId = ITEM_REWARD_CHEST > kFallbackRewardContainer ? ITEM_REWARD_CHEST : kFallbackRewardContainer;
		if (items.size() <= kMaxId) {
			items.resize(static_cast<size_t>(kMaxId) + 1);
		}

		for (uint32_t id = 0; id < items.size(); ++id) {
			auto &entry = items[id];
			entry.id = static_cast<uint16_t>(id);
		}

		const auto ensureContainer = [&items](uint16_t id) {
			auto &entry = items[id];
			entry.id = id;
			if (entry.group == ITEM_GROUP_NONE) {
				entry.group = ITEM_GROUP_CONTAINER;
			}
			if (entry.type == ITEM_TYPE_NONE) {
				entry.type = ITEM_TYPE_CONTAINER;
			}
			if (entry.maxItems == 0) {
				entry.maxItems = 10;
			}
		};

		const auto ensureItem = [&items](uint16_t id) {
			auto &entry = items[id];
			entry.id = id;
			if (entry.type == ITEM_TYPE_NONE) {
				entry.type = ITEM_TYPE_OTHER;
			}
		};

		ensureContainer(ITEM_REWARD_CONTAINER);
		ensureContainer(ITEM_REWARD_CHEST);
		ensureContainer(kFallbackRewardContainer);

		for (const uint16_t id : { static_cast<uint16_t>(100), static_cast<uint16_t>(101), static_cast<uint16_t>(102), static_cast<uint16_t>(103), static_cast<uint16_t>(104), static_cast<uint16_t>(105) }) {
			ensureItem(id);
		}
	}

	inline void ensureTestItemTypes() {
		auto &items = Item::items.getItems();
		if (items.empty()) {
			seedFallbackTestItems();
		}

		if (items.size() <= ITEM_REWARD_CHEST) {
			items.resize(static_cast<size_t>(ITEM_REWARD_CHEST) + 1);
		}

		for (uint32_t id = 0; id < items.size(); ++id) {
			auto &entry = items[id];
			entry.id = static_cast<uint16_t>(id);
			const bool isContainer = entry.maxItems > 0 || entry.type == ITEM_TYPE_CONTAINER || entry.type == ITEM_TYPE_REWARDCHEST;
			if (isContainer && entry.group == ITEM_GROUP_NONE) {
				entry.group = ITEM_GROUP_CONTAINER;
			}
			if (isContainer && entry.type == ITEM_TYPE_NONE) {
				entry.type = ITEM_TYPE_CONTAINER;
			}
			if (!isContainer && entry.type == ITEM_TYPE_NONE) {
				entry.type = ITEM_TYPE_OTHER;
			}
		}

		items[0].id = 0;
	}
}

class TestItems final {
public:
	static void init() {
		static const bool loaded = [] {
			Item::items.loadFromXml();
			return true;
		}();
		(void)loaded;
		ensureTestItemTypes();
	}
};
