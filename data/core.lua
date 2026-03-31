DATA_DIRECTORY = configManager.getString(configKeys.DATA_DIRECTORY)
CORE_DIRECTORY = configManager.getString(configKeys.CORE_DIRECTORY)

-- Extend package.path so that require() can find modules under the libs
-- directory (e.g. gamestore.*).  The base path is kept minimal (set in C++)
-- to avoid the heavy string processing that LuaJIT's package.searchpath
-- performs on every require() call when running in interpreter-only mode
-- (macOS ARM64).
local sep = package.config:sub(1, 1)
package.path = package.path
	.. ";" .. CORE_DIRECTORY .. sep .. "libs" .. sep .. "?.lua"
	.. ";" .. CORE_DIRECTORY .. sep .. "libs" .. sep .. "?" .. sep .. "init.lua"

dofile(CORE_DIRECTORY .. "/global.lua")
dofile(CORE_DIRECTORY .. "/libs/libs.lua")
dofile(CORE_DIRECTORY .. "/stages.lua")
