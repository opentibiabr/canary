#ifndef SRC_LUA_FUNCTIONS_CORE_GAME_BANK_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_GAME_BANK_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

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

		static std::unique_ptr<Bank> getBank(lua_State* L, int32_t arg, bool isGuild = false);
};

#endif // SRC_LUA_FUNCTIONS_CORE_GAME_BANK_FUNCTIONS_HPP_
