/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "security/argon.hpp"

#include <argon2.h>

bool Argon2::argon(const std::string &password_attempt, const std::string &hashed_password) const {
	return argon2id_verify(hashed_password.c_str(), password_attempt.c_str(), password_attempt.length()) == ARGON2_OK;
}
