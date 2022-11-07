-- Core API functions implemented in Lua
dofile(DATAPACK_FOLDER_NAME.. '/lib/core/load.lua')
dofile(DATAPACK_FOLDER_NAME.. '/lib/core/functions/load.lua')

-- Debugging helper function for Lua developers
dofile(DATAPACK_FOLDER_NAME.. '/lib/debugging/dump.lua')

-- Tables library
dofile(DATAPACK_FOLDER_NAME.. '/lib/tables/load.lua')

-- Daily reward library
dofile(DATAPACK_FOLDER_NAME.. '/lib/daily_reward/daily_reward.lua')
dofile(DATAPACK_FOLDER_NAME.. '/lib/daily_reward/player.lua')

-- Reward boss library
dofile(DATAPACK_FOLDER_NAME.. '/lib/reward_boss/reward_boss.lua')
dofile(DATAPACK_FOLDER_NAME.. '/lib/reward_boss/player.lua')
dofile(DATAPACK_FOLDER_NAME.. '/lib/reward_boss/monster.lua')
