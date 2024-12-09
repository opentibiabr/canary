/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

struct AccountInfo;

enum class CoinType : uint8_t;
enum class CoinTransactionType : uint8_t;
enum class AccountErrors_t : uint8_t;
enum AccountType : uint8_t;

class Account {
public:
	explicit Account(const uint32_t &id);
	explicit Account(std::string descriptor);

	~Account() = default;

	/** Coins
	 * @brief Get the amount of coins that the account has from database.
	 *
	 * @param type Type of the coin
	 *
	 * @return uint32_t Number of coins
	 * @return AccountErrors_t AccountErrors_t::Ok(0) Success, otherwise Fail.
	 */
	[[nodiscard]] std::tuple<uint32_t, AccountErrors_t> getCoins(CoinType type) const;

	/**
	 * @brief Add coins to the account.
	 *
	 * @param type Type of the coin
	 * @param amount Amount of coins to be added
	 * @return AccountErrors_t AccountErrors_t::Ok(0) Success, otherwise Fail.
	 */
	AccountErrors_t addCoins(CoinType type, const uint32_t &amount, const std::string &detail = "ADD Coins");

	/**
	 * @brief Removes coins from the account.
	 *
	 * @param type Type of the coin
	 * @param amount Amount of coins to be removed
	 * @return AccountErrors_t AccountErrors_t::Ok(0) Success, otherwise Fail.
	 */
	AccountErrors_t removeCoins(CoinType type, const uint32_t &amount, const std::string &detail = "REMOVE Coins");

	/**
	 * @brief Registers a coin transaction.
	 *
	 * @param type Type of the coin
	 * @param amount Amount of coins to be added
	 * @param detail Detail of the transaction
	 */
	void registerCoinTransaction(CoinTransactionType transactionType, CoinType type, const uint32_t &amount, const std::string &detail);

	/***************************************************************************
	 * Account Load/Save
	 **************************************************************************/

	/**
	 * @brief Save Account.
	 *
	 * @return AccountErrors_t AccountErrors_t::Ok(0) Success, otherwise Fail.
	 */
	AccountErrors_t save() const;

	/**
	 * @brief Load Account Information.
	 *
	 * @return AccountErrors_t AccountErrors_t::Ok(0) Success, otherwise Fail.
	 */
	AccountErrors_t load();

	/**
	 * @brief Re-Load Account Information to get update information(mainly the
	 * players list).
	 *
	 * @return AccountErrors_t AccountErrors_t::Ok(0) Success, otherwise Fail.
	 */
	AccountErrors_t reload();

	/***************************************************************************
	 * Setters and Getters
	 **************************************************************************/

	[[nodiscard]] uint32_t getID() const;

	/**
	 * @brief Get the Descriptor object
	 * @warning Descriptors are credentials that may be used to login into the account. DO NOT BPUBLISH THIS INFORMATION.
	 *
	 * @return std::string
	 */
	std::string getDescriptor() const;

	std::string getPassword();

	void addPremiumDays(const int32_t &days);
	void setPremiumDays(const int32_t &days);
	[[nodiscard]] uint32_t getPremiumRemainingDays() const;

	[[nodiscard]] uint32_t getPremiumDaysPurchased() const;

	[[nodiscard]] uint32_t getAccountAgeInDays() const;

	[[nodiscard]] time_t getPremiumLastDay() const;

	AccountErrors_t setAccountType(AccountType accountType);
	[[nodiscard]] AccountType getAccountType() const;

	void updatePremiumTime();

	std::tuple<phmap::flat_hash_map<std::string, uint64_t>, AccountErrors_t> getAccountPlayers() const;

	void setHouseBidId(uint32_t houseId);
	uint32_t getHouseBidId() const;

	// Old protocol compat
	void setProtocolCompat(bool toggle);

	bool getProtocolCompat() const;

	bool authenticate();
	bool authenticate(const std::string &secret);

	bool authenticateSession();

	bool authenticatePassword(const std::string &password);

private:
	std::string m_descriptor;
	std::unique_ptr<AccountInfo> m_account;
	bool m_accLoaded = false;
};
