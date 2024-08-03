-- Load core functions
dofile(CORE_DIRECTORY .. "/libs/functions/load.lua")

-- Core/data Global Storage System
dofile(CORE_DIRECTORY .. "/libs/core/global_storage.lua")

-- Compatibility library for our old Lua API
dofile(CORE_DIRECTORY .. "/libs/compat/compat.lua")

-- Debugging helper function for Lua developers
dofile(CORE_DIRECTORY .. "/libs/debugging/dump.lua")

-- Systems
dofile(CORE_DIRECTORY .. "/libs/systems/load.lua")

-- Tables
dofile(CORE_DIRECTORY .. "/libs/tables/load.lua")
