local gamestoreLibPath = CORE_DIRECTORY .. "/libs/gamestore"

local function moduleLoader(name)
	return dofile(gamestoreLibPath .. "/" .. name .. ".lua")
end

local modulesToPreload = {
	["gamestore.constants"] = function()
		return moduleLoader("constants")
	end,
	["gamestore.helpers"] = function()
		return moduleLoader("helpers")
	end,
	["gamestore.store"] = function()
		return moduleLoader("store")
	end,
	["gamestore.senders"] = function()
		return moduleLoader("senders")
	end,
	["gamestore.purchases"] = function()
		return moduleLoader("purchases")
	end,
	["gamestore.parsers"] = function()
		return moduleLoader("parsers")
	end,
	["gamestore.player"] = function()
		return moduleLoader("player")
	end,
}

for name, loader in pairs(modulesToPreload) do
	if not package.preload[name] then
		package.preload[name] = loader
	end
end

local constants = package.loaded["gamestore.constants"] or moduleLoader("constants")
package.loaded["gamestore.constants"] = constants

local helpers = package.loaded["gamestore.helpers"] or moduleLoader("helpers")
package.loaded["gamestore.helpers"] = helpers

GameStore = GameStore or {}
for key, value in pairs(constants) do
	GameStore[key] = value
end

local convertType = helpers.convertType
local useOfferConfigure = helpers.useOfferConfigure

_G.convertType = convertType
_G.useOfferConfigure = useOfferConfigure

GameStore.convertType = convertType
GameStore.useOfferConfigure = useOfferConfigure

local storeLib = require("gamestore.store")
for key, value in pairs(storeLib) do
	GameStore[key] = value
end

local senders = require("gamestore.senders")
local purchases = require("gamestore.purchases")
for key, value in pairs(purchases) do
	GameStore[key] = value
end

local parsers = require("gamestore.parsers")
GameStore.isItsPacket = parsers.isItsPacket
GameStore.fuzzySearchOffer = parsers.fuzzySearchOffer

local playerLib = require("gamestore.player")
for key, value in pairs(playerLib) do
	Player[key] = value
end

-- Expose senders and parsers functions for compatibility
openStore = senders.openStore
sendOfferDescription = senders.sendOfferDescription
sendShowStoreOffers = senders.sendShowStoreOffers
sendShowStoreOffersOnOldProtocol = senders.sendShowStoreOffersOnOldProtocol
sendStoreTransactionHistory = senders.sendStoreTransactionHistory
sendStorePurchaseSuccessful = senders.sendStorePurchaseSuccessful
sendStoreError = senders.sendStoreError
sendStoreBalanceUpdating = senders.sendStoreBalanceUpdating
sendUpdatedStoreBalances = senders.sendUpdatedStoreBalances
sendRequestPurchaseData = senders.sendRequestPurchaseData
sendHomePage = senders.sendHomePage

parseTransferableCoins = parsers.parseTransferableCoins
parseOpenStore = parsers.parseOpenStore
parseRequestStoreOffers = parsers.parseRequestStoreOffers
parseBuyStoreOffer = parsers.parseBuyStoreOffer
parseOpenTransactionHistory = parsers.parseOpenTransactionHistory
parseRequestTransactionHistory = parsers.parseRequestTransactionHistory

function onRecvbyte(player, msg, byte)
	return parsers.onRecvbyte(player, msg, byte)
end
