/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_ITEMS_FUNCTIONS_ITEM_CUSTOM_ATTRIBUTE_HPP_
#define SRC_ITEMS_FUNCTIONS_ITEM_CUSTOM_ATTRIBUTE_HPP_

#include "io/fileloader.h"

class CustomAttribute {
	public:
		CustomAttribute();
		~CustomAttribute();

		CustomAttribute(const std::string &initStringKey, const int64_t initInt64Value);
		CustomAttribute(const std::string &initStringKey, const std::string &initStringValue);
		CustomAttribute(const std::string &initStringKey, const double initDoubleValue);
		CustomAttribute(const std::string &initStringKey, const bool initBoolValue);

		const std::string &getStringKey() const;

		template <typename T>
		T getAttribute() const {
			if constexpr (std::is_same_v<T, std::string>) {
				return getString();
			} else if constexpr (std::is_same_v<T, double>) {
				return getDouble();
			} else if constexpr (std::is_same_v<T, bool>) {
				return getBool();
			} else {
				return std::clamp(
					static_cast<T>(getInteger()),
					std::numeric_limits<T>::min(),
					std::numeric_limits<T>::max()
				);
			}
			return {};
		}

		const int64_t &getInteger() const;
		const std::string &getString() const;
		const double &getDouble() const;
		const bool &getBool() const;

		void setValue(const int64_t newValue) {
			if (std::holds_alternative<int64_t>(value)) {
				value = newValue;
			}
		}
		void setValue(const std::string &newValue) {
			if (std::holds_alternative<std::string>(value)) {
				value = newValue;
			}
		}
		void setValue(const double newValue) {
			if (std::holds_alternative<double>(value)) {
				value = newValue;
			}
		}
		void setValue(const bool newValue) {
			if (std::holds_alternative<bool>(value)) {
				value = newValue;
			}
		}

		template <typename T>
		bool hasValue() const {
			return std::holds_alternative<T>(value);
		}

		void pushToLua(lua_State* L) const;

		void serialize(PropWriteStream &propWriteStream) const;
		bool unserialize(PropStream &propStream, const std::string &function);

	private:
		std::string stringKey;

		std::variant<int64_t, std::string, double, bool> value;
};

#endif //  SRC_ITEMS_FUNCTIONS_CUSTOM_ATTRIBUTE_HPP_
