/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/players/player.hpp"
#include "declarations.hpp"
#include "lib/di/container.hpp"
#include "utils/tools.hpp"

class Player;
class Item;

enum UseSkillMode : uint8_t {
	NormalSkill = 1,
	MagicLevel = 2,
	SpecialSkill = 3
};

struct BaseImbuement {
	BaseImbuement(uint16_t initId, std::string initName, uint32_t initPrice, uint32_t initProtectionPrice, uint32_t initRemoveCost, uint32_t initDuration, uint8_t initPercent) :
		id(initId), name(std::move(initName)), price(initPrice), protectionPrice(initProtectionPrice), removeCost(initRemoveCost), duration(initDuration), percent(initPercent) { }

	uint16_t id;
	std::string name;
	uint32_t price;
	uint32_t protectionPrice;
	uint32_t removeCost;
	uint32_t duration;
	uint8_t percent;
};

struct CategoryImbuement {
	CategoryImbuement(uint16_t initId, std::string initName, bool initAgressive) :
		id(initId), name(std::move(initName)), agressive(initAgressive) { }

	uint16_t id;
	std::string name;
	bool agressive;
};

class Imbuements {
public:
	Imbuements() = default;

	bool loadFromXml(bool reloading = false);
	bool reload();

	// non-copyable
	Imbuements(const Imbuements &) = delete;
	Imbuements &operator=(const Imbuements &) = delete;

	static Imbuements &getInstance() {
		return inject<Imbuements>();
	}

	std::shared_ptr<Imbuement> getImbuement(uint16_t id) const;
	std::shared_ptr<BaseImbuement> getBaseByID(uint16_t id) const;
	std::shared_ptr<CategoryImbuement> getCategoryByID(uint16_t id) const;

	std::vector<std::shared_ptr<Imbuement>> getImbuements(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item) const;

protected:
	friend class Imbuement;
	bool loaded = false;

private:
	uint32_t runningid = 0;

	std::map<uint32_t, std::shared_ptr<Imbuement>> imbuementMap;
	std::vector<std::shared_ptr<BaseImbuement>> basesImbuement;
	std::vector<std::shared_ptr<CategoryImbuement>> categoriesImbuement;

	bool processBaseNode(const pugi::xml_node &baseNode);
	bool processCategoryNode(const pugi::xml_node &categoryNode);
	bool processImbuementNode(const pugi::xml_node &imbuementNode);
	bool processImbuementChildNodes(const pugi::xml_node &imbuementNode, const std::shared_ptr<Imbuement> &imbuement);
};

constexpr auto g_imbuements = Imbuements::getInstance;

class Imbuement {
public:
	Imbuement(uint16_t initId, uint16_t initBaseId) :
		id(initId), baseid(initBaseId) { }

	uint16_t getID() const {
		return id;
	}

	uint16_t getBaseID() const {
		return baseid;
	}

	uint32_t getStorage() const {
		return storage;
	}

	bool isPremium() const {
		return premium;
	}
	std::string getName() const {
		return name;
	}
	std::string getDescription() const {
		return description;
	}

	std::string getSubGroup() const {
		return subgroup;
	}

	uint16_t getCategory() const {
		return category;
	}

	const std::vector<std::pair<uint16_t, uint16_t>> &getItems() const {
		return items;
	}

	uint16_t getIconID() const {
		return icon + (baseid - 1);
	}

	uint16_t icon = 1;
	int32_t stats[STAT_LAST + 1] = {};
	int32_t skills[SKILL_LAST + 1] = {};
	int32_t speed = 0;
	int32_t paralyzeReduction = 0;
	uint32_t capacity = 0;
	int16_t absorbPercent[COMBAT_COUNT] = {};
	int16_t elementDamage = 0;
	SoundEffect_t soundEffect = SoundEffect_t::SILENCE;
	CombatType_t combatType = COMBAT_NONE;

protected:
	friend class Imbuements;
	friend class Item;

private:
	bool premium = false;
	uint32_t storage = 0;
	uint16_t id, baseid, category = 0;
	std::string name, description, subgroup;

	std::vector<std::pair<uint16_t, uint16_t>> items;
};
