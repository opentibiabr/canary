/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

static constexpr int32_t MAP_MAX_CLIENT_VIEW_PORT_X = 8;
static constexpr int32_t MAP_MAX_CLIENT_VIEW_PORT_Y = 6;
static constexpr int32_t MAP_MAX_VIEW_PORT_X = MAP_MAX_CLIENT_VIEW_PORT_X + 3; // min value: maxClientViewportX + 1
static constexpr int32_t MAP_MAX_VIEW_PORT_Y = MAP_MAX_CLIENT_VIEW_PORT_Y + 5; // min value: maxClientViewportY + 1

static constexpr int8_t MAP_MAX_LAYERS = 16;
static constexpr int8_t MAP_INIT_SURFACE_LAYER = 7; // (MAP_MAX_LAYERS / 2) -1
static constexpr int8_t MAP_LAYER_VIEW_LIMIT = 2;

static constexpr int32_t FLOOR_BITS = 3;
static constexpr int32_t FLOOR_SIZE = (1 << FLOOR_BITS);
static constexpr int32_t FLOOR_MASK = (FLOOR_SIZE - 1);
