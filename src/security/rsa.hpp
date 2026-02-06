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
	~RSAManager() = default;

	void start(const std::string &filename = "key.pem");

	void setKey(const char* pString, const char* qString, int base = 10);
	void decrypt(char* msg) const;

	bool loadPEM(const std::string &filename);

private:
	struct BNDeleter {
		void operator()(BIGNUM* p) const {
			BN_free(p);
		}
	};
	struct BNMontCtxDeleter {
		void operator()(BN_MONT_CTX* p) const {
			BN_MONT_CTX_free(p);
		}
	};

	using BnPtr = std::unique_ptr<BIGNUM, BNDeleter>;
	using BnMontCtxPtr = std::unique_ptr<BN_MONT_CTX, BNMontCtxDeleter>;

	Logger &logger;
	BnPtr n;
	BnPtr d;
	BnMontCtxPtr mont_ctx;
};

constexpr auto g_RSA = RSAManager::getInstance;
