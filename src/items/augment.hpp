/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once
#include "utils/tools.hpp"
#include "items/items.hpp"

struct Augment {
	Augment(std::string spellName, AugmentTypes_t type, int16_t value) :
		spellName(std::move(spellName)), type(type), value(value) { }

	~Augment() = default;

	std::string spellName;
	AugmentTypes_t type;
	int16_t value;

	std::string toString() const {
		std::string augmentName = Items::getAugmentNameByType(type);
		std::string augmentSpellNameCapitalized = spellName;
		capitalizeWords(augmentSpellNameCapitalized);

		if (Items::isAugmentWithoutValueDescription(type)) {
			return fmt::format("{} -> {}", augmentSpellNameCapitalized, augmentName);
		} else if (type == AUGMENT_COOLDOWN) {
			return fmt::format("{} -> {:+}s {}", augmentSpellNameCapitalized, value, augmentName);
		}
		return fmt::format("{} -> {:+}% {}", augmentSpellNameCapitalized, value / 100, augmentName);
	}
};

/*
class Augment {
public:
	Augment(std::string spellName, AugmentTypes_t type, int16_t value) :
		spellName(std::move(spellName)), type(type), value(value) { }
	~Augment() = default;

	Augment(const Augment &i) :
		type(i.type), value(i.value) { }
	Augment(Augment &&augment) noexcept :
		spellName(std::move(spellName)), type(augment.type), value(std::move(augment.value)) { }

	Augment &operator=(Augment &&other) noexcept {
		type = other.type;
		value = std::move(other.value);
		return *this;
	}

private:
	std::string spellName;
	AugmentTypes_t type;
	int16_t value;
};
*/
