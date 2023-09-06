/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "config/configmanager.hpp"
#include "database/database.hpp"
#include "security/argon.hpp"

const std::regex Argon2::re("\\$([A-Za-z0-9+/]+)\\$([A-Za-z0-9+/]+)");
const std::string Argon2::base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

Argon2::Argon2() {
	updateConstants();
}

void Argon2::updateConstants() {
	m_const_str = g_configManager().getString(M_CONST);
	m_cost = parseBitShift(m_const_str);
	t_cost = g_configManager().getNumber(T_CONST);
	parallelism = g_configManager().getNumber(PARALLELISM);
}

uint32_t Argon2::parseBitShift(const std::string &bitShiftStr) const {
	std::stringstream ss(bitShiftStr);
	int base;
	int shift;
	char op1;
	char op2;

	if (!(ss >> base >> op1 >> op2 >> shift) || op1 != '<' || op2 != '<') {
		g_logger().warn("Invalid bit shift string");
	}

	return base << shift;
}

bool Argon2::verifyPassword(const std::string &password, const std::string &phash) const {
	std::smatch match;
	if (!std::regex_search(phash, match, re)) {
		g_logger().debug("No argon2 hash found in string");
		return false;
	}

	std::vector<uint8_t> salt = base64_decode(match[1]);
	std::vector<uint8_t> hash = base64_decode(match[2]);

	// Hash the password
	std::vector<uint8_t> computed_hash(hash.size());
	if (argon2id_hash_raw(t_cost, m_cost, parallelism, password.c_str(), password.length(), salt.data(), salt.size(), computed_hash.data(), computed_hash.size()) != ARGON2_OK) {
		g_logger().warn("Error hashing password");
		return false;
	}

	// Compare
	return computed_hash == hash;
}

std::vector<uint8_t> Argon2::base64_decode(const std::string &input) const {
	std::vector<uint8_t> ret;
	int i = 0;
	uint32_t val = 0;
	for (char c : input) {
		if (isspace(c) || c == '=') {
			continue;
		}

		size_t pos = base64_chars.find(c);
		if (pos == std::string::npos) {
			g_logger().warn("Invalid character in base64 string");
		} else if (pos > std::numeric_limits<uint32_t>::max()) {
			g_logger().warn("Position too large for uint32_t");
		} else {
			val = (val << 6) + static_cast<uint32_t>(pos);
		}

		if (++i % 4 == 0) {
			ret.push_back((val >> 16) & 0xFF);
			ret.push_back((val >> 8) & 0xFF);
			ret.push_back(val & 0xFF);
		}
	}

	switch (i % 4) {
		case 1:
			g_logger().warn("Invalid length for base64 string");
			break;
		case 2:
			ret.push_back((val >> 4) & 0xFF);
			break;
		case 3:
			ret.push_back((val >> 10) & 0xFF);
			ret.push_back((val >> 2) & 0xFF);
			break;
		default:
			g_logger().warn("Unexpected remainder when dividing string length by 4");
			break;
	}

	return ret;
}

bool Argon2::argon(const std::string &password_attempt, const std::string &hashed_password) const {
	return verifyPassword(password_attempt, hashed_password);
}
