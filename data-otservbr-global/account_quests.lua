-- Account-wide quest system configuration.
-- This file is loaded by scripts/custom/account_quest_system.lua.
-- Restart the server after changing it.

return {
    enabled = true,

    -- When true, an access unlocked by one character is available to every
    -- character on the same account.
    shareAccess = true,

    -- Supported values: "oncePerAccount" and "oncePerCharacter".
    defaultRewardMode = "oncePerAccount",

    -- Self-service reset is disabled by default. Administrators can always use
    -- /questreset Player Name, quest-id
    allowSelfReset = false,

    -- Register quests here. Storage keys listed in progressStorages are reset
    -- only for the selected character. Account access and reward history are
    -- deliberately not reset.
    quests = {
        -- Example:
        -- ["example-quest"] = {
        --     rewardMode = "oncePerAccount",
        --     progressStorages = {
        --         10001,
        --         10002,
        --         10003,
        --     },
        -- },
        --
        -- A quest whose final item must be obtainable by every character:
        -- ["character-item-quest"] = {
        --     rewardMode = "oncePerCharacter",
        --     progressStorages = { 10100, 10101 },
        -- },
    },
}
