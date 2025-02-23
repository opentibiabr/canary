-- Core API functions implemented in Lua
dofile(DATA_DIRECTORY .. "/lib/core/load.lua")

-- Others library
dofile(DATA_DIRECTORY .. "/lib/others/load.lua")

-- Quests library
dofile(DATA_DIRECTORY .. "/lib/quests/quest.lua")

-- Tables library
dofile(DATA_DIRECTORY .. "/lib/tables/load.lua")

-- Functions library
dofile(DATA_DIRECTORY .. "/lib/functions/load.lua")

-- Custom LIB
dofile(DATA_DIRECTORY .. "/lib/custom/load.lua")
dofile(DATA_DIRECTORY .. "/lib/custom/monsterHunter.lua")
dofile(DATA_DIRECTORY .. "/lib/custom/city_war.lua")
dofile(DATA_DIRECTORY .. "/lib/custom/tasksystem.lua")
