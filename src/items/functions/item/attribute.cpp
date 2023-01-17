/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "items/functions/item/attribute.hpp"

/*
=============================
* ItemAttribute class (Attributes methods)
=============================
*/
const std::string& ItemAttribute::getAttributeString(ItemAttribute_t type) const {
	if (!isStrAttrType(type)) {
		return {};
	}

	auto attribute = getAttribute(type);
	if (!attribute) {
		return {};
	}

	return *attribute->value.string;
}

int64_t ItemAttribute::getAttributeValue(ItemAttribute_t type) const {
	if (!isIntAttrType(type)) {
		return 0;
	}

	auto attribute = getAttribute(type);
	if (!attribute) {
		return 0;
	}

	return attribute->value.integer;
}

const Attributes* ItemAttribute::getAttribute(ItemAttribute_t type) const
{
	if (hasAttribute(type)) {
		for (const Attributes& attribute : attributeVector) {
			if (attribute.type == type) {
				return &attribute;
			}
		}
	}
	return nullptr;
}

Attributes& ItemAttribute::getAttributesByType(ItemAttribute_t type)
{
	if (hasAttribute(type)) {
		for (Attributes& attribute : attributeVector) {
			if (attribute.type == type) {
				return attribute;
			}
		}
	}

	attributeBits |= type;
	attributeVector.emplace_back(type);
	return attributeVector.back();
}

void ItemAttribute::setAttribute(ItemAttribute_t type, int64_t value) {
	if (!isIntAttrType(type)) {
		return;
	}

	getAttributesByType(type).value.integer = std::move(value);
}

void ItemAttribute::setAttribute(ItemAttribute_t type, const std::string &value) {
	if (!isStrAttrType(type)) {
		return;
	}

	if (value.empty()) {
		return;
	}

	Attributes& attr = getAttributesByType(type);
	delete attr.value.string;
	attr.value.string = new std::string(value);
}

bool ItemAttribute::removeAttribute(ItemAttribute_t type)
{
	if (!hasAttribute(type)) {
		return false;
	}

	for (auto it = attributeVector.begin(), end = attributeVector.end(); it != end; ++it) {
		if ((*it).type == type) {
			(*it) = std::move(attributeVector.back());
			attributeVector.pop_back();
			break;
		}
	}
	attributeBits &= ~type;
	return true;
}

/*
=============================
* CustomAttribute map methods
=============================
*/
const std::map<std::string, CustomAttribute, std::less<>>& ItemAttribute::getCustomAttributeMap() const
{
	return customAttributeMap;
}

/*
=============================
* CustomAttribute object methods
=============================
*/
const CustomAttribute* ItemAttribute::getCustomAttribute(const std::string& attributeName) const
{
	if (customAttributeMap.contains(asLowerCaseString(attributeName)))
	{
		return &customAttributeMap.at(asLowerCaseString(attributeName));
	}
	return nullptr;
}

void ItemAttribute::setCustomAttribute(const std::string &key, int64_t value) {
	CustomAttribute attribute(key, std::move(value));
	customAttributeMap[asLowerCaseString(key)] = std::move(attribute);
}

void ItemAttribute::setCustomAttribute(const std::string &key, std::string value) {
	CustomAttribute attribute(key, std::move(value));
	customAttributeMap[asLowerCaseString(key)] = std::move(attribute);
}

void ItemAttribute::setCustomAttribute(const std::string &key, double value) {
	CustomAttribute attribute(key, std::move(value));
	customAttributeMap[asLowerCaseString(key)] = std::move(attribute);
}

void ItemAttribute::setCustomAttribute(const std::string &key, bool value) {
	CustomAttribute attribute(key, std::move(value));
	customAttributeMap[asLowerCaseString(key)] = std::move(attribute);
}

void ItemAttribute::addCustomAttribute(const std::string &key, const CustomAttribute &customAttribute)
{
	customAttributeMap[asLowerCaseString(key)] = customAttribute;
}

bool ItemAttribute::removeCustomAttribute(const std::string& attributeName)
{
	auto it = customAttributeMap.find(asLowerCaseString(attributeName));
	if (it == customAttributeMap.end()) {
		return false;
	}

	customAttributeMap.erase(it);
	return true;
}
