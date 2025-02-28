/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "enums/item_attribute.hpp"
#include "io/fileloader.hpp"
#include "items/functions/item/attribute.hpp"
#include "items/items.hpp"
#include "items/thing.hpp"

class Creature;
class Player;
class Container;
class Depot;
class Teleport;
class TrashHolder;
class Mailbox;
class Door;
class MagicField;
class BedItem;
class Imbuement;
class Item;
class Cylinder;

// This class ItemProperties that serves as an interface to access and modify attributes of an item. The item's attributes are stored in an instance of ItemAttribute. The class ItemProperties has methods to get and set integer and string attributes, check if an attribute exists, remove an attribute, get the underlying attribute bits, and get a vector of attributes. It also has methods to get and set custom attributes, which are stored in a std::map<std::string, CustomAttribute, std::less<>>. The class has a data member attributePtr of type std::unique_ptr<ItemAttribute> that stores a pointer to the item's attributes methods.
class ItemProperties {
public:
	template <typename T>
	T getAttribute(ItemAttribute_t type) const {
		if constexpr (std::is_same_v<T, std::string>) {
			return getString(type);
		} else {
			return std::clamp(
				static_cast<T>(getInteger(type)),
				std::numeric_limits<T>::min(),
				std::numeric_limits<T>::max()
			);
		}
		g_logger().error("Failed to convert attribute for type {}", fmt::underlying(type));
		return {};
	}

	bool hasAttribute(ItemAttribute_t type) const {
		if (!attributePtr) {
			return false;
		}

		return attributePtr->hasAttribute(type);
	}
	void removeAttribute(ItemAttribute_t type) const {
		if (attributePtr) {
			attributePtr->removeAttribute(type);
		}
	}

	template <typename GenericAttribute>
	void setAttribute(ItemAttribute_t type, GenericAttribute genericAttribute) {
		initAttributePtr()->setAttribute(type, genericAttribute);
	}

	bool isAttributeInteger(ItemAttribute_t type) const {
		return initAttributePtr()->isAttributeInteger(type);
	}

	bool isAttributeString(ItemAttribute_t type) const {
		return initAttributePtr()->isAttributeString(type);
	}

	// Custom Attributes
	const std::map<std::string, CustomAttribute, std::less<>> &getCustomAttributeMap() const;
	const CustomAttribute* getCustomAttribute(const std::string &attributeName) const {
		if (!attributePtr) {
			return nullptr;
		}

		return attributePtr->getCustomAttribute(attributeName);
	}

	template <typename GenericType>
	void setCustomAttribute(const std::string &key, GenericType value) {
		initAttributePtr()->setCustomAttribute(key, value);
	}

	void addCustomAttribute(const std::string &key, const CustomAttribute &customAttribute) {
		initAttributePtr()->addCustomAttribute(key, customAttribute);
	}

	bool hasCustomAttribute() const {
		return !getCustomAttributeMap().empty();
	}

	bool removeCustomAttribute(const std::string &attributeName) const {
		if (!attributePtr) {
			return false;
		}

		return attributePtr->removeCustomAttribute(attributeName);
	}

	uint16_t getCharges() const {
		return getAttribute<uint16_t>(ItemAttribute_t::CHARGES);
	}

	int32_t getDuration() const;

	bool isStoreItem() const {
		return getAttribute<int64_t>(ItemAttribute_t::STORE) > 0;
	}

	void setDuration(int32_t time) {
		setAttribute(ItemAttribute_t::DURATION, std::max<int32_t>(0, time));
	}

	void setDecaying(ItemDecayState_t decayState) {
		setAttribute(ItemAttribute_t::DECAYSTATE, static_cast<int64_t>(decayState));
		if (decayState == DECAYING_FALSE) {
			removeAttribute(ItemAttribute_t::DURATION_TIMESTAMP);
		}
	}
	ItemDecayState_t getDecaying() const {
		auto decayState = getAttribute<int64_t>(ItemAttribute_t::DECAYSTATE);
		return static_cast<ItemDecayState_t>(decayState);
	}

	uint32_t getCorpseOwner() const {
		return getAttribute<uint32_t>(ItemAttribute_t::CORPSEOWNER);
	}

	void setRewardCorpse() {
		setAttribute(ItemAttribute_t::CORPSEOWNER, static_cast<uint32_t>(std::numeric_limits<int32_t>::max()));
	}

	bool isRewardCorpse() const {
		return getCorpseOwner() == static_cast<uint32_t>(std::numeric_limits<int32_t>::max());
	}

protected:
	std::unique_ptr<ItemAttribute> &initAttributePtr() {
		if (!attributePtr) {
			attributePtr = std::make_unique<ItemAttribute>();
		}

		return attributePtr;
	}
	const std::unique_ptr<ItemAttribute> &initAttributePtr() const {
		if (!attributePtr) {
			std::bit_cast<ItemProperties*>(this)->attributePtr = std::make_unique<ItemAttribute>();
		}

		return attributePtr;
	}

	const std::vector<Attributes> &getAttributeVector() const {
		static std::vector<Attributes> emptyVector = {};
		if (!attributePtr) {
			return emptyVector;
		}

		return attributePtr->getAttributeVector();
	}

	int64_t getInteger(ItemAttribute_t type) const {
		if (!attributePtr) {
			return {};
		}

		return attributePtr->getAttributeValue(type);
	}
	const std::string &getString(ItemAttribute_t type) const {
		static const std::string emptyString;
		if (!attributePtr) {
			return emptyString;
		}

		return attributePtr->getAttributeString(type);
	}

	bool isInitializedAttributePtr() const {
		if (!attributePtr) {
			return false;
		}

		return true;
	}

private:
	std::unique_ptr<ItemAttribute> attributePtr;

	friend class Item;
};

class Item : virtual public Thing, public ItemProperties, public SharedObject {
public:
	// Factory member to create item of right type based on type
	static std::shared_ptr<Item> CreateItem(uint16_t type, uint16_t count = 0, Position* itemPosition = nullptr);
	static std::shared_ptr<Container> CreateItemAsContainer(uint16_t type, uint16_t size);
	static std::shared_ptr<Item> CreateItem(uint16_t itemId, Position &itemPosition);
	static Items items;

	// Constructor for items
	explicit Item(uint16_t type, uint16_t count = 0);
	explicit Item(const std::shared_ptr<Item> &i);
	virtual std::shared_ptr<Item> clone() const;

	~Item() override = default;

	// non-assignable
	Item &operator=(const Item &) = delete;

	bool equals(const std::shared_ptr<Item> &compareItem) const;

	std::shared_ptr<Item> getItem() final {
		return static_self_cast<Item>();
	}
	std::shared_ptr<const Item> getItem() const final {
		return static_self_cast<Item>();
	}
	virtual std::shared_ptr<Teleport> getTeleport() {
		return nullptr;
	}
	virtual std::shared_ptr<TrashHolder> getTrashHolder() {
		return nullptr;
	}
	virtual std::shared_ptr<Mailbox> getMailbox() {
		return nullptr;
	}
	virtual std::shared_ptr<Door> getDoor() {
		return nullptr;
	}
	virtual std::shared_ptr<MagicField> getMagicField() {
		return nullptr;
	}
	virtual std::shared_ptr<BedItem> getBed() {
		return nullptr;
	}

	bool isSavedToHouses();

	SoundEffect_t getMovementSound(const std::shared_ptr<Cylinder> &toCylinder) const;

	void setIsLootTrackeable(bool value) {
		isLootTrackeable = value;
	}

	bool getIsLootTrackeable() const {
		return isLootTrackeable;
	}

	void setOwner(uint32_t owner) {
		setAttribute(ItemAttribute_t::OWNER, owner);
	}

	void setOwner(const std::shared_ptr<Creature> &owner);

	virtual uint32_t getOwnerId() const;

	bool isOwner(uint32_t ownerId) const;

	std::string getOwnerName() const;

	bool isOwner(const std::shared_ptr<Creature> &owner) const;

	bool hasOwner() const {
		return getOwnerId() != 0;
	}

	bool canBeMovedToStore() const {
		return isStoreItem() || hasOwner();
	}

	static std::string parseAugmentDescription(const std::shared_ptr<Item> &item, bool inspect = false) {
		if (!item) {
			return "";
		}
		return items[item->getID()].parseAugmentDescription(inspect);
	}
	static std::string parseImbuementDescription(const std::shared_ptr<Item> &item);
	static std::string parseShowDurationSpeed(int32_t speed, bool &begin);
	static std::string parseShowDuration(const std::shared_ptr<Item> &item);
	static std::string parseShowAttributesDescription(const std::shared_ptr<Item> &item, uint16_t itemId);
	static std::string parseClassificationDescription(const std::shared_ptr<Item> &item);

	static std::vector<std::pair<std::string, std::string>> getDescriptions(const ItemType &it, const std::shared_ptr<Item> &item = nullptr);
	static std::string getDescription(const ItemType &it, int32_t lookDistance, const std::shared_ptr<Item> &item = nullptr, int32_t subType = -1, bool addArticle = true);
	static std::string getNameDescription(const ItemType &it, const std::shared_ptr<Item> &item = nullptr, int32_t subType = -1, bool addArticle = true);
	static std::string getWeightDescription(const ItemType &it, uint32_t weight, uint32_t count = 1);

	std::string getDescription(int32_t lookDistance) final;
	std::string getNameDescription();
	std::string getWeightDescription() const;

	// serialization
	virtual Attr_ReadValue readAttr(AttrTypes_t attr, PropStream &propStream);
	bool unserializeAttr(PropStream &propStream);
	virtual bool unserializeItemNode(OTB::Loader &, const OTB::Node &, PropStream &propStream, Position &itemPosition);

	virtual void serializeAttr(PropWriteStream &propWriteStream) const;

	bool isPushable() final {
		return isMovable();
	}
	int32_t getThrowRange() const final {
		return (isPickupable() ? 15 : 2);
	}

	uint16_t getID() const {
		return id;
	}
	void setID(uint16_t newid);

	// Returns the player that is holding this item in his inventory
	std::shared_ptr<Player> getHoldingPlayer();

	WeaponType_t getWeaponType() const {
		return items[id].weaponType;
	}
	Ammo_t getAmmoType() const {
		return items[id].ammoType;
	}
	uint8_t getShootRange() const {
		if (hasAttribute(ItemAttribute_t::SHOOTRANGE)) {
			return getAttribute<uint8_t>(ItemAttribute_t::SHOOTRANGE);
		}
		return items[id].shootRange;
	}

	virtual uint32_t getWeight() const;
	uint32_t getBaseWeight() const {
		if (hasAttribute(ItemAttribute_t::WEIGHT)) {
			return getAttribute<uint32_t>(ItemAttribute_t::WEIGHT);
		}
		return items[id].weight;
	}

	int32_t getCleavePercent() const {
		return items[id].abilities->cleavePercent;
	}

	int32_t getPerfectShotDamage() const {
		return items[id].abilities->perfectShotDamage;
	}
	uint8_t getPerfectShotRange() const {
		return items[id].abilities->perfectShotRange;
	}

	int32_t getReflectionFlat(CombatType_t combatType) const;

	int32_t getReflectionPercent(CombatType_t combatType) const;

	int16_t getMagicShieldCapacityPercent() const {
		return items[id].abilities->magicShieldCapacityPercent;
	}

	int32_t getMagicShieldCapacityFlat() const {
		return items[id].abilities->magicShieldCapacityFlat;
	}

	int32_t getSpecializedMagicLevel(CombatType_t combat) const;

	int32_t getSpeed() const {
		const int32_t value = items[id].getSpeed();
		return value;
	}

	int32_t getSkill(skills_t skill) const {
		const int32_t value = items[id].getSkill(skill);
		return value;
	}

	int32_t getStat(stats_t stat) const {
		const int32_t value = items[id].getStat(stat);
		return value;
	}

	int32_t getAttack() const {
		if (hasAttribute(ItemAttribute_t::ATTACK)) {
			return getAttribute<int32_t>(ItemAttribute_t::ATTACK);
		}
		return items[id].attack;
	}
	int32_t getArmor() const {
		if (hasAttribute(ItemAttribute_t::ARMOR)) {
			return getAttribute<int32_t>(ItemAttribute_t::ARMOR);
		}
		return items[id].armor;
	}
	int32_t getDefense() const {
		if (hasAttribute(ItemAttribute_t::DEFENSE)) {
			return getAttribute<int32_t>(ItemAttribute_t::DEFENSE);
		}
		return items[id].defense;
	}
	int32_t getExtraDefense() const {
		if (hasAttribute(ItemAttribute_t::EXTRADEFENSE)) {
			return getAttribute<int32_t>(ItemAttribute_t::EXTRADEFENSE);
		}
		return items[id].extraDefense;
	}
	std::vector<std::shared_ptr<AugmentInfo>> getAugments() const {
		return items[id].augments;
	}
	std::vector<std::shared_ptr<AugmentInfo>> getAugmentsBySpellNameAndType(const std::string &spellName, Augment_t augmentType) const {
		std::vector<std::shared_ptr<AugmentInfo>> augments;
		for (const auto &augment : items[id].augments) {
			if (strcasecmp(augment->spellName.c_str(), spellName.c_str()) == 0 && augment->type == augmentType) {
				augments.push_back(augment);
			}
		}

		return augments;
	}
	std::vector<std::shared_ptr<AugmentInfo>> getAugmentsBySpellName(const std::string &spellName) const {
		std::vector<std::shared_ptr<AugmentInfo>> augments;
		for (const auto &augment : items[id].augments) {
			if (strcasecmp(augment->spellName.c_str(), spellName.c_str()) == 0) {
				augments.push_back(augment);
			}
		}

		return augments;
	}
	uint8_t getImbuementSlot() const {
		if (hasAttribute(ItemAttribute_t::IMBUEMENT_SLOT)) {
			return getAttribute<uint8_t>(ItemAttribute_t::IMBUEMENT_SLOT);
		}
		return items[id].imbuementSlot;
	}
	int32_t getSlotPosition() const {
		return items[id].slotPosition;
	}
	int8_t getHitChance() const {
		if (hasAttribute(ItemAttribute_t::HITCHANCE)) {
			return getAttribute<int8_t>(ItemAttribute_t::HITCHANCE);
		}
		return items[id].hitChance;
	}

	uint32_t getWorth() const;
	uint32_t getForgeSlivers() const;
	uint32_t getForgeCores() const;
	LightInfo getLightInfo() const;

	bool hasProperty(ItemProperty prop) const;
	bool isBlocking() const {
		return items[id].blockSolid;
	}
	bool isStackable() const {
		return items[id].stackable;
	}
	bool isStowable() const {
		return items[id].stackable && items[id].wareId > 0;
	}
	bool isAlwaysOnTop() const {
		return items[id].alwaysOnTopOrder != 0;
	}
	bool isGroundTile() const {
		return items[id].isGroundTile();
	}
	bool isMagicField() const {
		return items[id].isMagicField();
	}
	bool isWrapContainer() const {
		return items[id].wrapContainer;
	}
	bool isMovable() const {
		return items[id].movable;
	}
	bool isCorpse() const {
		return items[id].isCorpse;
	}
	bool isPickupable() const {
		return items[id].pickupable;
	}
	bool isMultiUse() const {
		return items[id].multiUse;
	}
	bool isHangable() const {
		return items[id].isHangable;
	}
	bool isRotatable() const {
		return items[id].rotatable && items[id].rotateTo;
	}
	bool isPodium() const {
		return items[id].isPodium;
	}
	bool isWrapable() const {
		return items[id].wrapable && items[id].wrapableTo;
	}
	bool isRing() const {
		return items[id].isRing();
	}
	bool isAmulet() const {
		return items[id].isAmulet();
	}
	bool isAmmo() const {
		return items[id].isAmmo();
	}
	bool hasWalkStack() const {
		return items[id].walkStack;
	}
	bool isQuiver() const {
		return items[id].isQuiver();
	}
	bool isShield() const {
		return items[id].isShield();
	}
	bool isWand() const {
		return items[id].isWand();
	}
	bool isSpellBook() const {
		return items[id].isSpellBook();
	}
	bool isLadder() const {
		return items[id].isLadder();
	}
	bool isDummy() const {
		return items[id].isDummy();
	}
	bool isCarpet() const {
		return items[id].isCarpet();
	}
	bool canReceiveAutoCarpet() const {
		return isBlocking() && isAlwaysOnTop() && !items[id].hasHeight;
	}
	bool canBeUsedByGuests() const {
		return isDummy() || items[id].m_canBeUsedByGuests;
	}

	bool isDecayDisabled() const {
		return decayDisabled;
	}

	const std::string &getName() const {
		if (hasAttribute(ItemAttribute_t::NAME)) {
			return getString(ItemAttribute_t::NAME);
		}
		return items[id].name;
	}
	std::string getPluralName() const {
		if (hasAttribute(ItemAttribute_t::PLURALNAME)) {
			return getString(ItemAttribute_t::PLURALNAME);
		}
		return items[id].getPluralName();
	}
	const std::string &getArticle() const {
		if (hasAttribute(ItemAttribute_t::ARTICLE)) {
			return getString(ItemAttribute_t::ARTICLE);
		}
		return items[id].article;
	}

	uint8_t getStackSize() const {
		if (isStackable()) {
			return items[id].stackSize;
		}
		return 1;
	}

	// get the number of items
	uint16_t getItemCount() const {
		return count;
	}
	// Get item total amount
	uint32_t getItemAmount() const {
		return count;
	}
	void setItemCount(uint8_t n) {
		count = n;
	}

	static uint32_t countByType(const std::shared_ptr<Item> &item, int32_t subType) {
		if (!item) {
			return 0;
		}

		if (subType == -1 || subType == item->getSubType()) {
			return item->getItemCount();
		}

		return 0;
	}

	void setDefaultSubtype();
	uint16_t getSubType() const;
	bool isItemStorable() const;
	void setSubType(uint16_t n);
	void addUniqueId(uint16_t uniqueId);

	void setDefaultDuration() {
		const uint32_t duration = getDefaultDuration();
		if (duration != 0) {
			setDuration(duration);
		}
	}
	uint32_t getDefaultDuration() const {
		return items[id].decayTime * 1000;
	}

	bool canDecay();

	virtual bool canRemove() const {
		return true;
	}
	virtual bool canTransform() const {
		return true;
	}
	virtual void onRemoved();
	virtual void onTradeEvent(TradeEvents_t, const std::shared_ptr<Player> &) { }

	virtual void startDecaying();
	virtual void stopDecaying();

	std::shared_ptr<Item> transform(uint16_t itemId, uint16_t itemCount = -1);

	bool isLoadedFromMap() const {
		return loadedFromMap;
	}

	bool isCleanable() const {
		return !loadedFromMap && canRemove() && isPickupable() && !hasAttribute(ItemAttribute_t::UNIQUEID) && !hasAttribute(ItemAttribute_t::ACTIONID);
	}

	bool hasMarketAttributes() const;

	std::shared_ptr<Cylinder> getParent() override {
		return m_parent.lock();
	}
	void setParent(std::weak_ptr<Cylinder> cylinder) override {
		m_parent = cylinder;
	}
	void resetParent() {
		m_parent.reset();
	}
	std::shared_ptr<Cylinder> getTopParent();
	std::shared_ptr<Tile> getTile() override;
	bool isRemoved() override;

	bool isInsideDepot(bool includeInbox = false);

	/**
	 * @brief Get the Imbuement Info object
	 *
	 * @param slot
	 * @param imbuementInfo (Imbuement *imbuement, uint32_t duration = 0)
	 * @return true = duration is > 0 (info >> 8)
	 * @return false
	 */
	bool getImbuementInfo(uint8_t slot, ImbuementInfo* imbuementInfo) const;
	void addImbuement(uint8_t slot, uint16_t imbuementId, uint32_t duration);
	/**
	 * @brief Decay imbuement time duration, only use this for decay the imbuement time
	 *
	 * @param slot Slot id to decay
	 * @param imbuementId Imbuement id to decay
	 * @param duration New duration
	 */
	void decayImbuementTime(uint8_t slot, uint16_t imbuementId, uint32_t duration) {
		return setImbuement(slot, imbuementId, duration);
	}
	void clearImbuement(uint8_t slot, uint16_t imbuementId) {
		return setImbuement(slot, imbuementId, 0);
	}
	bool hasImbuementType(ImbuementTypes_t imbuementType, uint16_t imbuementTier) const {
		const auto it = items[id].imbuementTypes.find(imbuementType);
		if (it != items[id].imbuementTypes.end()) {
			return (it->second >= imbuementTier);
		}
		return false;
	}
	bool hasImbuementCategoryId(uint16_t categoryId) const;
	bool hasImbuementAttribute(const std::string &attributeSlot) const;
	bool hasImbuements() const {
		for (uint8_t slotid = 0; slotid < getImbuementSlot(); slotid++) {
			ImbuementInfo imbuementInfo;
			if (getImbuementInfo(slotid, &imbuementInfo)) {
				return true;
			}
		}

		return false;
	}

	double getDodgeChance() const;

	double getFatalChance() const;

	double getMomentumChance() const;

	double getTranscendenceChance() const;

	uint8_t getTier() const;
	void setTier(uint8_t tier);
	uint8_t getClassification() const {
		return items[id].upgradeClassification;
	}

	void updateTileFlags();
	bool canBeMoved() const;
	void checkDecayMapItemOnMove();

	void setActor(bool value) {
		m_hasActor = value;
	}

	bool hasActor() const {
		return m_hasActor;
	}

protected:
	std::weak_ptr<Cylinder> m_parent;

	uint16_t id; // the same id as in ItemType
	uint8_t count = 1; // number of stacked items

	bool loadedFromMap = false;
	bool isLootTrackeable = false;
	bool decayDisabled = false;
	bool m_hasActor = false;

private:
	void setImbuement(uint8_t slot, uint16_t imbuementId, uint32_t duration);
	// Don't add variables here, use the ItemAttribute class.
	std::string getWeightDescription(uint32_t weight) const;

	friend class Decay;
	friend class MapCache;
};

using ItemList = std::list<std::shared_ptr<Item>>;
using ItemDeque = std::deque<std::shared_ptr<Item>>;
using StashContainerList = std::vector<std::pair<std::shared_ptr<Item>, uint32_t>>;
