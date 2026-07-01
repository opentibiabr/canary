/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "utils/worldpointer.hpp"

enum PlayerSex_t : uint8_t;
class Player;

struct OutfitEntry {
	constexpr explicit OutfitEntry(uint16_t initLookType, uint8_t initAddons) :
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
	using OutfitAllocator = WorldPtr<Outfit>::DefaultAllocator;
	using OwningOutfit = WorldPtr<Outfit>::Owning<OutfitAllocator>;
	using BorrowedOutfit = WorldPtr<Outfit>::Borrowed<OutfitAllocator>;
	using OutfitVector = std::vector<OwningOutfit>;

	static Outfits &getInstance();

	bool reload();
	bool loadFromXml();

	// Storage owns each Outfit via an affine WorldPtr<Outfit>::Owning;
	// callers receive a WorldPtr<Outfit>::Borrowed (`BorrowedOutfit`),
	// free to copy and cheap to pass around. To escape the world (Lua,
	// network), assign to a WorldPtr<Outfit>::Shared — the implicit
	// conversion bumps the existing block's refcount.
	[[nodiscard]] BorrowedOutfit getOutfitByLookType(const std::shared_ptr<const Player> &player, uint16_t lookType, bool isOppositeOutfit = false) const;
	[[nodiscard]] const OutfitVector &getOutfits(PlayerSex_t sex) const;

	[[nodiscard]] BorrowedOutfit getOutfitByName(PlayerSex_t sex, const std::string &name) const;
};
