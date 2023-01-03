/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_SECURITY_RSA_H_
#define SRC_SECURITY_RSA_H_


class RSA
{
	public:
		RSA();
		~RSA();

		// Singleton - ensures we don't accidentally copy it
		RSA(RSA const&) = delete;
		void operator=(RSA const&) = delete;

		static RSA& getInstance() {
			// Guaranteed to be destroyed
			static RSA instance;
			// Instantiated on first use
			return instance;
		}

		void setKey(const char* pString, const char* qString, int base = 10);
		void decrypt(char* msg) const;

		std::string base64Decrypt(const std::string& input) const;
		uint16_t decodeLength(char*& pos) const;
		void readHexString(char*& pos, uint16_t length, std::string& output) const;
		bool loadPEM(const std::string& filename);

	private:
		mpz_t n;
		mpz_t d;
};

constexpr auto g_RSA = &RSA::getInstance;

#endif  // SRC_SECURITY_RSA_H_
