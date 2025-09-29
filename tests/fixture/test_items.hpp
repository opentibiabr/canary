#pragma once

#include "items/item.hpp"

class TestItems final {
public:
	static void init() {
		static const bool loaded = [] {
			Item::items.loadFromXml();
			return true;
		}();
		(void)loaded;
	}
};
