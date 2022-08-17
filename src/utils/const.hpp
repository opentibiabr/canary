/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_UTILS_CONST_H_
#define SRC_UTILS_CONST_H_

const uint32_t MAX_LOOTCHANCE = 100000;
const uint32_t MAX_STATICWALK = 100;

static constexpr size_t NETWORKMESSAGE_PLAYERNAME_MAXLENGTH = 30;
static constexpr int32_t NETWORKMESSAGE_MAXSIZE = 65500;

// QT clients probably have bigger input buffer because of exiva options
// But for now we don't support exiva options
static constexpr int32_t INPUTMESSAGE_MAXSIZE = 2048;

static constexpr int32_t CHANNEL_GUILD = 0x00;
static constexpr int32_t CHANNEL_PARTY = 0x01;
static constexpr int32_t CHANNEL_PRIVATE = 0xFFFF;

// This is in miliseconds
static constexpr int32_t EVENT_IMBUEMENT_INTERVAL = 1000;
static constexpr uint8_t IMBUEMENT_MAX_TIER = 3;

static constexpr int32_t STORAGEVALUE_PROMOTION = 30018;
static constexpr int32_t STORAGEVALUE_EMOTE = 30019;
static constexpr int32_t STORAGEVALUE_DAILYREWARD = 14898;
static constexpr int32_t STORAGEVALUE_BESTIARYKILLCOUNT = 61305000; // Can get up to 2000 storages!
// Reserved player storage key ranges;
// [10000000 - 20000000];
static constexpr int32_t PSTRG_RESERVED_RANGE_START = 10000000;
static constexpr int32_t PSTRG_RESERVED_RANGE_SIZE = 10000000;
// [1000 - 1500];
static constexpr int32_t PSTRG_OUTFITS_RANGE_START = (PSTRG_RESERVED_RANGE_START + 1000);
static constexpr int32_t PSTRG_OUTFITS_RANGE_SIZE = 500;
// [2001 - 2011];
static constexpr int32_t PSTRG_MOUNTS_RANGE_START = (PSTRG_RESERVED_RANGE_START + 2001);
static constexpr int32_t PSTRG_MOUNTS_RANGE_SIZE = 10;
static constexpr int32_t PSTRG_MOUNTS_CURRENTMOUNT = (PSTRG_MOUNTS_RANGE_START + 10);
// [3000 - 3500];
static constexpr int32_t PSTRG_FAMILIARS_RANGE_START = (PSTRG_RESERVED_RANGE_START + 3000);
static constexpr int32_t PSTRG_FAMILIARS_RANGE_SIZE = 500;

#define IS_IN_KEYRANGE(key, range) \
    (key >= PSTRG_##range##_START && \
    ((key - PSTRG_##range##_START) <= PSTRG_##range##_SIZE))

#endif  // SRC_UTILS_CONST_H_
