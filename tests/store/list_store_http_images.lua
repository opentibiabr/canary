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
local seen, names, sources = {}, {}, {}
local function add(size, filename, kind, id)
	local path = size .. "/" .. filename
	if not seen[path] then
		assert(not filename:find("..", 1, true) and not filename:find("[/\\%c]") and filename:match("%.png$"))
		seen[path] = true
		names[#names + 1] = path
		sources[path] = { kind or 0, id or 0 }
	end
end
for _, category in ipairs(catalog) do
	for _, icon in ipairs(category.icons) do
		add("13", icon)
	end
	for _, offer in ipairs(category.offers or {}) do
		-- Legacy clients request HTTP icons even for modern native appearances.
		if offer.type == GameStore.OfferTypes.OFFER_TYPE_MOUNT then
			add("64", offer.name:gsub(" ", "_") .. ".png", 3, offer.id)
		else
			for index, icon in ipairs(offer.icons or {}) do
				local itemId = type(offer.itemtype) == "table" and offer.itemtype[1] or offer.itemtype
				local look = offer.sexId and (index == 2 and offer.sexId.female or offer.sexId.male)
				add("64", icon, itemId and 1 or (look and 2 or 0), itemId or look)
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

local metadata = os.getenv("CANARY_STORE_IMAGE_SOURCES")
if metadata then
	local file = assert(io.open(metadata, "w"))
	for _, name in ipairs(names) do
		file:write(name, "\t", sources[name][1], "\t", sources[name][2], "\n")
	end
	file:close()
end
