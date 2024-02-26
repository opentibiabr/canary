module;

#include <cstdint>

export module light_info;

/**
 * @file light_info.ixx
 * @brief Module for LightInfo definitions.
 *
 * @details Defines the LightInfo structure representing player and creature outfits in the game.
 */

/**
 * @struct LightInfo
 * @brief Represents the level and color from game light info.
 */

export struct LightInfo {
	uint8_t level = 0;
	uint8_t color = 215;
	constexpr LightInfo() = default;
	constexpr LightInfo(uint8_t newLevel, uint8_t newColor) :
		level(newLevel), color(newColor) { }
};
