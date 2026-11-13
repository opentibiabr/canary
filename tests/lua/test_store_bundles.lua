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
local accessGroup = false
local failUnlock, unlockFailure, failMount = nil, nil, false
local outfitSex = {}
for _, entry in ipairs(catalog.offers) do
	outfitSex[entry.sexId.male] = 1
	outfitSex[entry.sexId.female] = 0
end
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
function player:hasOutfit(id, addon, ownedOnly)
	if accessGroup and not ownedOnly then
		return true
	end
	if not ownedOnly and outfitSex[id] ~= sex then
		return false
	end
	return outfits[id] ~= nil and bit.band(outfits[id], addon or 0) == (addon or 0)
end
function player:hasMount(id, ownedOnly)
	if accessGroup and not ownedOnly then
		return true
	end
	return mounts[id] == true
end
function player:addOutfitAddon(id, addon)
	if id == failUnlock and unlockFailure ~= "after" then
		return unlockFailure == "silent"
	end
	outfits[id] = bit.bor(outfits[id] or 0, addon)
	return id ~= failUnlock
end
function player:addMount(id)
	if failMount then
		return false
	end
	mounts[id] = true
	return true
end
function player:removeOutfit(id)
	outfits[id] = nil
	return true
end
function player:removeOutfitAddon(id, addons)
	if outfits[id] == nil then
		return false
	end
	outfits[id] = bit.band(outfits[id], bit.bnot(addons))
	return true
end
function player:removeMount(id)
	mounts[id] = nil
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
	failUnlock, unlockFailure, failMount = nil, nil, false
	accessGroup = false
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
-- Access-based wearability must not masquerade as purchased outfit ownership.
reset()
accessGroup = true
mounts[offer.mountId] = true
assert(player:hasOutfit(offer.sexId.male, 3))
assert(not bundles.unavailableReason(player, offer), "access-group buyer does not own this outfit")
buy(offer)
assert(player.charges == 1 and outfits[offer.sexId.male] == 3 and outfits[offer.sexId.female] == 3)
assert(bundles.unavailableReason(player, offer), "an actual completed purchase must still be rejected")
reset()
accessGroup = true
outfits[offer.sexId.male] = 3
outfits[offer.sexId.female] = 3
mounts[offer.mountId] = true
assert(bundles.unavailableReason(player, offer), "raw duplicate ownership remains blocked")
buy(offer)
assert(player.charges == 0 and #items == 0)
-- Mount access is also not raw ownership: no free mount may survive a failure.
reset()
accessGroup = true
outfits[offer.sexId.male] = 3
outfits[offer.sexId.female] = 3
assert(player:hasMount(offer.mountId) and not player:hasMount(offer.mountId, true))
assert(not bundles.unavailableReason(player, offer))
failPayment = true
buy(offer)
assert(player.charges == 0 and not mounts[offer.mountId] and outfits[offer.sexId.male] == 3)
failPayment = false
buy(offer)
assert(player.charges == 1 and mounts[offer.mountId] and bundles.unavailableReason(player, offer))
-- Every unlock failure must precede payment and preserve both sexes' exact masks.
for _, failingLook in ipairs({ offer.sexId.male, offer.sexId.female }) do
	for _, mode in ipairs({ "before", "after", "silent" }) do
		reset()
		outfits[offer.sexId.male] = 1
		outfits[offer.sexId.female] = 2
		failUnlock, unlockFailure = failingLook, mode
		buy(offer)
		assert(player.coins == 10000 and player.charges == 0)
		assert(outfits[offer.sexId.male] == 1 and outfits[offer.sexId.female] == 2 and not mounts[offer.mountId])
		assert(not stored[tostring(offer.id)])
		for _, kit in ipairs(items) do
			assert(kit.removed)
		end
	end
end
reset()
outfits[offer.sexId.male] = 0
failMount = true
buy(offer)
assert(player.charges == 0 and outfits[offer.sexId.male] == 0 and outfits[offer.sexId.female] == nil)
reset()
outfits[offer.sexId.male] = 1
outfits[offer.sexId.female] = 2
mounts[offer.mountId] = true
failPayment = true
buy(offer)
assert(outfits[offer.sexId.male] == 1 and outfits[offer.sexId.female] == 2 and mounts[offer.mountId])
assert(player.charges == 0 and not stored[tostring(offer.id)])
failPayment = false
buy(offer)
assert(player.charges == 1 and stored[tostring(offer.id)])
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
