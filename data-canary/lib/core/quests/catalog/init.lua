local questModules = {
	"001_example",
}

local catalog = dofile(CORE_DIRECTORY .. "/lib/core/quests/catalog.lua")
local dirSep = package.config:sub(1, 1)
local catalogDirectory = table.concat({ DATA_DIRECTORY, "lib", "core", "quests", "catalog" }, dirSep)

return catalog.build(DATA_DIRECTORY .. ".lib.core.quests.catalog", questModules, catalogDirectory)
