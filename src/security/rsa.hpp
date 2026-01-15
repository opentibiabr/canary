/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Logger;

class RSAManager {
public:
	// Singleton - ensures we don't accidentally copy it
	RSAManager(const RSAManager &) = delete;
	void operator=(const RSAManager &) = delete;

	static RSAManager &getInstance();

	explicit RSAManager(Logger &logger);
	~RSAManager();

	void start();

	void setKey(const char* pString, const char* qString, int base = 10);
	void decrypt(char* msg) const;

	bool loadPEM(const std::string &filename);

private:
	Logger &logger;
	BIGNUM* n = nullptr;
	BIGNUM* d = nullptr;
	BN_MONT_CTX* mont_ctx = nullptr;
};

constexpr auto g_RSA = RSAManager::getInstance;
