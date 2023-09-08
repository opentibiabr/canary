/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "declarations.hpp"
#include "lib/di/container.hpp"

struct Outfit {
	Outfit(std::string initName, uint16_t initLookType, bool initPremium, bool initUnlocked, std::string initFrom) :
		name(initName), lookType(initLookType), premium(initPremium), unlocked(initUnlocked), from(initFrom) { }

	std::string name;
	uint16_t lookType;
	bool premium;
	bool unlocked;
	std::string from;
};

struct ProtocolOutfit {
	ProtocolOutfit(const std::string &initName, uint16_t initLookType, uint8_t initAddons) :
		name(initName), lookType(initLookType), addons(initAddons) { }

	const std::string &name;
	uint16_t lookType;
	uint8_t addons;
};

class Outfits {
public:
	static Outfits &getInstance() {
		return inject<Outfits>();
	}

	std::shared_ptr<Outfit> getOpositeSexOutfitByLookType(PlayerSex_t sex, uint16_t lookType);

	bool loadFromXml();

	[[nodiscard]] std::shared_ptr<Outfit> getOutfitByLookType(PlayerSex_t sex, uint16_t lookType) const;
	[[nodiscard]] const std::vector<std::shared_ptr<Outfit>> &getOutfits(PlayerSex_t sex) const {
		return outfits[sex];
	}

private:
	std::vector<std::shared_ptr<Outfit>> outfits[PLAYERSEX_LAST + 1];
};
