/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/docgen/lua_api_doc_generator.hpp"

#include "lib/logging/logger.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <array>
	#include <cctype>
	#include <fstream>
	#include <initializer_list>
	#include <stdexcept>
	#include <regex>
	#include <set>
	#include <sstream>
	#include <string_view>
	#include <system_error>
	#include <utility>
#endif

namespace {
	using LuaClassMap = std::map<std::string, LuaClassInfo, std::less<>>;
	using LuaClassValuesMap = std::map<std::string, std::vector<std::string>, std::less<>>;

	struct ParameterHint {
		std::string name;
		bool optional { false };
	};

	struct LuaSignatureHint {
		bool found { false };
		bool hasSelfParameter { false };
		std::vector<ParameterHint> parameters;
	};

	LuaSignatureHint extractLuaSignatureHint(const std::string &body);

	struct LuaDocParameter {
		std::string name;
		std::string type;
		bool optional { false };
		bool variadic { false };
	};

	struct ParameterInfo {
		std::string type;
		std::string name;
		bool optional { false };
	};

	template <typename Container, typename... Args>
	void appendValue(Container &container, Args &&... args) {
		auto &inserted = container.emplace_back(std::forward<Args>(args)...);
		static_cast<void>(inserted);
	}

	template <typename Set, typename Value>
	bool addUnique(Set &values, Value &&value) {
		const auto [_, inserted] = values.insert(std::forward<Value>(value));
		static_cast<void>(_);
		return inserted;
	}

	void appendUnique(std::vector<std::string> &values, std::string value) {
		if (value.empty() || std::ranges::find(values, value) != values.end()) {
			return;
		}
		appendValue(values, std::move(value));
	}

	void incrementIterator(std::filesystem::recursive_directory_iterator &it, std::error_code &ec) {
		const auto &advanced = it.increment(ec);
		static_cast<void>(advanced);
	}

	std::string trim(const std::string_view value) {
		const auto start = value.find_first_not_of(" \t\n\r");
		const auto end = value.find_last_not_of(" \t\n\r");
		if (start == std::string::npos || end == std::string::npos) {
			return "";
		}
		return std::string(value.substr(start, end - start + 1));
	}

	std::string collapseWhitespace(const std::string_view value) {
		return trim(std::regex_replace(std::string(value), std::regex(R"regex(\s+)regex"), " "));
	}

	bool startsWithPair(const std::string &value, const size_t position, const char first, const char second) {
		return position + 1 < value.size() && value[position] == first && value[position + 1] == second;
	}

	void skipLineComment(const std::string &value, size_t &position) {
		position += 2;
		while (position < value.size() && value[position] != '\n' && value[position] != '\r') {
			++position;
		}
	}

	void skipBlockComment(const std::string &value, std::string &output, size_t &position) {
		position += 2;
		while (position + 1 < value.size() && !startsWithPair(value, position, '*', '/')) {
			if (value[position] == '\n' || value[position] == '\r') {
				output.push_back(value[position]);
			}
			++position;
		}
		position = std::min(position + 2, value.size());
	}

	std::string stripComments(const std::string &value) {
		std::string stripped;
		stripped.reserve(value.size());
		for (size_t i = 0; i < value.size();) {
			if (startsWithPair(value, i, '/', '/')) {
				stripped.push_back(' ');
				skipLineComment(value, i);
				continue;
			}
			if (startsWithPair(value, i, '/', '*')) {
				stripped.push_back(' ');
				skipBlockComment(value, stripped, i);
				continue;
			}
			stripped.push_back(value[i]);
			++i;
		}
		return stripped;
	}

	bool isIdentifierCharacter(const char ch) {
		return std::isalnum(static_cast<unsigned char>(ch)) || ch == '_';
	}

	struct DelimiterScanState {
		int depth { 0 };
		bool inLineComment { false };
		bool inBlockComment { false };
		bool inString { false };
		char stringDelimiter { '\0' };
	};

	bool consumeDelimiterScanState(DelimiterScanState &state, const char ch, const char next, size_t &position) {
		if (state.inLineComment) {
			state.inLineComment = ch != '\n' && ch != '\r';
			return true;
		}
		if (state.inBlockComment) {
			if (ch == '*' && next == '/') {
				state.inBlockComment = false;
				++position;
			}
			return true;
		}
		if (!state.inString) {
			return false;
		}
		if (ch == '\\') {
			++position;
			return true;
		}
		if (ch == state.stringDelimiter) {
			state.inString = false;
		}
		return true;
	}

	bool enterDelimiterScanState(DelimiterScanState &state, const char ch, const char next, size_t &position) {
		if (ch == '/' && next == '/') {
			state.inLineComment = true;
			++position;
			return true;
		}
		if (ch == '/' && next == '*') {
			state.inBlockComment = true;
			++position;
			return true;
		}
		if (ch == '"' || ch == '\'') {
			state.inString = true;
			state.stringDelimiter = ch;
			return true;
		}
		return false;
	}

	size_t findMatchingDelimiter(const std::string &content, const size_t openPosition, const char open, const char close) {
		if (openPosition >= content.size() || content[openPosition] != open) {
			return std::string::npos;
		}

		DelimiterScanState state;
		size_t i = openPosition;
		while (i < content.size()) {
			const auto ch = content[i];
			const auto next = i + 1 < content.size() ? content[i + 1] : '\0';

			if (consumeDelimiterScanState(state, ch, next, i)) {
				++i;
				continue;
			}
			if (enterDelimiterScanState(state, ch, next, i)) {
				++i;
				continue;
			}
			if (ch == open) {
				++state.depth;
				++i;
				continue;
			}
			if (ch == close) {
				--state.depth;
				if (state.depth == 0) {
					return i;
				}
			}
			++i;
		}

		return std::string::npos;
	}

	size_t findHandlerSignature(const std::string &content, const std::string_view handler) {
		size_t searchPosition = 0;
		while ((searchPosition = content.find(handler, searchPosition)) != std::string::npos) {
			const auto hasScopeOperatorPrefix = searchPosition >= 2 && content[searchPosition - 1] == ':' && content[searchPosition - 2] == ':';
			const auto isScopedHandlerDefinition = hasScopeOperatorPrefix && handler.find("::") == std::string_view::npos;
			if (searchPosition > 0 && (isIdentifierCharacter(content[searchPosition - 1]) || (content[searchPosition - 1] == ':' && !isScopedHandlerDefinition))) {
				searchPosition += handler.size();
				continue;
			}

			auto cursor = searchPosition + handler.size();
			while (cursor < content.size() && std::isspace(static_cast<unsigned char>(content[cursor]))) {
				++cursor;
			}
			if (cursor >= content.size() || content[cursor] != '(') {
				searchPosition += handler.size();
				continue;
			}

			const auto closeParenthesis = findMatchingDelimiter(content, cursor, '(', ')');
			if (closeParenthesis == std::string::npos) {
				searchPosition += handler.size();
				continue;
			}

			cursor = closeParenthesis + 1;
			while (cursor < content.size() && std::isspace(static_cast<unsigned char>(content[cursor]))) {
				++cursor;
			}
			if (cursor < content.size() && content[cursor] == '{') {
				return searchPosition;
			}
			searchPosition += handler.size();
		}

		return std::string::npos;
	}

	std::string getReturnTypeBeforeHandler(const std::string &content, const size_t handlerPosition) {
		const auto lineStart = content.rfind('\n', handlerPosition);
		const auto start = lineStart == std::string::npos ? 0 : lineStart + 1;
		const auto contentView = std::string_view(content);
		auto prefix = trim(contentView.substr(start, handlerPosition - start));
		if (prefix.rfind("static ", 0) == 0) {
			prefix = trim(std::string_view(prefix).substr(7));
		}
		return prefix;
	}

	bool isLuaDocSignaturePrefix(const std::string &value) {
		return std::ranges::all_of(value, [](const char ch) {
			return std::isspace(static_cast<unsigned char>(ch)) || isIdentifierCharacter(ch) || ch == ':' || ch == '<' || ch == '>' || ch == ',' || ch == '&' || ch == '*';
		});
	}

	std::string toLowerCopy(const std::string &value) {
		std::string lower;
		lower.reserve(value.size());
		for (const auto ch : value) {
			lower.push_back(static_cast<char>(std::tolower(static_cast<unsigned char>(ch))));
		}
		return lower;
	}

	std::string unwrapTemplateType(const std::string &type, const std::string &wrapper) {
		if (type.empty()) {
			return type;
		}
		const auto prefix = wrapper + "<";
		if (type.rfind(prefix, 0) != 0 || type.back() != '>') {
			return type;
		}
		return trim(std::string_view(type).substr(prefix.size(), type.size() - prefix.size() - 1));
	}

	std::string normalizeLuaType(std::string type) {
		type = collapseWhitespace(type);
		type = std::regex_replace(type, std::regex(R"regex(^const\s+)regex", std::regex::icase), "");
		type = std::regex_replace(type, std::regex(R"regex(\s+const$)regex", std::regex::icase), "");
		type = std::regex_replace(type, std::regex(R"regex([\*&])regex"), "");
		type = trim(type);

		type = unwrapTemplateType(type, "std::shared_ptr");
		type = unwrapTemplateType(type, "std::unique_ptr");
		type = unwrapTemplateType(type, "std::optional");
		if (type.rfind("std::vector<", 0) == 0 || type.rfind("std::list<", 0) == 0 || type.rfind("std::set<", 0) == 0 || type.rfind("std::unordered_set<", 0) == 0 || type.rfind("phmap::", 0) == 0) {
			return "table";
		}
		type = std::regex_replace(type, std::regex(R"regex(Shared_ptr$)regex"), "");
		type = trim(type);

		const auto lower = toLowerCopy(type);
		if (lower.empty() || lower == "auto") {
			return "any";
		}
		if (lower == "bool" || lower == "boolean") {
			return "boolean";
		}
		if (lower == "std::string" || lower == "string" || lower == "std::string_view" || lower == "string_view" || lower == "char" || lower == "const char") {
			return "string";
		}
		if (lower == "float" || lower == "double" || lower == "int" || lower == "integer" || lower == "lua_number" || lower == "lua_integer" || lower == "size_t" || lower == "uint8_t" || lower == "uint16_t" || lower == "uint32_t" || lower == "uint64_t" || lower == "int8_t" || lower == "int16_t" || lower == "int32_t" || lower == "int64_t") {
			return "number";
		}
		if (lower == "void") {
			return "nil";
		}
		if (type.ends_with("_t")) {
			return "any";
		}
		static const std::set<std::string, std::less<>> cppOnlyTypes = {
			"AccountType",
			"CombatSpell",
			"CombatOrigin",
			"Direction",
			"Attributes",
			"ImbuementAction",
			"IconBakragore",
			"InstantSpell",
			"ItemProperty",
			"MagicEffectClasses",
			"MessageClasses",
			"Outfit",
			"ReturnValue",
			"SpeakClasses",
			"Thing",
			"UserdataType",
		};
		if (cppOnlyTypes.contains(type)) {
			return "any";
		}
		if (lower == "userdata" || lower == "lightuserdata") {
			return lower;
		}
		if (lower == "unknown" || lower == "lua_state" || lower == "std::source_location") {
			return "any";
		}
		if (type.find('\n') != std::string::npos || type.find('\r') != std::string::npos || type.find(' ') != std::string::npos || type.find("::") != std::string::npos) {
			return "any";
		}
		if (!std::regex_match(type, std::regex(R"regex([A-Za-z_][A-Za-z0-9_]*)regex"))) {
			return "any";
		}
		return type;
	}

	std::string normalizeLuaTypeExpression(const std::string &type) {
		std::vector<std::string> normalizedTypes;
		std::stringstream stream(type);
		std::string item;
		while (std::getline(stream, item, '|')) {
			auto normalized = normalizeLuaType(item);
			if (normalized.empty()) {
				normalized = "any";
			}
			if (std::ranges::find(normalizedTypes, normalized) == normalizedTypes.end()) {
				appendValue(normalizedTypes, std::move(normalized));
			}
		}
		if (normalizedTypes.empty()) {
			return "any";
		}
		if (std::ranges::find(normalizedTypes, "any") != normalizedTypes.end()) {
			return "any";
		}
		std::ostringstream output;
		for (size_t i = 0; i < normalizedTypes.size(); ++i) {
			if (i > 0) {
				output << "|";
			}
			output << normalizedTypes[i];
		}
		return output.str();
	}

	std::string normalizeManualLuaTypeExpression(const std::string_view type) {
		const auto normalized = collapseWhitespace(type);
		return normalized.empty() ? "any" : normalized;
	}

	std::string normalizeDocParameterType(const std::string_view type, const bool normalizeTypes) {
		const auto fallbackType = type.empty() ? std::string_view("any") : type;
		if (normalizeTypes) {
			return normalizeLuaTypeExpression(std::string(fallbackType));
		}
		return normalizeManualLuaTypeExpression(fallbackType);
	}

	std::string sanitizeParameterName(std::string name, const int index) {
		name = trim(name);
		const auto lowerName = toLowerCopy(name);
		if (lowerName == "itemid") {
			name = "itemId";
		} else if (lowerName == "actionid") {
			name = "actionId";
		} else if (lowerName == "raceid") {
			name = "raceId";
		} else if (lowerName == "grouptype") {
			name = "groupType";
		}
		static const std::set<std::string, std::less<>> reservedNames = {
			"and",
			"break",
			"do",
			"else",
			"elseif",
			"end",
			"false",
			"for",
			"function",
			"goto",
			"if",
			"in",
			"local",
			"nil",
			"not",
			"or",
			"repeat",
			"return",
			"then",
			"true",
			"until",
			"while",
		};
		if (name.empty() || reservedNames.contains(name) || !std::regex_match(name, std::regex(R"regex([A-Za-z_][A-Za-z0-9_]*)regex"))) {
			return fmt::format("arg{}", index);
		}
		return name;
	}

	std::vector<std::string> splitSignatureParameters(const std::string &parameters) {
		std::vector<std::string> values;
		std::stringstream stream(parameters);
		std::string item;
		while (std::getline(stream, item, ',')) {
			auto trimmed = trim(item);
			if (!trimmed.empty()) {
				appendValue(values, std::move(trimmed));
			}
		}
		return values;
	}

	std::vector<LuaDocParameter> parseLuaDocParameters(const std::vector<std::string> &parameters, const bool normalizeTypes = true) {
		std::vector<LuaDocParameter> parsedParameters;
		int parameterIndex = 1;
		for (const auto &parameter : parameters) {
			auto trimmed = trim(parameter);
			if (trimmed.empty()) {
				continue;
			}

			const auto separator = trimmed.find(':');
			const auto trimmedView = std::string_view(trimmed);
			auto name = separator == std::string::npos ? trimmed : trim(trimmedView.substr(0, separator));
			auto type = separator == std::string::npos ? "any" : trim(trimmedView.substr(separator + 1));

			LuaDocParameter parsedParameter;
			if (name == "...") {
				parsedParameter.name = "...";
				parsedParameter.type = normalizeDocParameterType(type, normalizeTypes);
				parsedParameter.variadic = true;
				appendValue(parsedParameters, std::move(parsedParameter));
				continue;
			}

			if (!name.empty() && name.back() == '?') {
				name.pop_back();
				parsedParameter.optional = true;
			}

			parsedParameter.name = sanitizeParameterName(name, parameterIndex);
			parsedParameter.type = normalizeDocParameterType(type, normalizeTypes);
			appendValue(parsedParameters, std::move(parsedParameter));
			++parameterIndex;
		}

		bool hasOptionalParameter = false;
		for (auto &parameter : parsedParameters) {
			if (parameter.variadic) {
				continue;
			}
			if (hasOptionalParameter) {
				parameter.optional = true;
			}
			hasOptionalParameter = hasOptionalParameter || parameter.optional;
		}
		return parsedParameters;
	}

	std::vector<std::string> normalizeLuaDocParameters(const std::vector<std::string> &parameters, const bool normalizeTypes = true) {
		std::vector<std::string> normalizedParameters;
		for (const auto &parameter : parseLuaDocParameters(parameters, normalizeTypes)) {
			if (parameter.variadic) {
				appendValue(normalizedParameters, "...: " + parameter.type);
			} else {
				appendValue(normalizedParameters, parameter.name + std::string(parameter.optional ? "?: " : ": ") + parameter.type);
			}
		}
		return normalizedParameters;
	}

	std::string getLuaOperatorName(const std::string &methodName) {
		static const LuaStringMap operatorNames = {
			{ "__add", "add" },
			{ "__sub", "sub" },
			{ "__mul", "mul" },
			{ "__div", "div" },
			{ "__mod", "mod" },
			{ "__pow", "pow" },
			{ "__unm", "unm" },
			{ "__idiv", "idiv" },
			{ "__band", "band" },
			{ "__bor", "bor" },
			{ "__bxor", "bxor" },
			{ "__bnot", "bnot" },
			{ "__shl", "shl" },
			{ "__shr", "shr" },
			{ "__concat", "concat" },
			{ "__len", "len" },
			{ "__eq", "eq" },
			{ "__lt", "lt" },
			{ "__le", "le" },
			{ "__call", "call" },
		};
		const auto found = operatorNames.find(methodName);
		return found == operatorNames.end() ? "" : found->second;
	}

	bool isLuaMetaMethod(const LuaFunctionInfo &function) {
		return function.name.rfind("__", 0) == 0;
	}

	std::vector<std::string> getLuaReturnAnnotations(const LuaFunctionInfo &function) {
		if (!function.returns.empty()) {
			return function.returns;
		}

		const auto type = function.returnType.empty() ? "any" : function.returnType;
		return { function.hasExplicitDocumentation ? normalizeManualLuaTypeExpression(type) : normalizeLuaTypeExpression(type) };
	}

	std::string getLuaReturnType(const std::string &returnAnnotation) {
		const auto trimmed = trim(returnAnnotation);
		const auto separator = trimmed.find_first_of(" \t");
		return separator == std::string::npos ? trimmed : trimmed.substr(0, separator);
	}

	std::string joinLuaReturnAnnotations(const LuaFunctionInfo &function) {
		const auto returns = getLuaReturnAnnotations(function);
		std::ostringstream output;
		for (size_t i = 0; i < returns.size(); ++i) {
			if (i > 0) {
				output << ", ";
			}
			output << returns[i];
		}
		return output.str();
	}

	void writeLuaOperatorAnnotation(std::ostringstream &output, const std::string &owner, const LuaFunctionInfo &function) {
		const auto operatorName = getLuaOperatorName(function.name);
		if (operatorName.empty()) {
			return;
		}
		const auto parameters = parseLuaDocParameters(function.parameters, !function.hasExplicitDocumentation);
		const auto operandType = parameters.empty() ? owner : parameters.front().type;
		output << "---@operator " << operatorName;
		if (!operandType.empty()) {
			output << "(" << operandType << ")";
		}
		output << ":" << getLuaReturnType(getLuaReturnAnnotations(function).front()) << "\n";
	}

	void writeLuaOverloadAnnotations(std::ostringstream &output, const std::vector<std::string> &overloads) {
		for (const auto &overload : overloads) {
			if (!overload.empty()) {
				output << "---@overload " << overload << "\n";
			}
		}
	}

	void writeLuaFunctionDefinition(std::ostringstream &output, const std::string &owner, const LuaFunctionInfo &function) {
		const auto parameters = parseLuaDocParameters(function.parameters, !function.hasExplicitDocumentation);
		writeLuaOverloadAnnotations(output, function.overloads);
		for (const auto &parameter : parameters) {
			if (parameter.variadic) {
				output << "---@param ... " << parameter.type << "\n";
				continue;
			}
			output << "---@param " << parameter.name << (parameter.optional ? "? " : " ") << parameter.type << "\n";
		}

		for (const auto &returnAnnotation : getLuaReturnAnnotations(function)) {
			if (!returnAnnotation.empty()) {
				output << "---@return " << returnAnnotation << "\n";
			}
		}

		if (owner.empty()) {
			output << "function " << function.name << "(";
		} else if (function.hasSelfParameter) {
			output << "function " << owner << ":" << function.name << "(";
		} else {
			output << "function " << owner << "." << function.name << "(";
		}

		bool hasPrevious = false;
		for (const auto &parameter : parameters) {
			if (hasPrevious) {
				output << ", ";
			}
			output << parameter.name;
			hasPrevious = true;
		}
		output << ") end\n\n";
	}

	std::string normalizeHintParameterName(std::string name, const int index) {
		const auto rawName = name;
		if (rawName.find("_t") != std::string::npos) {
			return fmt::format("arg{}", index);
		}
		name = std::regex_replace(name, std::regex(R"regex(\s*=.*$)regex"), "");
		name = std::regex_replace(name, std::regex(R"regex(\s+or\s+nil\b.*$)regex", std::regex::icase), "");
		name = std::regex_replace(name, std::regex(R"regex(/)regex"), " or ");
		name = std::regex_replace(name, std::regex(R"regex(\|)regex"), " or ");
		const bool hadOrWord = std::regex_search(name, std::regex(R"regex(\bor\b)regex", std::regex::icase));
		name = std::regex_replace(name, std::regex(R"regex(\bor\b)regex", std::regex::icase), "Or");
		name = std::regex_replace(name, std::regex(R"regex([^A-Za-z0-9_])regex"), "");
		if (hadOrWord) {
			for (auto pos = name.find("Or"); pos != std::string::npos && pos + 2 < name.size(); pos = name.find("Or", pos + 2)) {
				name[pos + 2] = static_cast<char>(std::toupper(static_cast<unsigned char>(name[pos + 2])));
			}
		}
		name = std::regex_replace(name, std::regex(R"regex(Raceid)regex"), "RaceId");
		const auto normalizedLower = toLowerCopy(name);
		if (normalizedLower == "function") {
			return "callback";
		}
		if (normalizedLower == "bool" || normalizedLower == "boolean" || normalizedLower == "string" || normalizedLower == "number") {
			return "value";
		}
		return sanitizeParameterName(name, index);
	}

	std::string inferTypeFromParameterName(const std::string &name) {
		const auto lower = toLowerCopy(name);
		if (lower == "callback") {
			return "function";
		}
		if (lower.find("idornameoruserdata") != std::string::npos || lower.find("nameoridoruserdata") != std::string::npos) {
			return "number|string|userdata";
		}
		if (lower.find("idorname") != std::string::npos || lower.find("nameorid") != std::string::npos || lower.find("looktypeorname") != std::string::npos || lower.find("mountidormountname") != std::string::npos || lower.find("itemidorname") != std::string::npos) {
			return "number|string";
		}
		if (lower.find("position") != std::string::npos || lower == "pos" || lower.find("pos") == 0 || (lower.size() >= 3 && lower.rfind("pos") == lower.size() - 3)) {
			return "Position";
		}
		if (lower.find("player") != std::string::npos) {
			return "Player";
		}
		if (lower.find("creature") != std::string::npos || lower == "actor" || lower == "target") {
			return "Creature";
		}
		if (lower.find("item") != std::string::npos && lower.find("id") == std::string::npos) {
			return "Item";
		}
		if (lower.find("tile") != std::string::npos) {
			return "Tile";
		}
		if (lower.find("variant") != std::string::npos) {
			return "Variant";
		}
		if (lower.find("list") != std::string::npos || lower.find("table") != std::string::npos || lower.find("attributes") != std::string::npos) {
			return "table";
		}
		if (lower.find("name") != std::string::npos || lower.find("text") != std::string::npos || lower.find("message") != std::string::npos || lower.find("description") != std::string::npos || lower.find("shader") != std::string::npos) {
			return "string";
		}
		if (lower.find("enabled") != std::string::npos || lower.find("force") != std::string::npos || lower.find("recursive") != std::string::npos || lower.find("clear") != std::string::npos || lower.find("update") != std::string::npos || lower.find("premium") != std::string::npos) {
			return "boolean";
		}
		if (lower.find("id") != std::string::npos || lower.find("amount") != std::string::npos || lower.find("count") != std::string::npos || lower.find("level") != std::string::npos || lower.find("value") != std::string::npos || lower.find("time") != std::string::npos || lower.find("chance") != std::string::npos || lower.find("percent") != std::string::npos || lower.find("range") != std::string::npos || lower.find("radius") != std::string::npos || lower.find("speed") != std::string::npos || lower.find("damage") != std::string::npos || lower.find("type") != std::string::npos || lower.find("guid") != std::string::npos) {
			return "number";
		}
		return "any";
	}

	std::string deduceLuaTypeFromGetter(const std::string &getter, const std::string &templ) {
		if (!templ.empty()) {
			const auto normalizedTemplate = normalizeLuaTypeExpression(templ);
			if (!normalizedTemplate.empty()) {
				return normalizedTemplate;
			}
		}

		const auto base = toLowerCopy(getter);
		static const LuaStringMap typeMap = {
			{ "player", "Player" },
			{ "creature", "Creature" },
			{ "npc", "Npc" },
			{ "monster", "Monster" },
			{ "guild", "Guild" },
			{ "item", "Item" },
			{ "position", "Position" },
			{ "tile", "Tile" },
			{ "variant", "Variant" },
			{ "lightinfo", "LightInfo" },
			{ "thing", "Thing" },
			{ "boolean", "boolean" },
			{ "bool", "boolean" },
			{ "string", "string" },
			{ "number", "number" },
			{ "integer", "number" },
			{ "bank", "any" },
			{ "playerornpc", "Player" },
			{ "playerormonster", "Creature" },
			{ "playerorcreature", "Creature" },
			{ "creatureorplayer", "Creature" },
			{ "userdata", "userdata" },
			{ "userdatahandle", "userdata" }
		};

		if (const auto found = typeMap.find(base); found != typeMap.end()) {
			return found->second;
		}

		if (base.find("number") != std::string::npos || base.find("integer") != std::string::npos) {
			return "number";
		}
		if (base.find("string") != std::string::npos) {
			return "string";
		}
		if (base.find("bool") != std::string::npos) {
			return "boolean";
		}
		if (base.find("player") != std::string::npos) {
			return "Player";
		}
		if (base.find("creature") != std::string::npos) {
			return "Creature";
		}
		if (base.find("thing") != std::string::npos) {
			return "Thing";
		}
		if (base.find("position") != std::string::npos) {
			return "Position";
		}
		if (base.find("variant") != std::string::npos) {
			return "Variant";
		}

		return getter;
	}

	bool isBetterParameterName(const std::string &current, const std::string &candidate) {
		if (candidate.empty()) {
			return false;
		}
		if (current.empty()) {
			return true;
		}
		return current.rfind("arg", 0) == 0 && candidate.rfind("arg", 0) != 0;
	}

	void appendUniqueLuaType(std::vector<std::string> &parts, const std::string &type, const bool skipAny) {
		const auto normalized = normalizeLuaTypeExpression(type);
		if (normalized.empty() || (skipAny && normalized == "any")) {
			return;
		}
		if (std::ranges::find(parts, normalized) == parts.end()) {
			appendValue(parts, normalized);
		}
	}

	std::string mergeLuaParameterTypes(const std::string &current, const std::string &candidate) {
		if (candidate.empty() || candidate == "any") {
			return current.empty() ? std::string("any") : current;
		}
		if (current.empty() || current == "unknown" || current == "any") {
			return candidate;
		}

		std::vector<std::string> parts;
		std::stringstream stream(current);
		std::string item;
		while (std::getline(stream, item, '|')) {
			appendUniqueLuaType(parts, item, false);
		}

		std::stringstream candidateStream(candidate);
		while (std::getline(candidateStream, item, '|')) {
			appendUniqueLuaType(parts, item, true);
		}

		if (parts.empty()) {
			return "any";
		}

		if (std::ranges::find_if(parts, [](const auto &type) {
				return type != "nil" && type != "any" && type != "boolean" && type != "string" && type != "number" && type != "integer" && type != "function" && type != "table" && type != "thread" && type != "userdata" && type != "lightuserdata";
			})
		    != parts.end()) {
			const auto erased = std::erase(parts, std::string("userdata"));
			static_cast<void>(erased);
		}

		std::ostringstream output;
		for (size_t i = 0; i < parts.size(); ++i) {
			if (i > 0) {
				output << "|";
			}
			output << parts[i];
		}
		return output.str();
	}

	void addInferredParameter(std::map<int, ParameterInfo> &parameterMap, int index, const std::string &type, const std::string &name, const bool optional, const bool skipSelfParameter) {
		if (index < 0) {
			index = 1;
		}
		if (index <= 0 || (skipSelfParameter && index == 1)) {
			return;
		}

		auto &param = parameterMap[index];
		param.type = mergeLuaParameterTypes(param.type, normalizeLuaTypeExpression(type));
		if (isBetterParameterName(param.name, name)) {
			param.name = name;
		}
		param.optional = param.optional || optional;
	}

	std::string luaHelperType(const std::string_view helper) {
		if (helper.find("string") != std::string::npos) {
			return "string";
		}
		if (helper.find("number") != std::string::npos || helper.find("integer") != std::string::npos) {
			return "number";
		}
		if (helper.find("boolean") != std::string::npos || helper.find("bool") != std::string::npos) {
			return "boolean";
		}
		return "";
	}

	using RegexFlags = std::regex_constants::syntax_option_type;
	using ParameterMap = std::map<int, ParameterInfo>;
	using StringViewRegexIterator = std::regex_iterator<std::string_view::const_iterator>;

	std::set<int> collectOptionalThresholds(const std::string_view body, const RegexFlags flags) {
		std::set<int> optionalThresholds;
		std::regex topPattern(R"regex(lua_gettop\s*\(\s*L\s*\)\s*([<>!=]=?|==)\s*(\d+))regex", flags);
		for (auto it = StringViewRegexIterator(body.begin(), body.end(), topPattern); it != StringViewRegexIterator(); ++it) {
			const auto op = (*it)[1].str();
			const int threshold = std::stoi((*it)[2].str());
			int optionalStart = 0;
			if (op == ">=" || op == ">") {
				optionalStart = threshold;
			} else if (op == "==" || op == "=" || op == "<" || op == "<=") {
				optionalStart = threshold + 1;
			}
			if (optionalStart > 0) {
				const auto [_, inserted] = optionalThresholds.insert(optionalStart);
				static_cast<void>(_);
				static_cast<void>(inserted);
			}
		}
		return optionalThresholds;
	}

	void collectGetterMatches(ParameterMap &parameterMap, const std::string_view body, const std::vector<std::pair<std::regex, std::string>> &getters, const bool optional, const bool skipSelfParameter) {
		for (const auto &[pattern, type] : getters) {
			for (auto it = StringViewRegexIterator(body.begin(), body.end(), pattern); it != StringViewRegexIterator(); ++it) {
				const auto index = std::stoi((*it)[1].str());
				addInferredParameter(parameterMap, index, type, "", optional, skipSelfParameter);
			}
		}
	}

	void collectSimpleGetterParameters(ParameterMap &parameterMap, const std::string_view body, const RegexFlags flags, const bool skipSelfParameter) {
		const std::vector<std::pair<std::regex, std::string>> simpleGetters = {
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_tonumber\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_tointeger\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_tostring\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "string" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_toboolean\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "boolean" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_checknumber\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_checkinteger\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_checkstring\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "string" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isnumber\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isinteger\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isstring\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "string" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isboolean\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "boolean" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isuserdata\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "userdata" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_istable\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "table" }
		};
		collectGetterMatches(parameterMap, body, simpleGetters, false, skipSelfParameter);
	}

	void collectOptionalGetterParameters(ParameterMap &parameterMap, const std::string_view body, const RegexFlags flags, const bool skipSelfParameter) {
		const std::vector<std::pair<std::regex, std::string>> optionalGetters = {
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_opt(?:number|integer)\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
			{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_optstring\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "string" }
		};
		collectGetterMatches(parameterMap, body, optionalGetters, true, skipSelfParameter);
	}

	void collectTypedGetterAssignments(ParameterMap &parameterMap, const std::string_view body, const RegexFlags flags, const bool skipSelfParameter) {
		std::regex assignmentWithType(
			R"regex((?:const\s+)?([A-Za-z_][A-Za-z0-9_:<>, \*&]+?)\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(?:[A-Za-z_][A-Za-z0-9_:]*::)?(?:Lua::)?get([A-Za-z0-9_]+)\s*(?:<([^>]+)>)?\s*\(\s*L\s*,\s*(-?\d+)(?:\s*,[^)]*)?\))regex",
			flags
		);
		for (auto it = StringViewRegexIterator(body.begin(), body.end(), assignmentWithType); it != StringViewRegexIterator(); ++it) {
			const auto declaredTypeRaw = trim((*it)[1].str());
			const auto declaredType = normalizeLuaTypeExpression(declaredTypeRaw);
			const auto getter = (*it)[3].str();
			const auto templ = trim((*it)[4].str());
			const auto inferredType = !declaredType.empty() && toLowerCopy(declaredTypeRaw) != "auto" ? declaredType : deduceLuaTypeFromGetter(getter, templ);
			addInferredParameter(parameterMap, std::stoi((*it)[5].str()), inferredType, (*it)[2].str(), false, skipSelfParameter);
		}
	}

	void collectAutoGetterAssignments(ParameterMap &parameterMap, const std::string_view body, const RegexFlags flags, const bool skipSelfParameter) {
		std::regex assignmentAuto(
			R"regex((?:const\s+)?auto\s*&?\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(?:[A-Za-z_][A-Za-z0-9_:]*::)?(?:Lua::)?get([A-Za-z0-9_]+)\s*(?:<([^>]+)>)?\s*\(\s*L\s*,\s*(-?\d+)(?:\s*,[^)]*)?\))regex",
			flags
		);
		for (auto it = StringViewRegexIterator(body.begin(), body.end(), assignmentAuto); it != StringViewRegexIterator(); ++it) {
			addInferredParameter(parameterMap, std::stoi((*it)[4].str()), deduceLuaTypeFromGetter((*it)[2].str(), trim((*it)[3].str())), (*it)[1].str(), false, skipSelfParameter);
		}
	}

	void collectDirectGetterParameters(ParameterMap &parameterMap, const std::string_view body, const RegexFlags flags, const bool skipSelfParameter) {
		std::regex directGetter(
			R"regex((?:[A-Za-z_][A-Za-z0-9_:]*::)?(?:Lua::)?get([A-Za-z0-9_]+)\s*(?:<([^>]+)>)?\s*\(\s*L\s*,\s*(-?\d+)(?:\s*,[^)]*)?\))regex",
			flags
		);
		for (auto it = StringViewRegexIterator(body.begin(), body.end(), directGetter); it != StringViewRegexIterator(); ++it) {
			addInferredParameter(parameterMap, std::stoi((*it)[3].str()), deduceLuaTypeFromGetter((*it)[1].str(), trim((*it)[2].str())), "", false, skipSelfParameter);
		}
	}

	void collectNamedLuaHelperParameters(ParameterMap &parameterMap, const std::string_view body, const RegexFlags flags, const bool skipSelfParameter) {
		std::regex namedLuaHelpers(
			R"regex((?:const\s+)?(?:auto|[A-Za-z_][A-Za-z0-9_:<>\s\*&]+)\s*&?\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(lua_[a-z]+|luaL_check[a-z]+|luaL_opt[a-z]+)\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex",
			flags
		);
		for (auto it = StringViewRegexIterator(body.begin(), body.end(), namedLuaHelpers); it != StringViewRegexIterator(); ++it) {
			const auto helper = (*it)[2].str();
			addInferredParameter(parameterMap, std::stoi((*it)[3].str()), luaHelperType(helper), (*it)[1].str(), helper.rfind("luaL_opt", 0) == 0, skipSelfParameter);
		}
	}

	void collectExplicitLuaAssignments(ParameterMap &parameterMap, const std::string_view body, const RegexFlags flags, const bool skipSelfParameter) {
		std::regex explicitTypeAssignment(
			R"regex((?:const\s+)?([A-Za-z_][A-Za-z0-9_:<>, \*&]+?)\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(?:lua_[a-z]+|luaL_[a-z]+)\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex",
			flags
		);
		for (auto it = StringViewRegexIterator(body.begin(), body.end(), explicitTypeAssignment); it != StringViewRegexIterator(); ++it) {
			addInferredParameter(parameterMap, std::stoi((*it)[3].str()), normalizeLuaTypeExpression((*it)[1].str()), (*it)[2].str(), false, skipSelfParameter);
		}
	}

	void applyOptionalThresholds(ParameterMap &parameterMap, const std::set<int> &optionalThresholds) {
		for (const auto threshold : optionalThresholds) {
			for (auto &[idx, info] : parameterMap) {
				if (idx >= threshold) {
					info.optional = true;
				}
			}
		}
	}

	std::vector<std::string> varargFallbackParameters(const bool skipSelfParameter) {
		std::vector<std::string> parameters;
		if (!skipSelfParameter) {
			appendValue(parameters, "...");
		}
		return parameters;
	}

	std::vector<std::string> parametersFromSignatureHint(const LuaSignatureHint &signatureHint, const ParameterMap &parameterMap, const bool skipSelfParameter) {
		std::vector<std::string> parameters;
		for (size_t i = 0; i < signatureHint.parameters.size(); ++i) {
			const auto &hint = signatureHint.parameters[i];
			const auto stackIndex = static_cast<int>(i + 1 + (skipSelfParameter ? 1 : 0));
			const auto found = parameterMap.find(stackIndex);
			const auto type = found != parameterMap.end() && !found->second.type.empty() ? found->second.type : inferTypeFromParameterName(hint.name);
			auto name = sanitizeParameterName(hint.name, stackIndex);
			if (hint.optional || (found != parameterMap.end() && found->second.optional)) {
				name.push_back('?');
			}
			appendValue(parameters, name + ": " + normalizeLuaTypeExpression(type));
		}
		return parameters;
	}

	std::vector<std::string> parametersFromMap(const ParameterMap &parameterMap) {
		std::vector<std::string> parameters;
		for (const auto &[index, info] : parameterMap) {
			std::string name = sanitizeParameterName(info.name, index);
			if (info.optional) {
				name.push_back('?');
			}
			const auto type = info.type.empty() ? "any" : normalizeLuaTypeExpression(info.type);
			appendValue(parameters, name + ": " + type);
		}
		return parameters;
	}

	std::vector<std::string> inferParametersFromBody(const std::string &rawBody, const bool skipSelfParameter) {
		try {
			const auto signatureHint = extractLuaSignatureHint(rawBody);
			const auto body = stripComments(rawBody);
			const auto flags = std::regex::optimize | std::regex::icase;

			ParameterMap parameterMap;
			const auto optionalThresholds = collectOptionalThresholds(body, flags);
			collectSimpleGetterParameters(parameterMap, body, flags, skipSelfParameter);
			collectOptionalGetterParameters(parameterMap, body, flags, skipSelfParameter);
			collectTypedGetterAssignments(parameterMap, body, flags, skipSelfParameter);
			collectAutoGetterAssignments(parameterMap, body, flags, skipSelfParameter);
			collectDirectGetterParameters(parameterMap, body, flags, skipSelfParameter);
			collectNamedLuaHelperParameters(parameterMap, body, flags, skipSelfParameter);
			collectExplicitLuaAssignments(parameterMap, body, flags, skipSelfParameter);
			applyOptionalThresholds(parameterMap, optionalThresholds);

			if (signatureHint.found && !signatureHint.parameters.empty()) {
				return parametersFromSignatureHint(signatureHint, parameterMap, skipSelfParameter);
			}

			auto parameters = parametersFromMap(parameterMap);
			return parameters.empty() ? varargFallbackParameters(skipSelfParameter) : parameters;
		} catch (const std::regex_error &) {
			return varargFallbackParameters(skipSelfParameter);
		}
	}

	bool containsAny(const std::string_view value, const std::initializer_list<std::string_view> needles) {
		return std::ranges::any_of(needles, [value](const std::string_view needle) {
			return value.find(needle) != std::string_view::npos;
		});
	}

	void addUniqueReturnType(std::vector<std::string> &returnTypes, const std::string &type) {
		const auto normalized = normalizeLuaTypeExpression(type);
		if (std::ranges::find(returnTypes, normalized) == returnTypes.end()) {
			appendValue(returnTypes, normalized);
		}
	}

	void addReturnTypeIfContains(std::vector<std::string> &returnTypes, const std::string_view body, const std::initializer_list<std::string_view> needles, const std::string &type) {
		if (containsAny(body, needles)) {
			addUniqueReturnType(returnTypes, type);
		}
	}

	LuaSignatureHint extractLuaSignatureHint(const std::string &body) {
		LuaSignatureHint hint;
		std::regex signaturePattern(
			R"regex((?://|/\*+|\*)\s*[A-Za-z_][A-Za-z0-9_]*\s*([:.])\s*[A-Za-z_][A-Za-z0-9_:]*\s*\(([^\)\r\n]*)\))regex",
			std::regex::optimize
		);
		std::smatch match;
		if (!std::regex_search(body, match, signaturePattern)) {
			return hint;
		}

		hint.found = true;
		hint.hasSelfParameter = match[1].str() == ":";
		const auto rawParameters = match[2].str();
		int parameterIndex = 1;
		bool optionalContext = false;
		for (const auto &token : splitSignatureParameters(rawParameters)) {
			const auto trimmed = trim(token);
			const bool optional = optionalContext || trimmed.rfind("[", 0) == 0 || trimmed.find("<optional") != std::string::npos || std::regex_search(trimmed, std::regex(R"regex(\bor\s+nil\b)regex", std::regex::icase));
			optionalContext = trimmed.find('[') != std::string::npos;
			auto cleaned = std::regex_replace(trimmed, std::regex(R"regex(<\s*optional[^>]*>\s*)regex", std::regex::icase), "");
			const auto inlineOptionalMarker = cleaned.find('[');
			if (inlineOptionalMarker != std::string::npos && inlineOptionalMarker > 0) {
				cleaned = cleaned.substr(0, inlineOptionalMarker);
			}
			cleaned = std::regex_replace(cleaned, std::regex(R"regex([\[\]])regex"), "");
			auto name = normalizeHintParameterName(cleaned, parameterIndex);
			appendValue(hint.parameters, ParameterHint { std::move(name), optional });
			++parameterIndex;
		}
		return hint;
	}

	struct LuaDocBlock {
		bool found { false };
		bool hasSelfParameter { false };
		std::string className;
		std::string functionName;
		std::vector<std::string> parameters;
		std::vector<std::string> returns;
		std::vector<std::string> overloads;
		std::vector<std::string> fields;
	};

	std::string cleanLuaDocBlockLine(std::string line) {
		line = trim(line);
		if (!line.empty() && line.front() == '*') {
			line = trim(std::string_view(line).substr(1));
		}
		return line;
	}

	void parseLuaDocFunction(LuaDocBlock &docBlock, const std::string_view symbol) {
		const auto colon = symbol.find(':');
		const auto dot = symbol.find('.');
		const auto separator = colon == std::string::npos ? dot : colon;
		if (separator == std::string::npos) {
			docBlock.functionName = std::string(symbol);
			docBlock.hasSelfParameter = false;
			return;
		}

		docBlock.className = std::string(symbol.substr(0, separator));
		docBlock.functionName = std::string(symbol.substr(separator + 1));
		docBlock.hasSelfParameter = symbol[separator] == ':';
	}

	void parseLuaDocClass(LuaDocBlock &docBlock, const std::string_view symbol) {
		const auto className = trim(symbol);
		if (!className.empty()) {
			docBlock.className = className;
		}
	}

	void parseLuaDocParam(LuaDocBlock &docBlock, const std::string_view value) {
		const auto trimmed = trim(value);
		if (trimmed.empty()) {
			return;
		}

		const auto separator = trimmed.find_first_of(" \t");
		const auto trimmedView = std::string_view(trimmed);
		auto name = separator == std::string::npos ? trimmed : trim(trimmedView.substr(0, separator));
		const auto type = separator == std::string::npos ? "any" : normalizeManualLuaTypeExpression(trimmedView.substr(separator + 1));
		bool optional = false;
		if (!name.empty() && name.back() == '?') {
			name.pop_back();
			optional = true;
		}

		if (name == "...") {
			appendValue(docBlock.parameters, "...: " + type);
			return;
		}
		appendValue(docBlock.parameters, name + std::string(optional ? "?: " : ": ") + type);
	}

	void parseLuaDocField(LuaDocBlock &docBlock, const std::string_view value) {
		appendUnique(docBlock.fields, normalizeManualLuaTypeExpression(value));
	}

	void parseLuaDocOverload(LuaDocBlock &docBlock, const std::string_view value) {
		appendUnique(docBlock.overloads, normalizeManualLuaTypeExpression(value));
	}

	LuaDocBlock parseLuaDocBlock(const std::string &block) {
		LuaDocBlock docBlock;
		std::stringstream stream(block);
		std::string line;
		while (std::getline(stream, line)) {
			line = cleanLuaDocBlockLine(line);
			if (line.rfind("@function ", 0) == 0) {
				parseLuaDocFunction(docBlock, trim(std::string_view(line).substr(10)));
				docBlock.found = true;
				continue;
			}
			if (line.rfind("@class ", 0) == 0) {
				parseLuaDocClass(docBlock, std::string_view(line).substr(7));
				docBlock.found = true;
				continue;
			}
			if (line.rfind("@field ", 0) == 0) {
				parseLuaDocField(docBlock, std::string_view(line).substr(7));
				docBlock.found = true;
				continue;
			}
			if (line.rfind("@overload ", 0) == 0) {
				parseLuaDocOverload(docBlock, std::string_view(line).substr(10));
				docBlock.found = true;
				continue;
			}
			if (line.rfind("@param ", 0) == 0) {
				parseLuaDocParam(docBlock, std::string_view(line).substr(7));
				docBlock.found = true;
				continue;
			}
			if (line.rfind("@return ", 0) == 0) {
				appendValue(docBlock.returns, normalizeManualLuaTypeExpression(std::string_view(line).substr(8)));
				docBlock.found = true;
			}
		}

		return docBlock;
	}

	LuaDocBlock extractLuaDocBlockBeforePosition(const std::string &content, const size_t position) {
		if (position == std::string::npos) {
			return {};
		}

		const auto blockEnd = content.rfind("*/", position);
		if (blockEnd == std::string::npos) {
			return {};
		}

		const auto blockStart = content.rfind("/***", blockEnd);
		if (blockStart == std::string::npos) {
			return {};
		}

		if (!isLuaDocSignaturePrefix(content.substr(blockEnd + 2, position - blockEnd - 2))) {
			return {};
		}

		return parseLuaDocBlock(content.substr(blockStart + 4, blockEnd - blockStart - 4));
	}

	LuaDocBlock extractLuaDocBlock(const std::string &content, const std::string &handler) {
		if (handler.empty()) {
			return {};
		}

		return extractLuaDocBlockBeforePosition(content, findHandlerSignature(content, handler));
	}

	void applyLuaDocBlock(LuaFunctionInfo &info, const LuaDocBlock &docBlock) {
		if (!docBlock.found) {
			return;
		}

		if (!docBlock.className.empty()) {
			info.className = docBlock.className;
		}
		if (!docBlock.functionName.empty()) {
			info.name = docBlock.functionName;
		}
		if (!docBlock.className.empty() || !docBlock.functionName.empty()) {
			info.hasSelfParameter = docBlock.hasSelfParameter;
		}
		if (!docBlock.parameters.empty()) {
			info.parameters = docBlock.parameters;
		}
		if (!docBlock.returns.empty()) {
			info.returns = docBlock.returns;
			info.returnType = getLuaReturnType(docBlock.returns.front());
		}
		if (!docBlock.overloads.empty()) {
			info.overloads = docBlock.overloads;
		}
		info.hasExplicitDocumentation = true;
	}

	void applyExplicitLuaDoc(LuaFunctionInfo &info, const std::string &content, const size_t registrationPosition = std::string::npos) {
		auto docBlock = extractLuaDocBlockBeforePosition(content, registrationPosition);
		if (!docBlock.found) {
			docBlock = extractLuaDocBlock(content, info.handler);
		}

		applyLuaDocBlock(info, docBlock);
	}

	void applyExplicitLuaClassDoc(LuaScanResult &result, const std::string &className, const std::string &content, const std::string &handler, const size_t registrationPosition = std::string::npos) {
		auto docBlock = extractLuaDocBlockBeforePosition(content, registrationPosition);
		if (!docBlock.found) {
			docBlock = extractLuaDocBlock(content, handler);
		}

		if (!docBlock.found) {
			return;
		}

		const auto targetClassName = docBlock.className.empty() ? className : docBlock.className;
		for (const auto &field : docBlock.fields) {
			appendUnique(result.classFields[targetClassName], field);
		}
		for (const auto &overload : docBlock.overloads) {
			appendUnique(result.classOverloads[targetClassName], overload);
		}
	}

	bool extractFunctionBody(const std::string &content, const std::string &handler, std::string &body) {
		const auto handlerPosition = findHandlerSignature(content, handler);
		if (handlerPosition == std::string::npos) {
			return false;
		}

		auto cursor = content.find('(', handlerPosition + handler.size());
		if (cursor == std::string::npos) {
			return false;
		}
		const auto closeParenthesis = findMatchingDelimiter(content, cursor, '(', ')');
		if (closeParenthesis == std::string::npos) {
			return false;
		}
		cursor = closeParenthesis + 1;
		while (cursor < content.size() && std::isspace(static_cast<unsigned char>(content[cursor]))) {
			++cursor;
		}
		if (cursor >= content.size() || content[cursor] != '{') {
			return false;
		}
		const auto closeBrace = findMatchingDelimiter(content, cursor, '{', '}');
		if (closeBrace == std::string::npos) {
			return false;
		}

		body = content.substr(cursor + 1, closeBrace - cursor - 1);
		return true;
	}

	std::string jsonEscape(const std::string &value) {
		std::ostringstream stream;
		for (const auto ch : value) {
			switch (ch) {
				case '\\':
					stream << R"(\\)";
					break;
				case '"':
					stream << R"(\")";
					break;
				case '\n':
					stream << R"(\n)";
					break;
				case '\r':
					stream << R"(\r)";
					break;
				case '\t':
					stream << R"(\t)";
					break;
				default:
					if (static_cast<unsigned char>(ch) < 0x20) {
						stream << fmt::format(R"(\u{:04X})", static_cast<int>(static_cast<unsigned char>(ch)));
					} else {
						stream << ch;
					}
					break;
			}
		}
		return stream.str();
	}

	std::string joinStrings(const std::vector<std::string> &values, const std::string_view separator) {
		std::ostringstream output;
		for (size_t i = 0; i < values.size(); ++i) {
			if (i > 0) {
				output << separator;
			}
			output << values[i];
		}
		return output.str();
	}

	std::vector<std::string> displayParametersFor(const LuaFunctionInfo &function) {
		return normalizeLuaDocParameters(function.parameters, !function.hasExplicitDocumentation);
	}

	void writeMarkdownFunctionEntry(std::ostringstream &output, const std::string_view heading, const std::string &signatureName, const LuaFunctionInfo &function) {
		output << heading << " `" << signatureName << "(" << joinStrings(displayParametersFor(function), ", ") << ")`\n\n";
		if (!function.overloads.empty()) {
			output << "- Overloads:\n";
			for (const auto &overload : function.overloads) {
				output << "  - `" << overload << "`\n";
			}
		}
		output << "- Returns: `" << joinLuaReturnAnnotations(function) << "`\n";
		output << "- Source: `" << function.sourceFile << "`\n\n";
	}

	void writeJsonStringArray(std::ostringstream &output, const std::string &indent, const std::string_view key, const std::vector<std::string> &values) {
		if (values.empty()) {
			output << indent << "\"" << key << "\": [],\n";
			return;
		}

		output << indent << "\"" << key << "\": [\n";
		for (size_t i = 0; i < values.size(); ++i) {
			output << indent << "  \"" << jsonEscape(values[i]) << "\"";
			if (i + 1 < values.size()) {
				output << ",";
			}
			output << "\n";
		}
		output << indent << "],\n";
	}

	void writeJsonFunctionObject(std::ostringstream &output, const LuaFunctionInfo &function, const std::string &indent) {
		output << indent << "{\n";
		output << indent << R"(  "name": ")" << jsonEscape(function.name) << R"(",)"
			   << "\n";
		if (!function.overloads.empty()) {
			writeJsonStringArray(output, indent + "  ", "overloads", function.overloads);
		}
		writeJsonStringArray(output, indent + "  ", "params", displayParametersFor(function));
		output << indent << R"(  "return": ")" << jsonEscape(joinLuaReturnAnnotations(function)) << R"(",)"
			   << "\n";
		output << indent << R"(  "source": ")" << jsonEscape(function.sourceFile) << R"(")"
			   << "\n";
		output << indent << "}";
	}

	void writeJsonClassStringArrayMap(std::ostringstream &output, const std::map<std::string, LuaClassInfo, std::less<>> &classes, const std::string_view key, const std::vector<std::string> LuaClassInfo::*member) {
		output << "  \"" << key << "\": {\n";
		bool firstClass = true;
		for (const auto &[name, classInfo] : classes) {
			const auto &values = classInfo.*member;
			if (values.empty()) {
				continue;
			}
			if (!firstClass) {
				output << ",\n";
			}
			firstClass = false;
			output << "    \"" << jsonEscape(name) << "\": [\n";
			for (size_t i = 0; i < values.size(); ++i) {
				output << "      \"" << jsonEscape(values[i]) << "\"";
				if (i + 1 < values.size()) {
					output << ",";
				}
				output << "\n";
			}
			output << "    ]";
		}
		output << "\n";
		output << "  }";
	}

	void appendClassStringValues(std::vector<std::string> &target, const std::vector<std::string> &values) {
		for (const auto &value : values) {
			appendUnique(target, value);
		}
	}

	void appendMappedClassStringValues(std::vector<std::string> &target, const LuaClassValuesMap &valuesByClass, const std::string &className) {
		if (const auto values = valuesByClass.find(className); values != valuesByClass.end()) {
			appendClassStringValues(target, values->second);
		}
	}

	void applyClassBase(LuaClassInfo &classInfo, const LuaStringMap &baseClasses, const std::string &className) {
		if (!classInfo.baseClass.empty()) {
			return;
		}

		if (const auto baseClass = baseClasses.find(className); baseClass != baseClasses.end()) {
			classInfo.baseClass = baseClass->second;
		}
	}

	void applyScannedClassMetadata(LuaClassInfo &classInfo, const LuaScanResult &scanResult, const std::string &className) {
		classInfo.name = className;
		applyClassBase(classInfo, scanResult.classBaseClasses, className);
		appendMappedClassStringValues(classInfo.fields, scanResult.classFields, className);
		appendMappedClassStringValues(classInfo.overloads, scanResult.classOverloads, className);
	}

	void applyScannedClassValues(LuaClassMap &classes, const LuaClassValuesMap &valuesByClass, std::vector<std::string> LuaClassInfo::*member) {
		for (const auto &[name, values] : valuesByClass) {
			auto &classInfo = classes[name];
			classInfo.name = name;
			appendClassStringValues(classInfo.*member, values);
		}
	}

	void writeMarkdownStringList(std::ostringstream &output, const std::string_view title, const std::vector<std::string> &values) {
		if (values.empty()) {
			return;
		}

		output << "- " << title << ":\n";
		for (const auto &value : values) {
			output << "  - `" << value << "`\n";
		}
		output << "\n";
	}

	void writeMarkdownClassMetadata(std::ostringstream &output, const LuaClassInfo &classInfo) {
		if (!classInfo.baseClass.empty()) {
			output << "- Extends: `" << classInfo.baseClass << "`\n\n";
		}
		writeMarkdownStringList(output, "Fields", classInfo.fields);
		writeMarkdownStringList(output, "Overloads", classInfo.overloads);
	}

	void writeMarkdownClassMethods(std::ostringstream &output, const std::string &name, const LuaClassInfo &classInfo) {
		for (const auto &method : classInfo.methods) {
			if (isLuaMetaMethod(method)) {
				continue;
			}
			writeMarkdownFunctionEntry(output, "####", name + (method.hasSelfParameter ? ":" : ".") + method.name, method);
		}
	}

	void writeMarkdownClasses(std::ostringstream &output, const LuaClassMap &classes) {
		for (const auto &[name, classInfo] : classes) {
			output << "### " << name << "\n\n";
			writeMarkdownClassMetadata(output, classInfo);
			writeMarkdownClassMethods(output, name, classInfo);
		}
	}

	void writeMarkdownGlobals(std::ostringstream &output, const std::vector<LuaFunctionInfo> &globals) {
		if (globals.empty()) {
			return;
		}

		output << "## Global\n\n";
		for (const auto &function : globals) {
			writeMarkdownFunctionEntry(output, "###", function.name, function);
		}
	}

	using LuaTypeAlias = std::pair<std::string_view, std::string_view>;

	[[nodiscard]] constexpr std::array<LuaTypeAlias, 6> getLuaTypeAliases() {
		return { {
			{ "CombatType", "integer" },
			{ "DistanceEffect", "integer" },
			{ "MagicEffect", "integer" },
			{ "ReturnValue", "integer" },
			{ "SoundEffect", "integer" },
			{ "TileState", "integer" },
		} };
	}

	void writeLuaTypeAliases(std::ostringstream &output) {
		for (const auto &[name, type] : getLuaTypeAliases()) {
			output << "---@alias " << name << " " << type << "\n";
		}
		output << "\n";
	}

	void writeMarkdownTypeAliases(std::ostringstream &output) {
		output << "## Type Aliases\n\n";
		for (const auto &[name, type] : getLuaTypeAliases()) {
			output << "- `" << name << "`: `" << type << "`\n";
		}
		output << "\n";
	}

	void writeJsonTypeAliases(std::ostringstream &output) {
		output << "  \"typeAliases\": {\n";
		const auto &aliases = getLuaTypeAliases();
		for (size_t i = 0; i < aliases.size(); ++i) {
			const auto &[name, type] = aliases[i];
			output << "    \"" << jsonEscape(std::string(name)) << "\": \"" << jsonEscape(std::string(type)) << "\"";
			if (i + 1 < aliases.size()) {
				output << ",";
			}
			output << "\n";
		}
		output << "  },\n";
	}

	std::vector<const LuaFunctionInfo*> getPublicMethods(const LuaClassInfo &classInfo) {
		std::vector<const LuaFunctionInfo*> publicMethods;
		for (const auto &method : classInfo.methods) {
			if (!isLuaMetaMethod(method)) {
				appendValue(publicMethods, &method);
			}
		}
		return publicMethods;
	}

	void writeJsonClassMethods(std::ostringstream &output, const LuaClassInfo &classInfo) {
		const auto publicMethods = getPublicMethods(classInfo);
		for (size_t i = 0; i < publicMethods.size(); ++i) {
			writeJsonFunctionObject(output, *publicMethods[i], "      ");
			if (i + 1 < publicMethods.size()) {
				output << ",";
			}
			output << "\n";
		}
	}

	void writeJsonClasses(std::ostringstream &output, const LuaClassMap &classes) {
		output << "  \"classes\": {\n";
		bool firstClass = true;
		for (const auto &[name, classInfo] : classes) {
			if (!firstClass) {
				output << ",\n";
			}
			firstClass = false;
			output << "    \"" << jsonEscape(name) << "\": [\n";
			writeJsonClassMethods(output, classInfo);
			output << "    ]";
		}
		output << "\n";
		output << "  },\n";
	}

	void writeJsonClassParents(std::ostringstream &output, const LuaClassMap &classes) {
		output << "  \"classParents\": {\n";
		bool firstParent = true;
		for (const auto &[name, classInfo] : classes) {
			if (classInfo.baseClass.empty()) {
				continue;
			}
			if (!firstParent) {
				output << ",\n";
			}
			firstParent = false;
			output << "    \"" << jsonEscape(name) << "\": \"" << jsonEscape(classInfo.baseClass) << "\"";
		}
		output << "\n";
		output << "  },\n";
	}

	void writeJsonGlobals(std::ostringstream &output, const std::vector<LuaFunctionInfo> &globals) {
		if (globals.empty()) {
			output << "  \"globals\": []\n";
			return;
		}

		output << "  \"globals\": [\n";
		for (size_t i = 0; i < globals.size(); ++i) {
			writeJsonFunctionObject(output, globals[i], "    ");
			if (i + 1 < globals.size()) {
				output << ",";
			}
			output << "\n";
		}
		output << "  ]\n";
	}

	std::string finishGeneratedFile(std::string content) {
		while (!content.empty() && (content.back() == '\n' || content.back() == '\r')) {
			content.pop_back();
		}
		content.push_back('\n');
		return content;
	}

	bool writeFileAtomically(const std::filesystem::path &path, const std::string &content, std::string &errorMessage) {
		std::error_code ec;
		const auto createdDirectory = std::filesystem::create_directories(path.parent_path(), ec);
		static_cast<void>(createdDirectory);
		if (ec) {
			errorMessage = fmt::format("failed to create {}: {}", path.parent_path().generic_string(), ec.message());
			return false;
		}

		if (std::filesystem::exists(path, ec) && !ec) {
			std::ifstream existing(path, std::ios::binary);
			if (existing.is_open()) {
				std::stringstream buffer;
				buffer << existing.rdbuf();
				if (buffer.str() == content) {
					return true;
				}
			}
		}
		ec.clear();

		auto tempPath = path;
		tempPath += ".tmp";
		{
			std::ofstream output(tempPath, std::ios::binary | std::ios::trunc);
			if (!output.is_open()) {
				errorMessage = fmt::format("failed to open {}", tempPath.generic_string());
				return false;
			}
			output << content;
			if (!output.good()) {
				errorMessage = fmt::format("failed to write {}", tempPath.generic_string());
				return false;
			}
		}

		std::filesystem::rename(tempPath, path, ec);
		if (ec) {
			const auto removedTarget = std::filesystem::remove(path, ec);
			static_cast<void>(removedTarget);
			ec.clear();
			std::filesystem::rename(tempPath, path, ec);
		}
		if (ec) {
			errorMessage = fmt::format("failed to replace {}: {}", path.generic_string(), ec.message());
			return false;
		}
		return true;
	}
}

LuaBindingScanner::LuaBindingScanner(std::filesystem::path rootPath) :
	root(std::move(rootPath)) { }

LuaScanResult LuaBindingScanner::scan() const {
	LuaScanResult result;
	const auto sourceRoot = root / "src";
	std::error_code ec;
	if (!std::filesystem::exists(sourceRoot, ec) || ec) {
		return result;
	}

	std::filesystem::recursive_directory_iterator it(sourceRoot, std::filesystem::directory_options::skip_permission_denied, ec);
	const std::filesystem::recursive_directory_iterator end;
	while (it != end) {
		if (ec) {
			ec.clear();
			incrementIterator(it, ec);
			continue;
		}

		const auto &entry = *it;
		if (!entry.is_regular_file(ec) || ec) {
			ec.clear();
			incrementIterator(it, ec);
			continue;
		}

		const auto extension = entry.path().extension().string();
		if (extension != ".cpp" && extension != ".hpp") {
			incrementIterator(it, ec);
			continue;
		}

		scanFile(entry.path(), result);
		incrementIterator(it, ec);
	}

	return result;
}

void LuaBindingScanner::scanFile(const std::filesystem::path &filePath, LuaScanResult &result) const {
	std::ifstream stream(filePath);
	if (!stream.is_open()) {
		return;
	}

	std::stringstream buffer;
	buffer << stream.rdbuf();
	const auto content = buffer.str();

	parseLuaReg(content, filePath, result);
	parseRegistrations(content, filePath, result);
}
void LuaBindingScanner::parseLuaReg(const std::string &content, const std::filesystem::path &filePath, LuaScanResult &result) const {
	// Canary does NOT use luaL_Reg, but kept in case there is some legacy code
	if (content.find("luaL_Reg") == std::string::npos) {
		return;
	}

	std::regex luaRegPattern(
		R"regex(luaL_Reg\s+([A-Za-z0-9_]+)\s*\[\]\s*=\s*\{((?:[^\{\}]|\{[^\{\}]*\})*?)\}\s*;)regex",
		std::regex::optimize | std::regex::icase
	);
	std::regex entryPattern(
		R"regex(\{\s*"([^"]+)"\s*,\s*([A-Za-z0-9_:]+)\s*\}\s*,?)regex",
		std::regex::optimize | std::regex::icase
	);

	for (auto regIt = std::sregex_iterator(content.begin(), content.end(), luaRegPattern); regIt != std::sregex_iterator(); ++regIt) {
		const auto block = (*regIt)[2].str();
		LuaStringSet seen;
		for (auto entryIt = std::sregex_iterator(block.begin(), block.end(), entryPattern); entryIt != std::sregex_iterator(); ++entryIt) {
			const auto name = (*entryIt)[1].str();
			if (!addUnique(seen, name)) {
				continue;
			}
			LuaFunctionInfo info;
			info.name = name;
			info.handler = (*entryIt)[2].str();
			info.returnType = normalizeReturnType(content, info.handler);
			info.sourceFile = relativePath(filePath);
			info.parameters = inferParameters(content, info.handler, false);
			applyExplicitLuaDoc(info, content);
			appendValue(result.functions, std::move(info));
		}
	}
}

void LuaBindingScanner::parseRegistrations(const std::string &content, const std::filesystem::path &filePath, LuaScanResult &result) const {

	std::regex classPattern(
		R"regex(Lua::register(?:Shared)?Class\s*\(\s*[^,]*,\s*"([^"]+)"\s*,\s*"([^"]*)"(?:\s*,\s*([A-Za-z0-9_:]+))?)regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), classPattern); it != std::sregex_iterator(); ++it) {
		const auto className = (*it)[1].str();
		const auto baseClass = (*it)[2].str();
		const auto constructorHandler = (*it)[3].str();
		const auto classInserted = addUnique(result.classes, className);
		if (!baseClass.empty() && (classInserted || !result.classBaseClasses.contains(className))) {
			result.classBaseClasses[className] = baseClass;
		}
		applyExplicitLuaClassDoc(result, className, content, constructorHandler, static_cast<size_t>(it->position(0)));
	}

	std::regex methodPattern(
		R"regex(Lua::registerMethod\s*\(\s*[^,]+,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*([A-Za-z0-9_:]+))regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), methodPattern); it != std::sregex_iterator(); ++it) {
		LuaFunctionInfo info;
		info.className = (*it)[1].str();
		info.name = (*it)[2].str();
		info.handler = (*it)[3].str();
		info.returnType = info.handler == "Lua::luaGarbageCollection" ? "nil" : normalizeReturnType(content, info.handler);
		info.hasSelfParameter = usesSelfParameter(content, info.handler);
		info.parameters = inferParameters(content, info.handler, info.hasSelfParameter);
		info.sourceFile = relativePath(filePath);
		applyExplicitLuaDoc(info, content, static_cast<size_t>(it->position(0)));
		appendValue(result.functions, std::move(info));
	}

	std::regex metaMethodPattern(
		R"regex(Lua::registerMetaMethod\s*\(\s*[^,]+,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*([A-Za-z0-9_:]+))regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), metaMethodPattern); it != std::sregex_iterator(); ++it) {
		LuaFunctionInfo info;
		info.className = (*it)[1].str();
		info.name = (*it)[2].str();
		info.handler = (*it)[3].str();
		if (info.handler == "Lua::luaUserdataCompare") {
			info.returnType = "boolean";
		} else if (info.handler == "Lua::luaGarbageCollection") {
			info.returnType = "nil";
		} else {
			info.returnType = normalizeReturnType(content, info.handler);
		}
		info.hasSelfParameter = true;
		info.parameters = inferParameters(content, info.handler, info.hasSelfParameter);
		if (info.name == "__eq" && info.parameters.empty()) {
			appendValue(info.parameters, "other: " + info.className);
		}
		info.sourceFile = relativePath(filePath);
		applyExplicitLuaDoc(info, content, static_cast<size_t>(it->position(0)));
		appendValue(result.functions, std::move(info));
	}

	std::regex globalPattern(
		R"regex(Lua::registerGlobalMethod\s*\(\s*"([^"]+)"\s*,\s*([A-Za-z0-9_:]+))regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), globalPattern); it != std::sregex_iterator(); ++it) {
		LuaFunctionInfo info;
		info.name = (*it)[1].str();
		info.handler = (*it)[2].str();
		info.returnType = normalizeReturnType(content, info.handler);
		info.parameters = inferParameters(content, info.handler, false);
		info.sourceFile = relativePath(filePath);
		applyExplicitLuaDoc(info, content, static_cast<size_t>(it->position(0)));
		appendValue(result.functions, std::move(info));
	}

	std::regex constantBoolPattern(
		R"regex(Lua::registerGlobalBoolean\s*\(\s*"([^"]+)")regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), constantBoolPattern); it != std::sregex_iterator(); ++it) {
		LuaFunctionInfo info;
		info.name = (*it)[1].str();
		info.returnType = "boolean";
		info.sourceFile = relativePath(filePath);
		applyExplicitLuaDoc(info, content, static_cast<size_t>(it->position(0)));
		appendValue(result.functions, std::move(info));
	}

	std::regex constantNumberPattern(
		R"regex(Lua::registerGlobalVariable\s*\(\s*"([^"]+)")regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), constantNumberPattern); it != std::sregex_iterator(); ++it) {
		LuaFunctionInfo info;
		info.name = (*it)[1].str();
		info.returnType = "number";
		info.sourceFile = relativePath(filePath);
		applyExplicitLuaDoc(info, content, static_cast<size_t>(it->position(0)));
		appendValue(result.functions, std::move(info));
	}

	std::regex constantStringPattern(
		R"regex(Lua::registerGlobalString\s*\(\s*"([^"]+)")regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), constantStringPattern); it != std::sregex_iterator(); ++it) {
		LuaFunctionInfo info;
		info.name = (*it)[1].str();
		info.returnType = "string";
		info.sourceFile = relativePath(filePath);
		applyExplicitLuaDoc(info, content, static_cast<size_t>(it->position(0)));
		appendValue(result.functions, std::move(info));
	}
}

std::vector<std::string> LuaBindingScanner::inferParameters(const std::string &content, const std::string &handler, bool skipSelfParameter) const {
	std::vector<std::string> parameters;

	if (handler.empty()) {
		return parameters;
	}

	std::string rawBody;
	if (!extractFunctionBody(content, handler, rawBody)) {
		return parameters;
	}

	return inferParametersFromBody(rawBody, skipSelfParameter);
}

std::vector<std::string> LuaBindingScanner::splitParameters(const std::string &parameters) const {
	std::vector<std::string> values;
	std::stringstream paramStream(parameters);
	std::string item;
	while (std::getline(paramStream, item, ',')) {
		const auto trimmed = trim(item);
		if (!trimmed.empty()) {
			appendValue(values, trimmed);
		}
	}
	return values;
}

bool LuaBindingScanner::usesSelfParameter(const std::string &content, const std::string &handler) const {
	if (handler.empty()) {
		return false;
	}

	std::string body;
	if (!extractFunctionBody(content, handler, body)) {
		return false;
	}

	const auto signatureHint = extractLuaSignatureHint(body);
	if (signatureHint.found) {
		return signatureHint.hasSelfParameter;
	}

	const auto strippedBody = stripComments(body);
	const auto flags = std::regex::optimize | std::regex::icase;
	return std::regex_search(strippedBody, std::regex(R"regex((?:Lua::)?get(?:Raw)?UserData(?:Shared)?\s*(?:<[^>]+>)?\s*\(\s*L\s*,\s*1\b)regex", flags));
}

std::string LuaBindingScanner::normalizeReturnType(const std::string &content, const std::string &handler) const {
	if (handler.empty()) {
		return "any";
	}

	std::string body;
	if (extractFunctionBody(content, handler, body)) {
		try {
			const auto inferred = inferReturnByBody(stripComments(body));
			if (inferred != "any") {
				return inferred;
			}
		} catch (const std::regex_error &) {
			return "any";
		}
	}

	const auto handlerPosition = findHandlerSignature(content, handler);
	if (handlerPosition != std::string::npos) {
		const auto normalized = normalizeLuaType(getReturnTypeBeforeHandler(content, handlerPosition));
		return normalized == "number" ? "any" : normalized;
	}

	return "any";
}

std::string LuaBindingScanner::inferReturnByBody(const std::string &body) const {
	auto returnBody = std::regex_replace(body, std::regex(R"regex(lua_pushstring\s*\([^;]*\);\s*lua_error\s*\([^;]*\);)regex"), "");
	returnBody = std::regex_replace(returnBody, std::regex(R"regex(lua_push(?:number|integer|string|boolean)\s*\([^;]*\);\s*(?:Lua::)?push[A-Za-z0-9_]*\s*(?:<[^>]+>)?\s*\([^;]*\);\s*(?:(?:Lua::)?set[A-Za-z0-9_]*\s*\([^;]*\);\s*)?lua_settable\s*\([^;]*\);)regex"), "");
	returnBody = std::regex_replace(returnBody, std::regex(R"regex((?:Lua::)?push[A-Za-z0-9_]*\s*(?:<[^>]+>)?\s*\([^;]*\);\s*(?:(?:Lua::)?set[A-Za-z0-9_]*\s*\([^;]*\);\s*)?lua_(?:rawseti|setfield|settable|rawset)\s*\([^;]*\);)regex"), "");
	returnBody = std::regex_replace(returnBody, std::regex(R"regex(lua_push(?:number|integer|string|boolean|nil)\s*\([^;]*\);\s*lua_(?:rawseti|setfield|settable|rawset)\s*\([^;]*\);)regex"), "");
	returnBody = std::regex_replace(returnBody, std::regex(R"regex(lua_pushnil\s*\(\s*L\s*\);\s*(?:[^{};]+;\s*){0,4}while\s*\(\s*lua_next)regex"), "while (lua_next");
	if (std::regex_search(returnBody, std::regex(R"regex(return\s+0\s*;)regex")) && !std::regex_search(returnBody, std::regex(R"regex(return\s+[1-9]\d*\s*;)regex"))) {
		return "nil";
	}

	std::vector<std::string> returnTypes;
	addReturnTypeIfContains(returnTypes, returnBody, { "lua_pushboolean", "pushBoolean" }, "boolean");
	addReturnTypeIfContains(returnTypes, returnBody, { "lua_pushnumber", "lua_pushinteger", "pushNumber" }, "number");
	addReturnTypeIfContains(returnTypes, returnBody, { "lua_pushstring", "pushString" }, "string");
	addReturnTypeIfContains(returnTypes, returnBody, { "lua_createtable", "lua_newtable" }, "table");
	addReturnTypeIfContains(returnTypes, returnBody, { "lua_pushnil", "pushNil" }, "nil");
	addReturnTypeIfContains(returnTypes, returnBody, { "pushPosition" }, "Position");
	if (std::regex_search(returnBody, std::regex(R"regex(pushUserdata\s*\(\s*L\s*,[^;]*getOrCreateTile\s*\()regex"))) {
		addUniqueReturnType(returnTypes, "Tile");
	} else if (std::regex_search(returnBody, std::regex(R"regex(pushUserdata\s*\(\s*L\s*,[^;]*getTile\s*\()regex"))) {
		addUniqueReturnType(returnTypes, "nil|Tile");
	}

	std::regex metatablePattern(R"regex((?:Lua::)?set(?:[A-Za-z0-9_]*)?Metatable\s*\([^;]*,\s*"([A-Za-z_][A-Za-z0-9_]*)"\s*\))regex");
	for (auto it = std::sregex_iterator(returnBody.begin(), returnBody.end(), metatablePattern); it != std::sregex_iterator(); ++it) {
		addUniqueReturnType(returnTypes, (*it)[1].str());
	}

	std::regex pushTemplatePattern(R"regex(push[A-Za-z0-9_]*\s*<\s*([^>]+)\s*>\s*\()regex");
	for (auto it = std::sregex_iterator(returnBody.begin(), returnBody.end(), pushTemplatePattern); it != std::sregex_iterator(); ++it) {
		addUniqueReturnType(returnTypes, (*it)[1].str());
	}
	if (returnBody.find("pushUserdata") != std::string::npos && returnTypes.empty()) {
		addUniqueReturnType(returnTypes, "any");
	}

	if (returnTypes.empty() && (returnBody.find("return true") != std::string::npos || returnBody.find("return false") != std::string::npos)) {
		return "boolean";
	}

	if (returnTypes.empty() && returnBody.find("lua_push") == std::string::npos && returnBody.find("push") == std::string::npos) {
		return "nil";
	}

	if (returnTypes.empty()) {
		return "any";
	}

	if (std::ranges::find(returnTypes, "any") != returnTypes.end()) {
		return "any";
	}

	std::ostringstream stream;
	for (size_t i = 0; i < returnTypes.size(); ++i) {
		if (i > 0) {
			stream << "|";
		}
		stream << returnTypes[i];
	}
	return stream.str();
}

std::string LuaBindingScanner::relativePath(const std::filesystem::path &path) const {
	const auto relative = path.lexically_relative(root);
	if (!relative.empty() && relative.generic_string().find("..") != 0) {
		return relative.generic_string();
	}
	return path.filename().generic_string();
}

LuaApiDocGenerator::LuaApiDocGenerator(const std::filesystem::path &initialProjectRoot, std::filesystem::path outputDirectory, Logger &logger) :
	logger(logger),
	projectRoot(findProjectRoot(initialProjectRoot)),
	docsDirectory(resolveDocsDirectory(outputDirectory)) { }

bool LuaApiDocGenerator::generate() {
	try {
		std::error_code ec;
		const auto createdDirectory = std::filesystem::create_directories(docsDirectory, ec);
		static_cast<void>(createdDirectory);
		if (ec) {
			logger.warn(fmt::format("Failed to create Lua API documentation directory {}: {}", docsDirectory.generic_string(), ec.message()));
			return false;
		}

		LuaBindingScanner scanner(projectRoot);
		const auto scanResult = scanner.scan();
		if (scanResult.classes.empty() && scanResult.functions.empty()) {
			logger.warn(fmt::format("Lua API documentation scan found no Lua bindings under {}", (projectRoot / "src").generic_string()));
			return false;
		}
		buildModel(scanResult);
		const bool exported = exportEmmyLua() && exportMarkdown() && exportJson();
		if (!exported) {
			return false;
		}
		return true;
	} catch (const std::filesystem::filesystem_error &e) {
		logger.warn(fmt::format("Failed to generate Lua API documentation: {}", e.what()));
		return false;
	} catch (const std::regex_error &e) {
		logger.warn(fmt::format("Failed to generate Lua API documentation: {}", e.what()));
		return false;
	} catch (const std::ios_base::failure &e) {
		logger.warn(fmt::format("Failed to generate Lua API documentation: {}", e.what()));
		return false;
	} catch (const std::system_error &e) {
		logger.warn(fmt::format("Failed to generate Lua API documentation: {}", e.what()));
		return false;
	} catch (const std::invalid_argument &e) {
		logger.warn(fmt::format("Failed to generate Lua API documentation: {}", e.what()));
		return false;
	} catch (const std::out_of_range &e) {
		logger.warn(fmt::format("Failed to generate Lua API documentation: {}", e.what()));
		return false;
	} catch (const std::length_error &e) {
		logger.warn(fmt::format("Failed to generate Lua API documentation: {}", e.what()));
		return false;
	}
}

std::filesystem::path LuaApiDocGenerator::findProjectRoot(const std::filesystem::path &start) const {
	auto current = start;
	const auto existsWithoutError = [](const std::filesystem::path &path) {
		std::error_code ec;
		return std::filesystem::exists(path, ec) && !ec;
	};

	while (!current.empty()) {
		if (existsWithoutError(current / "src") && existsWithoutError(current / "config.lua.dist")) {
			return current;
		}
		auto parent = current.parent_path();
		if (parent == current) {
			break;
		}
		current = parent;
	}
	return start;
}

std::filesystem::path LuaApiDocGenerator::resolveDocsDirectory(const std::filesystem::path &outputDirectory) const {
	const auto output = outputDirectory.empty() ? std::filesystem::path("docs/lua-api") : outputDirectory;
	if (output.is_absolute()) {
		return output.lexically_normal();
	}
	return (projectRoot / output).lexically_normal();
}

void LuaApiDocGenerator::buildModel(const LuaScanResult &scanResult) {
	classes.clear();
	globals.clear();

	for (const auto &className : scanResult.classes) {
		applyScannedClassMetadata(classes[className], scanResult, className);
	}

	std::unordered_map<std::string, LuaStringSet, TransparentStringHash, std::equal_to<>> classMethodNames;
	LuaStringSet globalNames;

	for (const auto &function : scanResult.functions) {
		if (function.className.empty()) {
			const auto &key = function.name;
			if (addUnique(globalNames, key)) {
				appendValue(globals, function);
			}
			continue;
		}

		auto &classInfo = classes[function.className];
		applyScannedClassMetadata(classInfo, scanResult, function.className);
		auto &names = classMethodNames[function.className];
		if (addUnique(names, function.name)) {
			appendValue(classInfo.methods, function);
		}
	}

	applyScannedClassValues(classes, scanResult.classFields, &LuaClassInfo::fields);
	applyScannedClassValues(classes, scanResult.classOverloads, &LuaClassInfo::overloads);

	for (auto &[name, classInfo] : classes) {
		static_cast<void>(name);
		const auto sortedMethodsEnd = std::ranges::sort(classInfo.methods, {}, &LuaFunctionInfo::name);
		static_cast<void>(sortedMethodsEnd);
	}

	const auto sortedGlobalsEnd = std::ranges::sort(globals, {}, &LuaFunctionInfo::name);
	static_cast<void>(sortedGlobalsEnd);
}

bool LuaApiDocGenerator::exportEmmyLua() const {
	auto path = docsDirectory / "lua_api.d.lua";
	std::ostringstream output;

	output << "---@meta\n";
	output << "--- Auto-generated Lua API (do not edit manually)\n\n";
	writeLuaTypeAliases(output);

	for (const auto &[name, classInfo] : classes) {
		output << "---@class " << name;
		if (!classInfo.baseClass.empty()) {
			output << ": " << classInfo.baseClass;
		}
		output << "\n";
		for (const auto &field : classInfo.fields) {
			output << "---@field " << field << "\n";
		}
		writeLuaOverloadAnnotations(output, classInfo.overloads);
		for (const auto &method : classInfo.methods) {
			writeLuaOperatorAnnotation(output, name, method);
		}
		output << name << " = {}\n\n";
		for (const auto &method : classInfo.methods) {
			if (isLuaMetaMethod(method)) {
				continue;
			}
			writeLuaFunctionDefinition(output, name, method);
		}
	}

	if (!globals.empty()) {
		for (const auto &function : globals) {
			writeLuaFunctionDefinition(output, "", function);
		}
	}

	std::string errorMessage;
	if (!writeFileAtomically(path, finishGeneratedFile(output.str()), errorMessage)) {
		logger.warn(fmt::format("Failed to write Lua API EmmyLua documentation: {}", errorMessage));
		return false;
	}
	return true;
}

bool LuaApiDocGenerator::exportMarkdown() const {
	auto path = docsDirectory / "lua_api.md";
	std::ostringstream output;
	auto docsDirectoryPath = docsDirectory.lexically_relative(projectRoot).generic_string();
	if (docsDirectoryPath.empty() || docsDirectoryPath.find("..") == 0) {
		docsDirectoryPath = docsDirectory.filename().generic_string();
	}
	const auto docsFilePath = [&docsDirectoryPath](const std::string &fileName) {
		return (std::filesystem::path(docsDirectoryPath) / fileName).generic_string();
	};

	output << "# Lua API\n\n";
	output << "This file is auto-generated from Canary's C++ Lua bindings. Do not edit it manually.\n\n";
	output << "## Generated Files\n\n";
	output << "- `" << docsFilePath("lua_api.d.lua") << "`: Lua Language Server definition file for IntelliSense.\n";
	output << "- `" << docsFilePath("lua_api.md") << "`: human-readable API reference.\n";
	output << "- `" << docsFilePath("lua_api.json") << "`: structured API metadata for tooling.\n\n";
	writeMarkdownTypeAliases(output);
	output << "## VSCode IntelliSense\n\n";
	output << "Install the Lua extension for VSCode. The repository `.luarc.json` already adds `" << docsDirectoryPath
		   << "` to the Lua workspace library and sets `workspace.preloadFileSize` high enough for `" << docsFilePath("lua_api.d.lua") << "`.\n\n";
	output << "On Windows, run `tools/setup_vscode_lua_api.ps1` from the repository root to also update local `.vscode/settings.json` workspace settings. "
		   << "The helper keeps `.luarc.json` aligned and ignores generated build, cache, Visual Studio, and vcpkg directories through `workspace.ignoreDir`.\n\n";
	output << "For manual setup, add `" << docsDirectoryPath << "` or `" << docsFilePath("lua_api.d.lua")
		   << "` to the Lua Language Server workspace library. Canary updates these files during startup when `generateLuaApiDocs` is enabled in `config.lua`.\n\n";
	output << "Some signatures are inferred from C++ bindings and may use `any`, `argN`, or `...` until explicit Lua API annotations are added.\n\n";
	output << "## Manual Signature Hints\n\n";
	output << "C++ Lua binding handlers and registration lines can override inferred signatures with a `/*** */` block immediately before the handler or `Lua::register*` call. Supported tags are `@class`, `@field`, `@function`, `@overload`, `@param`, and `@return`; functions without docblocks continue to use automatic inference.\n\n";
	output << "## Classes\n\n";
	writeMarkdownClasses(output, classes);
	writeMarkdownGlobals(output, globals);

	std::string errorMessage;
	if (!writeFileAtomically(path, finishGeneratedFile(output.str()), errorMessage)) {
		logger.warn(fmt::format("Failed to write Lua API Markdown documentation: {}", errorMessage));
		return false;
	}
	return true;
}

bool LuaApiDocGenerator::exportJson() const {
	auto path = docsDirectory / "lua_api.json";
	std::ostringstream output;

	output << "{\n";
	writeJsonTypeAliases(output);
	writeJsonClasses(output, classes);
	writeJsonClassParents(output, classes);
	writeJsonClassStringArrayMap(output, classes, "classFields", &LuaClassInfo::fields);
	output << ",\n";
	writeJsonClassStringArrayMap(output, classes, "classOverloads", &LuaClassInfo::overloads);
	output << ",\n";
	writeJsonGlobals(output, globals);
	output << "}\n";

	std::string errorMessage;
	if (!writeFileAtomically(path, finishGeneratedFile(output.str()), errorMessage)) {
		logger.warn(fmt::format("Failed to write Lua API JSON documentation: {}", errorMessage));
		return false;
	}

	return true;
}
