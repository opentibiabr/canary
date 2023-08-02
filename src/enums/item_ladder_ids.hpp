/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_ENUMS_ITEM_LADDER_IDS_HPP
#define SRC_ENUMS_ITEM_LADDER_IDS_HPP

enum class ItemLadderIds_t : uint16_t {
	Item_1 = 1948,
	Item_2 = 1968,
	Item_3 = 5542,
	Item_4 = 20474,
	Item_5 = 20475,
	Item_6 = 28656,
	Item_7 = 21935,
	Item_8 = 31129,
	Item_9 = 31130,
	Item_10 = 34243,
	Item_11 = 33770,
};

namespace ItemLadderIdsArray {
	constexpr std::array<uint16_t, 12> get() {
		return {
			static_cast<uint16_t>(ItemLadderIds_t::Item_1),
				static_cast<uint16_t>(ItemLadderIds_t::Item_2),
				static_cast<uint16_t>(ItemLadderIds_t::Item_3),
				static_cast<uint16_t>(ItemLadderIds_t::Item_4),
				static_cast<uint16_t>(ItemLadderIds_t::Item_5),
				static_cast<uint16_t>(ItemLadderIds_t::Item_6),
				static_cast<uint16_t>(ItemLadderIds_t::Item_7),
				static_cast<uint16_t>(ItemLadderIds_t::Item_8),
				static_cast<uint16_t>(ItemLadderIds_t::Item_9),
				static_cast<uint16_t>(ItemLadderIds_t::Item_10),
				static_cast<uint16_t>(ItemLadderIds_t::Item_11),
		};
	}
}

#endif // SRC_ENUMS_ITEM_LADDER_IDS_HPP
