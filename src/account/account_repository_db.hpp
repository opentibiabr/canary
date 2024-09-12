/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "account/account_repository.hpp"

class AccountRepositoryDB final : public AccountRepository {
public:
	AccountRepositoryDB();

	bool loadByID(const uint32_t &id, AccountInfo &acc) override;
	bool loadByEmailOrName(bool oldProtocol, const std::string &emailOrName, AccountInfo &acc) override;
	bool loadBySession(const std::string &esseionKey, AccountInfo &acc) override;
	bool save(const AccountInfo &accInfo) override;

	bool getCharacterByAccountIdAndName(const uint32_t &id, const std::string &name) override;

	bool getPassword(const uint32_t &id, std::string &password) override;

	bool getCoins(const uint32_t &id, const uint8_t &type, uint32_t &coins) override;
	bool setCoins(const uint32_t &id, const uint8_t &type, const uint32_t &amount) override;
	bool registerCoinsTransaction(
		const uint32_t &id,
		uint8_t type,
		uint32_t coins,
		const uint8_t &coinType,
		const std::string &description
	) override;

private:
	const std::map<uint8_t, std::string> coinTypeToColumn;
	bool load(const std::string &query, AccountInfo &acc);
	bool loadAccountPlayers(AccountInfo &acc);
	void setupLoyaltyInfo(AccountInfo &acc);
};
