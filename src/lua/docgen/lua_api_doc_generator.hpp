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
	#include <filesystem>
	#include <map>
	#include <string>
	#include <unordered_map>
	#include <unordered_set>
	#include <vector>
#endif

class Logger;

struct LuaFunctionInfo {
	std::string name;
	std::string className;
	std::vector<std::string> parameters;
	std::string returnType;
	std::vector<std::string> returns;
	std::string sourceFile;
	std::string handler;
	bool hasSelfParameter { false };
	bool hasExplicitDocumentation { false };
};

struct LuaClassInfo {
	std::string name;
	std::string baseClass;
	std::vector<LuaFunctionInfo> methods;
};

struct LuaScanResult {
	std::vector<LuaFunctionInfo> functions;
	std::unordered_set<std::string> classes;
	std::unordered_map<std::string, std::string> classBaseClasses;
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
	LuaApiDocGenerator(const std::filesystem::path &projectRoot, std::filesystem::path outputDirectory, Logger &logger);
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
	std::map<std::string, LuaClassInfo> classes;
	std::vector<LuaFunctionInfo> globals;
};
