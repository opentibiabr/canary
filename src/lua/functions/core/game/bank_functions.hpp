/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Bank;

class BankFunctions {
public:
	static void init(lua_State* L);

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
