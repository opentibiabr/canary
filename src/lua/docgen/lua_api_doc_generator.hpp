/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstddef>
	#include <filesystem>
	#include <functional>
	#include <map>
	#include <string>
	#include <string_view>
	#include <unordered_map>
	#include <unordered_set>
	#include <vector>
#endif

class Logger;

struct TransparentStringHash {
	using is_transparent = void;

	std::size_t operator()(const std::string_view value) const noexcept {
		return std::hash<std::string_view> {}(value);
	}

	std::size_t operator()(const std::string &value) const noexcept {
		return (*this)(std::string_view(value));
	}

	std::size_t operator()(const char* value) const noexcept {
		return (*this)(std::string_view(value));
	}
};

using LuaStringSet = std::unordered_set<std::string, TransparentStringHash, std::equal_to<>>;
using LuaStringMap = std::unordered_map<std::string, std::string, TransparentStringHash, std::equal_to<>>;

struct LuaFunctionInfo {
	std::string name;
	std::string className;
	std::vector<std::string> parameters;
	std::string returnType;
	std::vector<std::string> returns;
	std::vector<std::string> overloads;
	std::string sourceFile;
	std::string handler;
	bool hasSelfParameter { false };
	bool hasExplicitDocumentation { false };
};

struct LuaClassInfo {
	std::string name;
	std::string baseClass;
	std::vector<std::string> fields;
	std::vector<std::string> overloads;
	std::vector<LuaFunctionInfo> methods;
};

struct LuaScanResult {
	std::vector<LuaFunctionInfo> functions;
	LuaStringSet classes;
	LuaStringMap classBaseClasses;
	std::map<std::string, std::vector<std::string>, std::less<>> classFields;
	std::map<std::string, std::vector<std::string>, std::less<>> classOverloads;
};

class LuaBindingScanner {
public:
	explicit LuaBindingScanner(std::filesystem::path rootPath);
	LuaScanResult scan() const;

private:
	void scanFile(const std::filesystem::path &filePath, LuaScanResult &result) const;
	void parseLuaReg(const std::string &content, const std::filesystem::path &filePath, LuaScanResult &result) const;
	void parseRegistrations(const std::string &content, const std::filesystem::path &filePath, LuaScanResult &result) const;
	std::vector<std::string> inferParameters(const std::string &content, const std::string &handler, bool skipSelfParameter) const;
	std::vector<std::string> splitParameters(const std::string &parameters) const;
	std::string normalizeReturnType(const std::string &content, const std::string &handler) const;
	std::string inferReturnByBody(const std::string &body) const;
	bool usesSelfParameter(const std::string &content, const std::string &handler) const;
	std::string relativePath(const std::filesystem::path &path) const;

	std::filesystem::path root;
};

class LuaApiDocGenerator {
public:
	LuaApiDocGenerator(const std::filesystem::path &initialProjectRoot, std::filesystem::path outputDirectory, Logger &logger);
	bool generate();

private:
	std::filesystem::path findProjectRoot(const std::filesystem::path &start) const;
	std::filesystem::path resolveDocsDirectory(const std::filesystem::path &outputDirectory) const;
	void buildModel(const LuaScanResult &scanResult);
	bool exportEmmyLua() const;
	bool exportMarkdown() const;
	bool exportJson() const;

	Logger &logger;
	std::filesystem::path projectRoot;
	std::filesystem::path docsDirectory;
	std::map<std::string, LuaClassInfo, std::less<>> classes;
	std::vector<LuaFunctionInfo> globals;
};
