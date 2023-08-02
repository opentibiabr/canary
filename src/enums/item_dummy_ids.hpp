/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_ENUMS_ITEM_DUMMY_IDS_HPP
#define SRC_ENUMS_ITEM_DUMMY_IDS_HPP

enum class ItemDummyIds_t : uint16_t {
	Item_1 = 28558,
	Item_2 = 28559,
	Item_3 = 28560,
	Item_4 = 28561,
	Item_5 = 28562,
	Item_6 = 28563,
	Item_7 = 28564,
	Item_8 = 28565,
	Item_9 = 26077,
};

namespace ItemDummyIdsArray {
	constexpr std::array<uint16_t, 10> get() {
		return {
			static_cast<uint16_t>(ItemDummyIds_t::Item_1),
			static_cast<uint16_t>(ItemDummyIds_t::Item_2),
			static_cast<uint16_t>(ItemDummyIds_t::Item_3),
			static_cast<uint16_t>(ItemDummyIds_t::Item_4),
			static_cast<uint16_t>(ItemDummyIds_t::Item_5),
			static_cast<uint16_t>(ItemDummyIds_t::Item_6),
			static_cast<uint16_t>(ItemDummyIds_t::Item_7),
			static_cast<uint16_t>(ItemDummyIds_t::Item_8),
			static_cast<uint16_t>(ItemDummyIds_t::Item_9),
		};
	}
}

#endif // SRC_ENUMS_ITEM_DUMMY_IDS_HPP
