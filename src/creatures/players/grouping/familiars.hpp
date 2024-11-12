/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

struct FamiliarEntry {
	constexpr explicit FamiliarEntry(uint16_t initLookType) :
		lookType(initLookType) { }
	uint16_t lookType;
};

struct Familiar {
	Familiar(std::string initName, uint16_t initLookType, bool initPremium, bool initUnlocked, std::string initType) :
		name(std::move(initName)), lookType(initLookType),
		premium(initPremium), unlocked(initUnlocked),
		type(std::move(initType)) { }

	std::string name;
	uint16_t lookType;
	bool premium;
	bool unlocked;
	std::string type;
};

class Familiars {
public:
	static Familiars &getInstance();

	bool loadFromXml();
	bool reload();

	std::vector<std::shared_ptr<Familiar>> &getFamiliars(uint16_t vocation);

	[[nodiscard]] std::shared_ptr<Familiar> getFamiliarByLookType(uint16_t vocation, uint16_t lookType) const;
};
