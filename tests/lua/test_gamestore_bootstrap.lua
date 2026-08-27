-- Standalone bootstrap contract for the Game Store module loader.
-- Run from the repository root with: lua tests/lua/test_gamestore_bootstrap.lua

CORE_DIRECTORY = "data"
Player = {}

for name in pairs(package.loaded) do
	if name:match("^gamestore%.") then
		package.loaded[name] = nil
	end
end
for name in pairs(package.preload) do
	if name:match("^gamestore%.") then
		package.preload[name] = nil
	end
end

local originalPath = package.path
package.path = ".\\?.lua;.\\?\\init.lua"
local loaded, reason = pcall(dofile, "data/modules/scripts/gamestore/init.lua")
package.path = originalPath

assert(loaded, reason)
assert(type(package.preload["gamestore.taskboard"]) == "function")
assert(type(package.loaded["gamestore.purchases"]) == "table")
assert(type(package.loaded["gamestore.player"]) == "table")

print("\n1 passed, 0 failed")
