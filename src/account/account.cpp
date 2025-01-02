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
#include "account/account_info.hpp"
#include "security/argon.hpp"
#include "utils/tools.hpp"
#include "enums/account_coins.hpp"
#include "enums/account_errors.hpp"
#include "enums/account_type.hpp"

Account::Account(const uint32_t &id) {
	m_descriptor.clear();
	m_account = std::make_unique<AccountInfo>();
	m_account->id = id;
	m_account->premiumRemainingDays = 0;
	m_account->premiumLastDay = 0;
	m_account->accountType = ACCOUNT_TYPE_NORMAL;
}

Account::Account(std::string descriptor) :
	m_descriptor(std::move(descriptor)) {
	m_account = std::make_unique<AccountInfo>();
	m_account->id = 0;
	m_account->premiumRemainingDays = 0;
	m_account->premiumLastDay = 0;
	m_account->accountType = ACCOUNT_TYPE_NORMAL;
}

AccountErrors_t Account::load() {
	using enum AccountErrors_t;
	if (m_account->id != 0 && g_accountRepository().loadByID(m_account->id, m_account)) {
		m_accLoaded = true;
		return Ok;
	}

	if (!m_descriptor.empty() && g_accountRepository().loadByEmailOrName(getProtocolCompat(), m_descriptor, m_account)) {
		m_accLoaded = true;
		return Ok;
	}

	if (!m_descriptor.empty() && g_accountRepository().loadBySession(m_descriptor, m_account)) {
		m_accLoaded = true;
		return Ok;
	}

	updatePremiumTime();
	return LoadingAccount;
}

AccountErrors_t Account::reload() {
	if (!m_accLoaded) {
		return AccountErrors_t::NotInitialized;
	}

	return load();
}

AccountErrors_t Account::save() const {
	using enum AccountErrors_t;
	if (!m_accLoaded) {
		return NotInitialized;
	}
	if (!g_accountRepository().save(m_account)) {
		return Storage;
	}
	return Ok;
}

std::tuple<uint32_t, AccountErrors_t> Account::getCoins(CoinType type) const {
	using enum AccountErrors_t;
	if (!m_accLoaded) {
		return { 0, NotInitialized };
	}

	uint32_t coins = 0;
	if (!g_accountRepository().getCoins(m_account->id, type, coins)) {
		return { 0, Storage };
	}

	return { coins, Ok };
}

AccountErrors_t Account::addCoins(CoinType type, const uint32_t &amount, const std::string &detail) {
	using enum AccountErrors_t;
	if (!m_accLoaded) {
		return NotInitialized;
	}

	if (amount == 0) {
		return Ok;
	}

	auto [coins, result] = getCoins(type);

	if (Ok != result) {
		return result;
	}

	if (!g_accountRepository().setCoins(m_account->id, type, coins + amount)) {
		return Storage;
	}

	registerCoinTransaction(CoinTransactionType::Add, type, amount, detail);

	return Ok;
}

AccountErrors_t Account::removeCoins(CoinType type, const uint32_t &amount, const std::string &detail) {
	using enum AccountErrors_t;
	if (!m_accLoaded) {
		return NotInitialized;
	}

	if (amount == 0) {
		return Ok;
	}

	auto [coins, result] = getCoins(type);

	if (Ok != result) {
		return result;
	}

	if (coins < amount) {
		g_logger().info("Account doesn't have enough coins! current[{}], remove:[{}]", coins, amount);
		return RemoveCoins;
	}

	if (!g_accountRepository().setCoins(m_account->id, type, coins - amount)) {
		return Storage;
	}

	registerCoinTransaction(CoinTransactionType::Remove, type, amount, detail);

	return Ok;
}

void Account::registerCoinTransaction(CoinTransactionType transactionType, CoinType type, const uint32_t &amount, const std::string &detail) {
	if (!m_accLoaded) {
		return;
	}

	if (detail.empty()) {
		return;
	}

	if (!g_accountRepository().registerCoinsTransaction(m_account->id, transactionType, amount, type, detail)) {
		g_logger().error(
			"Failed to register transaction: 'account:[{}], transaction "
			"type:[{}], coins:[{}], coin type:[{}], description:[{}]",
			m_account->id, transactionType, amount, type, detail
		);
	}
}

[[nodiscard]] uint32_t Account::getID() const {
	return m_account->id;
};

std::string Account::getDescriptor() const {
	return m_descriptor;
}

std::string Account::getPassword() {
	if (!m_accLoaded) {
		return "";
	}

	std::string password;
	if (!g_accountRepository().getPassword(m_account->id, password)) {
		password.clear();
		g_logger().error("Failed to get password for account[{}]!", m_account->id);
	}

	return password;
}

void Account::addPremiumDays(const int32_t &days) {
	auto timeLeft = std::max(0, static_cast<int>((m_account->premiumLastDay - getTimeNow()) % 86400));
	setPremiumDays(m_account->premiumRemainingDays + days);
	m_account->premiumDaysPurchased += days;

	if (timeLeft > 0) {
		m_account->premiumLastDay += timeLeft;
	}
}

void Account::setPremiumDays(const int32_t &days) {
	m_account->premiumRemainingDays = days;
	m_account->premiumLastDay = getTimeNow() + (days * 86400);

	if (days <= 0) {
		m_account->premiumLastDay = 0;
		m_account->premiumRemainingDays = 0;
	}
}

[[nodiscard]] uint32_t Account::getPremiumRemainingDays() const {
	return m_account->premiumLastDay > getTimeNow() ? static_cast<uint32_t>((m_account->premiumLastDay - getTimeNow()) / 86400) : 0;
}

[[nodiscard]] uint32_t Account::getPremiumDaysPurchased() const {
	return m_account->premiumDaysPurchased;
}

AccountErrors_t Account::setAccountType(AccountType accountType) {
	m_account->accountType = accountType;
	return AccountErrors_t::Ok;
}

[[nodiscard]] AccountType Account::getAccountType() const {
	return m_account->accountType;
}

void Account::updatePremiumTime() {
	time_t lastDay = m_account->premiumLastDay;
	uint32_t remainingDays = m_account->premiumRemainingDays;

	time_t currentTime = getTimeNow();

	auto daysLeft = static_cast<int32_t>((lastDay - currentTime) / 86400);
	auto timeLeft = static_cast<int32_t>((lastDay - currentTime) % 86400);

	m_account->premiumRemainingDays = daysLeft > 0 ? daysLeft : 0;

	if (daysLeft == 0 && timeLeft == 0) {
		setPremiumDays(0);
	}

	if (lastDay < currentTime || lastDay == 0) {
		setPremiumDays(0);
	}

	if (remainingDays == m_account->premiumRemainingDays) {
		return;
	}

	if (AccountErrors_t::Ok != save()) {
		g_logger().error("Failed to update account premium time: [{}]", getDescriptor());
	}
}

std::tuple<phmap::flat_hash_map<std::string, uint64_t>, AccountErrors_t>
Account::getAccountPlayers() const {
	using enum AccountErrors_t;
	auto valueToReturn = m_accLoaded ? Ok : NotInitialized;
	return { m_account->players, valueToReturn };
}

void Account::setProtocolCompat(bool toggle) {
	m_account->oldProtocol = toggle;
}
bool Account::getProtocolCompat() const {
	return m_account->oldProtocol;
}

bool Account::authenticate() {
	// authenticate called without secret, so we use session authentication
	return authenticateSession();
}

bool Account::authenticate(const std::string &secret) {
	return authenticatePassword(secret);
}

bool Account::authenticateSession() {
	if (m_account->sessionExpires < getTimeNow()) {
		g_logger().error("Session expired for account[{}] expired at [{}] current time [{}]!", m_account->id, m_account->sessionExpires, getTimeNow());
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
	return static_cast<uint32_t>(std::ceil((getTimeNow() - m_account->creationTime) / 86400));
}

[[nodiscard]] time_t Account::getPremiumLastDay() const {
	return m_account->premiumLastDay;
}

uint32_t Account::getHouseBidId() const {
	return m_account->houseBidId;
}
void Account::setHouseBidId(uint32_t houseId) {
	m_account->houseBidId = houseId;
}
