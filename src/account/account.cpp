/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "account/account.hpp"

#include "account/account_repository_db.hpp"
#include "config/configmanager.hpp"
#include "utils/definitions.hpp"
#include "security/argon.hpp"
#include "utils/tools.hpp"
#include "lib/logging/log_with_spd_log.hpp"

#include "enums/account_type.hpp"
#include "enums/account_coins.hpp"
#include "enums/account_errors.hpp"

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

uint8_t Account::load() {
	if (m_account.id != 0 && g_accountRepository().loadByID(m_account.id, m_account)) {
		m_accLoaded = true;
		return enumToValue(AccountErrors_t::Ok);
	}

	if (!m_descriptor.empty() && g_accountRepository().loadByEmailOrName(getProtocolCompat(), m_descriptor, m_account)) {
		m_accLoaded = true;
		return enumToValue(AccountErrors_t::Ok);
	}

	if (!m_descriptor.empty() && g_accountRepository().loadBySession(m_descriptor, m_account)) {
		m_accLoaded = true;
		return enumToValue(AccountErrors_t::Ok);
	}

	updatePremiumTime();
	return enumToValue(AccountErrors_t::LoadingAccount);
}

uint8_t Account::reload() {
	if (!m_accLoaded) {
		return enumToValue(AccountErrors_t::NotInitialized);
	}

	return load();
}

uint8_t Account::save() {
	if (!m_accLoaded) {
		return enumToValue(AccountErrors_t::NotInitialized);
	}

	if (!g_accountRepository().save(m_account)) {
		return enumToValue(AccountErrors_t::Storage);
	}

	return enumToValue(AccountErrors_t::Ok);
}

std::tuple<uint32_t, uint8_t> Account::getCoins(const uint8_t &type) const {
	if (!m_accLoaded) {
		return { 0, enumToValue(AccountErrors_t::NotInitialized) };
	}

	uint32_t coins = 0;
	if (!g_accountRepository().getCoins(m_account.id, type, coins)) {
		return { 0, enumToValue(AccountErrors_t::Storage) };
	}

	return { coins, enumToValue(AccountErrors_t::Ok) };
}

uint8_t Account::addCoins(const uint8_t &type, const uint32_t &amount, const std::string &detail) {
	if (!m_accLoaded) {
		return enumToValue(AccountErrors_t::NotInitialized);
	}

	if (amount == 0) {
		return enumToValue(AccountErrors_t::Ok);
	}

	auto [coins, result] = getCoins(type);

	if (AccountErrors_t::Ok != enumFromValue<AccountErrors_t>(result)) {
		return result;
	}

	if (!g_accountRepository().setCoins(m_account.id, type, coins + amount)) {
		return enumToValue(AccountErrors_t::Storage);
	}

	registerCoinTransaction(enumToValue(CoinTransactionType::Add), type, amount, detail);

	return enumToValue(AccountErrors_t::Ok);
}

uint8_t Account::removeCoins(const uint8_t &type, const uint32_t &amount, const std::string &detail) {
	if (!m_accLoaded) {
		return enumToValue(AccountErrors_t::NotInitialized);
	}

	if (amount == 0) {
		return enumToValue(AccountErrors_t::Ok);
	}

	auto [coins, result] = getCoins(type);

	if (AccountErrors_t::Ok != enumFromValue<AccountErrors_t>(result)) {
		return result;
	}

	if (coins < amount) {
		g_logger().info("Account doesn't have enough coins! current[{}], remove:[{}]", coins, amount);
		return enumToValue(AccountErrors_t::RemoveCoins);
	}

	if (!g_accountRepository().setCoins(m_account.id, type, coins - amount)) {
		return enumToValue(AccountErrors_t::Storage);
	}

	registerCoinTransaction(enumToValue(CoinTransactionType::Remove), type, amount, detail);

	return enumToValue(AccountErrors_t::Ok);
}

void Account::registerCoinTransaction(const uint8_t &transactionType, const uint8_t &type, const uint32_t &amount, const std::string &detail) {
	if (!m_accLoaded) {
		return;
	}

	if (detail.empty()) {
		return;
	}

	if (!g_accountRepository().registerCoinsTransaction(m_account.id, transactionType, amount, type, detail)) {
		g_logger().error(
			"Failed to register transaction: 'account:[{}], transaction "
			"type:[{}], coins:[{}], coin type:[{}], description:[{}]",
			m_account.id, transactionType, amount, type, detail
		);
	}
}

[[nodiscard]] uint32_t Account::getID() const {
	return m_account.id;
};

std::string Account::getDescriptor() const {
	return m_descriptor;
}

std::string Account::getPassword() {
	if (!m_accLoaded) {
		return "";
	}

	std::string password;
	if (!g_accountRepository().getPassword(m_account.id, password)) {
		password.clear();
		g_logger().error("Failed to get password for account[{}]!", m_account.id);
	}

	return password;
}

void Account::addPremiumDays(const int32_t &days) {
	auto timeLeft = std::max(0, static_cast<int>((m_account.premiumLastDay - getTimeNow()) % 86400));
	setPremiumDays(m_account.premiumRemainingDays + days);
	m_account.premiumDaysPurchased += days;

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

[[nodiscard]] uint32_t Account::getPremiumRemainingDays() const {
	return m_account.premiumLastDay > getTimeNow() ? static_cast<uint32_t>((m_account.premiumLastDay - getTimeNow()) / 86400) : 0;
}

[[nodiscard]] uint32_t Account::getPremiumDaysPurchased() const {
	return m_account.premiumDaysPurchased;
}

uint8_t Account::setAccountType(const uint8_t &accountType) {
	m_account.accountType = accountType;
	return enumToValue(AccountErrors_t::Ok);
}

[[nodiscard]] uint8_t Account::getAccountType() const {
	return m_account.accountType;
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

	if (AccountErrors_t::Ok != enumFromValue<AccountErrors_t>(save())) {
		g_logger().error("Failed to update account premium time: [{}]", getDescriptor());
	}
}

std::tuple<phmap::flat_hash_map<std::string, uint64_t>, uint8_t>
Account::getAccountPlayers() const {
	auto valueToReturn = enumToValue(m_accLoaded ? AccountErrors_t::Ok : AccountErrors_t::NotInitialized);
	return { m_account.players, valueToReturn };
}

void Account::setProtocolCompat(bool toggle) {
	m_account.oldProtocol = toggle;
}
bool Account::getProtocolCompat() const {
	return m_account.oldProtocol;
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
		g_logger().error("Session expired for account[{}] expired at [{}] current time [{}]!", m_account.id, m_account.sessionExpires, getTimeNow());
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

	g_logger().error("Password '{}' doesn't match any account", getPassword());
	return false;
}

uint32_t Account::getAccountAgeInDays() const {
	return static_cast<uint32_t>(std::ceil((getTimeNow() - m_account.creationTime) / 86400));
}

[[nodiscard]] time_t Account::getPremiumLastDay() const {
	return m_account.premiumLastDay;
}
