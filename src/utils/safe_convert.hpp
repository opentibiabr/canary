/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <lib/logging/log_with_spd_log.hpp>

/**
 * @brief Returns a default value for a given type T.
 *
 * If T is an arithmetic type, the default value is 0. For non-arithmetic types,
 * the default value is constructed using T's default constructor.
 *
 * @tparam T The type for which the default value is required.
 * @return The default value for type T.
 */
template <typename T>
constexpr T get_default_value() {
	if constexpr (std::is_arithmetic_v<T>) {
		return T(0);
	} else {
		return T();
	}
}

/**
 * @brief Converts a numeric value to its string representation.
 *
 * This function uses std::to_chars for conversion, which is a modern and efficient
 * way to convert numbers to strings. It handles the conversion of integral and
 * floating-point types to a string. If the conversion fails, an error is logged.
 *
 * @tparam U The numeric type to be converted to a string.
 * @param value The numeric value to convert.
 * @return A string representation of the numeric value.
 */
template <typename U>
std::string number_to_string(U value) {
	std::string result(std::numeric_limits<U>::digits10 + 2, '\0');
	auto [ptr, ec] = std::to_chars(result.data(), result.data() + result.size(), value);
	if (ec == std::errc()) {
		result.resize(ptr - result.data());
		return result;
	}
	g_logger().error("[{}] - Conversion failed", __FUNCTION__);
}

/**
 * @brief Safely converts a value of one type to another, handling potential overflow, underflow, and other edge cases.
 *
 * This template function provides a safe way to convert values between different types, especially useful for arithmetic
 * and string conversions. It includes checks for overflow, underflow, loss of precision, and non-finite floating-point values.
 *
 * @tparam T The target type to which the value is to be converted.
 * @tparam U The source type from which the value is to be converted.
 * @param value The value to be converted.
 * @param callerName An optional string representing the name of the function or context calling this conversion. Default is "Name not defined".
 * @param defaultValue The default value to return in case of an unsuccessful conversion. Default is constructed using get_default_value<T>().
 * @return The converted value of type T, or defaultValue if the conversion is not possible or safe.
 *
 * @note This function uses static assertions and compile-time checks to handle different types of conversions, including edge cases.
 *
 * @example
 * double num = safe_convert<double>("123.45");
 * std::string str = safe_convert<std::string>(123);
 * int integer = safe_convert<int>("invalid", __FUNCTION__, -1); // Returns -1
 */
template <typename T, typename U>
	requires(std::is_arithmetic_v<T> && !std::is_enum_v<U>) || (!std::is_enum_v<U> && std::is_same_v<T, std::string>)
T safe_convert(U value, std::string_view callerName, T defaultValue = get_default_value<T>()) {
	static_assert(std::is_arithmetic_v<T> || std::is_same_v<T, std::string>, "T must be an arithmetic type or string.");
	// static_assert( sizeof(T) >= sizeof(U), "Erro: Conversão para um tipo menor não é permitida.");

	try {
		// Direct conversion if types are the same
		if constexpr (std::is_same_v<U, T>) {
			return value;
		} else {
			// String conversion to arithmetic type
			if constexpr (std::is_same_v<U, std::string> && std::is_arithmetic_v<T>) {
				T result;
				auto [ptr, ec] = std::from_chars(value.data(), value.data() + value.size(), result);
				if (ec == std::errc::invalid_argument || ec == std::errc::result_out_of_range) {
					return defaultValue;
				}
				return result;
			}
			// Arithmetic type conversion to string
			else if constexpr (std::is_arithmetic_v<U> && std::is_same_v<T, std::string>) {
				return number_to_string(value);
			}
			// Generic conversion to convertible types
			else if constexpr (std::is_convertible_v<U, T>) {
				// Checking for Floating Point Extrema
				if constexpr (std::is_floating_point_v<U>) {
					if (!std::isfinite(value)) {
						g_logger().error("[{}] - Function: {}. Non-finite floating point value detected. Value: {}, Type T: {}, Type value: {}", __FUNCTION__, callerName, value, typeid(T).name(), typeid(U).name());
						return defaultValue;
					}
				}
				// Check for conversion between types with different signs
				else if constexpr (std::is_integral_v<U> && std::is_integral_v<T> && (std::is_signed_v<U> != std::is_signed_v<T>)) {
					if (std::is_signed_v<U> && value < 0 && (callerName != "RSA::decodeLength" && callerName != "RSA::readHexString") || std::is_unsigned_v<U> && value > static_cast<U>(std::numeric_limits<T>::max()) && (callerName != "RSA::decodeLength" && callerName != "RSA::readHexString")) {
						g_logger().error("[{}] - Function: {}. Signed/Unsigned conversion overflow detected. Max: {}, Min: {}, Value: {}, Type T: {}, Type value: {}", __FUNCTION__, callerName, std::numeric_limits<T>::max(), std::numeric_limits<T>::min(), static_cast<int>(value), typeid(T).name(), typeid(U).name());
						return defaultValue;
					}
				}
				// Check for loss of precision in floating point conversions
				else if constexpr (std::is_floating_point_v<U> && std::is_floating_point_v<T> && sizeof(U) > sizeof(T)) {
					if (value > static_cast<U>(std::numeric_limits<T>::max()) || value < static_cast<U>(std::numeric_limits<T>::min())) {
						g_logger().error("[{}] - Function: {}. Floating point precision loss detected. Max: {}, Min: {}, Value: {}, Type T: {}, Type value: {}", __FUNCTION__, callerName, std::numeric_limits<T>::max(), std::numeric_limits<T>::min(), value, typeid(T).name(), typeid(U).name());
						return defaultValue;
					}
				}
				// Check for floating point to integral conversion
				else if constexpr (std::is_arithmetic_v<U> && std::is_floating_point_v<U> && std::is_integral_v<T>) {
					if (value < static_cast<U>(std::numeric_limits<T>::min()) || value > static_cast<U>(std::numeric_limits<T>::max())) {
						g_logger().error("[{}] - Function: {}. Floating Point to Integral Overflow or Underflow detected. Max: {}, Min: {}, value: {}, Type T: {}, Type value: {}", __FUNCTION__, callerName, std::numeric_limits<T>::max(), std::numeric_limits<T>::min(), value, typeid(T).name(), typeid(U).name());
						return defaultValue;
					}
				}
				// Check for conversion from char to unsigned char
				else if constexpr (std::is_same_v<U, char> && std::is_same_v<T, unsigned char>) {
					if (static_cast<T>(value) != value && (callerName != "RSA::decodeLength" && callerName != "RSA::readHexString")) {
						g_logger().error("[{}] - Function: {}. Char to Unsigned Char Conversion detected. Max: {}, Min: {}, Value: {}, Type T: {}, Type value: {}", __FUNCTION__, callerName, std::numeric_limits<T>::max(), std::numeric_limits<T>::min(), static_cast<int>(value), typeid(T).name(), typeid(U).name());
						return defaultValue;
					}
				}
				// Check for conversion from integral to char
				else if constexpr (std::is_integral_v<U> && std::is_same_v<T, char>) {
					if (static_cast<long long>(value) > static_cast<long long>(std::numeric_limits<T>::max()) && (callerName != "RSA::base64Decrypt") || static_cast<long long>(value) < static_cast<long long>(std::numeric_limits<T>::min()) && (callerName != "RSA::base64Decrypt")) {
						g_logger().error("[{}] - Function: {}. Integral to Char Overflow or Underflow detected. Max: {}, Min: {}, value: {}, Type T: {}, Type value: {}", __FUNCTION__, callerName, static_cast<int>(std::numeric_limits<T>::max()), static_cast<int>(std::numeric_limits<T>::min()), value, typeid(T).name(), typeid(U).name());
						return defaultValue;
					}
				}
				// Overflow check for other non-floating types
				else if constexpr (!std::is_floating_point_v<T> && !std::is_same_v<T, char>) {
					if ((std::is_signed_v<U> && (static_cast<long long>(value) > static_cast<long long>(std::numeric_limits<T>::max()) || static_cast<long long>(value) < static_cast<long long>(std::numeric_limits<T>::min()))) || (std::is_unsigned_v<U> && static_cast<unsigned long long>(value) > static_cast<unsigned long long>(std::numeric_limits<T>::max()))) {
						g_logger().error("[{}] - Function: {}. Non-Floating Point Overflow or Underflow detected. Max: {}, Min: {}, value: {}, Type T: {}, Type value: {}", __FUNCTION__, callerName, std::numeric_limits<T>::max(), std::numeric_limits<T>::min(), value, typeid(T).name(), typeid(U).name());
						return defaultValue;
					}
				}
				return static_cast<T>(value);
			}
			// If conversion is not possible
			else {
				g_logger().error("[{}] - Conversion not possible: Function:{} Type:{} value:{}", __FUNCTION__, callerName, typeid(T).name(), value);
				return defaultValue;
			}
		}
	} catch (const std::exception &e) {
		g_logger().error("[{}] - Conversion failed: Function:{} Target Type = '{}', Original Value = '{}', Exception = '{}'", __FUNCTION__, callerName, typeid(T).name(), value, e.what());
		return defaultValue;
	}
}

/**
 * @brief Converts a value of type U to type T, specifically for enum types.
 *
 * This function handles conversions where the target type T is an enum. It safely casts
 * the value to the target enum type, returning a default value in case of any exceptions.
 *
 * @tparam T The target enum type for the conversion.
 * @tparam U The source type from which to convert.
 * @param value The value to convert.
 * @param callerName The name of the calling function for logging purposes.
 * @param defaultValue The default enum value to return in case of conversion failure.
 * @return The converted enum value of type T, or the default value if conversion fails.
 *
 * @example
 * enum class MyEnum { A, B, C };
 * MyEnum e = safe_convert<MyEnum>(1);
 * MyEnum e2 = safe_convert<MyEnum>("B", __FUNCTION__, MyEnum::A); // Assuming a suitable conversion exists
 * MyEnum e3 = safe_convert<MyEnum>(10, "myFunction", MyEnum::C); // Returns MyEnum::C as default
 */
template <typename T, typename U>
	requires std::is_enum_v<T>
T safe_convert(U value, std::string_view callerName, T defaultValue = T()) {
	try {
		if constexpr (std::is_same_v<U, T>) {
			return value;
		}
		return static_cast<T>(value);
	} catch (const std::exception &e) {
		g_logger().error("[{}] - Conversion failed enum: Function:{} Target Type = '{}', Original Value = '{}', Exception = '{}'", __FUNCTION__, callerName, typeid(T).name(), typeid(value).name(), e.what());
		return defaultValue;
	}
}

/**
 * @brief Converts a value of type Source (enum) to type Target (arithmetic).
 *
 * This function is specialized for cases where the source type is an enum and the target type
 * is arithmetic. It first converts the enum to its underlying type, then to the target type.
 *
 * @tparam Target The target arithmetic type for the conversion.
 * @tparam Source The source enum type from which to convert.
 * @param s The enum value to convert.
 * @param callerName The name of the calling function for logging purposes.
 * @param defaultValue The default value to return in case of conversion failure.
 * @return The converted value of type Target, or the default value if conversion fails.
 *
 * @example
 * enum class MyEnum { X = 1, Y = 2 };
 * int val = safe_convert<int>(MyEnum::X);
 * float fval = safe_convert<float>(MyEnum::Y, __FUNCTION__);
 * unsigned int uval = safe_convert<unsigned int>(MyEnum::X, "callerFunc", 0);
 */
template <typename Target, typename Source>
	requires std::is_enum_v<Source> && std::is_arithmetic_v<Target>
Target safe_convert(Source sourceValue, std::string_view callerName, Target defaultValue = Target()) {
	try {
		if constexpr (std::is_same_v<Source, Target>) {
			return sourceValue;
		}

		using Underlying = typename std::underlying_type_t<Source>;
		auto underlyingValue = static_cast<Underlying>(sourceValue);

		if constexpr (std::is_floating_point_v<Target>) {
			if (!std::isfinite(static_cast<double>(underlyingValue))) {
				g_logger().error("[{}] - function:{}. Non-finite value detected in floating point conversion. Default value: {}, Max: {}, Min: {}, Value: {}, Type T: {}, Type Source: {}", __FUNCTION__, callerName, defaultValue, std::numeric_limits<Target>::max(), std::numeric_limits<Target>::min(), underlyingValue, typeid(Target).name(), typeid(Source).name());
				return defaultValue;
			}
		} else {
			if (underlyingValue > std::numeric_limits<Target>::max() || underlyingValue < std::numeric_limits<Target>::min()) {
				g_logger().error("[{}] - function:{}. Possible overflow/underflow or same type conversion. Default value: {}, Max: {}, Min: {}, Value: {}, Type T: {}, Type Source: {}", __FUNCTION__, callerName, defaultValue, std::numeric_limits<Target>::max(), std::numeric_limits<Target>::min(), underlyingValue, typeid(Target).name(), typeid(Source).name());
				return defaultValue;
			}
		}

		return static_cast<Target>(underlyingValue);
	} catch (const std::exception &e) {
		g_logger().error("[{}] - Exception caught in function:{} | error: {}", __FUNCTION__, callerName, e.what());
		return defaultValue;
	}
}
