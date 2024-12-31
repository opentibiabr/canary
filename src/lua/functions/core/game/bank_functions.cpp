/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/game/bank_functions.hpp"

#include "creatures/players/player.hpp"
#include "game/bank/bank.hpp"
#include "game/game.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void BankFunctions::init(lua_State* L) {
	Lua::registerTable(L, "Bank");
	Lua::registerMethod(L, "Bank", "credit", BankFunctions::luaBankCredit);
	Lua::registerMethod(L, "Bank", "debit", BankFunctions::luaBankDebit);
	Lua::registerMethod(L, "Bank", "balance", BankFunctions::luaBankBalance);
	Lua::registerMethod(L, "Bank", "hasBalance", BankFunctions::luaBankHasBalance);
	Lua::registerMethod(L, "Bank", "transfer", BankFunctions::luaBankTransfer);
	Lua::registerMethod(L, "Bank", "transferToGuild", BankFunctions::luaBankTransferToGuild);
	Lua::registerMethod(L, "Bank", "withdraw", BankFunctions::luaBankWithdraw);
	Lua::registerMethod(L, "Bank", "deposit", BankFunctions::luaBankDeposit);
}

int BankFunctions::luaBankCredit(lua_State* L) {
	// Bank.credit(playerOrGuild, amount)
	const auto &bank = getBank(L, 1);
	if (bank == nullptr) {
		Lua::reportErrorFunc("Bank is nullptr");
		return 1;
	}
	const uint64_t amount = Lua::getNumber<uint64_t>(L, 2);
	Lua::pushBoolean(L, bank->credit(amount));
	return 1;
}

int BankFunctions::luaBankDebit(lua_State* L) {
	// Bank.debit(playerOrGuild, amount)
	const auto &bank = getBank(L, 1);
	if (bank == nullptr) {
		Lua::reportErrorFunc("Bank is nullptr");
		return 1;
	}
	const uint64_t amount = Lua::getNumber<uint64_t>(L, 2);
	Lua::pushBoolean(L, bank->debit(amount));
	return 1;
}

int BankFunctions::luaBankBalance(lua_State* L) {
	// Bank.balance(playerOrGuild[, amount]])
	const auto &bank = getBank(L, 1);
	if (bank == nullptr) {
		Lua::reportErrorFunc("Bank is nullptr");
		return 1;
	}
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, bank->balance());
		return 1;
	}
	const uint64_t amount = Lua::getNumber<uint64_t>(L, 2);
	Lua::pushBoolean(L, bank->balance(amount));
	return 1;
}

int BankFunctions::luaBankHasBalance(lua_State* L) {
	// Bank.hasBalance(playerOrGuild, amount)
	const auto &bank = getBank(L, 1);
	if (bank == nullptr) {
		Lua::reportErrorFunc("Bank is nullptr");
		return 1;
	}
	const uint64_t amount = Lua::getNumber<uint64_t>(L, 2);
	Lua::pushBoolean(L, bank->hasBalance(amount));
	return 1;
}

int BankFunctions::luaBankTransfer(lua_State* L) {
	// Bank.transfer(fromPlayerOrGuild, toPlayerOrGuild, amount)
	const auto &source = getBank(L, 1);
	if (source == nullptr) {
		g_logger().debug("BankFunctions::luaBankTransfer: source is null");
		Lua::reportErrorFunc("Bank is nullptr");
		return 1;
	}
	const auto &destination = getBank(L, 2);
	if (destination == nullptr) {
		g_logger().debug("BankFunctions::luaBankTransfer: destination is null");
		Lua::reportErrorFunc("Bank is nullptr");
		return 1;
	}
	const uint64_t amount = Lua::getNumber<uint64_t>(L, 3);
	Lua::pushBoolean(L, source->transferTo(destination, amount));
	return 1;
}

int BankFunctions::luaBankTransferToGuild(lua_State* L) {
	// Bank.transfer(fromPlayerOrGuild, toGuild, amount)
	const auto &source = getBank(L, 1);
	if (source == nullptr) {
		Lua::reportErrorFunc("Source is nullptr");
		return 1;
	}
	const auto &destination = getBank(L, 2, true /* isGuild */);
	if (destination == nullptr) {
		Lua::reportErrorFunc("Destination is nullptr");
		return 1;
	}
	const uint64_t amount = Lua::getNumber<uint64_t>(L, 3);
	Lua::pushBoolean(L, source->transferTo(destination, amount));
	return 1;
}

int BankFunctions::luaBankWithdraw(lua_State* L) {
	// Bank.withdraw(player, amount[, source = player])
	const auto &player = Lua::getPlayer(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const uint64_t amount = Lua::getNumber<uint64_t>(L, 2);
	if (lua_gettop(L) == 2) {
		auto bank = std::make_shared<Bank>(player);
		Lua::pushBoolean(L, bank->withdraw(player, amount));
		return 1;
	}
	const auto &source = getBank(L, 3);
	if (source == nullptr) {
		Lua::reportErrorFunc("Source is nullptr");
		return 1;
	}
	Lua::pushBoolean(L, source->withdraw(player, amount));
	return 1;
}

int BankFunctions::luaBankDeposit(lua_State* L) {
	// Bank.deposit(player, amount[, destination = player])
	const auto &player = Lua::getPlayer(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}
	auto bank = std::make_shared<Bank>(player);

	uint64_t amount = 0;
	if (lua_isnumber(L, 2)) {
		amount = Lua::getNumber<uint64_t>(L, 2);
	} else if (lua_isnil(L, 2)) {
		amount = player->getMoney();
	}

	if (lua_gettop(L) == 2) {
		Lua::pushBoolean(L, g_game().removeMoney(player, amount) && bank->credit(amount));
		return 1;
	}
	const auto &destination = getBank(L, 3);
	if (destination == nullptr) {
		Lua::reportErrorFunc("Destination is nullptr");
		return 1;
	}
	Lua::pushBoolean(L, g_game().removeMoney(player, amount) && destination->credit(amount));
	return 1;
}

std::shared_ptr<Bank> BankFunctions::getBank(lua_State* L, int32_t arg, bool isGuild /*= false*/) {
	if (Lua::getUserdataType(L, arg) == LuaData_t::Guild) {
		return std::make_shared<Bank>(Lua::getGuild(L, arg));
	}
	if (isGuild) {
		const auto &guild = Lua::getGuild(L, arg, true);
		if (!guild) {
			return nullptr;
		}
		return std::make_shared<Bank>(guild);
	}
	const auto &player = Lua::getPlayer(L, arg, true);
	if (!player) {
		return nullptr;
	}
	return std::make_shared<Bank>(player);
}
