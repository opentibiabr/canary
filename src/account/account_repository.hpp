/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "account/account_definitions.hpp"

namespace account {
	class AccountRepository {
	public:
		virtual ~AccountRepository() = default;

		virtual bool loadByID(const uint32_t &id, AccountInfo &acc) = 0;
		virtual bool loadByEmailOrName(bool oldProtocol, const std::string &emailOrName, AccountInfo &acc) = 0;
		virtual bool loadBySession(const std::string &email, AccountInfo &acc) = 0;
		virtual bool save(const AccountInfo &accInfo) = 0;

		virtual bool getPassword(const uint32_t &id, std::string &password) = 0;

		virtual bool getCoins(const uint32_t &id, const CoinType &type, uint32_t &coins) = 0;
		virtual bool setCoins(const uint32_t &id, const CoinType &type, const uint32_t &amount) = 0;
		virtual bool registerCoinsTransaction(
			const uint32_t &id,
			CoinTransactionType type,
			uint32_t coins,
			const CoinType &coinType,
			const std::string &description
		) = 0;
	};

} // namespace account
