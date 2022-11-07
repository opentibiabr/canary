-- Core API functions implemented in Lua
dofile(DATAPACK_FOLDER_NAME.. '/lib/core/core.lua')

-- Compatibility library for our old Lua API
dofile(DATAPACK_FOLDER_NAME.. '/lib/compat/compat.lua')

-- Debugging helper function for Lua developers
dofile(DATAPACK_FOLDER_NAME.. '/lib/debugging/dump.lua')

-- Tables library
dofile(DATAPACK_FOLDER_NAME.. '/lib/tables/table.lua')

-- Others library
dofile(DATAPACK_FOLDER_NAME.. '/lib/others/others.lua')

-- Quests library
dofile(DATAPACK_FOLDER_NAME.. '/lib/quests/quest.lua')
