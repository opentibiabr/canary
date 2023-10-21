/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#include "pch.hpp"

#include "creatures/players/wheel/player_wheel.hpp"

#include "io/io_wheel.hpp"

#include "game/game.hpp"
#include "creatures/players/player.hpp"
#include "creatures/combat/spells.hpp"

// To avoid conflict in other files that might use a function with the same name
// Here are built-in helper functions
namespace {
	template <typename SpellType>
	bool checkSpellArea(const std::array<SpellType, 5> &spellsTable, const std::string &spellName, uint8_t stage) {
		for (const auto &spellTable : spellsTable) {
			auto size = std::ssize(spellTable.grade);
			g_logger().debug("spell area stage {}, grade {}", stage, size);
			if (spellTable.name == spellName && stage < static_cast<uint8_t>(size)) {
				const auto &spellData = spellTable.grade[stage];
				if (spellData.increase.area) {
					g_logger().debug("[{}] spell with name {}, and stage {} has increase area", __FUNCTION__, spellName, stage);

					return true;
				}
			}
		}

		return false;
	}

	template <typename SpellType>
	int checkSpellAdditionalTarget(const std::array<SpellType, 5> &spellsTable, const std::string_view &spellName, uint8_t stage) {
		for (const auto &spellTable : spellsTable) {
			auto size = std::ssize(spellTable.grade);
			g_logger().debug("spell target stage {}, grade {}", stage, size);
			if (spellTable.name == spellName && stage < static_cast<uint8_t>(size)) {
				const auto &spellData = spellTable.grade[stage];
				if (spellData.increase.aditionalTarget) {
					return spellData.increase.aditionalTarget;
				}
			}
		}

		return 0;
	}

	template <typename SpellType>
	int checkSpellAdditionalDuration(const std::array<SpellType, 5> &spellsTable, const std::string_view &spellName, uint8_t stage) {
		for (const auto &spellTable : spellsTable) {
			auto size = std::ssize(spellTable.grade);
			g_logger().debug("spell duration stage {}, grade {}", stage, size);
			if (spellTable.name == spellName && stage < static_cast<uint8_t>(size)) {
				const auto &spellData = spellTable.grade[stage];
				if (spellData.increase.duration > 0) {
					return spellData.increase.duration;
				}
			}
		}

		return 0;
	}

	struct PromotionScroll {
		uint16_t itemId;
		std::string storageKey;
		uint8_t extraPoints;
	};

	std::vector<PromotionScroll> WheelOfDestinyPromotionScrolls = {
		{ 43946, "wheel.scroll.abridged", 3 },
		{ 43947, "wheel.scroll.basic", 5 },
		{ 43948, "wheel.scroll.revised", 9 },
		{ 43949, "wheel.scroll.extended", 13 },
		{ 43950, "wheel.scroll.advanced", 20 },
	};
} // namespace

PlayerWheel::PlayerWheel(Player &initPlayer) :
	m_player(initPlayer) {
	auto pointsPerLevel = (uint16_t)g_configManager().getNumber(WHEEL_POINTS_PER_LEVEL);
	m_pointsPerLevel = pointsPerLevel > 0 ? pointsPerLevel : 1;
}

bool PlayerWheel::canPlayerSelectPointOnSlot(WheelSlots_t slot, bool recursive) const {
	auto playerPoints = getWheelPoints();
	// Green quadrant
	if (slot == WheelSlots_t::SLOT_GREEN_200) {
		if (playerPoints < 375u) {
			g_logger().debug("Player {} trying to manipulate byte on green slot 200 {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_150)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_TOP_150) {
		if (playerPoints < 225u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_TOP_150: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_BOTTOM_150) {
		if (playerPoints < 225u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_BOTTOM_150: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_TOP_100) {
		if (playerPoints < 125u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_TOP_100: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_MIDDLE_100) {
		if (playerPoints < 125u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_MIDDLE_100: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_BOTTOM_100) {
		if (playerPoints < 125u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_BOTTOM_100: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_TOP_75) {
		if (playerPoints < 50u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_TOP_75: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_BOTTOM_75) {
		if (playerPoints < 50u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_BOTTOM_75: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_75)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_50) {
		return recursive && (getPointsBySlotType(slot) == getMaxPointsPerSlot(slot)) || true;
	}

	// Red quadrant
	if (slot == WheelSlots_t::SLOT_RED_200) {
		if (playerPoints < 375u) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_150)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_TOP_150) {
		if (playerPoints < 225) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_BOTTOM_150) {
		if (playerPoints < 225) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_TOP_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_MIDDLE_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_BOTTOM_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_TOP_75) {
		if (playerPoints < 50) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_75)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_BOTTOM_75) {
		if (playerPoints < 50) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_75)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_50) {
		return recursive && (getPointsBySlotType(slot) == getMaxPointsPerSlot(slot)) || true;
	}

	// Purple quadrant
	if (slot == WheelSlots_t::SLOT_PURPLE_200) {
		if (playerPoints < 375) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_150)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_TOP_150) {
		if (playerPoints < 225) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_150) {
		if (playerPoints < 225) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_TOP_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_MIDDLE_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_TOP_75) {
		if (playerPoints < 50) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_75) {
		if (playerPoints < 50) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_50) {
		return recursive && (getPointsBySlotType(slot) == getMaxPointsPerSlot(slot)) || true;
	}

	// Blue quadrant
	if (slot == WheelSlots_t::SLOT_BLUE_200) {
		if (playerPoints < 375) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_150)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_TOP_150) {
		if (playerPoints < 225) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_BOTTOM_150) {
		if (playerPoints < 225) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_TOP_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_MIDDLE_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_BOTTOM_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_TOP_75) {
		if (playerPoints < 50) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_BOTTOM_75) {
		if (playerPoints < 50) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_50) {
		return recursive && (getPointsBySlotType(slot) == getMaxPointsPerSlot(slot)) || true;
	}

	return false;
}

uint16_t PlayerWheel::getUnusedPoints() const {
	auto totalPoints = getWheelPoints();
	if (totalPoints == 0) {
		return 0;
	}

	for (uint8_t i = WheelSlots_t::SLOT_FIRST; i <= WheelSlots_t::SLOT_LAST; ++i) {
		totalPoints -= getPointsBySlotType(static_cast<WheelSlots_t>(i));
	}

	return totalPoints;
}

bool PlayerWheel::getSpellAdditionalArea(const std::string &spellName) const {
	auto stage = static_cast<uint8_t>(getSpellUpgrade(spellName));
	if (stage == 0) {
		return false;
	}

	auto vocationEnum = getPlayerVocationEnum();
	if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
		return checkSpellArea(g_game().getIOWheel()->getWheelBonusData().spells.knight, spellName, stage);
	} else if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
		return checkSpellArea(g_game().getIOWheel()->getWheelBonusData().spells.paladin, spellName, stage);
	} else if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
		return checkSpellArea(g_game().getIOWheel()->getWheelBonusData().spells.druid, spellName, stage);
	} else if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
		return checkSpellArea(g_game().getIOWheel()->getWheelBonusData().spells.sorcerer, spellName, stage);
	}

	return false;
}

int PlayerWheel::getSpellAdditionalTarget(const std::string &spellName) const {
	auto stage = static_cast<uint8_t>(getSpellUpgrade(spellName));
	if (stage == 0) {
		return 0;
	}

	auto vocationEnum = getPlayerVocationEnum();
	if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
		return checkSpellAdditionalTarget(g_game().getIOWheel()->getWheelBonusData().spells.knight, spellName, stage);
	} else if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
		return checkSpellAdditionalTarget(g_game().getIOWheel()->getWheelBonusData().spells.paladin, spellName, stage);
	} else if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
		return checkSpellAdditionalTarget(g_game().getIOWheel()->getWheelBonusData().spells.druid, spellName, stage);
	} else if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
		return checkSpellAdditionalTarget(g_game().getIOWheel()->getWheelBonusData().spells.sorcerer, spellName, stage);
	}

	return 0;
}

int PlayerWheel::getSpellAdditionalDuration(const std::string &spellName) const {
	auto stage = static_cast<uint8_t>(getSpellUpgrade(spellName));
	if (stage == 0) {
		return 0;
	}

	auto vocationEnum = getPlayerVocationEnum();
	if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
		return checkSpellAdditionalDuration(g_game().getIOWheel()->getWheelBonusData().spells.knight, spellName, stage);
	} else if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
		return checkSpellAdditionalDuration(g_game().getIOWheel()->getWheelBonusData().spells.paladin, spellName, stage);
	} else if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
		return checkSpellAdditionalDuration(g_game().getIOWheel()->getWheelBonusData().spells.druid, spellName, stage);
	} else if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
		return checkSpellAdditionalDuration(g_game().getIOWheel()->getWheelBonusData().spells.sorcerer, spellName, stage);
	}

	return 0;
}

void PlayerWheel::addPromotionScrolls(NetworkMessage &msg) const {
	uint16_t count = 0;
	std::vector<uint16_t> unlockedScrolls;

	for (const auto &scroll : WheelOfDestinyPromotionScrolls) {
		auto storageValue = m_player.getStorageValueByName(scroll.storageKey);
		if (storageValue > 0) {
			count++;
			unlockedScrolls.push_back(scroll.itemId);
		}
	}

	msg.add<uint16_t>(count);
	for (const auto &itemId : unlockedScrolls) {
		msg.add<uint16_t>(itemId);
	}
}

void PlayerWheel::sendOpenWheelWindow(NetworkMessage &msg, uint32_t ownerId) const {
	if (m_player.client && m_player.client->oldProtocol) {
		return;
	}

	msg.addByte(0x5F);
	bool canUse = canOpenWheel();
	msg.add<uint32_t>(ownerId); // Player ID
	msg.addByte(canUse ? 1 : 0); // Can Use
	if (!canUse) {
		return;
	}

	msg.addByte(getOptions(ownerId)); // Options
	msg.addByte(getPlayerVocationEnum()); // Vocation id

	msg.add<uint16_t>(getWheelPoints(false)); // Points (false param for not send extra points)
	msg.add<uint16_t>(getExtraPoints()); // Extra points
	for (uint8_t i = WheelSlots_t::SLOT_FIRST; i <= WheelSlots_t::SLOT_LAST; ++i) {
		msg.add<uint16_t>(getPointsBySlotType(i));
	}
	addPromotionScrolls(msg);
}

void PlayerWheel::sendGiftOfLifeCooldown() const {
	if (!m_player.client || m_player.client->oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x5E);
	msg.addByte(0x01); // Gift of life ID
	msg.addByte(0x00); // Cooldown ENUM
	msg.add<uint32_t>(getGiftOfCooldown());
	msg.add<uint32_t>(getGiftOfLifeTotalCooldown());
	// Checking if the cooldown if decreasing or it's stopped
	if (m_player.getZoneType() != ZONE_PROTECTION && m_player.hasCondition(CONDITION_INFIGHT)) {
		msg.addByte(0x01);
	} else {
		msg.addByte(0x00);
	}

	m_player.client->writeToOutputBuffer(msg);
}

bool PlayerWheel::checkSavePointsBySlotType(WheelSlots_t slotType, uint16_t points) {
	if (points > 0 && !canPlayerSelectPointOnSlot(slotType, false)) {
		g_logger().debug("[{}] Failed to save points: {}, from slot {}", __FUNCTION__, points, fmt::underlying(slotType));
		return false;
	}

	setPointsBySlotType(static_cast<uint8_t>(slotType), 0);

	auto unusedPoints = getUnusedPoints();
	if (points > unusedPoints) {
		return false;
	}

	setPointsBySlotType(static_cast<uint8_t>(slotType), points);
	return true;
}

void PlayerWheel::saveSlotPointsHandleRetryErrors(std::vector<SlotInfo> &retryTable, int &errors) {
	std::vector<SlotInfo> temporaryTable;
	for (const auto &data : retryTable) {
		auto saved = checkSavePointsBySlotType(static_cast<WheelSlots_t>(data.slot), data.points);
		if (saved) {
			errors--;
		} else {
			temporaryTable.emplace_back(data);
		}
	}
	retryTable = temporaryTable;
}

void PlayerWheel::saveSlotPointsOnPressSaveButton(NetworkMessage &msg) {
	if (m_player.client && m_player.client->oldProtocol) {
		return;
	}

	Benchmark bm_saveSlot;

	if (!canOpenWheel()) {
		return;
	}

	// Creates a vector to store slot information in order.
	std::vector<SlotInfo> sortedTable;
	// Iterates over all slots, getting the points for each slot from the message. If the slot points exceed
	for (uint8_t slot = WheelSlots_t::SLOT_FIRST; slot <= WheelSlots_t::SLOT_LAST; ++slot) {
		auto slotPoints = msg.get<uint16_t>(); // Points per Slot
		auto maxPointsPerSlot = getMaxPointsPerSlot(static_cast<WheelSlots_t>(slot));
		if (slotPoints > maxPointsPerSlot) {
			m_player.sendTextMessage(MESSAGE_TRADE, "Something went wrong, try relogging and try again or contact and adminstrator");
			g_logger().error("[{}] possible manipulation of client package using unauthorized program", __FUNCTION__);
			g_logger().warn("Player: {}, error on slot: {}, total points: {}, max points: {}", m_player.getName(), slotPoints, slot, maxPointsPerSlot);
			return;
		}

		auto order = g_game().getIOWheel()->getSlotPrioritaryOrder(static_cast<WheelSlots_t>(slot));
		if (order == -1) {
			continue;
		}

		// The slot information is then added to the vector in order.
		sortedTable.push_back({ order, slot, slotPoints });
	}

	// After iterating over all slots, the vector is sorted according to the slot order.
	std::ranges::sort(sortedTable.begin(), sortedTable.end(), [](const SlotInfo &a, const SlotInfo &b) {
		return a.order < b.order;
	});

	int errors = 0;
	std::vector<SlotInfo> sortedTableRetry;

	// Processes the vector in the correct order. If it is not possible to save points for a slot,
	for (const auto &data : sortedTable) {
		auto canSave = checkSavePointsBySlotType(static_cast<WheelSlots_t>(data.slot), data.points);
		if (!canSave) {
			sortedTableRetry.emplace_back(data);
			errors++;
		}
	}

	// The slot data is added to a retry vector and the error counter is incremented.
	if (!sortedTableRetry.empty()) {
		int maxLoop = 0;
		// The function then enters an error loop to handle possible errors in the slot tree
		while (maxLoop <= 5) {
			maxLoop++;
			saveSlotPointsHandleRetryErrors(sortedTableRetry, errors);
		}
	}

	// If there is still data in the retry vector after the error loop, an error message is sent to the player.
	if (!sortedTableRetry.empty()) {
		m_player.sendTextMessage(MESSAGE_TRADE, "Something went wrong, try relogging and try again");
		g_logger().error("[parseSaveWheel] Player '{}' tried to select a slot without the valid requirements", m_player.getName());
	}

	// Player's bonus data is loaded, initialized, and registered, and the function logs
	loadPlayerBonusData();
	initializePlayerData();
	registerPlayerBonusData();

	g_logger().debug("Player: {} is saved the all slots info in: {} milliseconds", m_player.getName(), bm_saveSlot.duration());
}

/*
 * Functions for load and save player database informations
 */
void PlayerWheel::loadDBPlayerSlotPointsOnLogin() {
	auto resultString = fmt::format("SELECT `slot` FROM `player_wheeldata` WHERE `player_id` = {}", m_player.getGUID());
	DBResult_ptr result = Database::getInstance().storeQuery(resultString);
	// Ignore if player not have nothing inserted in the table
	if (!result) {
		return;
	}

	unsigned long size;
	auto attribute = result->getStream("slot", size);
	PropStream propStream;
	propStream.init(attribute, size);
	for (size_t i = 0; i < size; i++) {
		uint8_t slot;
		uint16_t points;
		if (propStream.read<uint8_t>(slot) && propStream.read<uint16_t>(points)) {
			setPointsBySlotType(slot, points);
			g_logger().debug("Player: {}, loaded points {} to slot {}", m_player.getName(), points, slot);
		}
	}
}

bool PlayerWheel::saveDBPlayerSlotPointsOnLogout() const {
	Database &db = Database::getInstance();
	std::ostringstream query;
	DBInsert insertWheelData("INSERT INTO `player_wheeldata` (`player_id`, `slot`) VALUES ");
	insertWheelData.upsert({ "slot" });
	PropWriteStream stream;
	const auto wheelSlots = getSlots();
	for (uint8_t i = 1; i < wheelSlots.size(); ++i) {
		auto value = wheelSlots[i];
		if (value == 0) {
			continue;
		}

		stream.write<uint8_t>(i);
		stream.write<uint16_t>(value);
		g_logger().debug("Player: {}, saved points {} to slot {}", m_player.getName(), value, i);
	}

	size_t attributesSize;
	const char* attributes = stream.getStream(attributesSize);
	if (attributesSize > 0) {
		query << m_player.getGUID() << ',' << db.escapeBlob(attributes, (uint32_t)attributesSize);
		if (!insertWheelData.addRow(query)) {
			g_logger().debug("[{}] failed to insert row data", __FUNCTION__);
			return false;
		}
	}

	if (!insertWheelData.execute()) {
		g_logger().debug("[{}] failed to execute database insert", __FUNCTION__);
		return false;
	}

	return true;
}

uint16_t PlayerWheel::getExtraPoints() const {
	if (m_player.getLevel() < 51) {
		g_logger().error("Character level must be above 50.");
		return 0;
	}

	uint16_t totalBonus = 0;
	for (const auto &scroll : WheelOfDestinyPromotionScrolls) {
		auto storageValue = m_player.getStorageValueByName(scroll.storageKey);
		if (storageValue > 0) {
			totalBonus += scroll.extraPoints;
		}
	}

	return totalBonus;
}

uint16_t PlayerWheel::getWheelPoints(bool includeExtraPoints /* = true*/) const {
	uint32_t level = m_player.getLevel();
	auto totalPoints = std::max(0u, (level - m_minLevelToStartCountPoints)) * m_pointsPerLevel;

	if (includeExtraPoints) {
		const auto extraPoints = getExtraPoints();
		totalPoints += extraPoints;
	}

	return totalPoints;
}

bool PlayerWheel::canOpenWheel() const {
	// Vocation check
	if (getPlayerVocationEnum() == Vocation_t::VOCATION_NONE) {
		return false;
	}

	// Level check, This is hardcoded on the client, cannot be changed
	if (m_player.getLevel() <= 50) {
		return false;
	}

	if (!m_player.isPremium()) {
		return false;
	}

	if (!m_player.isPromoted()) {
		return false;
	}

	return true;
}

uint8_t PlayerWheel::getOptions(uint32_t ownerId) const {
	// 0: Cannot change points.
	// 1: Can increase and decrease points.
	// 2: Can increase points but cannot decrease id.

	// Validate the owner id
	if (m_player.getID() != ownerId) {
		return 0;
	}

	// Check if is in the temple range (we assume the temple is within the range of 10 sqms)
	if (m_player.getZoneType() == ZONE_PROTECTION) {
		for (auto [townid, town] : g_game().map.towns.getTowns()) {
			if (Position::areInRange<1, 10>(town->getTemplePosition(), m_player.getPosition())) {
				return 1;
			}
		}
	}

	return 2;
}

uint8_t PlayerWheel::getPlayerVocationEnum() const {
	int cipTibiaId = m_player.getVocation()->getClientId();
	if (cipTibiaId == 1 || cipTibiaId == 11) {
		return Vocation_t::VOCATION_KNIGHT_CIP; // Knight
	} else if (cipTibiaId == 2 || cipTibiaId == 12) {
		return Vocation_t::VOCATION_PALADIN_CIP; // Paladin
	} else if (cipTibiaId == 3 || cipTibiaId == 13) {
		return Vocation_t::VOCATION_SORCERER_CIP; // Sorcerer
	} else if (cipTibiaId == 4 || cipTibiaId == 14) {
		return Vocation_t::VOCATION_DRUID_CIP; // Druid
	}

	return Vocation_t::VOCATION_NONE;
}

bool PlayerWheel::canSelectSlotFullOrPartial(WheelSlots_t slot) const {
	if (getPointsBySlotType(slot) == getMaxPointsPerSlot(slot)) {
		g_logger().debug("[{}] points on slot {}, max points {}", __FUNCTION__, getPointsBySlotType(slot), getMaxPointsPerSlot(slot));
		return true;
	}
	g_logger().debug("[{}] slot {} is not full", __FUNCTION__, fmt::underlying(slot));
	return false;
}

uint8_t PlayerWheel::getMaxPointsPerSlot(WheelSlots_t slot) const {
	if (slot == WheelSlots_t::SLOT_BLUE_50 || slot == WheelSlots_t::SLOT_RED_50 || slot == WheelSlots_t::SLOT_PURPLE_50 || slot == WheelSlots_t::SLOT_GREEN_50) {
		return 50u;
	}

	if (slot == WheelSlots_t::SLOT_GREEN_TOP_75 || slot == WheelSlots_t::SLOT_GREEN_BOTTOM_75 || slot == WheelSlots_t::SLOT_RED_TOP_75 || slot == WheelSlots_t::SLOT_RED_BOTTOM_75 || slot == WheelSlots_t::SLOT_PURPLE_TOP_75 || slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_75 || slot == WheelSlots_t::SLOT_BLUE_TOP_75 || slot == WheelSlots_t::SLOT_BLUE_BOTTOM_75) {
		return 75u;
	}

	if (slot == WheelSlots_t::SLOT_GREEN_BOTTOM_100 || slot == WheelSlots_t::SLOT_GREEN_MIDDLE_100 || slot == WheelSlots_t::SLOT_GREEN_TOP_100 || slot == WheelSlots_t::SLOT_RED_BOTTOM_100 || slot == WheelSlots_t::SLOT_RED_MIDDLE_100 || slot == WheelSlots_t::SLOT_RED_TOP_100 || slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_100 || slot == WheelSlots_t::SLOT_PURPLE_MIDDLE_100 || slot == WheelSlots_t::SLOT_PURPLE_TOP_100 || slot == WheelSlots_t::SLOT_BLUE_BOTTOM_100 || slot == WheelSlots_t::SLOT_BLUE_MIDDLE_100 || slot == WheelSlots_t::SLOT_BLUE_TOP_100) {
		return 100u;
	}

	if (slot == WheelSlots_t::SLOT_GREEN_TOP_150 || slot == WheelSlots_t::SLOT_GREEN_BOTTOM_150 || slot == WheelSlots_t::SLOT_RED_TOP_150 || slot == WheelSlots_t::SLOT_RED_BOTTOM_150 || slot == WheelSlots_t::SLOT_PURPLE_TOP_150 || slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_150 || slot == WheelSlots_t::SLOT_BLUE_TOP_150 || slot == WheelSlots_t::SLOT_BLUE_BOTTOM_150) {
		return 150u;
	}

	if (slot == WheelSlots_t::SLOT_GREEN_200 || slot == WheelSlots_t::SLOT_RED_200 || slot == WheelSlots_t::SLOT_PURPLE_200 || slot == WheelSlots_t::SLOT_BLUE_200) {
		return 200u;
	}

	g_logger().error("[{}] player: {}, is trying to use unknown slot: {}", __FUNCTION__, m_player.getName(), fmt::underlying(slot));
	return 0u;
}

void PlayerWheel::resetPlayerBonusData() {
	m_playerBonusData = PlayerWheelMethodsBonusData();
}

void PlayerWheel::initializePlayerData() {
	if (m_player.client && m_player.client->oldProtocol) {
		return;
	}

	resetPlayerBonusData();
	loadPlayerBonusData();
}

void PlayerWheel::setPlayerCombatStats(CombatType_t type, int32_t leechAmount) {
	if (type == COMBAT_LIFEDRAIN) {
		if (leechAmount > 0) {
			setStat(WheelStat_t::LIFE_LEECH, leechAmount);
		} else {
			setStat(WheelStat_t::LIFE_LEECH, 0);
		}
	} else if (type == COMBAT_MANADRAIN) {
		if (leechAmount > 0) {
			setStat(WheelStat_t::MANA_LEECH, leechAmount);
		} else {
			setStat(WheelStat_t::MANA_LEECH, 0);
		}
	}
}

void PlayerWheel::reloadPlayerData() {
	// Maybe it's not really necessary, but it doesn't hurt to validate
	if (!m_player.getTile()) {
		return;
	}

	m_player.sendSkills();
	m_player.sendStats();
	m_player.sendBasicData();
	sendGiftOfLifeCooldown();
	g_game().reloadCreature(m_player.getPlayer());
}

void PlayerWheel::registerPlayerBonusData() {
	// Reset stages and spell data
	resetUpgradedSpells();
	// Reset resistance
	resetResistance();
	// Stats
	setStat(WheelStat_t::HEALTH, m_playerBonusData.stats.health);
	setStat(WheelStat_t::MANA, m_playerBonusData.stats.mana);
	setStat(WheelStat_t::CAPACITY, m_playerBonusData.stats.capacity * 100);
	setStat(WheelStat_t::MITIGATION, m_playerBonusData.mitigation * 100);
	setStat(WheelStat_t::DAMAGE, m_playerBonusData.stats.damage);
	setStat(WheelStat_t::HEALING, m_playerBonusData.stats.healing);

	// Resistance
	for (uint16_t i = 0; i < COMBAT_COUNT; ++i) {
		setResistance(indexToCombatType(i), m_playerBonusData.resistance[i]);
	}

	// Skills
	setStat(WheelStat_t::MELEE, m_playerBonusData.skills.melee);
	setStat(WheelStat_t::DISTANCE, m_playerBonusData.skills.distance);
	setStat(WheelStat_t::MAGIC, m_playerBonusData.skills.magic);

	// Leech
	setPlayerCombatStats(COMBAT_LIFEDRAIN, m_playerBonusData.leech.lifeLeech * 100);
	setPlayerCombatStats(COMBAT_MANADRAIN, m_playerBonusData.leech.manaLeech * 100);

	// Instant
	setSpellInstant("Battle Instinct", m_playerBonusData.instant.battleInstinct);
	setSpellInstant("Battle Healing", m_playerBonusData.instant.battleHealing);
	setSpellInstant("Positional Tatics", m_playerBonusData.instant.positionalTatics);
	setSpellInstant("Ballistic Mastery", m_playerBonusData.instant.ballisticMastery);
	setSpellInstant("Healing Link", m_playerBonusData.instant.healingLink);
	setSpellInstant("Runic Mastery", m_playerBonusData.instant.runicMastery);
	setSpellInstant("Focus Mastery", m_playerBonusData.instant.focusMastery);

	// Stages (Revelation)
	if (m_playerBonusData.stages.combatMastery > 0) {
		for (int i = 0; i < m_playerBonusData.stages.combatMastery; ++i) {
			setSpellInstant("Combat Mastery", true);
		}
	} else {
		setSpellInstant("Combat Mastery", false);
	}

	if (m_playerBonusData.stages.giftOfLife > 0) {
		for (int i = 0; i < m_playerBonusData.stages.giftOfLife; ++i) {
			setSpellInstant("Gift of Life", true);
		}
	} else {
		setSpellInstant("Gift of Life", false);
	}

	if (m_playerBonusData.stages.blessingOfTheGrove > 0) {
		for (int i = 0; i < m_playerBonusData.stages.blessingOfTheGrove; ++i) {
			setSpellInstant("Blessing of the Grove", true);
		}
	} else {
		setSpellInstant("Blessing of the Grove", false);
	}

	if (m_playerBonusData.stages.divineEmpowerment > 0) {
		for (int i = 0; i < m_playerBonusData.stages.divineEmpowerment; ++i) {
			setSpellInstant("Divine Empowerment", true);
		}
	} else {
		setSpellInstant("Divine Empowerment", false);
	}

	if (m_playerBonusData.stages.divineGrenade > 0) {
		for (int i = 0; i < m_playerBonusData.stages.divineGrenade; ++i) {
			setSpellInstant("Divine Grenade", true);
		}
	} else {
		setSpellInstant("Divine Grenade", false);
	}

	if (m_playerBonusData.stages.drainBody > 0) {
		for (int i = 0; i < m_playerBonusData.stages.drainBody; ++i) {
			setSpellInstant("Drain Body", true);
		}
	} else {
		setSpellInstant("Drain Body", false);
	}
	if (m_playerBonusData.stages.beamMastery > 0) {
		for (int i = 0; i < m_playerBonusData.stages.beamMastery; ++i) {
			setSpellInstant("Beam Mastery", true);
		}
	} else {
		setSpellInstant("Beam Mastery", false);
	}

	if (m_playerBonusData.stages.twinBurst > 0) {
		for (int i = 0; i < m_playerBonusData.stages.twinBurst; ++i) {
			setSpellInstant("Twin Burst", true);
		}
	} else {
		setSpellInstant("Twin Burst", false);
	}

	if (m_playerBonusData.stages.executionersThrow > 0) {
		for (int i = 0; i < m_playerBonusData.stages.executionersThrow; ++i) {
			setSpellInstant("Executioner's Throw", true);
		}
	} else {
		setSpellInstant("Executioner's Throw", false);
	}

	// Avatar
	if (m_playerBonusData.avatar.light > 0) {
		for (int i = 0; i < m_playerBonusData.avatar.light; ++i) {
			setSpellInstant("Avatar of Light", true);
		}
	} else {
		setSpellInstant("Avatar of Light", false);
	}

	if (m_playerBonusData.avatar.nature > 0) {
		for (int i = 0; i < m_playerBonusData.avatar.nature; ++i) {
			setSpellInstant("Avatar of Nature", true);
		}
	} else {
		setSpellInstant("Avatar of Nature", false);
	}

	if (m_playerBonusData.avatar.steel > 0) {
		for (int i = 0; i < m_playerBonusData.avatar.steel; ++i) {
			setSpellInstant("Avatar of Steel", true);
		}
	} else {
		setSpellInstant("Avatar of Steel", false);
	}

	if (m_playerBonusData.avatar.storm > 0) {
		for (int i = 0; i < m_playerBonusData.avatar.storm; ++i) {
			setSpellInstant("Avatar of Storm", true);
		}
	} else {
		setSpellInstant("Avatar of Storm", false);
	}

	for (const auto spell : m_playerBonusData.spells) {
		upgradeSpell(spell);
	}

	if (m_player.getHealth() > m_player.getMaxHealth()) {
		m_player.health = std::min<int32_t>(m_player.getMaxHealth(), m_player.healthMax);
		g_game().addCreatureHealth(m_player.getPlayer());
	}

	if (m_player.getMana() > m_player.getMaxMana()) {
		int32_t difference = m_player.getMana() - m_player.getMaxMana();
		m_player.changeMana(-difference);
	}

	onThink(false); // Not forcing the reload
	reloadPlayerData();
}

void PlayerWheel::loadPlayerBonusData() {
	// Check if the player can use the wheel, otherwise we dont need to do unnecessary loops and checks
	if (!canOpenWheel()) {
		return;
	}

	loadDedicationAndConvictionPerks();

	loadRevelationPerks();
	registerPlayerBonusData();

	printPlayerWheelMethodsBonusData(m_playerBonusData);
}

void PlayerWheel::printPlayerWheelMethodsBonusData(const PlayerWheelMethodsBonusData &bonusData) const {
	g_logger().debug("Initializing print of WhelPlayerBonusData informations for player {}", m_player.getName());

	g_logger().debug("Stats:");
	if (bonusData.stats.health > 0) {
		g_logger().debug("  health: {}", bonusData.stats.health);
	}
	if (bonusData.stats.mana > 0) {
		g_logger().debug("  mana: {}", bonusData.stats.mana);
	}
	if (bonusData.stats.capacity > 0) {
		g_logger().debug("  capacity: {}", bonusData.stats.capacity);
	}
	if (bonusData.stats.damage > 0) {
		g_logger().debug("  damage: {}", bonusData.stats.damage);
	}
	if (bonusData.stats.healing > 0) {
		g_logger().debug("  healing: {}", bonusData.stats.healing);
	}

	g_logger().debug("Resistance:");
	for (size_t i = 0; i < bonusData.resistance.size(); ++i) {
		auto combatValue = bonusData.resistance[i];
		if (combatValue == 0) {
			continue;
		}

		CombatType_t combatType = indexToCombatType(i);
		std::string combatTypeStr = getCombatName(combatType);
		// Convert to percentage
		float percentage = bonusData.resistance[i] / 100.0f;
		g_logger().debug("  combatName: {} value: {} ({}%)", combatTypeStr, bonusData.resistance[i], percentage);
	}

	g_logger().debug("Skills:");
	if (bonusData.skills.melee > 0) {
		g_logger().debug("  melee: {}", bonusData.skills.melee);
	}
	if (bonusData.skills.distance > 0) {
		g_logger().debug("  distance: {}", bonusData.skills.distance);
	}
	if (bonusData.skills.magic > 0) {
		g_logger().debug("  magic: {}", bonusData.skills.magic);
	}

	g_logger().debug("Leech:");
	if (bonusData.leech.manaLeech > 0) {
		g_logger().debug("  manaLeech: {}", bonusData.leech.manaLeech);
	}
	if (bonusData.leech.lifeLeech > 0) {
		g_logger().debug("  lifeLeech: {}", bonusData.leech.lifeLeech);
	}

	g_logger().debug("Instant:");
	if (bonusData.instant.battleInstinct) {
		g_logger().debug("  battleInstinct: {}", bonusData.instant.battleInstinct);
	}
	if (bonusData.instant.battleHealing) {
		g_logger().debug("  battleHealing: {}", bonusData.instant.battleHealing);
	}
	if (bonusData.instant.positionalTatics) {
		g_logger().debug("  positionalTatics: {}", bonusData.instant.positionalTatics);
	}
	if (bonusData.instant.ballisticMastery) {
		g_logger().debug("  ballisticMastery: {}", bonusData.instant.ballisticMastery);
	}
	if (bonusData.instant.healingLink) {
		g_logger().debug("  healingLink: {}", bonusData.instant.healingLink);
	}
	if (bonusData.instant.runicMastery) {
		g_logger().debug("  runicMastery: {}", bonusData.instant.runicMastery);
	}
	if (bonusData.instant.focusMastery) {
		g_logger().debug("  focusMastery: {}", bonusData.instant.focusMastery);
	}

	g_logger().debug("Stages:");
	if (bonusData.stages.combatMastery > 0) {
		g_logger().debug("  combatMastery: {}", bonusData.stages.combatMastery);
	}
	if (bonusData.stages.giftOfLife > 0) {
		g_logger().debug("  giftOfLife: {}", bonusData.stages.giftOfLife);
	}
	if (bonusData.stages.divineEmpowerment > 0) {
		g_logger().debug("  divineEmpowerment: {}", bonusData.stages.divineEmpowerment);
	}
	if (bonusData.stages.divineGrenade > 0) {
		g_logger().debug("  divineGrenade: {}", bonusData.stages.divineGrenade);
	}
	if (bonusData.stages.blessingOfTheGrove > 0) {
		g_logger().debug("  blessingOfTheGrove: {}", bonusData.stages.blessingOfTheGrove);
	}
	if (bonusData.stages.drainBody > 0) {
		g_logger().debug("  drainBody: {}", bonusData.stages.drainBody);
	}
	if (bonusData.stages.beamMastery > 0) {
		g_logger().debug("  beamMastery: {}", bonusData.stages.beamMastery);
	}
	if (bonusData.stages.twinBurst > 0) {
		g_logger().debug("  twinBurst: {}", bonusData.stages.twinBurst);
	}
	if (bonusData.stages.executionersThrow > 0) {
		g_logger().debug("  executionersThrow: {}", bonusData.stages.executionersThrow);
	}

	g_logger().debug("Avatar:");
	if (bonusData.avatar.light > 0) {
		g_logger().debug("  light: {}", bonusData.avatar.light);
	}
	if (bonusData.avatar.nature > 0) {
		g_logger().debug("  nature: {}", bonusData.avatar.nature);
	}
	if (bonusData.avatar.steel > 0) {
		g_logger().debug("  steel: {}", bonusData.avatar.steel);
	}
	if (bonusData.avatar.storm > 0) {
		g_logger().debug("  storm: {}", bonusData.avatar.storm);
	}

	if (bonusData.mitigation > 0) {
		g_logger().debug("mitigation: {}", bonusData.mitigation);
	}

	auto &spellsVector = bonusData.spells;
	if (!spellsVector.empty()) {
		g_logger().debug("Spells:");
		for (const auto spell : bonusData.spells) {
			g_logger().debug("  {}", spell);
		}
	}

	g_logger().debug("Print of player data finished!");
}

void PlayerWheel::loadDedicationAndConvictionPerks() {
	using VocationBonusFunction = std::function<void(const std::shared_ptr<Player> &, uint16_t, uint8_t, PlayerWheelMethodsBonusData &)>;
	auto wheelFunctions = g_game().getIOWheel()->getWheelMapFunctions();
	auto vocationCipId = getPlayerVocationEnum();
	if (vocationCipId < VOCATION_KNIGHT_CIP || vocationCipId > VOCATION_DRUID_CIP) {
		return;
	}

	for (uint8_t i = WheelSlots_t::SLOT_FIRST; i <= WheelSlots_t::SLOT_LAST; ++i) {
		uint16_t points = getPointsBySlotType(static_cast<WheelSlots_t>(i));
		if (points > 0) {
			VocationBonusFunction internalData = nullptr;
			auto it = wheelFunctions.find(static_cast<WheelSlots_t>(i));
			if (it != wheelFunctions.end()) {
				internalData = it->second;
			}
			if (internalData == nullptr) {
				g_logger().warn("[{}] 'internalData' cannot be null on slot type: {}, for player: {}", __FUNCTION__, i, m_player.getName());
			} else {
				internalData(m_player.getPlayer(), points, vocationCipId, m_playerBonusData);
			}
		}
	}
}

void PlayerWheel::addSpellToVector(const std::string &spellName) {
	m_playerBonusData.spells.emplace_back(spellName);
}

void PlayerWheel::loadRevelationPerks() {
	// Stats (Damage and Healing)
	WheelStageEnum_t greenStage = getPlayerSliceStage("green");
	if (greenStage != WheelStageEnum_t::NONE) {
		auto [statsDamage, statsHealing] = g_game().getIOWheel()->getRevelationStatByStage(greenStage);
		m_playerBonusData.stats.damage += statsDamage;
		m_playerBonusData.stats.healing += statsHealing;
		m_playerBonusData.stages.giftOfLife = static_cast<int>(greenStage);
	}

	WheelStageEnum_t redStageEnum = getPlayerSliceStage("red");
	if (redStageEnum != WheelStageEnum_t::NONE) {
		auto [statsDamage, statsHealing] = g_game().getIOWheel()->getRevelationStatByStage(redStageEnum);
		m_playerBonusData.stats.damage += statsDamage;
		m_playerBonusData.stats.healing += statsHealing;

		auto redStageValue = static_cast<uint8_t>(redStageEnum);
		auto vocationEnum = getPlayerVocationEnum();
		if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
			m_playerBonusData.stages.blessingOfTheGrove = redStageValue;
		} else if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
			m_playerBonusData.stages.executionersThrow = redStageValue;
			for (uint8_t i = 0; i < redStageValue; ++i) {
				addSpellToVector("Executioner's Throw");
			}
		} else if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
			m_playerBonusData.stages.beamMastery = redStageValue;
			for (uint8_t i = 0; i < redStageValue; ++i) {
				addSpellToVector("Great Death Beam");
			}
		} else if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
			m_playerBonusData.stages.divineGrenade = redStageValue;
			for (uint8_t i = 0; i < redStageValue; ++i) {
				addSpellToVector("Divine Grenade");
			}
		}
	}

	WheelStageEnum_t purpleStageEnum = getPlayerSliceStage("purple");
	if (purpleStageEnum != WheelStageEnum_t::NONE) {
		auto [statsDamage, statsHealing] = g_game().getIOWheel()->getRevelationStatByStage(purpleStageEnum);
		m_playerBonusData.stats.damage += statsDamage;
		m_playerBonusData.stats.healing += statsHealing;

		auto purpleStage = static_cast<uint8_t>(purpleStageEnum);
		auto vocationEnum = getPlayerVocationEnum();
		if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
			m_playerBonusData.avatar.steel = purpleStage;
			for (uint8_t i = 0; i < purpleStage; ++i) {
				addSpellToVector("Avatar of Steel");
			}
		} else if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
			m_playerBonusData.avatar.light = purpleStage;
			for (uint8_t i = 0; i < purpleStage; ++i) {
				addSpellToVector("Avatar of Light");
			}
		} else if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
			m_playerBonusData.avatar.nature = purpleStage;
			for (uint8_t i = 0; i < purpleStage; ++i) {
				addSpellToVector("Avatar of Nature");
			}
		} else if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
			m_playerBonusData.avatar.storm = purpleStage;
			for (uint8_t i = 0; i < purpleStage; ++i) {
				addSpellToVector("Avatar of Storm");
			}
		}
	}

	WheelStageEnum_t blueStageEnum = getPlayerSliceStage("blue");
	if (blueStageEnum != WheelStageEnum_t::NONE) {
		auto [statsDamage, statsHealing] = g_game().getIOWheel()->getRevelationStatByStage(blueStageEnum);
		m_playerBonusData.stats.damage += statsDamage;
		m_playerBonusData.stats.healing += statsHealing;

		auto blueStage = static_cast<uint8_t>(blueStageEnum);
		auto vocationEnum = getPlayerVocationEnum();
		if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
			m_playerBonusData.stages.combatMastery = blueStage;
		} else if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
			m_playerBonusData.stages.drainBody = blueStage;
			for (uint8_t i = 0; i <= blueStage; ++i) {
				addSpellToVector("Drain_Body_Spells");
			}
		} else if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
			m_playerBonusData.stages.divineEmpowerment = blueStage;
			for (uint8_t i = 0; i <= blueStage; ++i) {
				addSpellToVector("Divine Empowerment");
			}
		} else if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
			m_playerBonusData.stages.twinBurst = blueStage;
			for (uint8_t i = 1; i <= blueStage; ++i) {
				addSpellToVector("Twin Burst");
				addSpellToVector("Terra Burst");
				addSpellToVector("Ice Burst");
			}
		}
	}
}

WheelStageEnum_t PlayerWheel::getPlayerSliceStage(const std::string &color) const {
	std::vector<WheelSlots_t> slots;
	if (color == "green") {
		slots = {
			WheelSlots_t::SLOT_GREEN_50,
			WheelSlots_t::SLOT_GREEN_TOP_75,
			WheelSlots_t::SLOT_GREEN_BOTTOM_75,
			WheelSlots_t::SLOT_GREEN_TOP_100,
			WheelSlots_t::SLOT_GREEN_MIDDLE_100,
			WheelSlots_t::SLOT_GREEN_BOTTOM_100,
			WheelSlots_t::SLOT_GREEN_TOP_150,
			WheelSlots_t::SLOT_GREEN_BOTTOM_150,
			WheelSlots_t::SLOT_GREEN_200
		};
	} else if (color == "red") {
		slots = {
			WheelSlots_t::SLOT_RED_50,
			WheelSlots_t::SLOT_RED_TOP_75,
			WheelSlots_t::SLOT_RED_BOTTOM_75,
			WheelSlots_t::SLOT_RED_TOP_100,
			WheelSlots_t::SLOT_RED_MIDDLE_100,
			WheelSlots_t::SLOT_RED_BOTTOM_100,
			WheelSlots_t::SLOT_RED_TOP_150,
			WheelSlots_t::SLOT_RED_BOTTOM_150,
			WheelSlots_t::SLOT_RED_200
		};
	} else if (color == "purple") {
		slots = {
			WheelSlots_t::SLOT_PURPLE_50,
			WheelSlots_t::SLOT_PURPLE_TOP_75,
			WheelSlots_t::SLOT_PURPLE_BOTTOM_75,
			WheelSlots_t::SLOT_PURPLE_TOP_100,
			WheelSlots_t::SLOT_PURPLE_MIDDLE_100,
			WheelSlots_t::SLOT_PURPLE_BOTTOM_100,
			WheelSlots_t::SLOT_PURPLE_TOP_150,
			WheelSlots_t::SLOT_PURPLE_BOTTOM_150,
			WheelSlots_t::SLOT_PURPLE_200
		};
	} else if (color == "blue") {
		slots = {
			WheelSlots_t::SLOT_BLUE_50,
			WheelSlots_t::SLOT_BLUE_TOP_75,
			WheelSlots_t::SLOT_BLUE_BOTTOM_75,
			WheelSlots_t::SLOT_BLUE_TOP_100,
			WheelSlots_t::SLOT_BLUE_MIDDLE_100,
			WheelSlots_t::SLOT_BLUE_BOTTOM_100,
			WheelSlots_t::SLOT_BLUE_TOP_150,
			WheelSlots_t::SLOT_BLUE_BOTTOM_150,
			WheelSlots_t::SLOT_BLUE_200
		};
	} else {
		g_logger().error("[{}] error to wheel player {} color: {}, does not match any check and was ignored", __FUNCTION__, color, m_player.getName());
	}

	int totalPoints = 0;
	for (const auto &slot : slots) {
		totalPoints += getPointsBySlotType(slot);
	}
	if (totalPoints >= static_cast<int>(WheelStagePointsEnum_t::THREE)) {
		return WheelStageEnum_t::THREE;
	} else if (totalPoints >= static_cast<int>(WheelStagePointsEnum_t::TWO)) {
		return WheelStageEnum_t::TWO;
	} else if (totalPoints >= static_cast<uint8_t>(WheelStagePointsEnum_t::ONE)) {
		return WheelStageEnum_t::ONE;
	}

	return WheelStageEnum_t::NONE;
}

// Real player methods

void PlayerWheel::checkAbilities() {
	// Wheel of destiny
	bool reloadClient = false;
	if (getInstant("Battle Instinct") && getOnThinkTimer(WheelOnThink_t::BATTLE_INSTINCT) < OTSYS_TIME() && checkBattleInstinct()) {
		reloadClient = true;
	}
	if (getInstant("Positional Tatics") && getOnThinkTimer(WheelOnThink_t::POSITIONAL_TATICS) < OTSYS_TIME() && checkPositionalTatics()) {
		reloadClient = true;
	}
	if (getInstant("Ballistic Mastery") && getOnThinkTimer(WheelOnThink_t::BALLISTIC_MASTERY) < OTSYS_TIME() && checkBallisticMastery()) {
		reloadClient = true;
	}

	if (reloadClient) {
		m_player.sendSkills();
		m_player.sendStats();
	}
}

bool PlayerWheel::checkBattleInstinct() {
	setOnThinkTimer(WheelOnThink_t::BATTLE_INSTINCT, OTSYS_TIME() + 2000);
	bool updateClient = false;
	m_creaturesNearby = 0;
	uint16_t creaturesNearby = 0;
	for (int offsetX = -1; offsetX <= 1; offsetX++) {
		if (creaturesNearby >= 8) {
			break;
		}
		for (int offsetY = -1; offsetY <= 1; offsetY++) {
			if (creaturesNearby >= 8) {
				break;
			}

			const auto playerPositionOffSet = Position(
				m_player.getPosition().x + offsetX,
				m_player.getPosition().y + offsetY,
				m_player.getPosition().z
			);
			std::shared_ptr<Tile> tile = g_game().map.getTile(playerPositionOffSet);
			if (!tile) {
				continue;
			}

			std::shared_ptr<Creature> creature = tile->getTopVisibleCreature(m_player.getPlayer());
			if (!creature || creature == m_player.getPlayer() || (creature->getMaster() && creature->getMaster()->getPlayer() == m_player.getPlayer())) {
				continue;
			}

			creaturesNearby++;
		}
	}

	if (creaturesNearby >= 5) {
		m_creaturesNearby = creaturesNearby;
		creaturesNearby -= 4;
		uint16_t meleeSkill = 1 * creaturesNearby;
		uint16_t shieldSkill = 6 * creaturesNearby;
		if (getMajorStat(WheelMajor_t::MELEE) != meleeSkill || getMajorStat(WheelMajor_t::SHIELD) != shieldSkill) {
			setMajorStat(WheelMajor_t::MELEE, meleeSkill);
			setMajorStat(WheelMajor_t::SHIELD, shieldSkill);
			updateClient = true;
		}
	} else if (getMajorStat(WheelMajor_t::MELEE) != 0 || getMajorStat(WheelMajor_t::SHIELD) != 0) {
		setMajorStat(WheelMajor_t::MELEE, 0);
		setMajorStat(WheelMajor_t::SHIELD, 0);
		updateClient = true;
	}

	return updateClient;
}

bool PlayerWheel::checkPositionalTatics() {
	setOnThinkTimer(WheelOnThink_t::POSITIONAL_TATICS, OTSYS_TIME() + 2000);
	m_creaturesNearby = 0;
	bool updateClient = false;
	uint16_t creaturesNearby = 0;
	for (int offsetX = -1; offsetX <= 1; offsetX++) {
		if (creaturesNearby > 0) {
			break;
		}
		for (int offsetY = -1; offsetY <= 1; offsetY++) {
			const auto playerPositionOffSet = Position(
				m_player.getPosition().x + offsetX,
				m_player.getPosition().y + offsetY,
				m_player.getPosition().z
			);
			std::shared_ptr<Tile> tile = g_game().map.getTile(playerPositionOffSet);
			if (!tile) {
				continue;
			}

			std::shared_ptr<Creature> creature = tile->getTopVisibleCreature(m_player.getPlayer());
			if (!creature || creature == m_player.getPlayer() || !creature->getMonster() || (creature->getMaster() && creature->getMaster()->getPlayer())) {
				continue;
			}

			creaturesNearby++;
			break;
		}
	}
	uint16_t magicSkill = 3;
	uint16_t distanceSkill = 3;
	if (creaturesNearby == 0) {
		m_creaturesNearby = creaturesNearby;
		if (getMajorStat(WheelMajor_t::DISTANCE) != distanceSkill) {
			setMajorStat(WheelMajor_t::DISTANCE, distanceSkill);
			updateClient = true;
		}
		if (getMajorStat(WheelMajor_t::MAGIC) != 0) {
			setMajorStat(WheelMajor_t::MAGIC, 0);
			updateClient = true;
		}
	} else {
		if (getMajorStat(WheelMajor_t::DISTANCE) != 0) {
			setMajorStat(WheelMajor_t::DISTANCE, 0);
			updateClient = true;
		}
		if (getMajorStat(WheelMajor_t::MAGIC) != magicSkill) {
			setMajorStat(WheelMajor_t::MAGIC, magicSkill);
			updateClient = true;
		}
	}

	return updateClient;
}

bool PlayerWheel::checkBallisticMastery() {
	setOnThinkTimer(WheelOnThink_t::BALLISTIC_MASTERY, OTSYS_TIME() + 2000);
	bool updateClient = false;
	int32_t newCritical = 10;
	uint16_t newHolyBonus = 2; // 2%
	uint16_t newPhysicalBonus = 2; // 2%

	std::shared_ptr<Item> item = m_player.getWeapon();
	if (item && item->getAmmoType() == AMMO_BOLT) {
		if (getMajorStat(WheelMajor_t::CRITICAL_DMG) != newCritical) {
			setMajorStat(WheelMajor_t::CRITICAL_DMG, newCritical);
			updateClient = true;
		}
		if (getMajorStat(WheelMajor_t::PHYSICAL_DMG) != 0 || getMajorStat(WheelMajor_t::HOLY_DMG) != 0) {
			setMajorStat(WheelMajor_t::PHYSICAL_DMG, 0);
			setMajorStat(WheelMajor_t::HOLY_DMG, 0);
			updateClient = true;
		}
	} else if (item && item->getAmmoType() == AMMO_ARROW) {
		if (getMajorStat(WheelMajor_t::CRITICAL_DMG) != 0) {
			setMajorStat(WheelMajor_t::CRITICAL_DMG, 0);
			updateClient = true;
		}
		if (getMajorStat(WheelMajor_t::PHYSICAL_DMG) != newPhysicalBonus || getMajorStat(WheelMajor_t::HOLY_DMG) != newHolyBonus) {
			setMajorStat(WheelMajor_t::PHYSICAL_DMG, newPhysicalBonus);
			setMajorStat(WheelMajor_t::HOLY_DMG, newHolyBonus);
			updateClient = true;
		}
	} else {
		if (getMajorStat(WheelMajor_t::CRITICAL_DMG) != 0) {
			setMajorStat(WheelMajor_t::CRITICAL_DMG, 0);
			updateClient = true;
		}
		if (getMajorStat(WheelMajor_t::PHYSICAL_DMG) != 0 || getMajorStat(WheelMajor_t::HOLY_DMG) != 0) {
			setMajorStat(WheelMajor_t::PHYSICAL_DMG, 0);
			setMajorStat(WheelMajor_t::HOLY_DMG, 0);
			updateClient = true;
		}
	}

	return updateClient;
}

bool PlayerWheel::checkCombatMastery() {
	setOnThinkTimer(WheelOnThink_t::COMBAT_MASTERY, OTSYS_TIME() + 2000);
	bool updateClient = false;
	uint8_t stage = getStage(WheelStage_t::COMBAT_MASTERY);

	std::shared_ptr<Item> item = m_player.getWeapon();
	if (item && item->getSlotPosition() & SLOTP_TWO_HAND) {
		int32_t criticalSkill = 0;
		if (stage >= 3) {
			criticalSkill = 12;
		} else if (stage >= 2) {
			criticalSkill = 8;
		} else if (stage >= 1) {
			criticalSkill = 4;
		}

		if (getMajorStat(WheelMajor_t::CRITICAL_DMG_2) != criticalSkill) {
			setMajorStat(WheelMajor_t::CRITICAL_DMG_2, criticalSkill);
			updateClient = true;
		}
		if (getMajorStat(WheelMajor_t::DEFENSE) != 0) {
			setMajorStat(WheelMajor_t::DEFENSE, 0);
			updateClient = true;
		}
	} else {
		if (getMajorStat(WheelMajor_t::CRITICAL_DMG_2) != 0) {
			setMajorStat(WheelMajor_t::CRITICAL_DMG_2, 0);
			updateClient = true;
		}
		if (getMajorStat(WheelMajor_t::DEFENSE) == 0) {
			int32_t shieldSkill = 0;
			if (stage >= 3) {
				shieldSkill = 30;
			} else if (stage >= 2) {
				shieldSkill = 20;
			} else if (stage >= 1) {
				shieldSkill = 10;
			}
			setMajorStat(WheelMajor_t::DEFENSE, shieldSkill);
			updateClient = true;
		}
	}

	return updateClient;
}

bool PlayerWheel::checkDivineEmpowerment() {
	bool updateClient = false;
	setOnThinkTimer(WheelOnThink_t::DIVINE_EMPOWERMENT, OTSYS_TIME() + 1000);

	const auto tile = m_player.getTile();
	if (!tile) {
		return updateClient;
	}

	const auto items = tile->getItemList();
	if (!items) {
		return updateClient;
	}

	int32_t damageBonus = 0;
	bool isOwner = false;
	for (const auto &item : *items) {
		if (item->getID() == ITEM_DIVINE_EMPOWERMENT && item->getAttribute<uint32_t>(ItemAttribute_t::OWNER) == m_player.getID()) {
			isOwner = true;
			break;
		}
	}

	if (isOwner) {
		uint8_t stage = getStage(WheelStage_t::DIVINE_EMPOWERMENT);
		if (stage >= 3) {
			damageBonus = 12;
		} else if (stage >= 2) {
			damageBonus = 10;
		} else if (stage >= 1) {
			damageBonus = 8;
		}
	}
	if (damageBonus != getMajorStat(WheelMajor_t::DAMAGE)) {
		setMajorStat(WheelMajor_t::DAMAGE, damageBonus);
		updateClient = true;
	}

	return updateClient;
}

int32_t PlayerWheel::checkDivineGrenade(std::shared_ptr<Creature> target) const {
	if (!target || target == m_player.getPlayer()) {
		return 0;
	}

	int32_t damageBonus = 0;
	uint8_t stage = getStage(WheelStage_t::DIVINE_GRENADE);

	if (stage >= 3) {
		damageBonus = 100;
	} else if (stage >= 2) {
		damageBonus = 60;
	} else if (stage >= 1) {
		damageBonus = 30;
	}

	return damageBonus;
}

void PlayerWheel::checkGiftOfLife() {
	// Healing
	CombatDamage giftDamage;
	giftDamage.primary.value = (m_player.getMaxHealth() * getGiftOfLifeValue()) / 100;
	giftDamage.primary.type = COMBAT_HEALING;
	m_player.sendTextMessage(MESSAGE_EVENT_ADVANCE, "That was close! Fortunately, your were saved by the Gift of Life.");
	g_game().addMagicEffect(m_player.getPosition(), CONST_ME_WATER_DROP);
	g_game().combatChangeHealth(m_player.getPlayer(), m_player.getPlayer(), giftDamage);
	// Condition cooldown reduction
	uint16_t reductionTimer = 60000;
	reduceAllSpellsCooldownTimer(reductionTimer);

	// Set cooldown
	setGiftOfCooldown(getGiftOfLifeTotalCooldown(), false);
	sendGiftOfLifeCooldown();
}

int32_t PlayerWheel::checkBlessingGroveHealingByTarget(std::shared_ptr<Creature> target) const {
	if (!target || target == m_player.getPlayer()) {
		return 0;
	}

	int32_t healingBonus = 0;
	uint8_t stage = getStage(WheelStage_t::BLESSING_OF_THE_GROVE);
	int32_t healthPercent = std::round((static_cast<double>(target->getHealth()) * 100) / static_cast<double>(target->getMaxHealth()));
	if (healthPercent <= 30) {
		if (stage >= 3) {
			healingBonus = 24;
		} else if (stage >= 2) {
			healingBonus = 18;
		} else if (stage >= 1) {
			healingBonus = 12;
		}
	} else if (healthPercent <= 60) {
		if (stage >= 3) {
			healingBonus = 12;
		} else if (stage >= 2) {
			healingBonus = 9;
		} else if (stage >= 1) {
			healingBonus = 6;
		}
	}

	return healingBonus;
}

int32_t PlayerWheel::checkTwinBurstByTarget(std::shared_ptr<Creature> target) const {
	if (!target || target == m_player.getPlayer()) {
		return 0;
	}

	int32_t damageBonus = 0;
	uint8_t stage = getStage(WheelStage_t::TWIN_BURST);
	int32_t healthPercent = std::round((static_cast<double>(target->getHealth()) * 100) / static_cast<double>(target->getMaxHealth()));
	if (healthPercent > 60) {
		if (stage >= 3) {
			damageBonus = 60;
		} else if (stage >= 2) {
			damageBonus = 40;
		} else if (stage >= 1) {
			damageBonus = 20;
		}
	}

	return damageBonus;
}

int32_t PlayerWheel::checkExecutionersThrow(std::shared_ptr<Creature> target) const {
	if (!target || target == m_player.getPlayer()) {
		return 0;
	}

	int32_t damageBonus = 0;
	uint8_t stage = getStage(WheelStage_t::EXECUTIONERS_THROW);
	int32_t healthPercent = std::round((static_cast<double>(target->getHealth()) * 100) / static_cast<double>(target->getMaxHealth()));
	if (healthPercent <= 30) {
		if (stage >= 3) {
			damageBonus = 150;
		} else if (stage >= 2) {
			damageBonus = 125;
		} else if (stage >= 1) {
			damageBonus = 100;
		}
	}

	return damageBonus;
}

int32_t PlayerWheel::checkBeamMasteryDamage() const {
	int32_t damageBoost = 0;
	uint8_t stage = getStage(WheelStage_t::BEAM_MASTERY);
	if (stage >= 3) {
		damageBoost = 14;
	} else if (stage >= 2) {
		damageBoost = 12;
	} else if (stage >= 1) {
		damageBoost = 10;
	}

	return damageBoost;
}

int32_t PlayerWheel::checkDrainBodyLeech(std::shared_ptr<Creature> target, skills_t skill) const {
	if (!target || !target->getMonster() || target->getWheelOfDestinyDrainBodyDebuff() == 0) {
		return 0;
	}

	uint8_t stage = target->getWheelOfDestinyDrainBodyDebuff();
	if (target->getBuff(BUFF_DAMAGERECEIVED) > 100 && skill == SKILL_MANA_LEECH_AMOUNT) {
		int32_t manaLeechSkill = 0;
		if (stage >= 3) {
			manaLeechSkill = 400;
		} else if (stage >= 2) {
			manaLeechSkill = 300;
		} else if (stage >= 1) {
			manaLeechSkill = 200;
		}
		return manaLeechSkill;
	}

	if (target->getBuff(BUFF_DAMAGEDEALT) < 100 && skill == SKILL_LIFE_LEECH_AMOUNT) {
		int32_t lifeLeechSkill = 0;
		if (stage >= 3) {
			lifeLeechSkill = 500;
		} else if (stage >= 2) {
			lifeLeechSkill = 400;
		} else if (stage >= 1) {
			lifeLeechSkill = 300;
		}
		return lifeLeechSkill;
	}

	return 0;
}

int32_t PlayerWheel::checkBattleHealingAmount() const {
	double amount = (double)m_player.getSkillLevel(SKILL_SHIELD) * 0.2;
	uint8_t healthPercent = (m_player.getHealth() * 100) / m_player.getMaxHealth();
	if (healthPercent <= 30) {
		amount *= 3;
	} else if (healthPercent <= 60) {
		amount *= 2;
	}
	return (int32_t)amount;
}

int32_t PlayerWheel::checkAvatarSkill(WheelAvatarSkill_t skill) const {
	if (skill == WheelAvatarSkill_t::NONE || getOnThinkTimer(WheelOnThink_t::AVATAR) <= OTSYS_TIME()) {
		return 0;
	}

	uint8_t stage = 0;
	if (getInstant("Avatar of Light")) {
		stage = getStage(WheelStage_t::AVATAR_OF_LIGHT);
	} else if (getInstant("Avatar of Steel")) {
		stage = getStage(WheelStage_t::AVATAR_OF_STEEL);
	} else if (getInstant("Avatar of Nature")) {
		stage = getStage(WheelStage_t::AVATAR_OF_NATURE);
	} else if (getInstant("Avatar of Storm")) {
		stage = getStage(WheelStage_t::AVATAR_OF_STORM);
	} else {
		return 0;
	}

	if (skill == WheelAvatarSkill_t::DAMAGE_REDUCTION) {
		if (stage >= 3) {
			return 15;
		} else if (stage >= 2) {
			return 10;
		} else if (stage >= 1) {
			return 5;
		}
	} else if (skill == WheelAvatarSkill_t::CRITICAL_CHANCE) {
		return 100;
	} else if (skill == WheelAvatarSkill_t::CRITICAL_DAMAGE) {
		if (stage >= 3) {
			return 15;
		} else if (stage >= 2) {
			return 10;
		} else if (stage >= 1) {
			return 5;
		}
	}

	return 0;
}

int32_t PlayerWheel::checkFocusMasteryDamage() {
	if (getInstant(WheelInstant_t::FOCUS_MASTERY) && getOnThinkTimer(WheelOnThink_t::FOCUS_MASTERY) >= OTSYS_TIME()) {
		setOnThinkTimer(WheelOnThink_t::FOCUS_MASTERY, 0);
		return 35;
	}
	return 0;
}
int32_t PlayerWheel::checkElementSensitiveReduction(CombatType_t type) const {
	int32_t rt = 0;
	if (type == COMBAT_PHYSICALDAMAGE) {
		rt += getMajorStatConditional("Ballistic Mastery", WheelMajor_t::PHYSICAL_DMG);
	} else if (type == COMBAT_HOLYDAMAGE) {
		rt += getMajorStatConditional("Ballistic Mastery", WheelMajor_t::HOLY_DMG);
	}
	return rt;
}

void PlayerWheel::onThink(bool force /* = false*/) {
	bool updateClient = false;
	m_creaturesNearby = 0;
	if (!m_player.hasCondition(CONDITION_INFIGHT) || m_player.getZoneType() == ZONE_PROTECTION || (!getInstant("Battle Instinct") && !getInstant("Positional Tatics") && !getInstant("Ballistic Mastery") && !getInstant("Gift of Life") && !getInstant("Combat Mastery") && !getInstant("Divine Empowerment") && getGiftOfCooldown() == 0)) {
		bool mustReset = false;
		for (int i = 0; i < static_cast<int>(WheelMajor_t::TOTAL_COUNT); i++) {
			if (getMajorStat(static_cast<WheelMajor_t>(i)) != 0) {
				mustReset = true;
				break;
			}
		}

		if (mustReset) {
			for (int i = 0; i < static_cast<int>(WheelMajor_t::TOTAL_COUNT); i++) {
				setMajorStat(static_cast<WheelMajor_t>(i), 0);
			}
			m_player.sendSkills();
			m_player.sendStats();
			g_game().reloadCreature(m_player.getPlayer());
		}
		if (!force) {
			return;
		}
	}
	// Battle Instinct
	if (getInstant("Battle Instinct") && (force || getOnThinkTimer(WheelOnThink_t::BATTLE_INSTINCT) < OTSYS_TIME()) && checkBattleInstinct()) {
		updateClient = true;
	}
	// Positional Tatics
	if (getInstant("Positional Tatics") && (force || getOnThinkTimer(WheelOnThink_t::POSITIONAL_TATICS) < OTSYS_TIME()) && checkPositionalTatics()) {
		updateClient = true;
	}
	// Ballistic Mastery
	if (getInstant("Ballistic Mastery") && (force || getOnThinkTimer(WheelOnThink_t::BALLISTIC_MASTERY) < OTSYS_TIME()) && checkBallisticMastery()) {
		updateClient = true;
	}
	// Gift of life (Cooldown)
	if (getGiftOfCooldown() > 0 /*getInstant("Gift of Life")*/ && getOnThinkTimer(WheelOnThink_t::GIFT_OF_LIFE) <= OTSYS_TIME()) {
		decreaseGiftOfCooldown(1);
	}
	// Combat Mastery
	if (getInstant("Combat Mastery") && (force || getOnThinkTimer(WheelOnThink_t::COMBAT_MASTERY) < OTSYS_TIME()) && checkCombatMastery()) {
		updateClient = true;
	}
	// Divine Empowerment
	if (getInstant("Divine Empowerment") && (force || getOnThinkTimer(WheelOnThink_t::DIVINE_EMPOWERMENT) < OTSYS_TIME()) && checkDivineEmpowerment()) {
		updateClient = true;
	}
	if (updateClient) {
		m_player.sendSkills();
		m_player.sendStats();
	}
}

void PlayerWheel::reduceAllSpellsCooldownTimer(int32_t value) {
	for (const auto &condition : m_player.getConditionsByType(CONDITION_SPELLCOOLDOWN)) {
		if (condition->getTicks() <= value) {
			m_player.sendSpellCooldown(condition->getSubId(), 0);
			condition->endCondition(m_player.getPlayer());
		} else {
			condition->setTicks(condition->getTicks() - value);
			m_player.sendSpellCooldown(condition->getSubId(), condition->getTicks());
		}
	}
}

void PlayerWheel::resetUpgradedSpells() {
	for (const auto spell : m_learnedSpellsSelected) {
		if (m_player.hasLearnedInstantSpell(spell)) {
			m_player.forgetInstantSpell(spell);
		}
	}
	m_creaturesNearby = 0;
	m_spellsSelected.clear();
	m_learnedSpellsSelected.clear();
	for (int i = 0; i < static_cast<int>(WheelMajor_t::TOTAL_COUNT); i++) {
		setMajorStat(static_cast<WheelMajor_t>(i), 0);
	}
	for (int i = 0; i < static_cast<int>(WheelStage_t::TOTAL_COUNT); i++) {
		setStage(static_cast<WheelStage_t>(i), 0);
	}
	setOnThinkTimer(WheelOnThink_t::FOCUS_MASTERY, 0);
}

void PlayerWheel::upgradeSpell(const std::string &name) {
	if (!m_player.hasLearnedInstantSpell(name)) {
		m_learnedSpellsSelected.emplace_back(name);
		m_player.learnInstantSpell(name);
	}
	if (m_spellsSelected[name] == WheelSpellGrade_t::NONE) {
		m_spellsSelected[name] = WheelSpellGrade_t::REGULAR;
	} else if (m_spellsSelected[name] == WheelSpellGrade_t::REGULAR) {
		m_spellsSelected[name] = WheelSpellGrade_t::UPGRADED;
	} else if (m_spellsSelected[name] == WheelSpellGrade_t::UPGRADED) {
		m_spellsSelected[name] = WheelSpellGrade_t::MAX;
	}
}

void PlayerWheel::downgradeSpell(const std::string &name) {
	if (m_spellsSelected[name] == WheelSpellGrade_t::NONE || m_spellsSelected[name] == WheelSpellGrade_t::REGULAR) {
		m_spellsSelected.erase(name);
	} else if (m_spellsSelected[name] == WheelSpellGrade_t::UPGRADED) {
		m_spellsSelected[name] = WheelSpellGrade_t::REGULAR;
	} else if (m_spellsSelected[name] == WheelSpellGrade_t::MAX) {
		m_spellsSelected[name] = WheelSpellGrade_t::UPGRADED;
	}
}

std::shared_ptr<Spell> PlayerWheel::getCombatDataSpell(CombatDamage &damage) {
	std::shared_ptr<Spell> spell = nullptr;
	damage.damageMultiplier += getMajorStatConditional("Divine Empowerment", WheelMajor_t::DAMAGE);
	WheelSpellGrade_t spellGrade = WheelSpellGrade_t::NONE;
	if (!(damage.instantSpellName).empty()) {
		spellGrade = getSpellUpgrade(damage.instantSpellName);
		spell = g_spells().getInstantSpellByName(damage.instantSpellName);
	} else if (!(damage.runeSpellName).empty()) {
		spell = g_spells().getRuneSpellByName(damage.runeSpellName);
	}
	if (spell) {
		damage.damageMultiplier += checkFocusMasteryDamage();
		if (getHealingLinkUpgrade(spell->getName())) {
			damage.healingLink += 10;
		}
		if (spell->getSecondaryGroup() == SPELLGROUP_FOCUS && getInstant("Focus Mastery")) {
			setOnThinkTimer(WheelOnThink_t::FOCUS_MASTERY, (OTSYS_TIME() + 12000));
		}

		if (spell->getWheelOfDestinyUpgraded()) {
			damage.criticalDamage += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::CRITICAL_DAMAGE, spellGrade);
			damage.criticalChance += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::CRITICAL_CHANCE, spellGrade);
			damage.damageMultiplier += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::DAMAGE, spellGrade);
			damage.damageReductionMultiplier += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::DAMAGE_REDUCTION, spellGrade);
			damage.healingMultiplier += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::HEAL, spellGrade);
			damage.manaLeech += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::MANA_LEECH, spellGrade);
			damage.manaLeechChance += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::LIFE_LEECH_CHANCE, spellGrade);
			damage.lifeLeech += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::LIFE_LEECH, spellGrade);
			damage.lifeLeechChance += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::LIFE_LEECH_CHANCE, spellGrade);
		}
	}

	return spell;
}

// Wheel of destiny - setSpellInstant helpers
void PlayerWheel::setStage(WheelStage_t type, uint8_t value) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_stages.at(enumValue) = value;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
}

void PlayerWheel::setOnThinkTimer(WheelOnThink_t type, int64_t time) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_onThink.at(enumValue) = time;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range, value {}. Error message: {}", __FUNCTION__, enumValue, time, e.what());
	}
}

void PlayerWheel::setMajorStat(WheelMajor_t type, int32_t value) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_majorStats.at(enumValue) = value;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range, value {}. Error message: {}", __FUNCTION__, enumValue, value, e.what());
	}
}

void PlayerWheel::setInstant(WheelInstant_t type, bool toggle) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_instant.at(enumValue) = toggle;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
}

void PlayerWheel::setStat(WheelStat_t type, int32_t value) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_stats.at(enumValue) = value;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range, value {}. Error message: {}", __FUNCTION__, enumValue, value, e.what());
	}
}

void PlayerWheel::setResistance(CombatType_t type, int32_t value) {
	try {
		m_resistance.at(combatTypeToIndex(type)) = value;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range, value {}. Error message: {}", __FUNCTION__, combatTypeToIndex(type), value, e.what());
	}
}

void PlayerWheel::setSpellInstant(const std::string &name, bool value) {
	if (name == "Battle Instinct") {
		setInstant(WheelInstant_t::BATTLE_INSTINCT, value);
		if (!getInstant(WheelInstant_t::BATTLE_INSTINCT)) {
			setMajorStat(WheelMajor_t::SHIELD, 0);
			setMajorStat(WheelMajor_t::MELEE, 0);
		}
	} else if (name == "Battle Healing") {
		setInstant(WheelInstant_t::BATTLE_HEALING, value);
	} else if (name == "Positional Tatics") {
		setInstant(WheelInstant_t::POSITIONAL_TATICS, value);
		if (!getInstant(WheelInstant_t::POSITIONAL_TATICS)) {
			setMajorStat(WheelMajor_t::MAGIC, 0);
			setMajorStat(WheelMajor_t::HOLY_RESISTANCE, 0);
		}
	} else if (name == "Ballistic Mastery") {
		setInstant(WheelInstant_t::BALLISTIC_MASTERY, value);
		if (!getInstant(WheelInstant_t::BALLISTIC_MASTERY)) {
			setMajorStat(WheelMajor_t::CRITICAL_DMG, 0);
			setMajorStat(WheelMajor_t::PHYSICAL_DMG, 0);
			setMajorStat(WheelMajor_t::HOLY_DMG, 0);
		}
	} else if (name == "Healing Link") {
		setInstant(WheelInstant_t::HEALING_LINK, value);
	} else if (name == "Runic Mastery") {
		setInstant(WheelInstant_t::RUNIC_MASTERY, value);
	} else if (name == "Focus Mastery") {
		setInstant(WheelInstant_t::FOCUS_MASTERY, value);
		if (!getInstant(WheelInstant_t::FOCUS_MASTERY)) {
			setOnThinkTimer(WheelOnThink_t::FOCUS_MASTERY, 0);
		}
	} else if (name == "Beam Mastery") {
		if (value) {
			setStage(WheelStage_t::BEAM_MASTERY, getStage(WheelStage_t::BEAM_MASTERY) + 1);
		} else {
			setStage(WheelStage_t::BEAM_MASTERY, 0);
		}
	} else if (name == "Combat Mastery") {
		if (value) {
			setStage(WheelStage_t::COMBAT_MASTERY, getStage(WheelStage_t::COMBAT_MASTERY) + 1);
		} else {
			setStage(WheelStage_t::COMBAT_MASTERY, 0);
		}
	} else if (name == "Gift of Life") {
		if (value) {
			setStage(WheelStage_t::GIFT_OF_LIFE, getStage(WheelStage_t::GIFT_OF_LIFE) + 1);
		} else {
			setStage(WheelStage_t::GIFT_OF_LIFE, 0);
		}
	} else if (name == "Blessing of the Grove") {
		if (value) {
			setStage(WheelStage_t::BLESSING_OF_THE_GROVE, getStage(WheelStage_t::BLESSING_OF_THE_GROVE) + 1);
		} else {
			setStage(WheelStage_t::BLESSING_OF_THE_GROVE, 0);
		}
	} else if (name == "Drain Body") {
		if (value) {
			setStage(WheelStage_t::DRAIN_BODY, getStage(WheelStage_t::DRAIN_BODY) + 1);
		} else {
			setStage(WheelStage_t::DRAIN_BODY, 0);
		}
	} else if (name == "Divine Empowerment") {
		if (value) {
			setStage(WheelStage_t::DIVINE_EMPOWERMENT, getStage(WheelStage_t::DIVINE_EMPOWERMENT) + 1);
		} else {
			setStage(WheelStage_t::DIVINE_EMPOWERMENT, 0);
		}
	} else if (name == "Divine Grenade") {
		if (value) {
			setStage(WheelStage_t::DIVINE_GRENADE, getStage(WheelStage_t::DIVINE_GRENADE) + 1);
		} else {
			setStage(WheelStage_t::DIVINE_GRENADE, 0);
		}
	} else if (name == "Twin Burst") {
		if (value) {
			setStage(WheelStage_t::TWIN_BURST, getStage(WheelStage_t::TWIN_BURST) + 1);
		} else {
			setStage(WheelStage_t::TWIN_BURST, 0);
		}
	} else if (name == "Executioner's Throw") {
		if (value) {
			setStage(WheelStage_t::EXECUTIONERS_THROW, getStage(WheelStage_t::EXECUTIONERS_THROW) + 1);
		} else {
			setStage(WheelStage_t::EXECUTIONERS_THROW, 0);
		}
	} else if (name == "Avatar of Light") {
		if (value) {
			setStage(WheelStage_t::AVATAR_OF_LIGHT, getStage(WheelStage_t::AVATAR_OF_LIGHT) + 1);
		} else {
			setStage(WheelStage_t::AVATAR_OF_LIGHT, 0);
		}
	} else if (name == "Avatar of Nature") {
		if (value) {
			setStage(WheelStage_t::AVATAR_OF_NATURE, getStage(WheelStage_t::AVATAR_OF_NATURE) + 1);
		} else {
			setStage(WheelStage_t::AVATAR_OF_NATURE, 0);
		}
	} else if (name == "Avatar of Steel") {
		if (value) {
			setStage(WheelStage_t::AVATAR_OF_STEEL, getStage(WheelStage_t::AVATAR_OF_STEEL) + 1);
		} else {
			setStage(WheelStage_t::AVATAR_OF_STEEL, 0);
		}
	} else if (name == "Avatar of Storm") {
		if (value) {
			setStage(WheelStage_t::AVATAR_OF_STORM, getStage(WheelStage_t::AVATAR_OF_STORM) + 1);
		} else {
			setStage(WheelStage_t::AVATAR_OF_STORM, 0);
		}
	}
}

void PlayerWheel::resetResistance() {
	for (int32_t i = 0; i < COMBAT_COUNT; i++) {
		m_resistance[i] = 0;
	}
}

// Wheel of destiny - Header get:
bool PlayerWheel::getInstant(WheelInstant_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_instant.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return false;
}

uint8_t PlayerWheel::getStage(const std::string name) const {
	if (name == "Battle Instinct") {
		return PlayerWheel::getInstant(WheelInstant_t::BATTLE_INSTINCT);
	} else if (name == "Battle Healing") {
		return PlayerWheel::getInstant(WheelInstant_t::BATTLE_HEALING);
	} else if (name == "Positional Tatics") {
		return PlayerWheel::getInstant(WheelInstant_t::POSITIONAL_TATICS);
	} else if (name == "Ballistic Mastery") {
		return PlayerWheel::getInstant(WheelInstant_t::BALLISTIC_MASTERY);
	} else if (name == "Healing Link") {
		return PlayerWheel::getInstant(WheelInstant_t::HEALING_LINK);
	} else if (name == "Runic Mastery") {
		return PlayerWheel::getInstant(WheelInstant_t::RUNIC_MASTERY);
	} else if (name == "Focus Mastery") {
		return PlayerWheel::getInstant(WheelInstant_t::FOCUS_MASTERY);
	} else if (name == "Beam Mastery") {
		return PlayerWheel::getStage(WheelStage_t::BEAM_MASTERY);
	} else if (name == "Combat Mastery") {
		return PlayerWheel::getStage(WheelStage_t::COMBAT_MASTERY);
	} else if (name == "Gift of Life") {
		return PlayerWheel::getStage(WheelStage_t::GIFT_OF_LIFE);
	} else if (name == "Blessing of the Grove") {
		return PlayerWheel::getStage(WheelStage_t::BLESSING_OF_THE_GROVE);
	} else if (name == "Drain Body") {
		return PlayerWheel::getStage(WheelStage_t::DRAIN_BODY);
	} else if (name == "Divine Empowerment") {
		return PlayerWheel::getStage(WheelStage_t::DIVINE_EMPOWERMENT);
	} else if (name == "Divine Grenade") {
		return PlayerWheel::getStage(WheelStage_t::DIVINE_GRENADE);
	} else if (name == "Twin Burst") {
		return PlayerWheel::getStage(WheelStage_t::TWIN_BURST);
	} else if (name == "Executioner's Throw") {
		return PlayerWheel::getStage(WheelStage_t::EXECUTIONERS_THROW);
	} else if (name == "Avatar of Light") {
		return PlayerWheel::getStage(WheelStage_t::AVATAR_OF_LIGHT);
	} else if (name == "Avatar of Nature") {
		return PlayerWheel::getStage(WheelStage_t::AVATAR_OF_NATURE);
	} else if (name == "Avatar of Steel") {
		return PlayerWheel::getStage(WheelStage_t::AVATAR_OF_STEEL);
	} else if (name == "Avatar of Storm") {
		return PlayerWheel::getStage(WheelStage_t::AVATAR_OF_STORM);
	}

	return false;
}

uint8_t PlayerWheel::getStage(WheelStage_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_stages.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return 0;
}

int32_t PlayerWheel::getMajorStat(WheelMajor_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_majorStats.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return 0;
}

int32_t PlayerWheel::getStat(WheelStat_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_stats.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return 0;
}

int32_t PlayerWheel::getResistance(CombatType_t type) const {
	auto index = combatTypeToIndex(type);
	try {
		return m_resistance.at(index);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, index, e.what());
	}
	return 0;
}

WheelSpellGrade_t PlayerWheel::getSpellUpgrade(const std::string &name) const {
	for (const auto &[name_it, grade_it] : m_spellsSelected) {
		if (name_it == name) {
			return grade_it;
		}
	}
	return WheelSpellGrade_t::NONE;
}

double PlayerWheel::getMitigationMultiplier() const {
	return static_cast<double>(getStat(WheelStat_t::MITIGATION)) / 100.;
}

bool PlayerWheel::getHealingLinkUpgrade(const std::string &spell) const {
	if (!getInstant("Healing Link")) {
		return false;
	}
	if (spell == "Nature's Embrace" || spell == "Heal Friend") {
		return true;
	}
	return false;
}

int32_t PlayerWheel::getMajorStatConditional(const std::string &instant, WheelMajor_t major) const {
	return PlayerWheel::getInstant(instant) ? PlayerWheel::getMajorStat(major) : 0;
}

int64_t PlayerWheel::getOnThinkTimer(WheelOnThink_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_onThink.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range. Error message: {}", __FUNCTION__, enumValue, e.what());
	}

	return 0;
}

bool PlayerWheel::getInstant(const std::string name) const {
	if (name == "Battle Instinct") {
		return PlayerWheel::getInstant(WheelInstant_t::BATTLE_INSTINCT);
	} else if (name == "Battle Healing") {
		return PlayerWheel::getInstant(WheelInstant_t::BATTLE_HEALING);
	} else if (name == "Positional Tatics") {
		return PlayerWheel::getInstant(WheelInstant_t::POSITIONAL_TATICS);
	} else if (name == "Ballistic Mastery") {
		return PlayerWheel::getInstant(WheelInstant_t::BALLISTIC_MASTERY);
	} else if (name == "Healing Link") {
		return PlayerWheel::getInstant(WheelInstant_t::HEALING_LINK);
	} else if (name == "Runic Mastery") {
		return PlayerWheel::getInstant(WheelInstant_t::RUNIC_MASTERY);
	} else if (name == "Focus Mastery") {
		return PlayerWheel::getInstant(WheelInstant_t::FOCUS_MASTERY);
	} else if (name == "Beam Mastery") {
		return PlayerWheel::getStage(WheelStage_t::BEAM_MASTERY);
	} else if (name == "Combat Mastery") {
		return PlayerWheel::getStage(WheelStage_t::COMBAT_MASTERY);
	} else if (name == "Gift of Life") {
		return PlayerWheel::getStage(WheelStage_t::GIFT_OF_LIFE);
	} else if (name == "Blessing of the Grove") {
		return PlayerWheel::getStage(WheelStage_t::BLESSING_OF_THE_GROVE);
	} else if (name == "Drain Body") {
		return PlayerWheel::getStage(WheelStage_t::DRAIN_BODY);
	} else if (name == "Divine Empowerment") {
		return PlayerWheel::getStage(WheelStage_t::DIVINE_EMPOWERMENT);
	} else if (name == "Divine Grenade") {
		return PlayerWheel::getStage(WheelStage_t::DIVINE_GRENADE);
	} else if (name == "Twin Burst") {
		return PlayerWheel::getStage(WheelStage_t::TWIN_BURST);
	} else if (name == "Executioner's Throw") {
		return PlayerWheel::getStage(WheelStage_t::EXECUTIONERS_THROW);
	} else if (name == "Avatar of Light") {
		return PlayerWheel::getStage(WheelStage_t::AVATAR_OF_LIGHT);
	} else if (name == "Avatar of Nature") {
		return PlayerWheel::getStage(WheelStage_t::AVATAR_OF_NATURE);
	} else if (name == "Avatar of Steel") {
		return PlayerWheel::getStage(WheelStage_t::AVATAR_OF_STEEL);
	} else if (name == "Avatar of Storm") {
		return PlayerWheel::getStage(WheelStage_t::AVATAR_OF_STORM);
	}

	return false;
}

// Wheel of destiny - Specific functions
uint32_t PlayerWheel::getGiftOfLifeTotalCooldown() const {
	if (getStage(WheelStage_t::GIFT_OF_LIFE) == 1) {
		return 1 * 60 * 60 * 30;
	} else if (getStage(WheelStage_t::GIFT_OF_LIFE) == 2) {
		return 1 * 60 * 60 * 20;
	} else if (getStage(WheelStage_t::GIFT_OF_LIFE) == 3) {
		return 1 * 60 * 60 * 10;
	}
	return 0;
}

uint8_t PlayerWheel::getGiftOfLifeValue() const {
	if (getStage(WheelStage_t::GIFT_OF_LIFE) == 1) {
		return 20;
	} else if (getStage(WheelStage_t::GIFT_OF_LIFE) == 2) {
		return 25;
	} else if (getStage(WheelStage_t::GIFT_OF_LIFE) == 3) {
		return 30;
	}

	return 0;
}

int32_t PlayerWheel::getGiftOfCooldown() const {
	int32_t value = m_player.getStorageValue(STORAGEVALUE_GIFT_OF_LIFE_COOLDOWN_WOD);
	if (value <= 0) {
		return 0;
	}
	return value;
}

void PlayerWheel::setGiftOfCooldown(int32_t value, bool isOnThink) {
	m_player.addStorageValue(STORAGEVALUE_GIFT_OF_LIFE_COOLDOWN_WOD, value, true);
	if (!isOnThink) {
		setOnThinkTimer(WheelOnThink_t::GIFT_OF_LIFE, OTSYS_TIME() + 1000);
	}
}

void PlayerWheel::decreaseGiftOfCooldown(int32_t value) {
	int32_t cooldown = getGiftOfCooldown() - value;
	if (cooldown <= 0) {
		setOnThinkTimer(WheelOnThink_t::GIFT_OF_LIFE, OTSYS_TIME() + 3600000);
		return;
	}
	setOnThinkTimer(WheelOnThink_t::GIFT_OF_LIFE, OTSYS_TIME() + (value * 1000));
	setGiftOfCooldown(cooldown, true);
}

void PlayerWheel::sendOpenWheelWindow(uint32_t ownerId) const {
	if (m_player.client) {
		m_player.client->sendOpenWheelWindow(ownerId);
	}
}

uint16_t PlayerWheel::getPointsBySlotType(uint8_t slotType) const {
	try {
		return m_wheelSlots.at(slotType);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Index {} is out of range, invalid slot type. Error message: {}", __FUNCTION__, slotType, e.what());
		return 0;
	}
}

const std::array<uint16_t, 37> &PlayerWheel::getSlots() const {
	return m_wheelSlots;
}

void PlayerWheel::setPointsBySlotType(uint8_t slotType, uint16_t points) {
	try {
		m_wheelSlots.at(slotType) = points;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Index {} is out of range, invalid slot type. Error message: {}", __FUNCTION__, slotType, e.what());
	}
}

const PlayerWheelMethodsBonusData &PlayerWheel::getBonusData() const {
	return m_playerBonusData;
}

PlayerWheelMethodsBonusData &PlayerWheel::getBonusData() {
	return m_playerBonusData;
}

void PlayerWheel::setWheelBonusData(const PlayerWheelMethodsBonusData &newBonusData) {
	m_playerBonusData = newBonusData;
}

// Functions used to Manage Combat
uint8_t PlayerWheel::getBeamAffectedTotal(const CombatDamage &tmpDamage) const {
	uint8_t beamAffectedTotal = 0; // Removed const
	if (tmpDamage.runeSpellName == "Beam Mastery" && getInstant("Beam Mastery")) {
		beamAffectedTotal = 3;
	}
	return beamAffectedTotal;
}

void PlayerWheel::updateBeamMasteryDamage(CombatDamage &tmpDamage, uint8_t &beamAffectedTotal, uint8_t &beamAffectedCurrent) const {
	if (beamAffectedTotal > 0) {
		tmpDamage.damageMultiplier += checkBeamMasteryDamage();
		--beamAffectedTotal;
		beamAffectedCurrent++;
	}
}

void PlayerWheel::healIfBattleHealingActive() const {
	if (getInstant("Battle Healing")) {
		CombatDamage damage;
		damage.primary.value = checkBattleHealingAmount();
		damage.primary.type = COMBAT_HEALING;
		g_game().combatChangeHealth(m_player.getPlayer(), m_player.getPlayer(), damage);
	}
}

void PlayerWheel::adjustDamageBasedOnResistanceAndSkill(int32_t &damage, CombatType_t combatType) const {
	int32_t wheelOfDestinyElementAbsorb = getResistance(combatType);
	if (wheelOfDestinyElementAbsorb > 0) {
		damage -= std::ceil((damage * wheelOfDestinyElementAbsorb) / 10000.);
	}

	damage -= std::ceil((damage * checkAvatarSkill(WheelAvatarSkill_t::DAMAGE_REDUCTION)) / 100.);
}

float PlayerWheel::calculateMitigation() const {
	int32_t skill = m_player.getSkillLevel(SKILL_SHIELD);
	int32_t defenseValue = 0;
	std::shared_ptr<Item> weapon = m_player.inventory[CONST_SLOT_LEFT];
	std::shared_ptr<Item> shield = m_player.inventory[CONST_SLOT_RIGHT];

	float fightFactor = 1.0f;
	float shieldFactor = 1.0f;
	float distanceFactor = 1.0f;
	switch (m_player.fightMode) {
		case FIGHTMODE_ATTACK: {
			fightFactor = 0.67f;
			break;
		}
		case FIGHTMODE_BALANCED: {
			fightFactor = 0.84f;
			break;
		}
		case FIGHTMODE_DEFENSE: {
			fightFactor = 1.0f;
			break;
		}
		default:
			break;
	}

	if (shield) {
		if (shield->isSpellBook() || shield->isQuiver()) {
			distanceFactor = m_player.vocation->mitigationSecondaryShield;
		} else {
			shieldFactor = m_player.vocation->mitigationPrimaryShield;
		}
		defenseValue = shield->getDefense();
		// Wheel of destiny
		if (shield->getDefense() > 0) {
			defenseValue += getMajorStatConditional("Combat Mastery", WheelMajor_t::DEFENSE);
		}
	}

	if (weapon) {
		if (weapon->getAmmoType() == AMMO_BOLT || weapon->getAmmoType() == AMMO_ARROW) {
			distanceFactor = m_player.vocation->mitigationSecondaryShield;
		} else if (weapon->getSlotPosition() & SLOTP_TWO_HAND) {
			defenseValue = weapon->getDefense() + weapon->getExtraDefense();
			shieldFactor = m_player.vocation->mitigationSecondaryShield;
		} else {
			defenseValue += weapon->getExtraDefense();
			shieldFactor = m_player.vocation->mitigationPrimaryShield;
		}
	}

	float mitigation = std::ceil(((((skill * m_player.vocation->mitigationFactor) + (shieldFactor * (float)defenseValue)) / 100.0f) * fightFactor * distanceFactor) * 100.0f) / 100.0f;
	mitigation += (mitigation * (float)getMitigationMultiplier()) / 100.f;
	return mitigation;
}
