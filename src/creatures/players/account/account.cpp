/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include "creatures/players/account/account.hpp"
#include "database/databasetasks.h"

#include <algorithm>
#include <limits>

namespace account {

Account::Account() {
	id_ = 0;
	email_.clear();
	password_.clear();
	premium_remaining_days_ = 0;
	premium_last_day_ = 0;
	coin_balance_ = 0;
	tournament_coin_balance_ = 0;
	account_type_ = ACCOUNT_TYPE_NORMAL;
	db_ = &Database::getInstance();
	db_tasks_ = &g_databaseTasks;
}

Account::Account(uint32_t id) {
	id_ = id;
	email_.clear();
	password_.clear();
	premium_remaining_days_ = 0;
	premium_last_day_ = 0;
	coin_balance_ = 0;
	tournament_coin_balance_ = 0;
	account_type_ = ACCOUNT_TYPE_NORMAL;
	db_ = &Database::getInstance();
	db_tasks_ = &g_databaseTasks;
}

Account::Account(const std::string &email) : email_(email) {
	id_ = 0;
	password_.clear();
	premium_remaining_days_ = 0;
	premium_last_day_ = 0;
	coin_balance_ = 0;
	tournament_coin_balance_ = 0;
	account_type_ = ACCOUNT_TYPE_NORMAL;
	db_ = &Database::getInstance();
	db_tasks_ = &g_databaseTasks;
}


/*******************************************************************************
 * Interfaces
 ******************************************************************************/

error_t Account::SetDatabaseInterface(Database *database) {
	if (database == nullptr) {
		return ERROR_NULLPTR;
	}

	db_ = database;
	return ERROR_NO;
}

error_t Account::SetDatabaseTasksInterface(DatabaseTasks *database_tasks) {
	if (database_tasks == nullptr) {
		return ERROR_NULLPTR;
	}

	db_tasks_ = database_tasks;
	return ERROR_NO;
}


/*******************************************************************************
 * Coins Methods
 ******************************************************************************/

std::tuple<uint32_t, error_t> Account::GetCoins() {

	if (db_ == nullptr || id_ == 0) {
		return std::make_tuple(0, ERROR_NOT_INITIALIZED);
	}

	std::ostringstream query;
	query << "SELECT `coins` FROM `accounts` WHERE `id` = " << id_;

	DBResult_ptr result = db_->storeQuery(query.str());
	if (!result) {
		return std::make_tuple(0, ERROR_DB);
	}

	return std::make_tuple(result->getNumber<uint32_t>("coins"), ERROR_NO);
}

error_t Account::AddCoins(const uint32_t &amount) {

	if (db_tasks_ == nullptr) {
			return ERROR_NULLPTR;
	}

	if (amount == 0)  {
		return ERROR_NO;
	}

	int result = 0;
	uint32_t current_coins = 0;

	if (auto [ current_coins, result ] = this->GetCoins(); ERROR_NO == result) {
		if ((current_coins + amount) < current_coins) {
			return ERROR_VALUE_OVERFLOW;
		}
	}	else {
		return ERROR_GET_COINS;
	}

	std::ostringstream query;
	query << "UPDATE `accounts` SET `coins` = " << (current_coins + amount)
				<< " WHERE `id` = " << id_;

	db_tasks_->addTask(query.str());

	this->RegisterCoinsTransaction(COIN_ADD, amount, COIN, "");

	return ERROR_NO;
}

error_t Account::RemoveCoins(const uint32_t &amount) {

	if (db_tasks_ == nullptr) {
			return ERROR_NULLPTR;
	}

	if (amount == 0)  {
		return ERROR_NO;
	}

	int result = 0;
	uint32_t current_coins = 0;

	if (auto [ current_coins, result ] = this->GetCoins(); ERROR_NO == result) {
		if ((current_coins - amount) > current_coins) {
			return ERROR_VALUE_NOT_ENOUGH_COINS;
		}
	}	else {
		return ERROR_GET_COINS;
	}

	std::ostringstream query;
	query << "UPDATE `accounts` SET `coins` = "<< (current_coins - amount)
				<< " WHERE `id` = " << id_;

	db_tasks_->addTask(query.str());

	this->RegisterCoinsTransaction(COIN_REMOVE, amount, COIN, "");

	return ERROR_NO;
}

std::tuple<uint32_t, error_t> Account::GetTournamentCoins() {

	if (db_ == nullptr || id_ == 0) {
		return std::make_tuple(0, ERROR_NOT_INITIALIZED);
	}

	std::ostringstream query;
	query << "SELECT `tournament_coins` FROM `accounts` WHERE `id` = " << id_;

	DBResult_ptr result = db_->storeQuery(query.str());
	if (!result) {
		return std::make_tuple(0, ERROR_DB);
	}

	return std::make_tuple(result->getNumber<uint32_t>("tournament_coins"), ERROR_NO);
}

error_t Account::AddTournamentCoins(const uint32_t &amount) {

	if (db_tasks_ == nullptr) {
			return ERROR_NULLPTR;
	}
	if (amount == 0)  {
		return ERROR_NO;
	}

	int result = 0;
	uint32_t current_tournament_coins = 0;

	if (auto [ current_tournament_coins, result ] = this->GetTournamentCoins();
			ERROR_NO == result) {
		if ((current_tournament_coins + amount) < current_tournament_coins) {
			return ERROR_VALUE_OVERFLOW;
		}
	}	else {
		return ERROR_GET_COINS;
	}

	std::ostringstream query;
	query << "UPDATE `accounts` SET `tournament_coins` = "
				<< (current_tournament_coins + amount) << " WHERE `id` = " << id_;

	db_tasks_->addTask(query.str());

	this->RegisterCoinsTransaction(COIN_ADD, amount, TOURNAMENT, "");

	return ERROR_NO;
}

error_t Account::RemoveTournamentCoins(const uint32_t &amount) {

	if (db_tasks_ == nullptr) {
			return ERROR_NULLPTR;
	}

	if (amount == 0)  {
		return ERROR_NO;
	}

	int result = 0;
	uint32_t current_tournament_coins = 0;

	if (auto [ current_tournament_coins, result ] = this->GetTournamentCoins();
			ERROR_NO == result) {
		if ((current_tournament_coins - amount) > current_tournament_coins) {
			return ERROR_VALUE_NOT_ENOUGH_COINS;
		}
	}	else {
		return ERROR_GET_COINS;
	}

	std::ostringstream query;
	query << "UPDATE `accounts` SET `tournament_coins` = "
				<< (current_tournament_coins - amount) << " WHERE `id` = " << id_;

	db_tasks_->addTask(query.str());

	this->RegisterCoinsTransaction(COIN_REMOVE, amount, TOURNAMENT, "");

	return ERROR_NO;
}

error_t Account::RegisterCoinsTransaction(CoinTransactionType type,
	uint32_t coins, CoinType coin_type, const std::string& description) {

	if (db_ == nullptr) {
			return ERROR_NULLPTR;
	}

	std::ostringstream query;
	query << "INSERT INTO `coins_transactions` (`account_id`, `type`, `amount`,"
		" `coin_type`, `description`) VALUES (" << id_ << ", "
		<< static_cast<uint16_t>(type) << ", "<< coins << ", "
		<< static_cast<uint16_t>(coin_type) << ", "
		<< db_->escapeString(description) << ")";

	if (!db_->executeQuery(query.str())) {
			return ERROR_DB;
	}

	return ERROR_NO;
}

/*******************************************************************************
 * Database
 ******************************************************************************/

error_t Account::LoadAccountDB() {
	if (id_ != 0) {
		return this->LoadAccountDB(id_);
	} else if (!email_.empty()) {
		return this->LoadAccountDB(email_);
	}

	return ERROR_NOT_INITIALIZED;
}

error_t Account::LoadAccountDB(const std::string email) {
	std::ostringstream query;
	query << "SELECT * FROM `accounts` WHERE `email` = "
			<< db_->escapeString(email);
	return this->LoadAccountDB(query);
}

error_t Account::LoadAccountDB(uint32_t id) {
	std::ostringstream query;
	query << "SELECT * FROM `accounts` WHERE `id` = " << id;
	return this->LoadAccountDB(query);
}

error_t Account::LoadAccountDB(const std::ostringstream &query) {
	if (db_ == nullptr) {
		return ERROR_NULLPTR;
	}

	DBResult_ptr result = db_->storeQuery(query.str());
	if (!result) {
		return false;
	}

	this->SetID(result->getNumber<uint32_t>("id"));
	this->SetEmail(result->getString("email"));
	this->SetAccountType(static_cast<AccountType>(result->getNumber<int32_t>("type")));
	this->SetPassword(result->getString("password"));
	this->SetPremiumRemaningDays(result->getNumber<uint16_t>("premdays"));
	this->SetPremiumLastDay(result->getNumber<time_t>("lastday"));

	return ERROR_NO;
}

std::tuple<Player, error_t> Account::LoadAccountPlayerDB(const std::string& characterName) {

	Player player;

	if (id_ == 0) {
		std::make_tuple(player, ERROR_NOT_INITIALIZED);
	}

	std::ostringstream query;
	query << "SELECT `name`, `deletion` FROM `players` WHERE `account_id` = "
		<< id_ << " AND `name` = " << db_->escapeString(characterName)
		<< " ORDER BY `name` ASC";

	DBResult_ptr result = db_->storeQuery(query.str());
	if (!result || result->getNumber<uint64_t>("deletion") != 0) {
		return std::make_tuple(player, ERROR_PLAYER_NOT_FOUND);
	}

	player.name = result->getString("name");
	player.deletion = result->getNumber<uint64_t>("deletion");

	return std::make_tuple(player, ERROR_NO);
}

std::tuple<std::vector<Player>, error_t> Account::LoadAccountPlayersDB() {

	std::vector<Player> players;

	if (id_ == 0) {
		return std::make_tuple(players, ERROR_NOT_INITIALIZED);
	}

	std::ostringstream query;
	query << "SELECT `name`, `deletion` FROM `players` WHERE `account_id` = "
				<< id_ << " ORDER BY `name` ASC";

	DBResult_ptr result = db_->storeQuery(query.str());
	if (!result) {
		return std::make_tuple(players, ERROR_DB);
	}

	do {
		if (result->getNumber<uint64_t>("deletion") == 0) {
			Player new_player;
			new_player.name = result->getString("name");
			new_player.deletion = result->getNumber<uint64_t>("deletion");
			players.push_back(new_player);
		}
	} while (result->next());
	return std::make_tuple(players, ERROR_NO);
}

error_t Account::SaveAccountDB() {
	std::ostringstream query;

	query << "UPDATE `accounts` SET "
				<< "`email` = " << db_->escapeString(email_) << " , "
				<< "`type` = " << account_type_ << " , "
				<< "`password` = " << db_->escapeString(password_) << " , "
				<< "`coins` = " << coin_balance_ << " , "
				<< "`tournament_coins` = " << tournament_coin_balance_ << " , "
				<< "`premdays` = " << premium_remaining_days_ << " , "
	<< "`lastday` = " << premium_last_day_;

	if (id_ != 0) {
		query << " WHERE `id` = " << id_;
	} else if (!email_.empty()) {
		query << " WHERE `email` = " << email_;
	}

	if (!db_->executeQuery(query.str())) {
		return ERROR_DB;
	}

	return ERROR_NO;
}

/*******************************************************************************
 * Setters and Getters
 ******************************************************************************/

error_t Account::SetID(uint32_t id) {
	if (id == 0) {
		return ERROR_INVALID_ID;
	}
	id_ = id;
	return ERROR_NO;
}

uint32_t Account::GetID() {
	return id_;
}

error_t Account::SetEmail(std::string email) {
	if (email.empty()) {
		return ERROR_INVALID_ACCOUNT_EMAIL;
	}
	email_ = email;
	return ERROR_NO;
}

std::string Account::GetEmail() {
	return email_;
}

error_t Account::SetPassword(std::string password) {
	if (password.empty()) {
		return ERROR_INVALID_ACC_PASSWORD;
	}
	password_ = password;
	return ERROR_NO;
}

std::string Account::GetPassword() {
	return password_;
}

error_t Account::SetPremiumRemaningDays(uint32_t days) {
	premium_remaining_days_ = days;
	return ERROR_NO;
}

uint32_t Account::GetPremiumRemaningDays() {
	return premium_remaining_days_;
}

error_t Account::SetPremiumLastDay(time_t last_day) {
	if (last_day < 0) {
		return ERROR_INVALID_LAST_DAY;
	}
	premium_last_day_ = last_day;
	return ERROR_NO;
}

time_t Account::GetPremiumLastDay() {
	return premium_last_day_;
}

error_t Account::SetAccountType(AccountType account_type) {
	if (account_type > 5) {
		return ERROR_INVALID_ACC_TYPE;
	}
	account_type_ = account_type;
	return ERROR_NO;
}

AccountType Account::GetAccountType() {
	return account_type_;
}

std::tuple<Player, error_t> Account::GetAccountPlayer(
		const std::string& characterName) {

	Player player;
	int result;
	if (auto [ player, result ] = this->LoadAccountPlayerDB(characterName);
			ERROR_NO == result) {
		return std::make_tuple(player, ERROR_NO);
	}

	return std::make_tuple(player, result);
}


std::tuple<std::vector<Player>, error_t> Account::GetAccountPlayers() {
	std::vector<Player> players;
	int result;
	if (auto [ players, result ] = this->LoadAccountPlayersDB();
			ERROR_NO == result) {
		return std::make_tuple(players, ERROR_NO);
	} else {
		return std::make_tuple(players, result);
	}
}

}  // namespace account
