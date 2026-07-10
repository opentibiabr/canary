-- Account-wide quest system configuration.
-- This file is loaded by scripts/custom/account_quest_system.lua.
-- Restart the server after changing it.

return {
    enabled = true,
    shareAccess = true,
    defaultRewardMode = "oncePerAccount",
    allowSelfReset = false,
    quests = {
        ["the-ape-city"] = {
            rewardMode = "oncePerCharacter",
            progressStorages = {
                40612, 40613, 40614, 40615, 40616, 40617, 40618, 40619,
                40620, 40621, 40622, 40623, 40624, 40625, 40626, 40627, 40628,
            },
        },
    },
}
