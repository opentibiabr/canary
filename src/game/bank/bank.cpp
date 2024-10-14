/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "bank.hpp"
#include "game/game.hpp"
#include "creatures/players/player.hpp"
#include "io/iologindata.hpp"
#include "game/scheduling/save_manager.hpp"
#include "lib/metrics/metrics.hpp"

Bank::Bank(const std::shared_ptr<Bankable> bankable) :
	m_bankable(bankable) {
}

Bank::~Bank() {
	auto bankable = getBankable();
	if (!bankable || bankable->isOnline()) {
		return;
	}

	if (auto player = bankable->getPlayer()) {
		if (!player->isOnline()) {
			g_saveManager().savePlayer(player);
		}
	} else if (auto guild = bankable->getGuild()) {
		if (!guild->isOnline()) {
			g_saveManager().saveGuild(guild);
		}
	}
}

bool Bank::credit(uint64_t amount) {
	return balance(balance() + amount);
}

bool Bank::debit(uint64_t amount) {
	if (hasBalance(amount)) {
		return balance(balance() - amount);
	}
	return false;
}

bool Bank::balance(uint64_t amount) const {
	if (auto bankable = getBankable()) {
		bankable->setBankBalance(amount);
		return true;
	}
	return false;
}

uint64_t Bank::balance() {
	if (auto bankable = getBankable()) {
		return bankable->getBankBalance();
	}
	return 0;
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

bool Bank::transferTo(const std::shared_ptr<Bank> &destination, const uint64_t amount) {
	if (!destination) {
		g_logger().error("Bank::transferTo: destination is nullptr");
		return false;
	}

	const auto bankable = getBankable();
	if (!bankable) {
		g_logger().error("Bank::transferTo: bankable is nullptr");
		return false;
	}

	const auto destinationBankable = destination->getBankable();
	if (!destinationBankable) {
		g_logger().error("Bank::transferTo: destinationBankable is nullptr");
		return false;
	}

	const auto &destinationPlayer = destinationBankable->getPlayer();
	const auto &bankablePlayer = bankable->getPlayer();
	if (destinationPlayer && bankablePlayer) {
		auto name = asLowerCaseString(destinationPlayer->getName());
		replaceString(name, " ", "");

		if (deniedNames.contains(name)) {
			g_logger().warn("Bank::transferTo: denied name: {}", name);
			return false;
		}

		const auto destinationTownId = destinationPlayer->getTown()->getID();
		const auto bankableTownId = bankablePlayer->getTown()->getID();
		const auto minTownIdToTransferFromMain = g_configManager().getNumber(MIN_TOWN_ID_TO_BANK_TRANSFER_FROM_MAIN);

		if (destinationTownId < minTownIdToTransferFromMain && bankableTownId >= minTownIdToTransferFromMain) {
			g_logger().warn("[{}] Player {} is from main town, trying to transfer money to player {} in {} town.", __FUNCTION__, bankablePlayer->getName(), destinationPlayer->getName(), destinationTownId);
			return false;
		}

		if (bankableTownId < minTownIdToTransferFromMain && destinationTownId >= minTownIdToTransferFromMain) {
			g_logger().warn("[{}] Player {} is not from main town, trying to transfer money to player {} in {} town.", __FUNCTION__, bankablePlayer->getName(), destinationPlayer->getName(), destinationTownId);
			return false;
		}
	}

	auto transactionSuccessfully = debit(amount) && destination->credit(amount);
	if (!transactionSuccessfully) {
		return false;
	}

	if (destinationPlayer) {
		g_metrics().addCounter("balance_increase", amount, { { "player", destinationPlayer->getName() }, { "context", "bank_transfer" } });
	}
	if (bankablePlayer) {
		g_metrics().addCounter("balance_decrease", amount, { { "player", bankablePlayer->getName() }, { "context", "bank_transfer" } });
	}
	return true;
}

bool Bank::withdraw(std::shared_ptr<Player> player, uint64_t amount) {
	if (!player) {
		return false;
	}

	if (debit(amount)) {
		g_game().addMoney(player, amount);
		g_metrics().addCounter("balance_decrease", amount, { { "player", player->getName() }, { "context", "bank_withdraw" } });
		return true;
	}
	return false;
}

bool Bank::deposit(const std::shared_ptr<Bank> destination) {
	auto bankable = getBankable();
	if (!bankable) {
		return false;
	}

	const auto &bankablePlayer = bankable->getPlayer();
	if (!bankablePlayer) {
		return false;
	}

	auto amount = bankablePlayer->getMoney();
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

	const auto &bankablePlayer = bankable->getPlayer();
	if (!bankablePlayer) {
		return false;
	}

	auto successfullyRemovedMoney = g_game().removeMoney(bankablePlayer, amount);
	if (!successfullyRemovedMoney) {
		return false;
	}

	g_metrics().addCounter("balance_decrease", amount, { { "player", bankablePlayer->getName() }, { "context", "bank_deposit" } });
	return destination->credit(amount);
}
