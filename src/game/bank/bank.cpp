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
#include "game/scheduling/save_manager.hpp"

Bank::Bank(const std::shared_ptr<Bankable> bankable) :
	m_bankable(bankable) {
}

Bank::~Bank() {
	auto bankable = getBankable();
	if (bankable == nullptr || bankable->isOnline()) {
		return;
	}
	std::shared_ptr<Player> player = bankable->getPlayer();
	if (player && !player->isOnline()) {
		g_saveManager().savePlayer(player);

		return;
	}
	if (bankable->isGuild()) {
		const auto guild = static_self_cast<Guild>(bankable);
		if (guild && !guild->isOnline()) {
			g_saveManager().saveGuild(guild);
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
	auto bankable = getBankable();
	if (!bankable) {
		return 0;
	}
	bankable->setBankBalance(amount);
	return true;
}

uint64_t Bank::balance() {
	auto bankable = getBankable();
	if (!bankable) {
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

bool Bank::transferTo(const std::shared_ptr<Bank> destination, uint64_t amount) {
	if (!destination) {
		g_logger().error("Bank::transferTo: destination is nullptr");
		return false;
	}
	auto bankable = getBankable();
	if (!bankable) {
		g_logger().error("Bank::transferTo: bankable is nullptr");
		return false;
	}
	auto destinationBankable = destination->getBankable();
	if (!destinationBankable) {
		g_logger().error("Bank::transferTo: destinationBankable is nullptr");
		return false;
	}
	if (destinationBankable->getPlayer() != nullptr) {
		auto player = destinationBankable->getPlayer();
		auto name = asLowerCaseString(player->getName());
		replaceString(name, " ", "");
		if (deniedNames.contains(name)) {
			g_logger().warn("Bank::transferTo: denied name: {}", name);
			return false;
		}
		if (player->getTown()->getID() < minTownId) {
			g_logger().warn("Bank::transferTo: denied town: {}", player->getTown()->getID());
			return false;
		}
	}

	return debit(amount) && destination->credit(amount);
}

bool Bank::withdraw(std::shared_ptr<Player> player, uint64_t amount) {
	if (!debit(amount)) {
		return false;
	}
	g_game().addMoney(player, amount);
	return true;
}

bool Bank::deposit(const std::shared_ptr<Bank> destination) {
	auto bankable = getBankable();
	if (!bankable) {
		return false;
	}
	if (bankable->getPlayer() == nullptr) {
		return false;
	}
	auto amount = bankable->getPlayer()->getMoney();
	return deposit(destination, amount);
}

bool Bank::deposit(const std::shared_ptr<Bank> destination, uint64_t amount) {
	if (!destination) {
		return false;
	}
	auto bankable = getBankable();
	if (!bankable) {
		return false;
	}
	if (!g_game().removeMoney(bankable->getPlayer(), amount)) {
		return false;
	}
	return destination->credit(amount);
}
