/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_ITEMS_FUNCTIONS_ITEM_ATTRIBUTE_HPP
#define SRC_ITEMS_FUNCTIONS_ITEM_ATTRIBUTE_HPP

#include "enums/item_attribute.hpp"
#include "items/functions/item/custom_attribute.hpp"
#include "utils/tools.h"

class ItemAttributeHelper
{
public:
	bool isIntAttrType(ItemAttribute_t type) const
	{
		std::underlying_type_t<ItemAttribute_t> checkTypes = 0;
		checkTypes |= ItemAttribute_t::ACTIONID;
		checkTypes |= ItemAttribute_t::UNIQUEID;
		checkTypes |= ItemAttribute_t::DATE;
		checkTypes |= ItemAttribute_t::WEIGHT;
		checkTypes |= ItemAttribute_t::ATTACK;
		checkTypes |= ItemAttribute_t::DEFENSE;
		checkTypes |= ItemAttribute_t::EXTRADEFENSE;
		checkTypes |= ItemAttribute_t::ARMOR;
		checkTypes |= ItemAttribute_t::HITCHANCE;
		checkTypes |= ItemAttribute_t::SHOOTRANGE;
		checkTypes |= ItemAttribute_t::OWNER;
		checkTypes |= ItemAttribute_t::DURATION;
		checkTypes |= ItemAttribute_t::DECAYSTATE;
		checkTypes |= ItemAttribute_t::CORPSEOWNER;
		checkTypes |= ItemAttribute_t::CHARGES;
		checkTypes |= ItemAttribute_t::FLUIDTYPE;
		checkTypes |= ItemAttribute_t::DOORID;
		checkTypes |= ItemAttribute_t::IMBUEMENT_SLOT;
		checkTypes |= ItemAttribute_t::OPENCONTAINER;
		checkTypes |= ItemAttribute_t::QUICKLOOTCONTAINER;
		checkTypes |= ItemAttribute_t::DURATION_TIMESTAMP;
		checkTypes |= ItemAttribute_t::TIER;
		return (type & static_cast<ItemAttribute_t>(checkTypes)) != 0;
	}

	bool isStrAttrType(ItemAttribute_t type) const
	{
		std::underlying_type_t<ItemAttribute_t> checkTypes = 0;
		checkTypes |= ItemAttribute_t::DESCRIPTION;
		checkTypes |= ItemAttribute_t::TEXT;
		checkTypes |= ItemAttribute_t::WRITER;
		checkTypes |= ItemAttribute_t::NAME;
		checkTypes |= ItemAttribute_t::ARTICLE;
		checkTypes |= ItemAttribute_t::PLURALNAME;
		checkTypes |= ItemAttribute_t::SPECIAL;
		return (type & static_cast<ItemAttribute_t>(checkTypes)) != 0;
	}
};

struct Attributes : public ItemAttributeHelper
{
	explicit Attributes(ItemAttribute_t type) : type(type) {
		memset(&value, 0, sizeof(value));
	}
	Attributes(const Attributes& i) {
		type = i.type;
		if (isIntAttrType(type)) {
			value.integer = i.value.integer;
		} else if (isStrAttrType(type)) {
			value.string = new std::string(*i.value.string);
		} else {
			memset(&value, 0, sizeof(value));
		}
	}
	Attributes(Attributes&& attribute) noexcept : value(attribute.value), type(attribute.type) {
		memset(&attribute.value, 0, sizeof(value));
		attribute.type = ItemAttribute_t::NONE;
	}
	Attributes& operator=(Attributes&& other) noexcept {
		if (this != &other) {
			if (isStrAttrType(type)) {
				delete value.string;
			}

			value = other.value;
			type = other.type;

			memset(&other.value, 0, sizeof(value));
			other.type = ItemAttribute_t::NONE;
		}
		return *this;
	}
	~Attributes() {
		if (isStrAttrType(type)) {
			delete value.string;
		}
	}

	const ItemAttribute_t &getAttributeType() const;

	ItemAttribute_t type;

	union {
		int64_t integer;
		std::string* string;
	} value;
};

class ItemAttribute : public ItemAttributeHelper
{
public:
	ItemAttribute() = default;

	// CustomAttribute map methods
	const std::map<std::string, CustomAttribute, std::less<>>& getCustomAttributeMap() const;
	// CustomAttribute object methods
	const CustomAttribute* getCustomAttribute(const std::string& attributeName) const;
	
	void setCustomAttribute(const std::string &key, int64_t value);
	void setCustomAttribute(const std::string &key, std::string value);
	void setCustomAttribute(const std::string &key, double value);
	void setCustomAttribute(const std::string &key, bool value);

	void addCustomAttribute(const std::string &key, const CustomAttribute &customAttribute);
	bool removeCustomAttribute(const std::string& attributeName);

	void setAttribute(ItemAttribute_t type, int64_t value);
	void setAttribute(ItemAttribute_t type, const std::string &value);
	bool removeAttribute(ItemAttribute_t type);

	const std::string& getAttributeString(ItemAttribute_t type) const;
	const int64_t& getAttributeValue(ItemAttribute_t type) const;

	const std::underlying_type_t<ItemAttribute_t>& getAttributeBits() const {
		return attributeBits;
	}
	const std::vector<Attributes>& getAttributeVector() const {
		return attributeVector;
	}

	bool hasAttribute(ItemAttribute_t type) const {
		return (type & static_cast<ItemAttribute_t>(attributeBits)) != 0;
	}

	const Attributes* getAttribute(ItemAttribute_t type) const;

	Attributes& getAttributesByType(ItemAttribute_t type);

	void setSpecialDescription(const std::string& desc) {
		setAttribute(ItemAttribute_t::DESCRIPTION, desc);
	}
	const std::string& getSpecialDescription() const {
		return getAttributeString(ItemAttribute_t::DESCRIPTION);
	}

	void setText(const std::string& text) {
		setAttribute(ItemAttribute_t::TEXT, text);
	}
	void resetText() {
		removeAttribute(ItemAttribute_t::TEXT);
	}
	const std::string& getText() const {
		return getAttributeString(ItemAttribute_t::TEXT);
	}

	void setDate(int32_t n) {
		setAttribute(ItemAttribute_t::DATE, n);
	}
	void resetDate() {
		removeAttribute(ItemAttribute_t::DATE);
	}
	time_t getDate() const {
		return getAttributeValue(ItemAttribute_t::DATE);
	}

	void setWriter(const std::string& writer) {
		setAttribute(ItemAttribute_t::WRITER, writer);
	}
	void resetWriter() {
		removeAttribute(ItemAttribute_t::WRITER);
	}
	const std::string& getWriter() const {
		return getAttributeString(ItemAttribute_t::WRITER);
	}

	void setActionId(uint16_t n) {
		setAttribute(ItemAttribute_t::ACTIONID, n);
	}
	uint16_t getActionId() const {
		return static_cast<uint16_t>(getAttributeValue(ItemAttribute_t::ACTIONID));
	}

	void setUniqueId(uint16_t n) {
		setAttribute(ItemAttribute_t::UNIQUEID, n);
	}
	uint16_t getUniqueId() const {
		return static_cast<uint16_t>(getAttributeValue(ItemAttribute_t::UNIQUEID));
	}

	void setCharges(uint16_t n) {
		setAttribute(ItemAttribute_t::CHARGES, n);
	}
	uint16_t getCharges() const {
		return static_cast<uint16_t>(getAttributeValue(ItemAttribute_t::CHARGES));
	}

	void setFluidType(uint16_t n) {
		setAttribute(ItemAttribute_t::FLUIDTYPE, n);
	}
	uint16_t getFluidType() const {
		return static_cast<uint16_t>(getAttributeValue(ItemAttribute_t::FLUIDTYPE));
	}

	void setOwner(uint32_t owner) {
		setAttribute(ItemAttribute_t::OWNER, owner);
	}
	uint32_t getOwner() const {
		return static_cast<uint32_t>(getAttributeValue(ItemAttribute_t::OWNER));
	}

	void setCorpseOwner(uint32_t corpseOwner) {
		setAttribute(ItemAttribute_t::CORPSEOWNER, corpseOwner);
	}
	uint32_t getCorpseOwner() const {
		return static_cast<uint32_t>(getAttributeValue(ItemAttribute_t::CORPSEOWNER));
	}

	void setRewardCorpse() {
		setCorpseOwner(static_cast<uint32_t>(std::numeric_limits<int32_t>::max()));
	}
	bool isRewardCorpse() const {
		return getCorpseOwner() == static_cast<uint32_t>(std::numeric_limits<int32_t>::max());
	}

	void setDuration(int32_t time) {
		setAttribute(ItemAttribute_t::DURATION, std::max<int32_t>(0, time));
	}
	void setDurationTimestamp(int64_t timestamp) {
		setAttribute(ItemAttribute_t::DURATION_TIMESTAMP, timestamp);
	}
	int32_t getDuration() const {
		ItemDecayState_t decayState = getDecaying();
		if (decayState == DECAYING_TRUE || decayState == DECAYING_STOPPING) {
			return std::max<int32_t>(0, static_cast<int32_t>(getAttributeValue(ItemAttribute_t::DURATION_TIMESTAMP) -OTSYS_TIME()));
		} else {
			return static_cast<int32_t>(getAttributeValue(ItemAttribute_t::DURATION));
		}
	}

	void setDecaying(ItemDecayState_t decayState) {
		setAttribute(ItemAttribute_t::DECAYSTATE, decayState);
		if (decayState == DECAYING_FALSE) {
			removeAttribute(ItemAttribute_t::DURATION_TIMESTAMP);
		}
	}
	ItemDecayState_t getDecaying() const {
		return static_cast<ItemDecayState_t>(getAttributeValue(ItemAttribute_t::DECAYSTATE));
	}

private:
	std::map<std::string, CustomAttribute, std::less<>> customAttributeMap;
	std::underlying_type_t<ItemAttribute_t> attributeBits = 0;
	std::vector<Attributes> attributeVector;
};

#endif //  SRC_ITEMS_FUNCTIONS_ITEM_ATTRIBUTE_HPP
