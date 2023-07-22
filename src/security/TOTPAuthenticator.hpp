/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_SECURITY_TOTP_AUTHENTICATOR_H_
#define SRC_SECURITY_TOTP_AUTHENTICATOR_H_

class TOTPAuthenticator {
	public:
		TOTPAuthenticator();
		~TOTPAuthenticator();

		std::string verifyToken(uint32_t accountId, uint32_t tokenTime) const;

	private:
		std::string base32Decode(const std::string &encoded) const;
		uint64_t hostToBigEndian(uint64_t value) const;
		std::string getSecret2FA(uint32_t accountId) const;
};

#endif // SRC_SECURITY_TOTP_AUTHENTICATOR_H_
