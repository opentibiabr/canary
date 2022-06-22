/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_UTILS_LEXICAL_CAST_HPP_
#define SRC_UTILS_LEXICAL_CAST_HPP_

namespace LexicalCast {

// Functions of converions
template<typename Type>
inline const std::string convertNumericToString(const Type& arg, const char* fmt) {

	enum { MAX_SIZE = ( std::numeric_limits<Type>::digits10 + 1 ) + 1 };
	char buffer[MAX_SIZE] = { 0 };

	if (sprintf(buffer, fmt, arg) < 0) {
		SPDLOG_ERROR("[LexicalCast::convertNumericToString] - Failed to convert from numeric to string");
		return std::string();
	}
	return (std::string(buffer));
}

template<typename Type>
inline const Type convertStringToNumeric(const std::string& arg) {

	char* end = 0;
	double result = std::strtod(arg.c_str(), &end);

	if (!end || *end != 0) {
		SPDLOG_ERROR("[LexicalCast::convertStringToNumeric] - Failed to convert from string to numeric");
		return static_cast<Type>(0);
	}
	return Type(result);
}

// Casting types
template<typename Type>
inline Type numericToString(const int32_t& arg) {
	return (convertNumericToString<int32_t>(arg,"%li"));
}

template<typename Type>
inline Type numericToString(const uint32_t& arg) {
	return (convertNumericToString<uint32_t>(arg,"%lu"));
}

template<typename Type>
inline Type numericToString(const double& arg) {
	return (convertNumericToString<double>(arg,"%f"));
}

template<typename Type>
inline Type stringToNumeric(const std::string& arg) {
	return (convertStringToNumeric<Type>(arg));
}

} // End namespace LexicalCast

#endif  // SRC_UTILS_LEXICAL_CAST_HPP_
