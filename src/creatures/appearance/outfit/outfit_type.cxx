module;

#pragma once

#include <cstdint>

export module outfit_type;

/**
 * @file outfit_type.cxx
 * @brief Module for outfit types definitions.
 *
 * @details Defines the Outfit_t structure representing player and creature outfits in the game.
 */

/**
 * @struct Outfit_t
 * @brief Represents the detailed appearance of a character or creature.
 *
 * @details Each member of the struct defines a specific aspect of the outfit, including
 * @details body parts colors, types, and additional elements like addons or mounts.
 */

export struct Outfit_t {
	uint16_t lookType = 0;
	uint16_t lookTypeEx = 0;
	uint16_t lookMount = 0;
	uint8_t lookHead = 0;
	uint8_t lookBody = 0;
	uint8_t lookLegs = 0;
	uint8_t lookFeet = 0;
	uint8_t lookAddons = 0;
	uint8_t lookMountHead = 0;
	uint8_t lookMountBody = 0;
	uint8_t lookMountLegs = 0;
	uint8_t lookMountFeet = 0;
	uint16_t lookFamiliarsType = 0;
};
