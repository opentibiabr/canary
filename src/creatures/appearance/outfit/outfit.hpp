/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "declarations.hpp"
#include "lib/di/container.hpp"

struct OutfitEntry {
	constexpr OutfitEntry(uint16_t initLookType, uint8_t initAddons) :
		lookType(initLookType), addons(initAddons) { }

	uint16_t lookType;
	uint8_t addons;
};

struct Outfit {
	Outfit(std::string initName, uint16_t initLookType, bool initPremium, bool initUnlocked, std::string initFrom) :
		name(std::move(initName)), lookType(initLookType), premium(initPremium), unlocked(initUnlocked), from(std::move(initFrom)) { }

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

	std::shared_ptr<Outfit> getOpositeSexOutfitByLookType(PlayerSex_t sex, uint16_t lookType) const;

	bool loadFromXml();
	bool reload();

	[[nodiscard]] std::shared_ptr<Outfit> getOutfitByLookType(PlayerSex_t sex, uint16_t lookType) const;
	[[nodiscard]] const std::vector<std::shared_ptr<Outfit>> &getOutfits(PlayerSex_t sex) const {
		return outfits[sex];
	}

	std::shared_ptr<Outfit> getOutfitByName(PlayerSex_t sex, const std::string &name) const {
		for (const auto &outfit : outfits[sex]) {
			if (outfit->name == name) {
				return outfit;
			}
		}

		return nullptr;
	}

private:
	std::vector<std::shared_ptr<Outfit>> outfits[PLAYERSEX_LAST + 1];
};
