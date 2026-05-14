/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <memory>
	#include <string>
#endif

class Logger;
class RsaBackend;

class RSAManager {
public:
	RSAManager(const RSAManager &) = delete;
	void operator=(const RSAManager &) = delete;

	static RSAManager &getInstance();

	explicit RSAManager(Logger &logger);
	~RSAManager();

	void start(const std::string &filename = "key.pem");
	void setKey(const char* pString, const char* qString, int base = 10);
	void decrypt(char* msg) const;
	bool loadPEM(const std::string &filename);

private:
	Logger &logger;
	std::unique_ptr<RsaBackend> backend;
};

constexpr auto g_RSA = RSAManager::getInstance;
