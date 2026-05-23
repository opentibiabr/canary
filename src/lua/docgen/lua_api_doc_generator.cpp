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
	#include <cctype>
	#include <fstream>
	#include <iomanip>
	#include <regex>
	#include <set>
	#include <sstream>
	#include <system_error>
#endif

namespace {
	struct ParameterHint {
		std::string name;
		bool optional { false };
	};

	struct LuaSignatureHint {
		bool found { false };
		bool hasSelfParameter { false };
		std::vector<ParameterHint> parameters;
	};

	struct LuaDocParameter {
		std::string name;
		std::string type;
		bool optional { false };
		bool variadic { false };
	};

	std::string trim(const std::string &value) {
		const auto start = value.find_first_not_of(" \t\n\r");
		const auto end = value.find_last_not_of(" \t\n\r");
		if (start == std::string::npos || end == std::string::npos) {
			return "";
		}
		return value.substr(start, end - start + 1);
	}

	std::string collapseWhitespace(const std::string &value) {
		return trim(std::regex_replace(value, std::regex(R"regex(\s+)regex"), " "));
	}

	std::string escapeRegex(const std::string &value) {
		std::string escaped;
		escaped.reserve(value.size() * 2);
		for (const auto ch : value) {
			if (std::string(R"(\.^$|()[]{}*+?)").find(ch) != std::string::npos) {
				escaped.push_back('\\');
			}
			escaped.push_back(ch);
		}
		return escaped;
	}

	std::string stripComments(const std::string &value) {
		auto withoutBlockComments = std::regex_replace(value, std::regex(R"regex(/\*[\s\S]*?\*/)regex"), " ");
		return std::regex_replace(withoutBlockComments, std::regex(R"regex(//[^\r\n]*)regex"), " ");
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
		return trim(type.substr(prefix.size(), type.size() - prefix.size() - 1));
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
		if (type.size() > 2 && type.substr(type.size() - 2) == "_t") {
			return "any";
		}
		static const std::set<std::string> cppOnlyTypes = {
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
		if (cppOnlyTypes.find(type) != cppOnlyTypes.end()) {
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
				normalizedTypes.emplace_back(std::move(normalized));
			}
		}
		if (normalizedTypes.empty()) {
			return "any";
		}
		if (std::ranges::find(normalizedTypes, "any") != normalizedTypes.end()) {
			return normalizedTypes.size() == 1 ? "any" : "any";
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

	std::string normalizeManualLuaTypeExpression(const std::string &type) {
		const auto normalized = collapseWhitespace(type);
		return normalized.empty() ? "any" : normalized;
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
		static const std::set<std::string> reservedNames = {
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
		if (name.empty() || reservedNames.find(name) != reservedNames.end() || !std::regex_match(name, std::regex(R"regex([A-Za-z_][A-Za-z0-9_]*)regex"))) {
			return "arg" + std::to_string(index);
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
				values.emplace_back(std::move(trimmed));
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
			auto name = separator == std::string::npos ? trimmed : trim(trimmed.substr(0, separator));
			auto type = separator == std::string::npos ? "any" : trim(trimmed.substr(separator + 1));

			LuaDocParameter parsedParameter;
			if (name == "...") {
				parsedParameter.name = "...";
				parsedParameter.type = normalizeTypes ? normalizeLuaTypeExpression(type.empty() ? "any" : type) : normalizeManualLuaTypeExpression(type);
				parsedParameter.variadic = true;
				parsedParameters.emplace_back(std::move(parsedParameter));
				continue;
			}

			if (!name.empty() && name.back() == '?') {
				name.pop_back();
				parsedParameter.optional = true;
			}

			parsedParameter.name = sanitizeParameterName(name, parameterIndex);
			parsedParameter.type = normalizeTypes ? normalizeLuaTypeExpression(type.empty() ? "any" : type) : normalizeManualLuaTypeExpression(type);
			parsedParameters.emplace_back(std::move(parsedParameter));
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
				normalizedParameters.emplace_back("...: " + parameter.type);
			} else {
				normalizedParameters.emplace_back(parameter.name + std::string(parameter.optional ? "?: " : ": ") + parameter.type);
			}
		}
		return normalizedParameters;
	}

	std::string getLuaOperatorName(const std::string &methodName) {
		static const std::unordered_map<std::string, std::string> operatorNames = {
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

	void writeLuaFunctionDefinition(std::ostringstream &output, const std::string &owner, const LuaFunctionInfo &function) {
		const auto parameters = parseLuaDocParameters(function.parameters, !function.hasExplicitDocumentation);
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
			return "arg" + std::to_string(index);
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
			hint.parameters.push_back({ std::move(name), optional });
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
	};

	std::string cleanLuaDocBlockLine(std::string line) {
		line = trim(line);
		if (!line.empty() && line.front() == '*') {
			line = trim(line.substr(1));
		}
		return line;
	}

	void parseLuaDocFunction(LuaDocBlock &docBlock, const std::string &symbol) {
		const auto colon = symbol.find(':');
		const auto dot = symbol.find('.');
		const auto separator = colon == std::string::npos ? dot : colon;
		if (separator == std::string::npos) {
			docBlock.functionName = symbol;
			docBlock.hasSelfParameter = false;
			return;
		}

		docBlock.className = symbol.substr(0, separator);
		docBlock.functionName = symbol.substr(separator + 1);
		docBlock.hasSelfParameter = symbol[separator] == ':';
	}

	void parseLuaDocParam(LuaDocBlock &docBlock, const std::string &value) {
		const auto trimmed = trim(value);
		if (trimmed.empty()) {
			return;
		}

		const auto separator = trimmed.find_first_of(" \t");
		auto name = separator == std::string::npos ? trimmed : trim(trimmed.substr(0, separator));
		const auto type = separator == std::string::npos ? "any" : normalizeManualLuaTypeExpression(trimmed.substr(separator + 1));
		bool optional = false;
		if (!name.empty() && name.back() == '?') {
			name.pop_back();
			optional = true;
		}

		if (name == "...") {
			docBlock.parameters.emplace_back("...: " + type);
			return;
		}
		docBlock.parameters.emplace_back(name + std::string(optional ? "?: " : ": ") + type);
	}

	LuaDocBlock extractLuaDocBlock(const std::string &content, const std::string &handler) {
		LuaDocBlock docBlock;
		if (handler.empty()) {
			return docBlock;
		}

		const std::regex signaturePattern(std::string("\\b") + escapeRegex(handler) + R"regex(\s*\()regex", std::regex::optimize);
		std::smatch match;
		if (!std::regex_search(content, match, signaturePattern)) {
			return docBlock;
		}

		const auto handlerPosition = static_cast<size_t>(match.position(0));
		const auto blockEnd = content.rfind("*/", handlerPosition);
		if (blockEnd == std::string::npos) {
			return docBlock;
		}

		const auto blockStart = content.rfind("/***", blockEnd);
		if (blockStart == std::string::npos) {
			return docBlock;
		}

		const auto signaturePrefix = content.substr(blockEnd + 2, handlerPosition - blockEnd - 2);
		if (!std::regex_match(signaturePrefix, std::regex(R"regex([\sA-Za-z0-9_:<>,\*&]+)regex"))) {
			return docBlock;
		}

		const auto block = content.substr(blockStart + 4, blockEnd - blockStart - 4);
		std::stringstream stream(block);
		std::string line;
		while (std::getline(stream, line)) {
			line = cleanLuaDocBlockLine(line);
			if (line.rfind("@function ", 0) == 0) {
				parseLuaDocFunction(docBlock, trim(line.substr(10)));
				docBlock.found = true;
				continue;
			}
			if (line.rfind("@param ", 0) == 0) {
				parseLuaDocParam(docBlock, line.substr(7));
				docBlock.found = true;
				continue;
			}
			if (line.rfind("@return ", 0) == 0) {
				docBlock.returns.emplace_back(normalizeManualLuaTypeExpression(line.substr(8)));
				docBlock.found = true;
			}
		}

		return docBlock;
	}

	void applyExplicitLuaDoc(LuaFunctionInfo &info, const std::string &content) {
		const auto docBlock = extractLuaDocBlock(content, info.handler);
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
		info.hasExplicitDocumentation = true;
	}

	void applyKnownSignatureFixes(LuaFunctionInfo &info) {
		if (info.className == "Game" && info.name == "createTile") {
			info.parameters = {
				"x: number|Position",
				"y?: number|boolean",
				"z?: number",
				"isDynamic?: boolean",
			};
		}
	}

	bool extractFunctionBody(const std::string &content, const std::string &handler, std::string &body) {
		std::regex signaturePattern(
			std::string("\\b") + handler + "\\s*\\([^)]*\\)\\s*\\{",
			std::regex::optimize | std::regex::icase
		);
		std::smatch match;
		if (!std::regex_search(content, match, signaturePattern)) {
			return false;
		}

		const auto openBrace = static_cast<size_t>(match.position(0) + match.length(0) - 1);
		int depth = 0;
		for (size_t i = openBrace; i < content.size(); ++i) {
			if (content[i] == '{') {
				++depth;
				continue;
			}
			if (content[i] != '}') {
				continue;
			}
			--depth;
			if (depth == 0) {
				body = content.substr(openBrace + 1, i - openBrace - 1);
				return true;
			}
		}

		return false;
	}

	std::string jsonEscape(const std::string &value) {
		std::ostringstream stream;
		for (const auto ch : value) {
			switch (ch) {
				case '\\':
					stream << "\\\\";
					break;
				case '"':
					stream << "\\\"";
					break;
				case '\n':
					stream << "\\n";
					break;
				case '\r':
					stream << "\\r";
					break;
				case '\t':
					stream << "\\t";
					break;
				default:
					if (static_cast<unsigned char>(ch) < 0x20) {
						stream << "\\u" << std::hex << std::uppercase << std::setw(4) << std::setfill('0') << static_cast<int>(static_cast<unsigned char>(ch));
					} else {
						stream << ch;
					}
					break;
			}
		}
		return stream.str();
	}

	bool writeFileAtomically(const std::filesystem::path &path, const std::string &content, std::string &errorMessage) {
		std::error_code ec;
		std::filesystem::create_directories(path.parent_path(), ec);
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

		const auto tempPath = path.string() + ".tmp";
		{
			std::ofstream output(tempPath, std::ios::binary | std::ios::trunc);
			if (!output.is_open()) {
				errorMessage = fmt::format("failed to open {}", std::filesystem::path(tempPath).generic_string());
				return false;
			}
			output << content;
			if (!output.good()) {
				errorMessage = fmt::format("failed to write {}", std::filesystem::path(tempPath).generic_string());
				return false;
			}
		}

		std::filesystem::rename(tempPath, path, ec);
		if (ec) {
			std::filesystem::remove(path, ec);
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
			it.increment(ec);
			continue;
		}

		const auto &entry = *it;
		if (!entry.is_regular_file(ec) || ec) {
			ec.clear();
			it.increment(ec);
			continue;
		}

		const auto extension = entry.path().extension().string();
		if (extension != ".cpp" && extension != ".hpp") {
			it.increment(ec);
			continue;
		}

		scanFile(entry.path(), result);
		it.increment(ec);
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
		std::unordered_set<std::string> seen;
		for (auto entryIt = std::sregex_iterator(block.begin(), block.end(), entryPattern); entryIt != std::sregex_iterator(); ++entryIt) {
			const auto name = (*entryIt)[1].str();
			if (!seen.insert(name).second) {
				continue;
			}
			LuaFunctionInfo info;
			info.name = name;
			info.handler = (*entryIt)[2].str();
			info.returnType = normalizeReturnType(content, info.handler);
			info.sourceFile = relativePath(filePath);
			info.parameters = inferParameters(content, info.handler, false);
			applyKnownSignatureFixes(info);
			applyExplicitLuaDoc(info, content);
			result.functions.emplace_back(std::move(info));
		}
	}
}

void LuaBindingScanner::parseRegistrations(const std::string &content, const std::filesystem::path &filePath, LuaScanResult &result) const {

	std::regex classPattern(
		R"regex(Lua::register(?:Shared)?Class\s*\(\s*[^,]*,\s*"([^"]+)"\s*,\s*"([^"]*)")regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), classPattern); it != std::sregex_iterator(); ++it) {
		const auto className = (*it)[1].str();
		const auto baseClass = (*it)[2].str();
		result.classes.insert(className);
		if (!baseClass.empty()) {
			result.classBaseClasses[className] = baseClass;
		}
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
		info.returnType = normalizeReturnType(content, info.handler);
		info.hasSelfParameter = usesSelfParameter(content, info.handler);
		info.parameters = inferParameters(content, info.handler, info.hasSelfParameter);
		info.sourceFile = relativePath(filePath);
		applyKnownSignatureFixes(info);
		applyExplicitLuaDoc(info, content);
		result.functions.emplace_back(std::move(info));
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
			info.parameters.emplace_back("other: " + info.className);
		}
		info.sourceFile = relativePath(filePath);
		applyKnownSignatureFixes(info);
		applyExplicitLuaDoc(info, content);
		result.functions.emplace_back(std::move(info));
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
		applyKnownSignatureFixes(info);
		applyExplicitLuaDoc(info, content);
		result.functions.emplace_back(std::move(info));
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
		applyKnownSignatureFixes(info);
		applyExplicitLuaDoc(info, content);
		result.functions.emplace_back(std::move(info));
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
		applyKnownSignatureFixes(info);
		applyExplicitLuaDoc(info, content);
		result.functions.emplace_back(std::move(info));
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
		applyKnownSignatureFixes(info);
		applyExplicitLuaDoc(info, content);
		result.functions.emplace_back(std::move(info));
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

	const auto signatureHint = extractLuaSignatureHint(rawBody);
	const auto body = stripComments(rawBody);
	const auto flags = std::regex::optimize | std::regex::icase;

	struct ParameterInfo {
		std::string type;
		std::string name;
		bool optional { false };
	};

	auto normalizeType = [](const std::string &type) -> std::string {
		return normalizeLuaTypeExpression(type);
	};

	auto deduceTypeFromGetter = [&normalizeType](const std::string &getter, const std::string &templ) -> std::string {
		if (!templ.empty()) {
			const auto normalizedTemplate = normalizeType(templ);
			if (!normalizedTemplate.empty()) {
				return normalizedTemplate;
			}
		}

		std::string base;
		base.reserve(getter.size());
		for (const auto ch : getter) {
			base.push_back(static_cast<char>(std::tolower(static_cast<unsigned char>(ch))));
		}

		static const std::unordered_map<std::string, std::string> typeMap = {
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

		const auto found = typeMap.find(base);
		if (found != typeMap.end()) {
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
	};

	std::map<int, ParameterInfo> parameterMap;
	auto betterName = [](const std::string &current, const std::string &candidate) {
		if (candidate.empty()) {
			return false;
		}
		if (current.empty()) {
			return true;
		}
		if (current.rfind("arg", 0) == 0 && candidate.rfind("arg", 0) != 0) {
			return true;
		}
		return false;
	};

	auto mergeTypes = [](const std::string &current, const std::string &candidate) {
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
			const auto normalized = normalizeLuaTypeExpression(item);
			if (!normalized.empty() && std::ranges::find(parts, normalized) == parts.end()) {
				parts.emplace_back(normalized);
			}
		}

		std::stringstream candidateStream(candidate);
		while (std::getline(candidateStream, item, '|')) {
			const auto normalized = normalizeLuaTypeExpression(item);
			if (normalized.empty() || normalized == "any") {
				continue;
			}
			if (std::ranges::find(parts, normalized) == parts.end()) {
				parts.emplace_back(normalized);
			}
		}

		if (parts.empty()) {
			return std::string("any");
		}

		if (std::ranges::find_if(parts, [](const std::string &type) {
				return type != "nil" && type != "any" && type != "boolean" && type != "string" && type != "number" && type != "integer" && type != "function" && type != "table" && type != "thread" && type != "userdata" && type != "lightuserdata";
			}) != parts.end()) {
			std::erase(parts, std::string("userdata"));
		}

		std::ostringstream output;
		for (size_t i = 0; i < parts.size(); ++i) {
			if (i > 0) {
				output << "|";
			}
			output << parts[i];
		}
		return output.str();
	};

	auto addParameter = [&](int index, const std::string &type, const std::string &name, bool optional) {
		if (index < 0) {
			index = 1;
		}
		if (index <= 0) {
			return;
		}
		if (skipSelfParameter && index == 1) {
			return;
		}
		auto &param = parameterMap[index];
		const auto normalizedType = normalizeType(type);
		param.type = mergeTypes(param.type, normalizedType);
		if (betterName(param.name, name)) {
			param.name = name;
		}
		param.optional = param.optional || optional;
	};

	std::set<int> optionalThresholds;
	std::regex topPattern(R"regex(lua_gettop\s*\(\s*L\s*\)\s*([<>!=]=?|==)\s*(\d+))regex", flags);
	for (auto it = std::sregex_iterator(body.begin(), body.end(), topPattern); it != std::sregex_iterator(); ++it) {
		const auto op = (*it)[1].str();
		const int threshold = std::stoi((*it)[2].str());
		int optionalStart = 0;
		if (op == ">=" || op == ">") {
			optionalStart = threshold;
		} else if (op == "==" || op == "=") {
			optionalStart = threshold + 1;
		} else if (op == "<" || op == "<=") {
			optionalStart = threshold + 1;
		}
		if (optionalStart > 0) {
			optionalThresholds.insert(optionalStart);
		}
	}

	std::vector<std::pair<std::regex, std::string>> simpleGetters = {
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_tonumber\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_tointeger\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_tostring\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "string" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_toboolean\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "boolean" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_checknumber\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_checkinteger\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_checkstring\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "string" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_opt(?:number|integer)\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_optstring\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "string" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isnumber\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isinteger\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isstring\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "string" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isboolean\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "boolean" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isuserdata\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "userdata" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_istable\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex", flags), "table" }
	};

	for (const auto &[pattern, type] : simpleGetters) {
		for (auto it = std::sregex_iterator(body.begin(), body.end(), pattern); it != std::sregex_iterator(); ++it) {
			const auto index = std::stoi((*it)[1].str());
			addParameter(index, type, "", false);
		}
	}

	std::regex assignmentWithType(
		R"regex((?:const\s+)?([A-Za-z_][A-Za-z0-9_:<>, \*&]+?)\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(?:[A-Za-z_][A-Za-z0-9_:]*::)?(?:Lua::)?get([A-Za-z0-9_]+)\s*(?:<([^>]+)>)?\s*\(\s*L\s*,\s*(-?\d+)(?:\s*,[^)]*)?\))regex",
		flags
	);
	for (auto it = std::sregex_iterator(body.begin(), body.end(), assignmentWithType); it != std::sregex_iterator(); ++it) {
		const auto declaredTypeRaw = trim((*it)[1].str());
		const auto declaredType = normalizeType(declaredTypeRaw);
		const auto name = (*it)[2].str();
		const auto getter = (*it)[3].str();
		const auto templ = trim((*it)[4].str());
		const auto index = std::stoi((*it)[5].str());
		const auto inferredType = !declaredType.empty() && toLowerCopy(declaredTypeRaw) != "auto" ? declaredType : deduceTypeFromGetter(getter, templ);
		addParameter(index, inferredType, name, false);
	}

	std::regex assignmentAuto(
		R"regex((?:const\s+)?auto\s*&?\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(?:[A-Za-z_][A-Za-z0-9_:]*::)?(?:Lua::)?get([A-Za-z0-9_]+)\s*(?:<([^>]+)>)?\s*\(\s*L\s*,\s*(-?\d+)(?:\s*,[^)]*)?\))regex",
		flags
	);
	for (auto it = std::sregex_iterator(body.begin(), body.end(), assignmentAuto); it != std::sregex_iterator(); ++it) {
		const auto name = (*it)[1].str();
		const auto getter = (*it)[2].str();
		const auto templ = trim((*it)[3].str());
		const auto index = std::stoi((*it)[4].str());
		addParameter(index, deduceTypeFromGetter(getter, templ), name, false);
	}

	std::regex directGetter(
		R"regex((?:[A-Za-z_][A-Za-z0-9_:]*::)?(?:Lua::)?get([A-Za-z0-9_]+)\s*(?:<([^>]+)>)?\s*\(\s*L\s*,\s*(-?\d+)(?:\s*,[^)]*)?\))regex",
		flags
	);
	for (auto it = std::sregex_iterator(body.begin(), body.end(), directGetter); it != std::sregex_iterator(); ++it) {
		const auto getter = (*it)[1].str();
		const auto templ = trim((*it)[2].str());
		const auto index = std::stoi((*it)[3].str());
		addParameter(index, deduceTypeFromGetter(getter, templ), "", false);
	}

	std::regex namedLuaHelpers(
		R"regex((?:const\s+)?(?:auto|[A-Za-z_][A-Za-z0-9_:<>\s\*&]+)\s*&?\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(lua_[a-z]+|luaL_check[a-z]+|luaL_opt[a-z]+)\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex",
		flags
	);
	for (auto it = std::sregex_iterator(body.begin(), body.end(), namedLuaHelpers); it != std::sregex_iterator(); ++it) {
		const auto name = (*it)[1].str();
		const auto helper = (*it)[2].str();
		const auto index = std::stoi((*it)[3].str());
		std::string helperType;
		if (helper.find("string") != std::string::npos) {
			helperType = "string";
		} else if (helper.find("number") != std::string::npos || helper.find("integer") != std::string::npos) {
			helperType = "number";
		} else if (helper.find("boolean") != std::string::npos || helper.find("bool") != std::string::npos) {
			helperType = "boolean";
		}
		addParameter(index, helperType, name, false);
	}

	std::regex explicitTypeAssignment(
		R"regex((?:const\s+)?([A-Za-z_][A-Za-z0-9_:<>, \*&]+?)\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(?:lua_[a-z]+|luaL_[a-z]+)\s*\(\s*L\s*,\s*(-?\d+)\s*\))regex",
		flags
	);
	for (auto it = std::sregex_iterator(body.begin(), body.end(), explicitTypeAssignment); it != std::sregex_iterator(); ++it) {
		const auto declaredType = normalizeType((*it)[1].str());
		const auto name = (*it)[2].str();
		const auto index = std::stoi((*it)[3].str());
		addParameter(index, declaredType, name, false);
	}

	for (const auto threshold : optionalThresholds) {
		for (auto &[idx, info] : parameterMap) {
			if (idx >= threshold) {
				info.optional = true;
			}
		}
	}

	if (signatureHint.found && !signatureHint.parameters.empty()) {
		for (size_t i = 0; i < signatureHint.parameters.size(); ++i) {
			const auto &hint = signatureHint.parameters[i];
			const auto stackIndex = static_cast<int>(i + 1 + (skipSelfParameter ? 1 : 0));
			const auto found = parameterMap.find(stackIndex);
			const auto type = found != parameterMap.end() && !found->second.type.empty() ? found->second.type : inferTypeFromParameterName(hint.name);
			auto name = sanitizeParameterName(hint.name, stackIndex);
			if (hint.optional || (found != parameterMap.end() && found->second.optional)) {
				name.push_back('?');
			}
			parameters.emplace_back(name + ": " + normalizeLuaTypeExpression(type));
		}
		return parameters;
	}

	for (const auto &[index, info] : parameterMap) {
		std::string name = sanitizeParameterName(info.name, index);
		if (info.optional) {
			name.push_back('?');
		}
		const auto type = info.type.empty() ? "any" : normalizeLuaTypeExpression(info.type);
		parameters.emplace_back(name + ": " + type);
	}

	if (parameters.empty()) {
		if (!skipSelfParameter) {
			parameters.emplace_back("...");
		}
	}

	return parameters;
}

std::vector<std::string> LuaBindingScanner::splitParameters(const std::string &parameters) const {
	std::vector<std::string> values;
	std::stringstream paramStream(parameters);
	std::string item;
	while (std::getline(paramStream, item, ',')) {
		const auto trimmed = trim(item);
		if (!trimmed.empty()) {
			values.emplace_back(trimmed);
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

	std::regex signaturePattern(
		std::string("(\\w+)\\s+") + handler + "\\s*\\(",
		std::regex::optimize | std::regex::icase
	);

	std::string body;
	if (extractFunctionBody(content, handler, body)) {
		const auto inferred = inferReturnByBody(stripComments(body));
		if (inferred != "any") {
			return inferred;
		}
	}

	std::smatch match;
	if (std::regex_search(content, match, signaturePattern)) {
		const auto normalized = normalizeLuaType(match[1].str());
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
	auto addReturnType = [&returnTypes](const std::string &type) {
		const auto normalized = normalizeLuaTypeExpression(type);
		if (std::ranges::find(returnTypes, normalized) == returnTypes.end()) {
			returnTypes.emplace_back(normalized);
		}
	};

	if (returnBody.find("lua_pushboolean") != std::string::npos || returnBody.find("pushBoolean") != std::string::npos) {
		addReturnType("boolean");
	}
	if (returnBody.find("lua_pushnumber") != std::string::npos || returnBody.find("lua_pushinteger") != std::string::npos || returnBody.find("pushNumber") != std::string::npos) {
		addReturnType("number");
	}
	if (returnBody.find("lua_pushstring") != std::string::npos || returnBody.find("pushString") != std::string::npos) {
		addReturnType("string");
	}
	if (returnBody.find("lua_createtable") != std::string::npos || returnBody.find("lua_newtable") != std::string::npos) {
		addReturnType("table");
	}
	if (returnBody.find("lua_pushnil") != std::string::npos || returnBody.find("pushNil") != std::string::npos) {
		addReturnType("nil");
	}
	if (returnBody.find("pushPosition") != std::string::npos) {
		addReturnType("Position");
	}
	if (std::regex_search(returnBody, std::regex(R"regex(pushUserdata\s*\(\s*L\s*,[^;]*getOrCreateTile\s*\()regex"))) {
		addReturnType("Tile");
	} else if (std::regex_search(returnBody, std::regex(R"regex(pushUserdata\s*\(\s*L\s*,[^;]*getTile\s*\()regex"))) {
		addReturnType("nil|Tile");
	}

	std::regex metatablePattern(R"regex((?:Lua::)?set(?:[A-Za-z0-9_]*)?Metatable\s*\([^;]*,\s*"([A-Za-z_][A-Za-z0-9_]*)"\s*\))regex");
	for (auto it = std::sregex_iterator(returnBody.begin(), returnBody.end(), metatablePattern); it != std::sregex_iterator(); ++it) {
		addReturnType((*it)[1].str());
	}

	std::regex pushTemplatePattern(R"regex(push[A-Za-z0-9_]*\s*<\s*([^>]+)\s*>\s*\()regex");
	for (auto it = std::sregex_iterator(returnBody.begin(), returnBody.end(), pushTemplatePattern); it != std::sregex_iterator(); ++it) {
		addReturnType((*it)[1].str());
	}
	if (returnBody.find("pushUserdata") != std::string::npos && returnTypes.empty()) {
		addReturnType("any");
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

LuaApiDocGenerator::LuaApiDocGenerator(const std::filesystem::path &projectRoot, std::filesystem::path outputDirectory, Logger &logger) :
	logger(logger),
	projectRoot(findProjectRoot(projectRoot)),
	docsDirectory(resolveDocsDirectory(std::move(outputDirectory))) { }

bool LuaApiDocGenerator::generate() {
	try {
		std::error_code ec;
		std::filesystem::create_directories(docsDirectory, ec);
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
	} catch (const std::exception &e) {
		logger.warn(fmt::format("Failed to generate Lua API documentation: {}", e.what()));
		return false;
	}
}

std::filesystem::path LuaApiDocGenerator::findProjectRoot(const std::filesystem::path &start) const {
	auto current = start;
	std::error_code ec;
	while (!current.empty()) {
		if (std::filesystem::exists(current / "src", ec) && !ec && std::filesystem::exists(current / "config.lua.dist", ec) && !ec) {
			return current;
		}
		ec.clear();
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
		classes[className].name = className;
		if (const auto baseClass = scanResult.classBaseClasses.find(className); baseClass != scanResult.classBaseClasses.end()) {
			classes[className].baseClass = baseClass->second;
		}
	}

	std::unordered_map<std::string, std::unordered_set<std::string>> classMethodNames;
	std::unordered_set<std::string> globalNames;

	for (const auto &function : scanResult.functions) {
		if (function.className.empty()) {
			const auto key = function.name;
			if (globalNames.insert(key).second) {
				globals.push_back(function);
			}
			continue;
		}

		auto &classInfo = classes[function.className];
		classInfo.name = function.className;
		if (classInfo.baseClass.empty()) {
			if (const auto baseClass = scanResult.classBaseClasses.find(function.className); baseClass != scanResult.classBaseClasses.end()) {
				classInfo.baseClass = baseClass->second;
			}
		}
		auto &names = classMethodNames[function.className];
		if (names.insert(function.name).second) {
			classInfo.methods.push_back(function);
		}
	}

	for (auto &classEntry : classes) {
		auto &methods = classEntry.second.methods;
		std::sort(methods.begin(), methods.end(), [](const auto &left, const auto &right) {
			return left.name < right.name;
		});
	}

	std::sort(globals.begin(), globals.end(), [](const auto &left, const auto &right) {
		return left.name < right.name;
	});
}

bool LuaApiDocGenerator::exportEmmyLua() const {
	auto path = docsDirectory / "lua_api.d.lua";
	std::ostringstream output;

	output << "---@meta\n";
	output << "--- Auto-generated Lua API (do not edit manually)\n\n";

	for (const auto &[name, classInfo] : classes) {
		output << "---@class " << name;
		if (!classInfo.baseClass.empty()) {
			output << ": " << classInfo.baseClass;
		}
		output << "\n";
		for (const auto &method : classInfo.methods) {
			writeLuaOperatorAnnotation(output, name, method);
		}
		output << name << " = {}\n\n";
		for (const auto &method : classInfo.methods) {
			writeLuaFunctionDefinition(output, name, method);
		}
	}

	if (!globals.empty()) {
		for (const auto &function : globals) {
			writeLuaFunctionDefinition(output, "", function);
		}
	}

	std::string errorMessage;
	if (!writeFileAtomically(path, output.str(), errorMessage)) {
		logger.warn(fmt::format("Failed to write Lua API EmmyLua documentation: {}", errorMessage));
		return false;
	}
	return true;
}

bool LuaApiDocGenerator::exportMarkdown() const {
	auto path = docsDirectory / "lua_api.md";
	std::ostringstream output;

	output << "# Lua API\n\n";
	output << "This file is auto-generated from Canary's C++ Lua bindings. Do not edit it manually.\n\n";
	output << "## Generated Files\n\n";
	output << "- `docs/lua-api/lua_api.d.lua`: Lua Language Server definition file for IntelliSense.\n";
	output << "- `docs/lua-api/lua_api.md`: human-readable API reference.\n";
	output << "- `docs/lua-api/lua_api.json`: structured API metadata for tooling.\n\n";
	output << "## VSCode IntelliSense\n\n";
	output << "Install the Lua extension for VSCode and add `docs/lua-api` or `docs/lua-api/lua_api.d.lua` to the Lua workspace library. Canary updates these files during startup when `generateLuaApiDocs` is enabled in `config.lua`.\n\n";
	output << "Some signatures are inferred from C++ bindings and may use `any`, `argN`, or `...` until explicit Lua API annotations are added.\n\n";
	output << "## Manual Signature Hints\n\n";
	output << "C++ Lua binding handlers can override inferred signatures with a `/*** */` block immediately before the handler. Supported tags are `@function`, `@param`, and `@return`; functions without docblocks continue to use automatic inference.\n\n";
	output << "## Classes\n\n";
	for (const auto &[name, classInfo] : classes) {
		output << "### " << name << "\n\n";
		if (!classInfo.baseClass.empty()) {
			output << "- Extends: `" << classInfo.baseClass << "`\n\n";
		}
		for (const auto &method : classInfo.methods) {
			const auto parameters = normalizeLuaDocParameters(method.parameters, !method.hasExplicitDocumentation);
			output << "#### `" << name << (method.hasSelfParameter ? ":" : ".") << method.name << "(";
			for (size_t i = 0; i < parameters.size(); ++i) {
				output << parameters[i];
				if (i + 1 < parameters.size()) {
					output << ", ";
				}
			}
			output << ")`\n\n";
			output << "- Returns: `" << joinLuaReturnAnnotations(method) << "`\n";
			output << "- Source: `" << method.sourceFile << "`\n\n";
		}
	}

	if (!globals.empty()) {
		output << "## Global\n\n";
		for (const auto &function : globals) {
			const auto parameters = normalizeLuaDocParameters(function.parameters, !function.hasExplicitDocumentation);
			output << "### `" << function.name << "(";
			for (size_t i = 0; i < parameters.size(); ++i) {
				output << parameters[i];
				if (i + 1 < parameters.size()) {
					output << ", ";
				}
			}
			output << ")`\n\n";
			output << "- Returns: `" << joinLuaReturnAnnotations(function) << "`\n";
			output << "- Source: `" << function.sourceFile << "`\n\n";
		}
	}

	std::string errorMessage;
	if (!writeFileAtomically(path, output.str(), errorMessage)) {
		logger.warn(fmt::format("Failed to write Lua API Markdown documentation: {}", errorMessage));
		return false;
	}
	return true;
}

bool LuaApiDocGenerator::exportJson() const {
	auto path = docsDirectory / "lua_api.json";
	std::ostringstream output;

	output << "{\n";
	output << "  \"classes\": {\n";
	bool firstClass = true;
	for (const auto &[name, classInfo] : classes) {
		if (!firstClass) {
			output << ",\n";
		}
		firstClass = false;
		output << "    \"" << jsonEscape(name) << "\": [\n";
		for (size_t i = 0; i < classInfo.methods.size(); ++i) {
			const auto &method = classInfo.methods[i];
			const auto parameters = normalizeLuaDocParameters(method.parameters, !method.hasExplicitDocumentation);
			output << "      {\n";
			output << "        \"name\": \"" << jsonEscape(method.name) << "\",\n";
			if (parameters.empty()) {
				output << "        \"params\": [],\n";
			} else {
				output << "        \"params\": [\n";
				for (size_t p = 0; p < parameters.size(); ++p) {
					output << "          \"" << jsonEscape(parameters[p]) << "\"";
					if (p + 1 < parameters.size()) {
						output << ",";
					}
					output << "\n";
				}
				output << "        ],\n";
			}
			output << "        \"return\": \"" << jsonEscape(joinLuaReturnAnnotations(method)) << "\",\n";
			output << "        \"source\": \"" << jsonEscape(method.sourceFile) << "\"\n";
			output << "      }";
			if (i + 1 < classInfo.methods.size()) {
				output << ",";
			}
			output << "\n";
		}
		output << "    ]";
	}

	output << "\n";
	output << "  },\n";
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
	if (globals.empty()) {
		output << "  \"globals\": []\n";
	} else {
		output << "  \"globals\": [\n";
		for (size_t i = 0; i < globals.size(); ++i) {
			const auto &function = globals[i];
			const auto parameters = normalizeLuaDocParameters(function.parameters, !function.hasExplicitDocumentation);
			output << "    {\n";
			output << "      \"name\": \"" << jsonEscape(function.name) << "\",\n";
			if (parameters.empty()) {
				output << "      \"params\": [],\n";
			} else {
				output << "      \"params\": [\n";
				for (size_t p = 0; p < parameters.size(); ++p) {
					output << "        \"" << jsonEscape(parameters[p]) << "\"";
					if (p + 1 < parameters.size()) {
						output << ",";
					}
					output << "\n";
				}
				output << "      ],\n";
			}
			output << "      \"return\": \"" << jsonEscape(joinLuaReturnAnnotations(function)) << "\",\n";
			output << "      \"source\": \"" << jsonEscape(function.sourceFile) << "\"\n";
			output << "    }";
			if (i + 1 < globals.size()) {
				output << ",";
			}
			output << "\n";
		}
		output << "  ]\n";
	}
	output << "}\n";

	std::string errorMessage;
	if (!writeFileAtomically(path, output.str(), errorMessage)) {
		logger.warn(fmt::format("Failed to write Lua API JSON documentation: {}", errorMessage));
		return false;
	}

	return true;
}
