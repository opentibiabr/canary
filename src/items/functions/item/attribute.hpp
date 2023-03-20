/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_ITEMS_FUNCTIONS_ITEM_ATTRIBUTE_HPP
#define SRC_ITEMS_FUNCTIONS_ITEM_ATTRIBUTE_HPP

#include "enums/item_attribute.hpp"
#include "items/functions/item/custom_attribute.hpp"
#include "utils/tools.h"

class ItemAttributeHelper {
	public:
		bool isAttributeInteger(ItemAttribute_t type) const {
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
			checkTypes |= ItemAttribute_t::AMOUNT;
			return (type & static_cast<ItemAttribute_t>(checkTypes)) != 0;
		}

		bool isAttributeString(ItemAttribute_t type) const {
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
			if (isAttributeInteger(attributeType)) {
				return 0;
			} else if (isAttributeString(attributeType)) {
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

		const std::shared_ptr<std::string> &getString() const {
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

		const std::underlying_type_t<ItemAttribute_t> &getAttributeBits() const {
			return attributeBits;
		}
		const std::vector<Attributes> &getAttributeVector() const {
			return attributeVector;
		}

		bool hasAttribute(ItemAttribute_t type) const {
			return (type & static_cast<ItemAttribute_t>(attributeBits)) != 0;
		}

		const Attributes* getAttribute(ItemAttribute_t type) const;

		Attributes &getAttributesByType(ItemAttribute_t type);

	private:
		// Singleton - ensures we don't accidentally copy it.
		ItemAttribute(const ItemAttribute &) = delete;
		ItemAttribute &operator=(const ItemAttribute &) = delete;

		std::map<std::string, CustomAttribute, std::less<>> customAttributeMap;
		std::underlying_type_t<ItemAttribute_t> attributeBits = 0;
		std::vector<Attributes> attributeVector;
};

#endif //  SRC_ITEMS_FUNCTIONS_ITEM_ATTRIBUTE_HPP
