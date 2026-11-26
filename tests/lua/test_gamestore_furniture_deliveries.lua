-- Run from the repository root: lua tests/lua/test_gamestore_furniture_deliveries.lua
package.path = "data/libs/?.lua;" .. package.path
GameStore = require("gamestore.constants")
package.loaded["gamestore.senders"] = {}
local purchases = require("gamestore.purchases")

local file = assert(io.open("data/items/items.xml", "r"))
local xml = file:read("*a")
file:close()
local itemNames = {}
for attributes in xml:gmatch("<item%s+([^>]+)>") do
	local name = attributes:match('name="([^"]+)"')
	local first = tonumber((" " .. attributes):match('%sid="(%d+)"'))
	if first then
		itemNames[first] = name
	else
		first = tonumber(attributes:match('fromid="(%d+)"'))
		local last = tonumber(attributes:match('toid="(%d+)"'))
		if first and last then
			for id = first, last do
				itemNames[id] = name
			end
		end
	end
end

-- Controlled engine interfaces; catalogs, XML definitions and purchase logic are real.
ITEM_HEALTH_CASK_START, ITEM_HEALTH_CASK_END = 25879, 25883
ITEM_MANA_CASK_START, ITEM_MANA_CASK_END = 25889, 25893
ITEM_SPIRIT_CASK_START, ITEM_SPIRIT_CASK_END = 25899, 25902
ITEM_DECORATION_KIT = 23398
ITEM_ATTRIBUTE_DESCRIPTION, ITEM_ATTRIBUTE_STORE = "description", "store"
function systemTime()
	return 1
end
function BatchUpdate()
	return { add = function() end, delete = function() end }
end
function ItemType(id)
	return {
		getName = function()
			return assert(itemNames[id], "item missing from XML")
		end,
	}
end

local expectedNames = {
	["Colourful Carpet"] = "rolled-up colourful carpet",
	["Flowery Carpet"] = "rolled-up flowery carpet",
	["Oven"] = "oven",
	["Volcanic Spire"] = "volcanic spire",
	["Heart Table"] = "heart table",
}
local checked = 0
for _, path in ipairs({ "house_decorations", "house_furniture" }) do
	local category = dofile("data/modules/scripts/gamestore/catalog/" .. path .. ".lua")
	for _, offer in ipairs(category.offers) do
		local expectedName = expectedNames[offer.name]
		if expectedName then
			assert(itemNames[offer.itemtype] == expectedName, offer.name .. " delivers a different item")
			local kits = {}
			local inbox = {
				addItem = function(_, id, count)
					assert(id == ITEM_DECORATION_KIT and count == 1)
					local kit = { attributes = {}, custom = {} }
					function kit:setAttribute(key, value)
						self.attributes[key] = value
					end
					function kit:setCustomAttribute(key, value)
						self.custom[key] = value
					end
					table.insert(kits, kit)
					return kit
				end,
			}
			local player = {
				canReceiveStoreItems = function()
					return true
				end,
				getStoreInbox = function()
					return inbox
				end,
			}
			purchases.processHouseRelatedPurchase(player, offer)
			assert(#kits == offer.count, "incorrect number of decoration kits")
			for _, kit in ipairs(kits) do
				assert(itemNames[kit.custom.unWrapId] == expectedName, "kit unwraps into a different item")
				assert(kit.attributes.description:find("<" .. expectedName .. ">", 1, true))
			end
			checked = checked + 1
		end
	end
end
assert(checked == 7, "missing affected single or bundle offers")
print("furniture delivery regressions passed")
