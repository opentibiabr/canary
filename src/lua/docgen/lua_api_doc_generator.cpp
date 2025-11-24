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
	// Canary NÃO usa luaL_Reg, mas mantenho caso exista algum legado
	std::regex luaRegPattern(
		R"regex(luaL_Reg\s+([A-Za-z0-9_]+)\s*\[\]\s*=\s*\{([^;]*?)\};)regex",
		std::regex::optimize | std::regex::icase | std::regex::multiline
	);
	std::regex entryPattern(
		R"regex(\{\s*"([^"]+)"\s*,\s*([A-Za-z0-9_:]+)\s*\})regex",
		std::regex::optimize
	);

	for (auto regIt = std::sregex_iterator(content.begin(), content.end(), luaRegPattern); regIt != std::sregex_iterator(); ++regIt) {
		const auto block = (*regIt)[2].str();
		for (auto entryIt = std::sregex_iterator(block.begin(), block.end(), entryPattern); entryIt != std::sregex_iterator(); ++entryIt) {
			LuaFunctionInfo info;
			info.name = (*entryIt)[1].str();
			info.handler = (*entryIt)[2].str();
			info.returnType = normalizeReturnType(info.handler);
			info.sourceFile = filePath.string();
			info.parameters = inferParameters(content, info.handler);
			result.functions.emplace_back(std::move(info));
		}
	}
}

void LuaBindingScanner::parseRegistrations(const std::string &content, const std::filesystem::path &filePath, LuaScanResult &result) const {

	// ==== 1) CLASSES ======================================================================
	std::regex classPattern(
		R"regex(Lua::register(?:Shared)?Class\s*\(\s*[^,]*,\s*"([^"]+)")regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), classPattern); it != std::sregex_iterator(); ++it) {
		result.classes.insert((*it)[1].str());
	}

	// ==== 2) MÉTODOS DE CLASSE =============================================================
	std::regex methodPattern(
		R"regex(Lua::registerMethod\s*\(\s*[^,]+,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*([A-Za-z0-9_:]+))regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), methodPattern); it != std::sregex_iterator(); ++it) {
		LuaFunctionInfo info;
		info.className = (*it)[1].str();
		info.name = (*it)[2].str();
		info.handler = (*it)[3].str();
		info.returnType = normalizeReturnType(info.handler);
		info.parameters = inferParameters(content, info.handler);
		info.sourceFile = filePath.string();
		result.functions.emplace_back(std::move(info));
	}

	// ==== 3) META MÉTODOS ==================================================================
	std::regex metaMethodPattern(
		R"regex(Lua::registerMetaMethod\s*\(\s*[^,]+,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*([A-Za-z0-9_:]+))regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), metaMethodPattern); it != std::sregex_iterator(); ++it) {
		LuaFunctionInfo info;
		info.className = (*it)[1].str();
		info.name = (*it)[2].str();
		info.handler = (*it)[3].str();
		info.returnType = normalizeReturnType(info.handler);
		info.parameters = inferParameters(content, info.handler);
		info.sourceFile = filePath.string();
		result.functions.emplace_back(std::move(info));
	}

	// ==== 4) FUNÇÕES GLOBAIS ===============================================================
	std::regex globalPattern(
		R"regex(Lua::registerGlobalMethod\s*\(\s*"([^"]+)"\s*,\s*([A-Za-z0-9_:]+))regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), globalPattern); it != std::sregex_iterator(); ++it) {
		LuaFunctionInfo info;
		info.name = (*it)[1].str();
		info.handler = (*it)[2].str();
		info.returnType = normalizeReturnType(info.handler);
		info.parameters = inferParameters(content, info.handler);
		info.sourceFile = filePath.string();
		result.functions.emplace_back(std::move(info));
	}

	// ==== 5) VARIÁVEIS BOOLEANAS GLOBAIS ===================================================
	std::regex constantBoolPattern(
		R"regex(Lua::registerGlobalBoolean\s*\(\s*"([^"]+)")regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), constantBoolPattern); it != std::sregex_iterator(); ++it) {
		LuaFunctionInfo info;
		info.name = (*it)[1].str();
		info.returnType = "boolean";
		info.sourceFile = filePath.string();
		result.functions.emplace_back(std::move(info));
	}

	// ==== 6) VARIÁVEIS NUMÉRICAS GLOBAIS ===================================================
	std::regex constantNumberPattern(
		R"regex(Lua::registerGlobalVariable\s*\(\s*"([^"]+)")regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), constantNumberPattern); it != std::sregex_iterator(); ++it) {
		LuaFunctionInfo info;
		info.name = (*it)[1].str();
		info.returnType = "number";
		info.sourceFile = filePath.string();
		result.functions.emplace_back(std::move(info));
	}

	// ==== 7) STRING GLOBAIS ================================================================
	std::regex constantStringPattern(
		R"regex(Lua::registerGlobalString\s*\(\s*"([^"]+)")regex",
		std::regex::optimize
	);
	for (auto it = std::sregex_iterator(content.begin(), content.end(), constantStringPattern); it != std::sregex_iterator(); ++it) {
		LuaFunctionInfo info;
		info.name = (*it)[1].str();
		info.returnType = "string";
		info.sourceFile = filePath.string();
		result.functions.emplace_back(std::move(info));
	}
}

std::vector<std::string> LuaBindingScanner::inferParameters(const std::string &content, const std::string &handler) const {
	std::vector<std::string> parameters;

	std::regex commentPattern(
		("//.*\\(([^)]*)\\)\\s*\\n\\s*int\\s+" + handler + R"regex(\s*\()regex"
	    ),
		std::regex::optimize
	);

	std::smatch match;
	if (std::regex_search(content, match, commentPattern)) {
		parameters = splitParameters(match[1].str());
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

std::string LuaBindingScanner::normalizeReturnType(const std::string &handler) const {
	if (handler.empty()) {
		return "unknown";
	}
	// Try to infer the return type from the handler's function signature in the source files
	// For simplicity, assume the handler is a function named 'handler' and look for its definition
	// Example: int handlerName(...)
	std::regex signaturePattern(R"regex((\w+)\s+" + handler + R"regex\s*\()regex", std::regex::optimize);
	for (const auto& entry : std::filesystem::recursive_directory_iterator(root / "src")) {
		if (!entry.is_regular_file()) continue;
		std::ifstream file(entry.path());
		if (!file.is_open()) continue;
		std::string content((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
		std::smatch match;
		if (std::regex_search(content, match, signaturePattern)) {
			// match[1] is the return type
			return match[1].str();
		}
	}
	return "unknown";
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

	for (const auto &function : scanResult.functions) {
		if (function.className.empty()) {
			globals.push_back(function);
			continue;
		}

		auto &classInfo = classes[function.className];
		classInfo.name = function.className;
		classInfo.methods.push_back(function);
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
			output << "], \"return\": \"" << (method.returnType.empty() ? "unknown" : method.returnType) << "\"}";
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
			output << "], \"return\": \"" << (function.returnType.empty() ? "unknown" : function.returnType) << "\"}";
			if (i + 1 < globals.size()) {
				output << ",";
			}
			output << "\n";
		}
		output << "  ]\n";
	}

	output << "}\n";
}
