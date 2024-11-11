/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "security/argon.hpp"

#include "config/configmanager.hpp"
#include "database/database.hpp"

#include <argon2.h>

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
	static const std::regex pattern(R"(^\s*(\d+)\s*<<\s*(\d+)\s*$)", std::regex_constants::ECMAScript | std::regex_constants::icase);
	std::smatch match;

	if (!std::regex_match(bitShiftStr, match, pattern)) {
		g_logger().warn("Invalid bit shift string format: '{}'", bitShiftStr);
		return 0;
	}

	int base = 0;
	int shift = 0;
	try {
		base = std::stoi(match[1].str());
		shift = std::stoi(match[2].str());
	} catch (const std::exception &e) {
		g_logger().warn("Error parsing bit shift string: '{}'", e.what());
		return 0;
	}

	if (shift < 0 || shift >= 32) {
		g_logger().warn("Shift value out of bounds: '{}'", shift);
		return 0;
	}

	return static_cast<uint32_t>(base) << shift;
}

bool Argon2::verifyPassword(const std::string &password, const std::string &phash) const {
	const std::regex re("\\$([A-Za-z0-9+/]+)\\$([A-Za-z0-9+/]+)");
	std::smatch match;
	if (!std::regex_search(phash, match, re)) {
		g_logger().debug("No argon2 hash found in string");
		return false;
	}

	const std::vector<uint8_t> salt = base64_decode(match[1]);
	const std::vector<uint8_t> hash = base64_decode(match[2]);

	// Hash the password
	std::vector<uint8_t> computed_hash(hash.size());
	if (argon2id_hash_raw(t_cost, m_cost, parallelism, password.c_str(), password.length(), salt.data(), salt.size(), computed_hash.data(), computed_hash.size()) != ARGON2_OK) {
		g_logger().warn("Error hashing password");
		return false;
	}

	// Compare
	return computed_hash == hash;
}

std::vector<uint8_t> Argon2::base64_decode(const std::string &input) {
	const std::string base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	std::vector<uint8_t> ret;
	int i = 0;
	uint32_t val = 0;
	for (const char c : input) {
		if (isspace(c) || c == '=') {
			continue;
		}

		const size_t pos = base64_chars.find(c);
		if (pos == std::string::npos) {
			g_logger().warn("Invalid character in base64 string");
		} else if (pos > std::numeric_limits<uint32_t>::max()) {
			g_logger().warn("Position too large for uint32_t");
		} else {
			val = (val << 6) + static_cast<uint32_t>(pos);
		}

		if (++i % 4 == 0) {
			ret.emplace_back((val >> 16) & 0xFF);
			ret.emplace_back((val >> 8) & 0xFF);
			ret.emplace_back(val & 0xFF);
		}
	}

	switch (i % 4) {
		case 1:
			g_logger().warn("Invalid length for base64 string");
			break;
		case 2:
			ret.emplace_back((val >> 4) & 0xFF);
			break;
		case 3:
			ret.emplace_back((val >> 10) & 0xFF);
			ret.emplace_back((val >> 2) & 0xFF);
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
