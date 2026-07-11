/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/bank/bank.hpp"

TEST(BankWithdrawalTest, RejectsZeroAndAmountsAboveMaximum) {
	EXPECT_FALSE(Bank::isWithdrawalAmountAllowed(0));
	EXPECT_TRUE(Bank::isWithdrawalAmountAllowed(1));
	EXPECT_TRUE(Bank::isWithdrawalAmountAllowed(Bank::MAX_WITHDRAWAL_AMOUNT));
	EXPECT_FALSE(Bank::isWithdrawalAmountAllowed(Bank::MAX_WITHDRAWAL_AMOUNT + 1));
}
