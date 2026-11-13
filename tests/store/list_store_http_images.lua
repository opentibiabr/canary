-- Read-only inventory of HTTP icons actually used by the production catalog.
package.path = "data/libs/?.lua;" .. package.path
CORE_DIRECTORY = "data"
GameStore = require("gamestore.constants")
local helpers = require("gamestore.helpers")
configKeys = setmetatable({}, {
	__index = function(_, name)
		return name
	end,
})
configManager = {
	getBoolean = function()
		return false
	end,
}
-- These IDs do not participate in image selection; no hireling system runs.
HIRELING_SKILLS = setmetatable({}, {
	__index = function()
		return { 0 }
	end,
})
HIRELING_OUTFITS = setmetatable({}, {
	__index = function()
		return { 0 }
	end,
})
local catalog = dofile("data/modules/scripts/gamestore/catalog/init.lua")
local seen, names = {}, {}
local function add(size, filename)
	local path = size .. "/" .. filename
	if not seen[path] then
		assert(not filename:find("..", 1, true) and filename:match("^[%w_%-%.]+%.png$"))
		seen[path] = true
		names[#names + 1] = path
	end
end
for _, category in ipairs(catalog) do
	for _, icon in ipairs(category.icons) do
		add("13", icon)
	end
	for _, offer in ipairs(category.offers or {}) do
		if helpers.convertType(offer.type) == GameStore.ConverType.SHOW_NONE then
			for _, icon in ipairs(offer.icons) do
				add("64", icon)
			end
		end
	end
end
table.sort(names)
local output = assert(io.open(assert(os.getenv("CANARY_STORE_IMAGE_LIST")), "w"))
for _, name in ipairs(names) do
	output:write(name, "\n")
end
output:close()
print("PASS: inventoried " .. #names .. " HTTP images from the real category/offer catalog")
