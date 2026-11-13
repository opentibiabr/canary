package.path = "data/libs/?.lua;" .. package.path
CORE_DIRECTORY = "data"
GameStore = require("gamestore.constants")
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
require("gamestore.helpers")
for key, value in pairs(require("gamestore.store")) do
	GameStore[key] = value
end
local categories = dofile("data/modules/scripts/gamestore/catalog/init.lua")
local loader = dofile("data/modules/scripts/gamestore/catalog_loader.lua")
for _, category in ipairs(categories) do
	loader.registerCategory(category, "house audit")
end
local beds, upgrades, counts, newOffers = {}, 0, {}, 0
for _, category in ipairs(categories) do
	for _, offer in ipairs(category.offers or {}) do
		if category.name == "Beds" then
			beds[#beds + 1] = offer
		end
		if category.name == "Upgrades" then
			upgrades = upgrades + 1
		end
		counts[offer.name] = (counts[offer.name] or 0) + 1
		if offer.id and type(offer.id) == "number" and offer.id >= 78000 and offer.id < 79000 then
			newOffers = newOffers + 1
		end
	end
end
assert(#beds == 25, "25 beds must be available in the 15.25 catalog")
assert(upgrades == 9, "all nine functional house upgrades must remain available")
assert(newOffers == 179, "missing house additions")
for _, name in ipairs({ "Exercise Wraps", "Durable Exercise Wraps", "Lasting Exercise Wraps" }) do
	assert(counts[name] == 1, "duplicate wraps offer: " .. name)
end
local file = assert(io.open("data/items/items.xml", "r"))
local xml = file:read("*a")
file:close()
local items = {}
for header, body in xml:gmatch("<item%s+([^>]+)>(.-)</item>") do
	local id = tonumber((" " .. header):match('%sid="(%d+)"'))
	if id then
		local attrs = {}
		for key, value in body:gmatch('<attribute key="([^"]+)" value="([^"]+)"') do
			attrs[key:lower()] = tonumber(value) or value
		end
		items[id] = attrs
	end
end
for _, bed in ipairs(beds) do
	if bed.id then
		local first = bed.itemtype[1]
		assert(bed.itemtype[2] == first + 1)
		for direction = 0, 3 do
			local freeId = first + direction
			local free = assert(items[freeId])
			assert(free.type == "bed" and free.wrapableto == 23398)
			local partner = assert(items[free.bedpartof])
			assert(partner.bedpartof == freeId and partner.bedpart ~= free.bedpart)
			assert(items[free.rotateto].rotateto == freeId)
			for _, sex in ipairs({ "maletransformto", "femaletransformto" }) do
				local occupied = assert(items[free[sex]])
				assert(occupied.type == "bed" and occupied.bedpart == free.bedpart)
				-- Native ItemParse::parseBed assigns the reverse free state from these references.
				assert(occupied.maletransformto == nil and occupied.femaletransformto == nil)
				assert(items[occupied.bedpartof].bedpartof == free[sex])
			end
		end
	end
end
print("PASS: 25 beds, 9 upgrades, 179 additions, bed partner/sleep/wake/rotation mappings and unique wraps")

local registered = {}
function Action()
	return {
		id = function(_, id)
			assert(not registered[id])
			registered[id] = true
		end,
		register = function(self)
			registered.action = self
		end,
	}
end
dofile("data/scripts/actions/items/store_house_lights.lua")
local lamp = {
	id = 44087,
	getId = function(self)
		return self.id
	end,
	transform = function(self, id)
		self.id = id
	end,
}
assert(registered.action.onUse(nil, lamp) and lamp.id == 44088)
assert(registered.action.onUse(nil, lamp) and lamp.id == 44087)
print("PASS: house lights toggle through native states without changing orientation")
