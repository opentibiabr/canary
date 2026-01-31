local questModules = {
	"001_example",
}

local catalog = dofile(CORE_DIRECTORY .. "/lib/core/quests/catalog.lua")

return catalog.build(DATA_DIRECTORY .. ".lib.core.quests.catalog", questModules)
