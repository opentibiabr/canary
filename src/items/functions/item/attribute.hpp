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
	ItemAttribute() {}

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

private:
	// Singleton - ensures we don't accidentally copy it.
	ItemAttribute(const ItemAttribute&) = delete;
	ItemAttribute& operator=(const ItemAttribute&) = delete;

	std::map<std::string, CustomAttribute, std::less<>> customAttributeMap;
	std::underlying_type_t<ItemAttribute_t> attributeBits = 0;
	std::vector<Attributes> attributeVector;
};

#endif //  SRC_ITEMS_FUNCTIONS_ITEM_ATTRIBUTE_HPP
