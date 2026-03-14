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

namespace {
	std::string trim(const std::string &value) {
		const auto start = value.find_first_not_of(" \t\n\r");
		const auto end = value.find_last_not_of(" \t\n\r");
		if (start == std::string::npos || end == std::string::npos) {
			return "";
		}
		return value.substr(start, end - start + 1);
	}
}

LuaBindingScanner::LuaBindingScanner(std::filesystem::path rootPath) :
	root(std::move(rootPath)) { }

LuaScanResult LuaBindingScanner::scan() const {
	LuaScanResult result;
	const auto sourceRoot = root / "src";
	if (!std::filesystem::exists(sourceRoot)) {
		return result;
	}

	for (const auto &entry : std::filesystem::recursive_directory_iterator(sourceRoot)) {
		if (!entry.is_regular_file()) {
			continue;
		}

		const auto extension = entry.path().extension().string();
		if (extension != ".cpp" && extension != ".hpp") {
			continue;
		}

		scanFile(entry.path(), result);
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
		std::regex::optimize | std::regex::icase | std::regex::multiline
	);
	std::regex entryPattern(
		R"regex(\{\s*"([^"]+)"\s*,\s*([A-Za-z0-9_:]+)\s*\}\s*,?)regex",
		std::regex::optimize | std::regex::icase | std::regex::multiline
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
			info.parameters = inferParameters(content, info.handler);
			result.functions.emplace_back(std::move(info));
		}
	}
}

void LuaBindingScanner::parseRegistrations(const std::string &content, const std::filesystem::path &filePath, LuaScanResult &result) const {

	std::regex classPattern(
		R"regex(Lua::register(?:Shared)?Class\s*\(\s*[^,]*,\s*"([^"]+)")regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), classPattern); it != std::sregex_iterator(); ++it) {
		result.classes.insert((*it)[1].str());
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
		info.parameters = inferParameters(content, info.handler);
		info.sourceFile = relativePath(filePath);
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
		info.returnType = normalizeReturnType(content, info.handler);
		info.parameters = inferParameters(content, info.handler);
		info.sourceFile = relativePath(filePath);
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
		info.parameters = inferParameters(content, info.handler);
		info.sourceFile = relativePath(filePath);
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
		result.functions.emplace_back(std::move(info));
	}
}

std::vector<std::string> LuaBindingScanner::inferParameters(const std::string &content, const std::string &handler) const {
	std::vector<std::string> parameters;

	if (handler.empty()) {
		return parameters;
	}

	std::string bodyRegex = "\\b" + handler + // start of the function
		"\\s*\\([^)]*\\)" // arguments (...)
		"\\s*\\{([\\s\\S]*?)\\}"; // body

	std::regex bodyPattern(bodyRegex, std::regex::optimize | std::regex::icase);

	std::smatch bodyMatch;
	if (!std::regex_search(content, bodyMatch, bodyPattern)) {
		return parameters;
	}

	const auto body = bodyMatch[1].str();
	const auto flags = std::regex::optimize | std::regex::icase | std::regex::multiline;

	struct ParameterInfo {
		std::string type;
		std::string name;
		bool optional { false };
	};

	auto cleanType = [](std::string type) {
		std::string value;
		value.reserve(type.size());
		for (const auto ch : type) {
			if (ch == '*' || ch == '&') {
				continue;
			}
			value.push_back(static_cast<char>(ch));
		}
		value = trim(value);
		value = std::regex_replace(value, std::regex(R"regex(^const\s+)regex", std::regex::icase), "");
		value = trim(value);
		return value;
	};

	auto normalizeType = [&cleanType](const std::string &type) -> std::string {
		const auto cleaned = cleanType(type);
		if (cleaned.empty()) {
			return "";
		}
		std::string lower;
		lower.reserve(cleaned.size());
		for (const auto ch : cleaned) {
			lower.push_back(static_cast<char>(std::tolower(static_cast<unsigned char>(ch))));
		}
		if (lower == "number" || lower == "lua_number" || lower == "integer" || lower == "int" || lower == "uint64_t" || lower == "uint32_t" || lower == "uint16_t" || lower == "uint8_t" || lower == "int64_t" || lower == "int32_t" || lower == "int16_t" || lower == "int8_t" || lower == "size_t" || lower == "double" || lower == "float") {
			return "number";
		}
		if (lower == "boolean" || lower == "bool") {
			return "boolean";
		}
		if (lower == "string" || lower == "std::string") {
			return "string";
		}
		if (lower == "userdata") {
			return "userdata";
		}
		if (lower == "table") {
			return "table";
		}
		return cleanType(cleaned);
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
			{ "bank", "Bank" },
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

	auto betterType = [](const std::string &current, const std::string &candidate) {
		if (candidate.empty()) {
			return false;
		}
		if (current.empty() || current == "unknown" || current == "any") {
			return true;
		}
		if (current == "number" && candidate != "number") {
			return true;
		}
		return false;
	};

	auto addParameter = [&](int index, const std::string &type, const std::string &name, bool optional) {
		if (index <= 0) {
			return;
		}
		auto &param = parameterMap[index];
		const auto normalizedType = normalizeType(type);
		if (betterType(param.type, normalizedType)) {
			param.type = normalizedType;
		}
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
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_tonumber\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_tointeger\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_tostring\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "string" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_toboolean\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "boolean" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_checknumber\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_checkinteger\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])luaL_checkstring\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "string" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isnumber\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isinteger\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "number" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isstring\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "string" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isboolean\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "boolean" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_isuserdata\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "userdata" },
		{ std::regex(R"regex((?:^|[^A-Za-z0-9_])lua_istable\s*\(\s*L\s*,\s*(\d+)\s*\))regex", flags), "table" }
	};

	for (const auto &[pattern, type] : simpleGetters) {
		for (auto it = std::sregex_iterator(body.begin(), body.end(), pattern); it != std::sregex_iterator(); ++it) {
			const auto index = std::stoi((*it)[1].str());
			addParameter(index, type, "", false);
		}
	}

	std::regex assignmentWithType(
		R"regex((?:const\s+)?([A-Za-z_][A-Za-z0-9_:<>\s\*&]+?)\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(?:[A-Za-z_][A-Za-z0-9_:]*::)?(?:Lua::)?get([A-Za-z0-9_]+)\s*(?:<([^>]+)>)?\s*\(\s*L\s*,\s*(\d+)\s*\))regex",
		flags
	);
	for (auto it = std::sregex_iterator(body.begin(), body.end(), assignmentWithType); it != std::sregex_iterator(); ++it) {
		const auto declaredType = normalizeType((*it)[1].str());
		const auto name = (*it)[2].str();
		const auto getter = (*it)[3].str();
		const auto templ = trim((*it)[4].str());
		const auto index = std::stoi((*it)[5].str());
		const auto inferredType = !declaredType.empty() && declaredType != "auto" ? declaredType : deduceTypeFromGetter(getter, templ);
		addParameter(index, inferredType, name, false);
	}

	std::regex assignmentAuto(
		R"regex((?:const\s+)?auto\s*&?\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(?:[A-Za-z_][A-Za-z0-9_:]*::)?(?:Lua::)?get([A-Za-z0-9_]+)\s*(?:<([^>]+)>)?\s*\(\s*L\s*,\s*(\d+)\s*\))regex",
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
		R"regex((?:[A-Za-z_][A-Za-z0-9_:]*::)?(?:Lua::)?get([A-Za-z0-9_]+)\s*(?:<([^>]+)>)?\s*\(\s*L\s*,\s*(\d+)\s*\))regex",
		flags
	);
	for (auto it = std::sregex_iterator(body.begin(), body.end(), directGetter); it != std::sregex_iterator(); ++it) {
		const auto getter = (*it)[1].str();
		const auto templ = trim((*it)[2].str());
		const auto index = std::stoi((*it)[3].str());
		addParameter(index, deduceTypeFromGetter(getter, templ), "", false);
	}

	std::regex namedLuaHelpers(
		R"regex((?:const\s+)?(?:auto|[A-Za-z_][A-Za-z0-9_:<>\s\*&]+)\s*&?\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(lua_[a-z]+|luaL_check[a-z]+)\s*\(\s*L\s*,\s*(\d+)\s*\))regex",
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
		R"regex((?:const\s+)?([A-Za-z_][A-Za-z0-9_:<>\s\*&]+?)\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(?:lua_[a-z]+|luaL_[a-z]+)\s*\(\s*L\s*,\s*(\d+)\s*\))regex",
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

	for (const auto &[index, info] : parameterMap) {
		std::string name = info.name.empty() ? "arg" + std::to_string(index) : info.name;
		if (info.optional) {
			name.push_back('?');
		}
		const auto type = info.type.empty() ? "any" : info.type;
		parameters.emplace_back(name + ": " + type);
	}

	if (parameters.empty()) {
		parameters.emplace_back("...");
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

std::string LuaBindingScanner::normalizeReturnType(const std::string &content, const std::string &handler) const {
	if (handler.empty()) {
		return "unknown";
	}

	std::regex signaturePattern(
		std::string("(\\w+)\\s+") + handler + "\\s*\\(",
		std::regex::optimize | std::regex::icase
	);

	std::regex bodyPattern(
		std::string("\\b") + handler + "\\s*\\([^)]*\\)\\s*\\{([\\s\\S]*?)\\}",
		std::regex::optimize | std::regex::icase
	);

	std::smatch match;
	if (std::regex_search(content, match, signaturePattern)) {
		return match[1].str();
	}

	if (std::regex_search(content, match, bodyPattern)) {
		return inferReturnByBody(match[1].str());
	}

	return "unknown";
}

std::string LuaBindingScanner::inferReturnByBody(const std::string &body) const {
	if (body.find("lua_pushboolean") != std::string::npos) {
		return "boolean";
	}
	if (body.find("lua_pushnumber") != std::string::npos || body.find("lua_pushinteger") != std::string::npos) {
		return "number";
	}
	if (body.find("lua_pushstring") != std::string::npos) {
		return "string";
	}

	std::regex pushPattern(R"regex(push([A-Z][A-Za-z0-9_]*)\s*\()regex");
	std::smatch pushMatch;
	if (std::regex_search(body, pushMatch, pushPattern)) {
		return pushMatch[1].str();
	}

	if (body.find("return true") != std::string::npos || body.find("return false") != std::string::npos) {
		return "boolean";
	}

	if (body.find("lua_push") == std::string::npos) {
		return "void";
	}

	return "unknown";
}

std::string LuaBindingScanner::relativePath(const std::filesystem::path &path) const {
	std::error_code ec;
	const auto relative = std::filesystem::relative(path, root, ec);
	if (!ec) {
		return relative.generic_string();
	}
	return path.generic_string();
}

LuaApiDocGenerator::LuaApiDocGenerator(const std::filesystem::path &projectRoot, Logger &logger) :
	logger(logger),
	projectRoot(findProjectRoot(projectRoot)),
	docsDirectory(ensureDocsDirectory()) { }

void LuaApiDocGenerator::generate() {
	try {
		LuaBindingScanner scanner(projectRoot);
		const auto scanResult = scanner.scan();
		buildModel(scanResult);
		exportEmmyLua();
		exportMarkdown();
		exportJson();
	} catch (const std::exception &e) {
		logger.warn(fmt::format("Failed to generate Lua API documentation: {}", e.what()));
	}
}

std::filesystem::path LuaApiDocGenerator::findProjectRoot(const std::filesystem::path &start) const {
	auto current = start;
	while (!current.empty()) {
		if (std::filesystem::exists(current / "docs") && std::filesystem::exists(current / "src")) {
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

void LuaApiDocGenerator::buildModel(const LuaScanResult &scanResult) {
	classes.clear();
	globals.clear();

	for (const auto &className : scanResult.classes) {
		classes[className].name = className;
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

std::filesystem::path LuaApiDocGenerator::ensureDocsDirectory() const {
	auto docs = findProjectRoot(projectRoot) / "docs";
	std::filesystem::create_directories(docs);
	return docs;
}

std::string LuaApiDocGenerator::buildFunctionSignature(const LuaFunctionInfo &function) const {
	std::ostringstream stream;
	stream << "fun(";
	bool hasPrevious = false;
	if (!function.className.empty()) {
		stream << "self: " << function.className;
		hasPrevious = true;
	}
	for (const auto &parameter : function.parameters) {
		if (hasPrevious) {
			stream << ", ";
		}
		stream << parameter;
		if (parameter.find(':') == std::string::npos) {
			stream << ": any";
		}
		hasPrevious = true;
	}
	stream << ")";
	if (!function.returnType.empty()) {
		stream << ": " << function.returnType;
	} else {
		stream << ": any";
	}
	return stream.str();
}

void LuaApiDocGenerator::exportEmmyLua() const {
	auto path = docsDirectory / "lua_api.lua";
	std::ofstream output(path);
	if (!output.is_open()) {
		return;
	}

	output << "--- Auto-generated Lua API (do not edit manually)\n\n";

	for (const auto &[name, classInfo] : classes) {
		output << "---@class " << name << "\n";
		for (const auto &method : classInfo.methods) {
			output << "---@field " << method.name << " " << buildFunctionSignature(method) << "\n";
		}
		output << "\n";
	}

	if (!globals.empty()) {
		output << "---@class GlobalApi\n";
		for (const auto &function : globals) {
			output << "---@field " << function.name << " " << buildFunctionSignature(function) << "\n";
		}
	}
}

void LuaApiDocGenerator::exportMarkdown() const {
	auto path = docsDirectory / "lua_api.md";
	std::ofstream output(path);
	if (!output.is_open()) {
		return;
	}

	output << "# Lua API\n\n";
	for (const auto &[name, classInfo] : classes) {
		output << "## " << name << "\n";
		for (const auto &method : classInfo.methods) {
			output << "### " << method.name << "(";
			for (size_t i = 0; i < method.parameters.size(); ++i) {
				output << method.parameters[i];
				if (i + 1 < method.parameters.size()) {
					output << ", ";
				}
			}
			output << ")\n";
			output << "Source: " << method.sourceFile << "\n\n";
		}
	}

	if (!globals.empty()) {
		output << "## Global\n";
		for (const auto &function : globals) {
			output << "### " << function.name << "(";
			for (size_t i = 0; i < function.parameters.size(); ++i) {
				output << function.parameters[i];
				if (i + 1 < function.parameters.size()) {
					output << ", ";
				}
			}
			output << ")\n";
			if (!function.returnType.empty()) {
				output << "Returns: " << function.returnType << "\n";
			}
			output << "Source: " << function.sourceFile << "\n\n";
		}
	}
}

void LuaApiDocGenerator::exportJson() const {
	auto path = docsDirectory / "lua_api.json";
	std::ofstream output(path);
	if (!output.is_open()) {
		return;
	}

	output << "{\n";
	bool firstClass = true;
	for (const auto &[name, classInfo] : classes) {
		if (!firstClass) {
			output << ",\n";
		}
		firstClass = false;
		output << "  \"" << name << "\": {\n";
		output << "    \"methods\": [\n";
		for (size_t i = 0; i < classInfo.methods.size(); ++i) {
			const auto &method = classInfo.methods[i];
			output << "      {\"name\": \"" << method.name << "\", \"params\": [";
			for (size_t p = 0; p < method.parameters.size(); ++p) {
				output << "\"" << method.parameters[p] << "\"";
				if (p + 1 < method.parameters.size()) {
					output << ", ";
				}
			}
			output << "], \"return\": \"" << (method.returnType.empty() ? "unknown" : method.returnType) << "\"";
			output << ", \"source\": \"" << method.sourceFile << "\"}";
			if (i + 1 < classInfo.methods.size()) {
				output << ",";
			}
			output << "\n";
		}
		output << "    ]\n";
		output << "  }";
	}

	if (!globals.empty()) {
		if (!classes.empty()) {
			output << ",\n";
		}
		output << "  \"globals\": [\n";
		for (size_t i = 0; i < globals.size(); ++i) {
			const auto &function = globals[i];
			output << "    {\"name\": \"" << function.name << "\", \"params\": [";
			for (size_t p = 0; p < function.parameters.size(); ++p) {
				output << "\"" << function.parameters[p] << "\"";
				if (p + 1 < function.parameters.size()) {
					output << ", ";
				}
			}
			output << "], \"return\": \"" << (function.returnType.empty() ? "unknown" : function.returnType) << "\"";
			output << ", \"source\": \"" << function.sourceFile << "\"}";
			if (i + 1 < globals.size()) {
				output << ",";
			}
			output << "\n";
		}
		output << "  ]\n";
	}

	output << "}\n";
}
