/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class Bank;

class BankFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerTable(L, "Bank");
		registerMethod(L, "Bank", "credit", BankFunctions::luaBankCredit);
		registerMethod(L, "Bank", "debit", BankFunctions::luaBankDebit);
		registerMethod(L, "Bank", "balance", BankFunctions::luaBankBalance);
		registerMethod(L, "Bank", "hasBalance", BankFunctions::luaBankHasBalance);
		registerMethod(L, "Bank", "transfer", BankFunctions::luaBankTransfer);
		registerMethod(L, "Bank", "transferToGuild", BankFunctions::luaBankTransferToGuild);
		registerMethod(L, "Bank", "withdraw", BankFunctions::luaBankWithdraw);
		registerMethod(L, "Bank", "deposit", BankFunctions::luaBankDeposit);
	}

private:
	static int luaBankCredit(lua_State* L);
	static int luaBankDebit(lua_State* L);
	static int luaBankBalance(lua_State* L);
	static int luaBankHasBalance(lua_State* L);
	static int luaBankTransfer(lua_State* L);
	static int luaBankTransferToGuild(lua_State* L);
	static int luaBankWithdraw(lua_State* L);
	static int luaBankDeposit(lua_State* L);

	static std::shared_ptr<Bank> getBank(lua_State* L, int32_t arg, bool isGuild = false);
};
