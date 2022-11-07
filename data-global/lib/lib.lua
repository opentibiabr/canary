-- Core API functions implemented in Lua
-- Load storages first
dofile(DATAPACK_FOLDER_NAME.. '/lib/core/load.lua')

-- Compatibility library for our old Lua API
dofile(DATAPACK_FOLDER_NAME.. '/lib/compat/compat.lua')

-- Tables library
dofile(DATAPACK_FOLDER_NAME.. '/lib/tables/load.lua')

-- Others library
dofile(DATAPACK_FOLDER_NAME.. '/lib/others/load.lua')

-- Quests library
dofile(DATAPACK_FOLDER_NAME.. '/lib/quests/quest.lua')
