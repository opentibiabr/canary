/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "bank.hpp"
#include "game/game.hpp"
#include "creatures/players/player.hpp"
#include "io/iologindata.hpp"

Bank::Bank(const std::shared_ptr<Bankable> &bankable) :
	bankable(bankable) {
}

Bank::~Bank() {
	if (bankable == nullptr || bankable->isOnline()) {
		return;
	}
	Player* player = bankable->getPlayer();
	if (player && !player->isOnline()) {
		IOLoginData::savePlayer(player);
		delete player;
		return;
	}
	if (bankable->isGuild()) {
		const auto &guild = static_self_cast<Guild>(bankable);
		if (guild && !guild->isOnline()) {
			IOGuild::saveGuild(guild);
		}
	}
}

bool Bank::credit(uint64_t amount) {
	return balance(balance() + amount);
}

bool Bank::debit(uint64_t amount) {
	if (!hasBalance(amount)) {
		return false;
	}
	return balance(balance() - amount);
}

bool Bank::balance(uint64_t amount) const {
	if (bankable == nullptr) {
		return 0;
	}
	bankable->setBankBalance(amount);
	return true;
}

uint64_t Bank::balance() {
	if (bankable == nullptr) {
		return 0;
	}
	return bankable->getBankBalance();
}

bool Bank::hasBalance(const uint64_t amount) {
	return balance() >= amount;
}

const std::set<std::string> deniedNames = {
	"accountmanager",
	"rooksample",
	"druidsample",
	"sorcerersample",
	"knightsample",
	"paladinsample"
};

const uint32_t minTownId = 3;

bool Bank::transferTo(const std::shared_ptr<Bank> &destination, uint64_t amount) {
	if (destination == nullptr) {
		return false;
	}
	if (destination->bankable->getPlayer() != nullptr) {
		auto player = bankable->getPlayer();
		auto name = asLowerCaseString(player->getName());
		replaceString(name, " ", "");
		if (deniedNames.contains(name)) {
			return false;
		}
		if (player->getTown()->getID() < minTownId) {
			return false;
		}
	}

	if (!hasBalance(amount)) {
		return false;
	}

	return debit(amount) && destination->credit(amount);
}

bool Bank::withdraw(Player* player, uint64_t amount) {
	if (!debit(amount)) {
		return false;
	}
	g_game().addMoney(player, amount);
	return true;
}

bool Bank::deposit(const std::shared_ptr<Bank> &destination) {
	if (bankable->getPlayer() == nullptr) {
		return false;
	}
	auto amount = bankable->getPlayer()->getMoney();
	return deposit(destination, amount);
}

bool Bank::deposit(const std::shared_ptr<Bank> &destination, uint64_t amount) {
	if (destination == nullptr) {
		return false;
	}
	if (!g_game().removeMoney(bankable->getPlayer(), amount)) {
		return false;
	}
	return destination->credit(amount);
}
