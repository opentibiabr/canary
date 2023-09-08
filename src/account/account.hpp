/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "account/account_repository_db.hpp"
#include "config/configmanager.hpp"
#include "utils/definitions.hpp"
#include "security/argon.hpp"

namespace account {
	class Account {
	public:
		explicit Account(const uint32_t &id);
		explicit Account(std::string descriptor);

		/** Coins
		 * @brief Get the amount of coins that the account has from database.
		 *
		 * @param type Type of the coin
		 *
		 * @return uint32_t Number of coins
		 * @return error_t ERROR_NO(0) Success, otherwise Fail.
		 */
		[[nodiscard]] std::tuple<uint32_t, error_t> getCoins(const CoinType &type) const;

		/**
		 * @brief Add coins to the account.
		 *
		 * @param type Type of the coin
		 * @param amount Amount of coins to be added
		 * @return error_t ERROR_NO(0) Success, otherwise Fail.
		 */
		error_t addCoins(const CoinType &type, const uint32_t &amount, const std::string &detail = "ADD Coins");

		/**
		 * @brief Removes coins from the account.
		 *
		 * @param type Type of the coin
		 * @param amount Amount of coins to be removed
		 * @return error_t ERROR_NO(0) Success, otherwise Fail.
		 */
		error_t removeCoins(const CoinType &type, const uint32_t &amount, const std::string &detail = "REMOVE Coins");

		/**
		 * @brief Registers a coin transaction.
		 *
		 * @param type Type of the coin
		 * @param amount Amount of coins to be added
		 * @param detail Detail of the transaction
		 */
		void registerCoinTransaction(const CoinTransactionType &transactionType, const CoinType &type, const uint32_t &amount, const std::string &detail);

		/***************************************************************************
		 * Account Load/Save
		 **************************************************************************/

		/**
		 * @brief Save Account.
		 *
		 * @return error_t ERROR_NO(0) Success, otherwise Fail.
		 */
		error_t save();

		/**
		 * @brief Load Account Information.
		 *
		 * @return error_t ERROR_NO(0) Success, otherwise Fail.
		 */
		error_t load();

		/**
		 * @brief Re-Load Account Information to get update information(mainly the
		 * players list).
		 *
		 * @return error_t ERROR_NO(0) Success, otherwise Fail.
		 */
		error_t reload();

		/***************************************************************************
		 * Setters and Getters
		 **************************************************************************/

		[[nodiscard]] inline uint32_t getID() const {
			return m_account.id;
		};

		/**
		 * @brief Get the Descriptor object
		 * @warning Descriptors are credentials that may be used to login into the account. DO NOT BPUBLISH THIS INFORMATION.
		 *
		 * @return std::string
		 */
		inline std::string getDescriptor() const {
			return m_descriptor;
		}

		std::string getPassword();

		void addPremiumDays(const int32_t &days);
		void setPremiumDays(const int32_t &days);
		[[nodiscard]] inline uint32_t getPremiumRemainingDays() const {
			return m_account.premiumRemainingDays;
		}

		[[nodiscard]] inline uint32_t getPremiumDaysPurchased() const {
			return m_account.premiumDaysPurchased;
		}

		[[nodiscard]] uint32_t getAccountAgeInDays() const;

		[[nodiscard]] inline time_t getPremiumLastDay() const {
			return m_account.premiumLastDay;
		}

		error_t setAccountType(const AccountType &accountType);
		[[nodiscard]] inline AccountType getAccountType() const {
			return m_account.accountType;
		}

		void updatePremiumTime();

		std::tuple<phmap::flat_hash_map<std::string, uint64_t>, error_t> getAccountPlayers() const;

		// Old protocol compat
		void setProtocolCompat(bool toggle) {
			m_account.oldProtocol = toggle;
		}

		bool getProtocolCompat() const {
			return m_account.oldProtocol;
		}

		bool authenticate();
		bool authenticate(const std::string &secret);

		bool authenticateSession();

		bool authenticatePassword(const std::string &password);

	private:
		std::string m_descriptor;
		AccountInfo m_account;
		bool m_accLoaded = false;

		Logger &logger = inject<Logger>();
		ConfigManager &configManager = inject<ConfigManager>();
		AccountRepository &accountRepository = inject<AccountRepository>();
	};

} // namespace account
