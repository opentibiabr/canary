/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "enums/item_attribute.hpp"
#include "items/functions/item/custom_attribute.hpp"
#include "utils/tools.hpp"

class ItemAttributeHelper {
public:
	bool isAttributeInteger(ItemAttribute_t type) const {
		switch (type) {
			case ItemAttribute_t::STORE:
			case ItemAttribute_t::ACTIONID:
			case ItemAttribute_t::UNIQUEID:
			case ItemAttribute_t::DATE:
			case ItemAttribute_t::WEIGHT:
			case ItemAttribute_t::ATTACK:
			case ItemAttribute_t::DEFENSE:
			case ItemAttribute_t::EXTRADEFENSE:
			case ItemAttribute_t::ARMOR:
			case ItemAttribute_t::HITCHANCE:
			case ItemAttribute_t::SHOOTRANGE:
			case ItemAttribute_t::OWNER:
			case ItemAttribute_t::DURATION:
			case ItemAttribute_t::DECAYSTATE:
			case ItemAttribute_t::CORPSEOWNER:
			case ItemAttribute_t::CHARGES:
			case ItemAttribute_t::FLUIDTYPE:
			case ItemAttribute_t::DOORID:
			case ItemAttribute_t::IMBUEMENT_SLOT:
			case ItemAttribute_t::OPENCONTAINER:
			case ItemAttribute_t::QUICKLOOTCONTAINER:
			case ItemAttribute_t::DURATION_TIMESTAMP:
			case ItemAttribute_t::TIER:
			case ItemAttribute_t::AMOUNT:
				return true;
			default:
				return false;
		}
	}

	bool isAttributeString(ItemAttribute_t type) const {
		switch (type) {
			case ItemAttribute_t::DESCRIPTION:
			case ItemAttribute_t::TEXT:
			case ItemAttribute_t::WRITER:
			case ItemAttribute_t::NAME:
			case ItemAttribute_t::ARTICLE:
			case ItemAttribute_t::PLURALNAME:
			case ItemAttribute_t::SPECIAL:
			case ItemAttribute_t::LOOTMESSAGE_SUFFIX:
			case ItemAttribute_t::STORE_INBOX_CATEGORY:
				return true;
			default:
				return false;
		}
	}
};

class Attributes : public ItemAttributeHelper {
public:
	explicit Attributes(ItemAttribute_t type) :
		type(type), value(getDefaultValueForType(type)) { }
	~Attributes() = default;

	Attributes(const Attributes &i) :
		type(i.type), value(i.value) { }
	Attributes(Attributes &&attribute) noexcept :
		type(attribute.type), value(std::move(attribute.value)) { }

	Attributes &operator=(Attributes &&other) noexcept {
		type = other.type;
		value = std::move(other.value);
		return *this;
	}

	const ItemAttribute_t &getAttributeType() const {
		return type;
	}

	std::variant<int64_t, std::shared_ptr<std::string>> getDefaultValueForType(ItemAttribute_t attributeType) const {
		ItemAttributeHelper helper;
		if (helper.isAttributeInteger(attributeType)) {
			return 0;
		} else if (helper.isAttributeString(attributeType)) {
			return std::make_shared<std::string>();
		} else {
			return {};
		}
	}

	void setValue(int64_t newValue) {
		if (std::holds_alternative<int64_t>(value)) {
			value = newValue;
		}
	}
	void setValue(const std::string &newValue) {
		if (std::holds_alternative<std::shared_ptr<std::string>>(value)) {
			value = std::make_shared<std::string>(newValue);
		}
	}
	const int64_t &getInteger() const {
		if (std::holds_alternative<int64_t>(value)) {
			return std::get<int64_t>(value);
		}
		static int64_t emptyValue;
		return emptyValue;
	}

	const std::shared_ptr<std::string> getString() const {
		if (std::holds_alternative<std::shared_ptr<std::string>>(value)) {
			return std::get<std::shared_ptr<std::string>>(value);
		}
		static std::shared_ptr<std::string> emptyPtr;
		return emptyPtr;
	}

private:
	ItemAttribute_t type;
	std::variant<int64_t, std::shared_ptr<std::string>> value;
};

class ItemAttribute : public ItemAttributeHelper {
public:
	ItemAttribute() = default;

	// CustomAttribute map methods
	const std::map<std::string, CustomAttribute, std::less<>> &getCustomAttributeMap() const;
	// CustomAttribute object methods
	const CustomAttribute* getCustomAttribute(const std::string &attributeName) const;

	void setCustomAttribute(const std::string &key, const int64_t value);
	void setCustomAttribute(const std::string &key, const std::string &value);
	void setCustomAttribute(const std::string &key, const double value);
	void setCustomAttribute(const std::string &key, const bool value);

	void addCustomAttribute(const std::string &key, const CustomAttribute &customAttribute);
	bool removeCustomAttribute(const std::string &attributeName);

	void setAttribute(ItemAttribute_t type, int64_t value);
	void setAttribute(ItemAttribute_t type, const std::string &value);
	bool removeAttribute(ItemAttribute_t type);

	const std::string &getAttributeString(ItemAttribute_t type) const;
	const int64_t &getAttributeValue(ItemAttribute_t type) const;

	const std::vector<Attributes> &getAttributeVector() const {
		return attributeVector;
	}

	bool hasAttribute(ItemAttribute_t type) const {
		for (const auto &attr : attributeVector) {
			if (attr.getAttributeType() == type) {
				return true;
			}
		}
		return false;
	}

	const Attributes* getAttribute(ItemAttribute_t type) const;

	Attributes &getAttributesByType(ItemAttribute_t type);

private:
	std::map<std::string, CustomAttribute, std::less<>> customAttributeMap;
	std::vector<Attributes> attributeVector;
};
