#include "pch.hpp"
#include "lua/functions/core/game/bank_functions.hpp"
#include "game/bank/bank.hpp"
#include "game/game.hpp"

int BankFunctions::luaBankCredit(lua_State* L) {
	// Bank.credit(playerOrGuild, amount)
	auto bank = getBank(L, 1);
	if (bank == nullptr) {
		lua_pushnil(L);
		return 1;
	}
	uint64_t amount = getNumber<uint64_t>(L, 2);
	pushBoolean(L, bank->credit(amount));
	return 1;
}

int BankFunctions::luaBankDebit(lua_State* L) {
	// Bank.debit(playerOrGuild, amount)
	auto bank = getBank(L, 1);
	if (bank == nullptr) {
		lua_pushnil(L);
		return 1;
	}
	uint64_t amount = getNumber<uint64_t>(L, 2);
	pushBoolean(L, bank->debit(amount));
	return 1;
}

int BankFunctions::luaBankBalance(lua_State* L) {
	// Bank.balance(playerOrGuild[, amount]])
	auto bank = getBank(L, 1);
	if (bank == nullptr) {
		lua_pushnil(L);
		return 1;
	}
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, bank->balance());
		return 1;
	}
	uint64_t amount = getNumber<uint64_t>(L, 2);
	pushBoolean(L, bank->balance(amount));
	return 1;
}

int BankFunctions::luaBankHasBalance(lua_State* L) {
	// Bank.hasBalance(playerOrGuild, amount)
	auto bank = getBank(L, 1);
	if (bank == nullptr) {
		lua_pushnil(L);
		return 1;
	}
	uint64_t amount = getNumber<uint64_t>(L, 2);
	pushBoolean(L, bank->hasBalance(amount));
	return 1;
}

int BankFunctions::luaBankTransfer(lua_State* L) {
	// Bank.transfer(fromPlayerOrGuild, toPlayerOrGuild, amount)
	auto source = getBank(L, 1);
	if (source == nullptr) {
		g_logger().debug("BankFunctions::luaBankTransfer: source is null");
		lua_pushnil(L);
		return 1;
	}
	std::shared_ptr<Bank> destination = getBank(L, 2);
	if (destination == nullptr) {
		g_logger().debug("BankFunctions::luaBankTransfer: destination is null");
		lua_pushnil(L);
		return 1;
	}
	uint64_t amount = getNumber<uint64_t>(L, 3);
	pushBoolean(L, source->transferTo(destination, amount));
	return 1;
}

int BankFunctions::luaBankTransferToGuild(lua_State* L) {
	// Bank.transfer(fromPlayerOrGuild, toGuild, amount)
	auto source = getBank(L, 1);
	if (source == nullptr) {
		lua_pushnil(L);
		return 1;
	}
	std::shared_ptr<Bank> destination = getBank(L, 2, true /* isGuild */);
	if (destination == nullptr) {
		lua_pushnil(L);
		return 1;
	}
	uint64_t amount = getNumber<uint64_t>(L, 3);
	pushBoolean(L, source->transferTo(destination, amount));
	return 1;
}

int BankFunctions::luaBankWithdraw(lua_State* L) {
	// Bank.withdraw(player, amount[, source = player])
	auto player = getPlayer(L, 1);
	uint64_t amount = getNumber<uint64_t>(L, 2);
	if (lua_gettop(L) == 2) {
		if (!player) {
			return 1;
		}

		const auto bank = std::make_shared<Bank>(player);
		pushBoolean(L, bank->withdraw(player, amount));
		return 1;
	}
	auto source = getBank(L, 3);
	if (source == nullptr) {
		lua_pushnil(L);
		return 1;
	}
	pushBoolean(L, source->withdraw(player, amount));
	return 1;
}

int BankFunctions::luaBankDeposit(lua_State* L) {
	// Bank.deposit(player, amount[, destination = player])
	auto player = getPlayer(L, 1);
	if (!player) {
		return 1;
	}
	const auto bank = std::make_shared<Bank>(player);

	uint64_t amount = 0;
	if (lua_isnumber(L, 2)) {
		amount = getNumber<uint64_t>(L, 2);
	} else if (lua_isnil(L, 2)) {
		amount = player->getMoney();
	}

	if (lua_gettop(L) == 2) {
		pushBoolean(L, g_game().removeMoney(player, amount) && bank->credit(amount));
		return 1;
	}
	auto destination = getBank(L, 3);
	if (destination == nullptr) {
		lua_pushnil(L);
		return 1;
	}
	pushBoolean(L, g_game().removeMoney(player, amount) && destination->credit(amount));
	return 1;
}

std::shared_ptr<Bank> BankFunctions::getBank(lua_State* L, int32_t arg, bool isGuild /*= false*/) {
	if (getUserdataType(L, arg) == LuaData_t::Guild) {
		return std::make_shared<Bank>(getGuild(L, arg));
	}
	if (isGuild) {
		const auto guild = getGuild(L, arg, true);
		if (!guild) {
			return nullptr;
		}
		return std::make_shared<Bank>(guild);
	}
	std::shared_ptr<Player> player = getPlayer(L, arg, true);
	if (!player) {
		return nullptr;
	}
	return std::make_shared<Bank>(player);
}
