/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "security/rsa.hpp"
#include "server/server.hpp"

class Logger;

class FailedToInitializeCanary final : public std::exception {
private:
	std::string message;

public:
	// Constructor accepts a specific message
	explicit FailedToInitializeCanary(const std::string &msg) :
		message("Canary load couldn't be completed. " + msg) { }

	// Override the what() method from std::exception
	const char* what() const noexcept override {
		return message.c_str();
	}
};

class CanaryServer {
public:
	explicit CanaryServer(
		Logger &logger,
		RSA &rsa,
		ServiceManager &serviceManager
	);

	int run();

private:
	enum class LoaderStatus : uint8_t {
		LOADING,
		LOADED,
		FAILED
	};

	Logger &logger;
	RSA &rsa;
	ServiceManager &serviceManager;

	std::atomic<LoaderStatus> loaderStatus = LoaderStatus::LOADING;

	void logInfos() const;
	static void toggleForceCloseButton();
	static void badAllocationHandler();
	static void shutdown();

	static std::string getCompiler();
	static std::string getPlatform();

	void loadConfigLua() const;
	void initializeDatabase() const;
	void loadModules() const;
	void setWorldType() const;
	void loadMaps() const;
	void setupHousesRent() const;
	void modulesLoadHelper(bool loaded, std::string moduleName) const;
};
