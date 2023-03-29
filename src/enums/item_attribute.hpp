/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_ENUMS_HPP
#define SRC_ENUMS_HPP

enum ItemAttribute_t : uint64_t {
	NONE = 0,
	ACTIONID = 1 << 0,
	UNIQUEID = 1 << 1,
	DESCRIPTION = 1 << 2,
	TEXT = 1 << 3,
	DATE = 1 << 4,
	WRITER = 1 << 5,
	NAME = 1 << 6,
	ARTICLE = 1 << 7,
	PLURALNAME = 1 << 8,
	WEIGHT = 1 << 9,
	ATTACK = 1 << 10,
	DEFENSE = 1 << 11,
	EXTRADEFENSE = 1 << 12,
	ARMOR = 1 << 13,
	HITCHANCE = 1 << 14,
	SHOOTRANGE = 1 << 15,
	OWNER = 1 << 16,
	DURATION = 1 << 17,
	DECAYSTATE = 1 << 18,
	CORPSEOWNER = 1 << 19,
	CHARGES = 1 << 20,
	FLUIDTYPE = 1 << 21,
	DOORID = 1 << 22,
	SPECIAL = 1 << 23,
	IMBUEMENT_SLOT = 1 << 24,
	OPENCONTAINER = 1 << 25,
	QUICKLOOTCONTAINER = 1 << 26,
	DURATION_TIMESTAMP = 1 << 27,
	AMOUNT = 1 << 28,
	TIER = 1 << 29,

	CUSTOM = 1U << 31
};

enum ItemDecayState_t : uint8_t {
	DECAYING_FALSE = 0,
	DECAYING_TRUE,
	DECAYING_PENDING,
	DECAYING_STOPPING,
};

#endif // SRC_ENUMS_HPP
