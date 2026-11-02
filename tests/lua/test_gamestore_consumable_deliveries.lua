-- Run from the repository root: lua tests/lua/test_gamestore_consumable_deliveries.lua
package.path = "data/libs/?.lua;" .. package.path
GameStore = require("gamestore.constants")
package.loaded["gamestore.senders"] = {}
local purchases = require("gamestore.purchases")

local file = assert(io.open("data/items/items.xml", "r"))
local xml = file:read("*a")
file:close()
local definitions = {}
for attributes, body in xml:gmatch('<item%s+([^>]-")%s*>(.-)</item>') do
	local id = tonumber((" " .. attributes):match('%sid="(%d+)"'))
	if id then
		definitions[id] = {
			name = attributes:match('name="([^"]+)"'),
			charges = tonumber(body:match('<attribute key="charges" value="(%d+)"')) or 0,
		}
	end
end

-- Controlled engine interfaces; load the real player inbox helpers and purchase function.
Player = {}
function Condition()
	return {}
end
configManager = {
	getBoolean = function()
		return false
	end,
}
configKeys = {}
SERVER_NAME = "Test"
logger = { error = function() end }
ITEM_ATTRIBUTE_CHARGES, ITEM_ATTRIBUTE_STORE = "charges", "store"
function systemTime()
	return 1
end
function BatchUpdate()
	return { add = function() end, delete = function() end }
end
function ItemType(id)
	local definition = assert(definitions[id], "item missing from XML")
	return {
		isStackable = function()
			return false
		end,
		getCharges = function()
			return definition.charges
		end,
	}
end
Game = {}
function Game.createItem(id, count)
	assert(count == 1, "charged purchase created multiple items")
	local item = { id = id, attributes = {} }
	function item:setAttribute(key, value)
		self.attributes[key] = value
	end
	function item:setOwner(owner)
		self.owner = owner
	end
	return item
end
dofile("data/libs/functions/player.lua")

local targets = {
	["Exercise Wraps"] = "exercise wraps",
	["Durable Exercise Wraps"] = "durable exercise wraps",
	["Ultimate Health Keg"] = "ultimate health keg",
	["Ultimate Mana Keg"] = "ultimate mana keg",
}
local failures, checked = {}, 0
for _, path in ipairs({ "consumables_exercise_weapons", "consumables_kegs" }) do
	local category = dofile("data/modules/scripts/gamestore/catalog/" .. path .. ".lua")
	for _, offer in ipairs(category.offers) do
		local expectedName = targets[offer.name]
		if expectedName then
			local ok, reason = pcall(function()
				local received = {}
				local inbox = {
					addItemEx = function(_, item)
						table.insert(received, item)
					end,
				}
				local player = setmetatable({
					canReceiveStoreItems = function()
						return true
					end,
					getStoreInbox = function()
						return inbox
					end,
					sendTextMessage = function() end,
				}, { __index = Player })
				purchases.processChargesPurchase(player, offer.itemtype, offer.name, offer.charges, offer.movable, offer.setOwner)
				assert(#received == 1, "charged offer delivered no item")
				local definition = assert(definitions[received[1].id])
				assert(definition.name == expectedName, "offer delivered a different item")
				assert(received[1].attributes.charges == definition.charges, "incorrect charge count")
			end)
			if not ok then
				table.insert(failures, offer.name .. ": " .. tostring(reason))
			end
			checked = checked + 1
		end
	end
end
assert(checked == 4, "missing corrected offers or unchanged controls")
assert(#failures == 0, table.concat(failures, "\n"))
print("consumable delivery regressions passed")
