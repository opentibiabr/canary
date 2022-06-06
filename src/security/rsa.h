/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 * Copyright (C) 2019-2021 Saiyans King
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_SECURITY_RSA_H_
#define SRC_SECURITY_RSA_H_

#include <gmp.h>

#include <string>

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
