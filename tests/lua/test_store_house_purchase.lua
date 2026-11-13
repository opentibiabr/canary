-- Reuse the native purchase parser fixture and exercise real house delivery/payment paths.
dofile("tests/lua/fixtures/store_purchase.lua")
local player = Player(10)
local parser = require("gamestore.parsers")
local purchases = require("gamestore.purchases")
ITEM_DECORATION_KIT = 23398
ITEM_HEALTH_CASK_START, ITEM_HEALTH_CASK_END = 25879, 25883
ITEM_MANA_CASK_START, ITEM_MANA_CASK_END = 25889, 25893
ITEM_SPIRIT_CASK_START, ITEM_SPIRIT_CASK_END = 25899, 25902
ITEM_ATTRIBUTE_DESCRIPTION, ITEM_ATTRIBUTE_STORE = "description", "store"
function systemTime()
	return 1
end
function BatchUpdate()
	return { add = function() end, delete = function() end }
end
function ItemType()
	return {
		getName = function()
			return "cyclops steel bed"
		end,
	}
end
local offer = dofile("data/modules/scripts/gamestore/catalog/house_additions_1525.lua").Beds[11]
GameStore.getOfferById = function()
	return offer
end
GameStore.processHouseRelatedPurchase = purchases.processHouseRelatedPurchase
local kits, failAt, full, failPayment = {}, nil, false, false
local inbox = {}
function inbox:addItem(id, count)
	assert(id == ITEM_DECORATION_KIT and count == 1)
	if failAt == #kits + 1 then
		return nil
	end
	local kit = { attributes = {}, custom = {} }
	function kit:setAttribute(key, value)
		self.attributes[key] = value
	end
	function kit:setCustomAttribute(key, value)
		self.custom[key] = value
	end
	function kit:setOwner(owner)
		self.owner = owner
	end
	function kit:remove()
		self.removed = true
	end
	kits[#kits + 1] = kit
	return kit
end
function player:getStoreInbox()
	return inbox
end
function player:canReceiveStoreItems(id, count)
	assert(id == ITEM_DECORATION_KIT and count == #offer.itemtype, "all decoration-kit slots must be checked")
	return not full, "Inbox full"
end
function player:makeCoinTransaction(o)
	if failPayment then
		return false
	end
	self.coins = self.coins - o.price
	self.charges = self.charges + 1
	return true
end
function player:showInfoModal() end
local summaries = {}
function player:createTransactionSummary(kind, count, id)
	assert(type(id) == "number" and self.charges == 1, "summary must follow a committed charge")
	summaries[#summaries + 1] = id
end
local tick = os.time()
os.time = function()
	tick = tick + 10
	return tick
end
local function buy()
	local msg = {
		getU32 = function()
			return offer.id
		end,
		getByte = function()
			return 0
		end,
	}
	return parser.parseBuyStoreOffer(player.id, msg)
end
player.coins, player.charges = 1000, 0
full = true
buy()
assert(#kits == 0 and player.coins == 1000)
full = false
failAt = 2
buy()
assert(#kits == 1 and kits[1].removed and player.coins == 1000)
kits = {}
failAt = nil
failPayment = true
buy()
assert(#kits == 2 and kits[1].removed and kits[2].removed and player.coins == 1000)
kits = {}
failPayment = false
buy()
assert(#kits == 2 and not kits[1].removed and player.coins == 850 and player.charges == 1)
for index, kit in ipairs(kits) do
	assert(kit.owner == player and kit.custom.unWrapId == offer.itemtype[index] and kit.attributes.store == 1)
end
print("PASS: real parser rejects full inbox, rolls back partial delivery/payment failure, delivers both owner-bound halves and charges once")

local additions = dofile("data/modules/scripts/gamestore/catalog/house_additions_1525.lua")
for _, entry in ipairs(additions.Furniture) do
	if entry.name == "Sighting Furniture" then
		offer = entry
	end
end
assert(#offer.itemtype == 4)
kits = {}
player.coins = 1000
player.charges = 0
buy()
assert(#kits == 4 and player.coins == 700 and player.charges == 1)
for index, kit in ipairs(kits) do
	assert(kit.custom.unWrapId == offer.itemtype[index] and kit.owner == player)
end
print("PASS: four-part furniture set delivers every listed component and charges once")

assert(#summaries == 4)
