/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
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

#include <cryptopp/rsa.h>

#include <string>

class RSA2
{
	public:
		RSA2() = default;

		// non-copyable
		RSA2(const RSA2&) = delete;
		RSA2& operator=(const RSA2&) = delete;

		static RSA2& getInstance() {
			// Guaranteed to be destroyed
			static RSA2 instance;
			// Instantiated on first use
			return instance;
		}

		void loadPEM(const std::string& filename);
		void decrypt(uint8_t* msg) const;

	private:
		CryptoPP::RSA::PrivateKey pk;
};

constexpr auto g_RSA = &RSA2::getInstance;

#endif  // SRC_SECURITY_RSA_H_
