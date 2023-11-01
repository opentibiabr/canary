/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"
#include <utility>

#include "account/account.hpp"
#include "utils/tools.hpp"

namespace account {
	Account::Account(const uint32_t &id) {
		m_descriptor.clear();
		m_account.id = id;
		m_account.premiumRemainingDays = 0;
		m_account.premiumLastDay = 0;
		m_account.accountType = ACCOUNT_TYPE_NORMAL;
	}

	Account::Account(std::string descriptor) :
		m_descriptor(std::move(descriptor)) {
		m_account.id = 0;
		m_account.premiumRemainingDays = 0;
		m_account.premiumLastDay = 0;
		m_account.accountType = ACCOUNT_TYPE_NORMAL;
	}

	error_t Account::load() {
		if (m_account.id != 0 && accountRepository.loadByID(m_account.id, m_account)) {
			m_accLoaded = true;
			return ERROR_NO;
		}

		if (!m_descriptor.empty() && accountRepository.loadByEmailOrName(getProtocolCompat(), m_descriptor, m_account)) {
			m_accLoaded = true;
			return ERROR_NO;
		}

		if (!m_descriptor.empty() && accountRepository.loadBySession(m_descriptor, m_account)) {
			m_accLoaded = true;
			return ERROR_NO;
		}

		updatePremiumTime();

		return ERROR_LOADING_ACCOUNT;
	}

	error_t Account::reload() {
		if (!m_accLoaded) {
			return ERROR_NOT_INITIALIZED;
		}

		return load();
	}

	error_t Account::save() {
		if (!m_accLoaded) {
			return ERROR_NOT_INITIALIZED;
		}

		if (!accountRepository.save(m_account)) {
			return ERROR_STORAGE;
		}

		return ERROR_NO;
	}

	std::tuple<uint32_t, error_t> Account::getCoins(const CoinType &type) const {
		if (!m_accLoaded) {
			return { 0, ERROR_NOT_INITIALIZED };
		}

		uint32_t coins = 0;
		if (!accountRepository.getCoins(m_account.id, type, coins)) {
			return { 0, ERROR_STORAGE };
		}

		return { coins, ERROR_NO };
	}

	error_t Account::addCoins(const CoinType &type, const uint32_t &amount, const std::string &detail) {
		if (!m_accLoaded) {
			return ERROR_NOT_INITIALIZED;
		}

		if (amount == 0) {
			return ERROR_NO;
		}

		auto [coins, result] = getCoins(type);

		if (ERROR_NO != result) {
			return result;
		}

		if (!accountRepository.setCoins(m_account.id, type, coins + amount)) {
			return ERROR_STORAGE;
		}

		registerCoinTransaction(CoinTransactionType::ADD, type, amount, detail);

		return ERROR_NO;
	}

	error_t Account::removeCoins(const CoinType &type, const uint32_t &amount, const std::string &detail) {
		if (!m_accLoaded) {
			return ERROR_NOT_INITIALIZED;
		}

		if (amount == 0) {
			return ERROR_NO;
		}

		auto [coins, result] = getCoins(type);

		if (ERROR_NO != result) {
			return result;
		}

		if (coins < amount) {
			logger.info("Account doesn't have enough coins! current[{}], remove:[{}]", coins, amount);
			return ERROR_REMOVE_COINS;
		}

		if (!accountRepository.setCoins(m_account.id, type, coins - amount)) {
			return ERROR_STORAGE;
		}

		registerCoinTransaction(CoinTransactionType::REMOVE, type, amount, detail);

		return ERROR_NO;
	}

	void Account::registerCoinTransaction(const CoinTransactionType &transactionType, const CoinType &type, const uint32_t &amount, const std::string &detail) {
		if (!m_accLoaded) {
			return;
		}

		if (detail.empty()) {
			return;
		}

		if (!accountRepository.registerCoinsTransaction(m_account.id, transactionType, amount, type, detail)) {
			logger.error(
				"Failed to register transaction: 'account:[{}], transaction "
				"type:[{}], coins:[{}], coin type:[{}], description:[{}]",
				m_account.id, static_cast<uint8_t>(transactionType), amount, static_cast<uint8_t>(type), detail
			);
		}
	}

	std::string Account::getPassword() {
		if (!m_accLoaded) {
			return "";
		}

		std::string password;
		if (!accountRepository.getPassword(m_account.id, password)) {
			password.clear();
			logger.error("Failed to get password for account[{}]!", m_account.id);
		}

		return password;
	}

	void Account::addPremiumDays(const int32_t &days) {
		auto timeLeft = static_cast<int32_t>((m_account.premiumLastDay - getTimeNow()) % 86400);
		setPremiumDays(m_account.premiumRemainingDays + days);

		if (timeLeft > 0) {
			m_account.premiumLastDay += timeLeft;
		}
	}

	void Account::setPremiumDays(const int32_t &days) {
		m_account.premiumRemainingDays = days;
		m_account.premiumLastDay = getTimeNow() + (days * 86400);

		if (days <= 0) {
			m_account.premiumLastDay = 0;
			m_account.premiumRemainingDays = 0;
		}
	}

	error_t Account::setAccountType(const AccountType &accountType) {
		m_account.accountType = accountType;
		return ERROR_NO;
	}

	void Account::updatePremiumTime() {
		time_t lastDay = m_account.premiumLastDay;
		uint32_t remainingDays = m_account.premiumRemainingDays;

		time_t currentTime = getTimeNow();

		auto daysLeft = static_cast<int32_t>((lastDay - currentTime) / 86400);
		auto timeLeft = static_cast<int32_t>((lastDay - currentTime) % 86400);

		m_account.premiumRemainingDays = daysLeft > 0 ? daysLeft : 0;

		if (daysLeft == 0 && timeLeft == 0) {
			setPremiumDays(0);
		}

		if (lastDay < currentTime || lastDay == 0) {
			setPremiumDays(0);
		}

		if (remainingDays == m_account.premiumRemainingDays) {
			return;
		}

		if (account::ERROR_NO != save()) {
			logger.error("Failed to update account premium time: [{}]", getDescriptor());
		}
	}

	std::tuple<phmap::flat_hash_map<std::string, uint64_t>, error_t>
	Account::getAccountPlayers() const {
		return { m_account.players, m_accLoaded ? ERROR_NO : ERROR_NOT_INITIALIZED };
	}

	bool Account::authenticate() {
		// authenticate called without secret, so we use session authentication
		return authenticateSession();
	}

	bool Account::authenticate(const std::string &secret) {
		return authenticatePassword(secret);
	}

	bool Account::authenticateSession() {
		if (m_account.sessionExpires < getTimeNow()) {
			logger.error("Session expired for account[{}] expired at [{}] current time [{}]!", m_account.id, m_account.sessionExpires, getTimeNow());
			return false;
		}
		return true;
	}

	bool Account::authenticatePassword(const std::string &password) {
		if (Argon2 {}.argon(password.c_str(), getPassword())) {
			return true;
		}

		if (transformToSHA1(password) == getPassword()) {
			return true;
		}

		logger.error("Password '{}' doesn't match any account", getPassword());
		return false;
	}

	uint32_t Account::getAccountAgeInDays() const {
		return static_cast<uint32_t>(std::ceil((getTimeNow() - m_account.creationTime) / 86400));
	}

} // namespace account
