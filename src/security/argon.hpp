/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Argon2 {
public:
	Argon2() = default;
	~Argon2() = default;

	Argon2(const Argon2 &) = delete;
	void operator=(const Argon2 &) = delete;

	bool argon(const std::string &password_attempt, const std::string &hashed_password) const;
};
