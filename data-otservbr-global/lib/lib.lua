-- Core API functions implemented in Lua
dofile(DATA_DIRECTORY .. "/lib/core/load.lua")

-- Others library
dofile(DATA_DIRECTORY .. "/lib/others/load.lua")

-- Quests library
dofile(DATA_DIRECTORY .. "/lib/quests/quest.lua")

-- Tables library
dofile(DATA_DIRECTORY .. "/lib/tables/load.lua")

-- Mount Doll library
dofile(DATA_DIRECTORY .. '/lib/others/mount_doll_lib.lua')

-- Remove Frag System
dofile(DATA_DIRECTORY.. '/lib/custom/remove_frags.lua')
