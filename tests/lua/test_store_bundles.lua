-- The fixture supplies a real Store parser and protocol stubs.
dofile("tests/lua/fixtures/store_purchase.lua")
local bundles = require("gamestore.bundles")
local parser = require("gamestore.parsers")
local canBuyOffer = require("gamestore.player").canBuyOffer
local catalog = dofile("data/modules/scripts/gamestore/catalog/bundles.lua")
local player = Player(10)
PLAYERSEX_MALE, PLAYERSEX_FEMALE = 1, 0
ITEM_DECORATION_KIT = 23398
ITEM_ATTRIBUTE_DESCRIPTION, ITEM_ATTRIBUTE_STORE = 1, 2
function systemTime()
	return os.time()
end
local items, outfits, mounts, stored, missing = {}, {}, {}, {}, nil
local noSpace, failAt, failPayment = false, nil, false
local sex = 1
local inbox = {}
local calls = 0
function inbox:addItem(id, count)
	calls = calls + 1
	if calls == failAt then
		return nil
	end
	local kit = { id = id, count = count }
	function kit:setAttribute(key, value)
		self[key] = value
	end
	function kit:setCustomAttribute(key, value)
		self[key] = value
	end
	function kit:setOwner(owner)
		self.owner = owner:getGuid()
	end
	function kit:remove()
		self.removed = true
	end
	items[#items + 1] = kit
	return kit
end
function ItemType(id)
	return {
		getId = function()
			return id == missing and 0 or id
		end,
		getName = function()
			return "decoration " .. id
		end,
	}
end
function Mount(id)
	return id ~= missing and {} or nil
end
function player:getSex()
	return sex
end
function player:hasOutfit(id, addon)
	return outfits[id] == 3
end
function player:hasMount(id)
	return mounts[id] == true
end
function player:addOutfitAddon(id, addon)
	outfits[id] = addon
	return true
end
function player:addMount(id)
	mounts[id] = true
	return true
end
function player:canReceiveStoreItems(id, count)
	assert(id == ITEM_DECORATION_KIT and (count == 1 or count == 2))
	return not noSpace, "No room for the complete bundle"
end
function player:getStoreInbox()
	return inbox
end
function player:kv()
	return {
		scoped = function(self, scope)
			return self
		end,
		get = function(self, key)
			return stored[key]
		end,
		set = function(self, key, value)
			stored[key] = value
		end,
	}
end
function player:makeCoinTransaction(offer)
	if failPayment then
		return false
	end
	self.coins = self.coins - offer.price
	self.charges = self.charges + 1
	return true
end
local function reset()
	items, outfits, mounts, stored = {}, {}, {}, {}
	noSpace, failAt, failPayment, missing, calls = false, nil, false, nil, 0
	player.coins, player.charges = 10000, 0
end
GameStore.getOfferById = function(id)
	for _, offer in ipairs(catalog.offers) do
		if offer.id == id then
			return offer
		end
	end
end
local function buy(offer)
	stored[GameStore.Kv.purchaseCooldown] = nil
	local msg = {
		getU32 = function()
			return offer.id
		end,
		getByte = function()
			return 0
		end,
	}
	return parser.parseBuyStoreOffer(player:getId(), msg)
end
assert(#catalog.offers == 6 and catalog.name == "Bundles")
for _, offer in ipairs(catalog.offers) do
	for _, characterSex in ipairs({ 0, 1 }) do
		reset()
		sex = characterSex
		assert(offer.price == 1500)
		assert(not bundles.unavailableReason(player, offer))
		assert(canBuyOffer(player, offer).disabled == 0)
		buy(offer)
		assert(player.coins == 8500 and player.charges == 1, "bundle must charge exactly once through real parser")
		assert(outfits[offer.sexId.male] == 3 and outfits[offer.sexId.female] == 3 and mounts[offer.mountId])
		assert(#items == #offer.decorations)
		for index, kit in ipairs(items) do
			assert(kit.unWrapId == offer.decorations[index] and kit.owner == player:getGuid() and not kit.removed)
		end
		buy(offer)
		assert(player.charges == 1 and #items == #offer.decorations, "duplicate bundle purchase granted or charged")
		assert(canBuyOffer(player, offer).disabled == 1)
	end
end
local offer = catalog.offers[2]
reset()
noSpace = true
assert(canBuyOffer(player, offer).disabled == 1)
buy(offer)
assert(#items == 0 and player.charges == 0 and not next(outfits))
reset()
failAt = 2
buy(offer)
assert(#items == 1 and items[1].removed and player.charges == 0 and not next(outfits))
reset()
failPayment = true
buy(offer)
assert(#items == 2 and items[1].removed and items[2].removed and player.coins == 10000 and not next(outfits))
reset()
player.coins = 1499
buy(offer)
assert(#items == 0 and player.charges == 0)
reset()
missing = offer.mountId
assert(bundles.unavailableReason(player, offer))
buy(offer)
assert(#items == 0 and player.charges == 0)
reset()
missing = offer.decorations[2]
buy(offer)
assert(#items == 0 and player.charges == 0)
reset()
outfits[offer.sexId.male] = 3
buy(offer)
assert(player.charges == 1 and outfits[offer.sexId.male] == 3 and mounts[offer.mountId], "partial ownership must preserve unlocks")
print("PASS: six bundles, both sexes, exact single debit, owner-bound kits, duplicate rejection, full inbox, failed second kit/payment, insufficient funds and missing components")

-- Load the real action and exercise every registered cosmetic state transition.
local registered, action = {}, nil
function Action()
	action = {
		id = function(self, id)
			assert(not registered[id])
			registered[id] = true
		end,
		register = function() end,
	}
	return action
end
dofile("data/scripts/actions/items/store_bundle_decorations.lua")
local transitions = 0
for id in pairs(registered) do
	local resultId
	local item = {
		getId = function()
			return id
		end,
		transform = function(self, target)
			resultId = target
		end,
	}
	assert(action.onUse(player, item) and registered[resultId])
	transitions = transitions + 1
end
assert(transitions == 19)
print("PASS: all 19 decoration use states remain within their registered cycles")
