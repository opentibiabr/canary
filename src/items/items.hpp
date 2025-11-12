/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/creatures_definitions.hpp"
#include "game/movement/position.hpp"
#include "items/items_definitions.hpp"
#include "utils/utils_definitions.hpp"
#include "enums/item_attribute.hpp"

struct Abilities {
	std::array<ConditionType_t, ConditionType_t::CONDITION_COUNT> conditionImmunities = {};
	std::array<ConditionType_t, ConditionType_t::CONDITION_COUNT> conditionSuppressions = {};

	// stats modifiers
	int32_t stats[STAT_LAST + 1] = { 0 };
	int32_t statsPercent[STAT_LAST + 1] = { 0 };

	// extra skill modifiers
	int32_t skills[SKILL_LAST + 1] = { 0 };

	int32_t speed = 0;

	// field damage abilities modifiers
	int16_t fieldAbsorbPercent[COMBAT_COUNT] = { 0 };

	// damage abilities modifiers
	int16_t absorbPercent[COMBAT_COUNT] = { 0 };

	// mantra abilities modifiers
	int16_t mantraAbsorbValue[COMBAT_COUNT] = { 0 };

	// relfect abilities modifires
	int16_t reflectPercent[COMBAT_COUNT] = { 0 };

	// elemental damage
	uint16_t elementDamage = 0;
	CombatType_t elementType = COMBAT_NONE;

	// 12.72 modifiers
	// Specialized magic level modifiers
	int32_t reflectFlat[COMBAT_COUNT] = { 0 };
	int32_t specializedMagicLevel[COMBAT_COUNT] = { 0 };

	// magic shield capacity
	int32_t magicShieldCapacityPercent = 0;
	int32_t magicShieldCapacityFlat = 0;

	// cleave
	int32_t cleavePercent = 0;

	// perfect shot
	int32_t perfectShotDamage = 0;
	uint8_t perfectShotRange = 0;

	bool manaShield = false;
	bool invisible = false;
	bool regeneration = false;

	void setHealthGain(uint32_t value) {
		healthGain = value;
	}

	uint32_t getHealthGain() const;

	void setHealthTicks(uint32_t value) {
		healthTicks = value;
	}

	uint32_t getHealthTicks() const;

	void setManaGain(uint32_t value) {
		manaGain = value;
	}

	uint32_t getManaGain() const;

	void setManaTicks(uint32_t value) {
		manaTicks = value;
	}

	uint32_t getManaTicks() const;

	uint32_t healthGain = 0;
	uint32_t healthTicks = 0;
	uint32_t manaGain = 0;
	uint32_t manaTicks = 0;
};

class ConditionDamage;

class ItemType {
public:
	ItemType() = default;

	// non-copyable
	ItemType(const ItemType &other) = delete;
	ItemType &operator=(const ItemType &other) = delete;

	ItemType(ItemType &&other) noexcept = default;
	ItemType &operator=(ItemType &&other) = default;

	bool triggerExhaustion() const;

	bool isGroundTile() const {
		return group == ITEM_GROUP_GROUND;
	}
	bool isContainer() const {
		return group == ITEM_GROUP_CONTAINER;
	}
	bool isSplash() const {
		return group == ITEM_GROUP_SPLASH;
	}
	bool isFluidContainer() const {
		return group == ITEM_GROUP_FLUID;
	}
	bool isShield() const {
		return type == ITEM_TYPE_SHIELD && !isSpellBook();
	}
	bool isSpellBook() const {
		return spellbook;
	}

	bool isDoor() const {
		return (type == ITEM_TYPE_DOOR);
	}
	bool isMagicField() const {
		return (type == ITEM_TYPE_MAGICFIELD);
	}
	bool isTeleport() const {
		return (type == ITEM_TYPE_TELEPORT);
	}
	bool isKey() const {
		return (type == ITEM_TYPE_KEY);
	}
	bool isDepot() const {
		return (type == ITEM_TYPE_DEPOT);
	}
	bool isRewardChest() const {
		return (type == ITEM_TYPE_REWARDCHEST);
	}
	bool isCarpet() const {
		return (type == ITEM_TYPE_CARPET);
	}
	bool isMailbox() const {
		return (type == ITEM_TYPE_MAILBOX);
	}
	bool isTrashHolder() const {
		return (type == ITEM_TYPE_TRASHHOLDER);
	}
	bool isBed() const {
		return (type == ITEM_TYPE_BED);
	}
	bool isWrappable() const {
		return (wrapableTo > 0);
	}
	bool isRune() const {
		return (type == ITEM_TYPE_RUNE);
	}
	bool isPickupable() const {
		return pickupable;
	}
	bool isMultiUse() const {
		return multiUse;
	}
	bool isQuiver() const {
		return (type == ITEM_TYPE_QUIVER);
	}
	bool isRing() const {
		return (type == ITEM_TYPE_RING);
	}
	bool isAmulet() const {
		return (type == ITEM_TYPE_AMULET);
	}
	bool isAmmo() const {
		return (type == ITEM_TYPE_AMMO);
	}
	bool isLadder() const {
		return (type == ITEM_TYPE_LADDER);
	}
	bool isDummy() const {
		return (type == ITEM_TYPE_DUMMY);
	}
	bool hasSubType() const {
		return (isFluidContainer() || isSplash() || stackable || charges != 0);
	}
	bool isWeapon() const {
		return weaponType != WEAPON_NONE && weaponType != WEAPON_SHIELD && weaponType != WEAPON_AMMO;
	}
	bool isWand() const {
		return weaponType == WEAPON_WAND;
	}
	bool isArmor() const {
		return slotPosition & SLOTP_ARMOR;
	}
	bool isHelmet() const {
		return slotPosition & SLOTP_HEAD;
	}
	bool isLegs() const {
		return slotPosition & SLOTP_LEGS;
	}
	bool isBoots() const {
		return slotPosition & SLOTP_FEET;
	}
	bool isRanged() const {
		return weaponType == WEAPON_DISTANCE && weaponType != WEAPON_NONE;
	}
	bool isMissile() const {
		return weaponType == WEAPON_MISSILE && weaponType != WEAPON_NONE;
	}

	Abilities &getAbilities() {
		if (!abilities) {
			abilities = std::make_unique<Abilities>();
		}
		return *abilities;
	}

	int32_t getSpeed() const {
		return abilities ? abilities->speed : 0;
	}

	int32_t getSkill(skills_t skill) const {
		return abilities ? abilities->skills[skill] : 0;
	}

	int32_t getStat(stats_t stat) const {
		return abilities ? abilities->stats[stat] : 0;
	}

	std::string getPluralName() const {
		if (!pluralName.empty()) {
			return pluralName;
		}

		if (showCount == 0) {
			return name;
		}

		std::string str;
		str.reserve(name.length() + 1);
		str.assign(name);
		str += 's';
		return str;
	}

	std::string parseAugmentDescription(bool inspect = false) const;
	std::string getFormattedAugmentDescription(const std::shared_ptr<AugmentInfo> &augmentInfo) const;

	void addAugment(std::string spellName, Augment_t augmentType, int32_t value);

	void setImbuementType(ImbuementTypes_t imbuementType, uint16_t slotMaxTier);

	ItemGroup_t group = ITEM_GROUP_NONE;
	ItemTypes_t type = ITEM_TYPE_NONE;
	uint16_t id = 0;

	std::string name;
	std::string article;
	std::string pluralName;
	std::string description;
	std::string runeSpellName;
	std::string vocationString;
	std::string m_primaryType;

	std::unique_ptr<Abilities> abilities;
	std::shared_ptr<ConditionDamage> conditionDamage;

	uint32_t levelDoor = 0;
	uint32_t decayTime = 0;
	uint32_t wieldInfo = 0;
	uint32_t minReqLevel = 0;
	uint32_t minReqMagicLevel = 0;
	uint32_t charges = 0;
	uint32_t buyPrice = 0;
	uint32_t sellPrice = 0;
	// Signed, because some items have negative weight, but this will only be necessary for the look so everything else will be uint32_t
	int32_t weight = 0;
	int32_t maxHitChance = -1;
	int32_t decayTo = -1;
	int32_t attack = 0;
	int32_t defense = 0;
	int32_t extraDefense = 0;
	int32_t armor = 0;
	int32_t rotateTo = 0;
	int32_t runeMagLevel = 0;
	int32_t runeLevel = 0;
	int32_t wrapableTo = 0;

	CombatType_t combatType = COMBAT_NONE;

	ItemAnimation_t animationType = ANIMATION_NONE;

	uint16_t transformToOnUse[2] = { 0, 0 };
	uint16_t transformToFree = 0;
	uint16_t destroyTo = 0;
	uint16_t maxTextLen = 0;
	uint16_t writeOnceItemId = 0;
	uint16_t transformEquipTo = 0;
	uint16_t transformDeEquipTo = 0;
	uint16_t maxItems = 8;
	uint16_t slotPosition = SLOTP_HAND;
	uint16_t speed = 0;
	uint16_t wareId = 0;
	uint16_t bedPartOf = 0;
	uint16_t m_transformOnUse = 0;

	MagicEffectClasses magicEffect = CONST_ME_NONE;
	Direction bedPartnerDir = DIRECTION_NONE;
	BedItemPart_t bedPart = BED_NONE_PART;
	WeaponType_t weaponType = WEAPON_NONE;
	Ammo_t ammoType = AMMO_NONE;
	ShootType_t shootType = CONST_ANI_NONE;
	RaceType_t corpseType = RACE_NONE;
	Fluids_t fluidSource = FLUID_NONE;
	TileFlags_t floorChange = TILESTATE_NONE;
	std::map<ImbuementTypes_t, uint16_t> imbuementTypes;

	uint8_t upgradeClassification = 0;
	uint8_t alwaysOnTopOrder = 0;
	uint8_t lightLevel = 0;
	uint8_t lightColor = 0;
	uint8_t shootRange = 1;
	uint8_t imbuementSlot = 0;
	uint8_t stackSize = 100;

	int8_t hitChance = 0;

	std::vector<std::shared_ptr<AugmentInfo>> augments;

	// 12.90
	bool wearOut = false;
	bool clockExpire = false;
	bool expire = false;
	bool expireStop = false;

	bool forceUse = false;
	bool hasHeight = false;
	bool walkStack = true;
	bool blockSolid = false;
	bool blockPickupable = false;
	bool blockProjectile = false;
	bool blockPathFind = false;
	bool showDuration = false;
	bool showCharges = false;
	bool showAttributes = false;
	bool replaceable = true;
	bool pickupable = false;
	bool rotatable = false;
	bool wrapable = false;
	bool wrapContainer = false;
	bool multiUse = false;
	bool movable = false;
	bool canReadText = false;
	bool canWriteText = false;
	bool isVertical = false;
	bool isHorizontal = false;
	bool isHangable = false;
	bool allowDistRead = false;
	bool lookThrough = false;
	bool stopTime = false;
	bool showCount = true;
	bool stackable = false;
	bool isPodium = false;
	bool isCorpse = false;
	bool loaded = false;
	bool spellbook = false;
	bool isWrapKit = false;
	bool m_canBeUsedByGuests = false;
	bool m_isMagicShieldPotion = false;

	std::string elementalBond;
	int16_t mantra = 0;
};

class Items {
public:
	using NameMap = std::unordered_multimap<std::string, uint16_t>;
	using InventoryVector = std::vector<uint16_t>;

	Items();

	// non-copyable
	Items(const Items &) = delete;
	Items &operator=(const Items &) = delete;

	bool reload();
	void clear();

	void loadFromProtobuf();

	const ItemType &operator[](size_t id) const {
		return getItemType(id);
	}
	const ItemType &getItemType(size_t id) const;
	ItemType &getItemType(size_t id);

	/**
	 * @brief Check if the itemid "hasId" is stored on "items", if not, return false
	 *
	 * @param hasId check item id
	 * @return true if the item exist
	 * @return false if the item not exist
	 */
	bool hasItemType(size_t hasId) const;

	uint16_t getItemIdByName(const std::string &name);

	ItemTypes_t getLootType(const std::string &strValue) const;

	bool loadFromXml();
	void parseItemNode(const pugi::xml_node &itemNode, uint16_t id);

	void buildInventoryList();
	const InventoryVector &getInventory() const {
		return inventory;
	}

	size_t size() const {
		return items.size();
	}

	std::vector<ItemType> &getItems() {
		return items;
	}

	NameMap nameToItems;

	void addLadderId(uint16_t newId) {
		ladders.push_back(newId);
	}
	void addDummyId(uint16_t newId, uint16_t rate) {
		dummys[newId] = rate;
	}

	const std::vector<uint16_t> &getLadders() const {
		return ladders;
	}
	const std::unordered_map<uint16_t, uint16_t> &getDummys() const {
		return dummys;
	}

	static std::string getAugmentNameByType(Augment_t augmentType);

	static bool isAugmentWithoutValueDescription(Augment_t augmentType) {
		static std::vector<Augment_t> vector = {
			Augment_t::IncreasedDamage,
			Augment_t::PowerfulImpact,
			Augment_t::StrongImpact,
		};

		return std::ranges::find(vector, augmentType) != vector.end();
	}

private:
	std::vector<ItemType> items;
	std::vector<uint16_t> ladders;
	std::unordered_map<uint16_t, uint16_t> dummys;
	InventoryVector inventory;
};
