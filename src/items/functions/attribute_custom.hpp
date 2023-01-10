/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_ITEMS_FUNCTIONS_ATTRIBUTE_CUSTOM_HPP_
#define SRC_ITEMS_FUNCTIONS_ATTRIBUTE_CUSTOM_HPP_

class CustomAttribute {
public:
	CustomAttribute();
	~CustomAttribute();
	CustomAttribute(const std::string &initStringKey, const std::int64_t &initInt64Value);
	CustomAttribute(const std::string &initStringKey, const std::string &initStringValue);
	CustomAttribute(const std::string &initStringKey, const double &initDoubleValue);
	CustomAttribute(const std::string &initStringKey, const bool &initBoolValue);

	const std::string &getStringKey() const;

	const std::int64_t &getInt64Value() const;
	const std::string &getStringValue() const;
	const double &getDoubleValue() const;
	const bool &getBoolValue() const;

	void pushToLua(lua_State* L) const;
private:
	std::string stringKey;

	int64_t int64Value = 0;
	std::string stringValue;
	double doubleValue = 0;
	bool boolValue = false;
};

#endif //  SRC_ITEMS_FUNCTIONS_ATTRIBUTE_CUSTOM_HPP_