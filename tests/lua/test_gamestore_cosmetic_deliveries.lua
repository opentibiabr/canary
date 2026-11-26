-- Run from the repository root: lua tests/lua/test_gamestore_cosmetic_deliveries.lua
package.path = "data/libs/?.lua;" .. package.path
GameStore = require("gamestore.constants")
package.loaded["gamestore.senders"] = {}
local purchases = require("gamestore.purchases")

local function readFile(path)
	local file = assert(io.open(path, "r"))
	local content = file:read("*a")
	file:close()
	return content
end

local mountIds = {}
for attributes in readFile("data/XML/mounts.xml"):gmatch("<mount%s+([^>]+)>") do
	local name = attributes:match('name="([^"]+)"')
	mountIds[name] = tonumber(attributes:match('id="(%d+)"'))
end

local mounts = dofile("data/modules/scripts/gamestore/catalog/cosmetics_mounts.lua")
local correctedMounts = {
	["Battle Badger"] = true,
	["Ether Badger"] = true,
	["Zaoan Badger"] = true,
	["Floating Sage"] = true,
	["Floating Scholar"] = true,
	["Floating Augur"] = true,
}

local checked = 0
for _, offer in ipairs(mounts.offers) do
	if correctedMounts[offer.name] then
		local expectedId = assert(mountIds[offer.name], "missing mount registration: " .. offer.name)
		assert(offer.id == expectedId, offer.name .. " delivers a different registered mount")
		local grantedId
		local player = {
			hasMount = function(_, id)
				return grantedId == id
			end,
			addMount = function(_, id)
				grantedId = id
			end,
		}
		purchases.processMountPurchase(player, offer.id)
		assert(grantedId == expectedId)
		assert(not pcall(purchases.processMountPurchase, player, offer.id), "duplicate mount purchase accepted")
		checked = checked + 1
	end
end
assert(checked == 6, "missing corrected mount offers")

local outfitIds = {}
for attributes in readFile("data/XML/outfits.xml"):gmatch("<outfit%s+([^>]+)>") do
	if attributes:match('name="([^"]+)"') == "Trophy Hunter" then
		outfitIds[tonumber(attributes:match('type="(%d+)"'))] = tonumber(attributes:match('looktype="(%d+)"'))
	end
end

PLAYERSEX_FEMALE, PLAYERSEX_MALE = 0, 1
local outfits = dofile("data/modules/scripts/gamestore/catalog/cosmetics_outfits.lua")
local checkedOutfits = 0
for _, offer in ipairs(outfits.offers) do
	if offer.name == "Full Trophy Hunter Outfit" then
		assert(offer.sexId.female == outfitIds[PLAYERSEX_FEMALE], "wrong female Trophy Hunter")
		assert(offer.sexId.male == outfitIds[PLAYERSEX_MALE], "wrong male Trophy Hunter")
		for _, sex in ipairs({ PLAYERSEX_FEMALE, PLAYERSEX_MALE }) do
			local granted = {}
			local player = {
				getSex = function()
					return sex
				end,
				hasOutfit = function(_, looktype, addon)
					return granted[looktype] == addon
				end,
				addOutfitAddon = function(_, looktype, addon)
					granted[looktype] = addon
					return true
				end,
			}
			purchases.processOutfitPurchase(player, offer.sexId, offer.addon)
			assert(granted[outfitIds[PLAYERSEX_FEMALE]] == 3)
			assert(granted[outfitIds[PLAYERSEX_MALE]] == 3)
		end
		checkedOutfits = checkedOutfits + 1
	end
end
assert(checkedOutfits == 1, "missing full Trophy Hunter offer")
print("cosmetic delivery regressions passed")
