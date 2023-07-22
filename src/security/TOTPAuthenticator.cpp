/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "TOTPAuthenticator.hpp"
#include "database/database.h"

TOTPAuthenticator::TOTPAuthenticator() = default;

TOTPAuthenticator::~TOTPAuthenticator() = default;

std::string TOTPAuthenticator::base32Decode(const std::string &encoded) const {
	std::istringstream istr(encoded);
	std::ostringstream ostr;
	Poco::Base32Decoder decoder(istr);
	Poco::StreamCopier::copyStream(decoder, ostr);
	std::string result = ostr.str();
	return result;
}

uint64_t TOTPAuthenticator::hostToBigEndian(uint64_t value) const {
	uint64_t result = 0;
	for (int i = 0; i < sizeof(value); ++i) {
		result <<= 8;
		result |= (value >> (i * 8)) & 0xFF;
	}
	return result;
}

std::string TOTPAuthenticator::verifyToken(uint32_t accountId, uint32_t tokenTime) const {

	if (accountId <= 0 || tokenTime <= 0) {
		SPDLOG_WARN("verifyToken called with invalid accountId or tokenTime. accountId: {}, tokenTime: {}", accountId, tokenTime);
		return {};
	}

	std::string secret2FA = getSecret2FA(accountId);

	if (secret2FA.empty()) {
		SPDLOG_WARN("Failed to retrieve secret key for accountId: {}", accountId);
		return {};
	}

	// Decode the secret
	std::string secret;
	try {
		secret = base32Decode(secret2FA);
	} catch (const std::exception &e) {
		SPDLOG_WARN("Error decoding secret key for accountId {}: {}", accountId, e.what());
		return {};
	}

	// Calculate the time step
	uint64_t timeStep = hostToBigEndian(tokenTime);

	// Calculate HMAC
	Poco::HMACEngine<Poco::SHA1Engine> hmac(secret);
	hmac.update(&timeStep, sizeof(timeStep)); // Updating the HMAC directly with the bytes
	const auto &digest = hmac.digest();

	// Perform the TOTP calculation
	auto offset = static_cast<std::byte>(digest[digest.size() - 1]) & std::byte(0x0F);
	auto binCode = (static_cast<unsigned int>(static_cast<std::byte>(digest[std::to_integer<std::size_t>(offset)]) & std::byte { 0x7f }) << 24)
		| (static_cast<unsigned int>(static_cast<std::byte>(digest[std::to_integer<std::size_t>(offset) + 1]) & std::byte { 0xff }) << 16)
		| (static_cast<unsigned int>(static_cast<std::byte>(digest[std::to_integer<std::size_t>(offset) + 2]) & std::byte { 0xff }) << 8)
		| (static_cast<unsigned int>(static_cast<std::byte>(digest[std::to_integer<std::size_t>(offset) + 3]) & std::byte { 0xff }));

	unsigned int token = binCode % 1000000; // 6-digit TOTP

	return std::to_string(token);
}

std::string TOTPAuthenticator::getSecret2FA(uint32_t accountId) const {
	std::ostringstream query;
	query << "SELECT `secret` FROM `account_authentication` WHERE `account_id` = " << accountId;
	if (auto results = Database::getInstance().storeQuery(query.str())) {
		return results->getString("secret");
	}
	return {};
}
