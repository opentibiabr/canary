local modules = {
	"premium_time",
	"consumables",
	"consumables_blessings",
	"consumables_casks",
	"consumables_exercise_weapons",
	"consumables_kegs",
	"consumables_potions",
	"consumables_runes",
	"cosmetics",
	"cosmetics_mounts",
	"cosmetics_outfits",
	"house",
	"house_decorations",
	"house_furniture",
	"beds",
	"house_upgrades",
	"house_hirelings",
	"house_hireling_dresses",
	"boost",
	"extras",
	"extras_extras_services",
	"extras_usefull_things",
	"tournament",
	"tournament_tickets",
	"tournament_exclusive_offers",
}

local basePath = CORE_DIRECTORY .. "/modules/scripts/gamestore/catalog/"
local inlineCategories = dofile(basePath .. "parent_categories.lua")
local catalog = {}

for _, moduleName in ipairs(modules) do
	local category = inlineCategories[moduleName]
	if not category then
		category = dofile(basePath .. moduleName .. ".lua")
	end
	if category.offers ~= nil and type(category.offers) ~= "table" then
		error(string.format("Invalid offers table in Game Store category module: %s", moduleName))
	end
	if category.subclasses ~= nil and type(category.subclasses) ~= "table" then
		error(string.format("Invalid subclasses table in Game Store category module: %s", moduleName))
	end
	if not category.name or category.rookgaard == nil or (category.offers == nil and category.subclasses == nil) then
		error(string.format("Invalid Game Store category module: %s", moduleName))
	end
	table.insert(catalog, category)
end

return catalog
