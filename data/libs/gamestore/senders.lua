local helpers = require("gamestore.helpers")
local senders = {}

local convertType = helpers.convertType
local useOfferConfigure = helpers.useOfferConfigure

local function getCategoriesRook()
	local tmpTable, count = {}, 0
	for i, v in pairs(GameStore.Categories) do
		if v.rookgaard then
			tmpTable[#tmpTable + 1] = v
			count = count + 1
		end
	end

	return tmpTable, count
end

--==Sending==--
local function openStore(playerId)
	local player = Player(playerId)
	if not player then
		return false
	end

	if not GameStore.Categories then
		return false
	end

	local oldProtocol = player:getClient().version < 1200
	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_OpenStore)
	if oldProtocol then
		msg:addByte(0x00)
	end

	local GameStoreCount
	local GameStoreCategories
	if player:getVocation():getId() == 0 then
		GameStoreCategories, GameStoreCount = getCategoriesRook()
	else
		GameStoreCategories, GameStoreCount = GameStore.Categories, #GameStore.Categories
	end
	local addCategory = function(category)
		msg:addString(category.name, "openStore - category.name")
		if oldProtocol then
			msg:addString(category.description, "openStore - category.description")
		end

		msg:addByte(category.state or GameStore.States.STATE_NONE)
		local size = #category.icons > 255 and 255 or #category.icons
		msg:addByte(size)
		for _, icon in ipairs(category.icons) do
			if size > 0 then
				msg:addString(icon, "openStore - icon")
				size = size - 1
			end
		end

		if category.parent then
			msg:addString(category.parent, "openStore - category.parent")
		else
			msg:addU16(0)
		end
	end

	if GameStoreCategories then
		msg:addU16(GameStoreCount)
		for _, category in ipairs(GameStoreCategories) do
			addCategory(category)
		end
		msg:sendToPlayer(player)
		sendStoreBalanceUpdating(playerId, true)
	end
end

local function sendOfferDescription(player, offerId, description)
	local msg = NetworkMessage()
	msg:addByte(0xEA)
	msg:addU32(offerId)
	msg:addString(description, "sendOfferDescription - description")
	msg:sendToPlayer(player)
end

local function sendShowStoreOffers(playerId, category, redirectId)
	local player = Player(playerId)
	if not player then
		return false
	end

	local oldProtocol = player:getClient().version < 1200

	local msg = NetworkMessage()
	local haveSaleOffer = 0
	msg:addByte(GameStore.SendingPackets.S_StoreOffers)
	msg:addString(category.name, "sendShowStoreOffers - category.name")

	local categoryLimit = 65535
	if oldProtocol then
		categoryLimit = 30
	elseif category.offers then
		categoryLimit = #category.offers > categoryLimit and categoryLimit or #category.offers
	else
		categoryLimit = 0
	end

	if not oldProtocol then
		msg:addU32(redirectId or 0)
		msg:addByte(0) -- Window Type
		msg:addByte(0) -- Collections Size
		msg:addU16(0) -- Collection Name
	end

	if not category.offers then
		msg:addU16(0) -- Disable reasons
		msg:addU16(0) -- Offers
		msg:sendToPlayer(player)
		return
	end

	local disableReasons = {}
	local offers = {}
	local count = 0
	for k, offer in ipairs(category.offers) do
		local name = offer.name or "Something Special"
		if not offers[name] then
			offers[name] = {}
			count = count + 1
			offers[name].offers = {}
			offers[name].state = offer.state
			offers[name].id = offer.id
			offers[name].type = offer.type
			offers[name].icons = offer.icons
			offers[name].basePrice = offer.basePrice
			offers[name].description = offer.description
			if offer.sexId then
				offers[name].sexId = offer.sexId
			end
			if offer.itemtype then
				offers[name].itemtype = offer.itemtype
			end
		end

		local canBuy = player:canBuyOffer(offer)
		if canBuy.disabled == 1 then
			for index, disableTable in ipairs(disableReasons) do
				if canBuy.disabledReason == disableTable.reason then
					offer.disabledReadonIndex = index
				end
			end

			if offer.disabledReadonIndex == nil then
				offer.disabledReadonIndex = #disableReasons
				table.insert(disableReasons, canBuy.disabledReason)
			end
		end

		table.insert(offers[name].offers, offer)
	end

	msg:addU16(#disableReasons)
	for _, reason in ipairs(disableReasons) do
		msg:addString(reason, "sendShowStoreOffers - reason")
	end

	if count > categoryLimit then
		count = categoryLimit
	end

	msg:addU16(count)
	for name, offer in pairs(offers) do
		if count > 0 then
			count = count - 1
			msg:addString(name, "sendShowStoreOffers - name")
			msg:addByte(#offer.offers)
			sendOfferDescription(player, offer.id and offer.id or 0xFFFF, offer.description)
			for _, off in ipairs(offer.offers) do
				xpBoostPrice = nil
				if offer.type == GameStore.OfferTypes.OFFER_TYPE_EXPBOOST then
					local playerKV = player:kv()
					local purchaseExpCount = playerKV:get(GameStore.Kv.expBoostCount) or 0
					xpBoostPrice = GameStore.ExpBoostValues[purchaseExpCount]
				end

				nameLockPrice = nil
				if offer.type == GameStore.OfferTypes.OFFER_TYPE_NAMECHANGE and player:kv():get("namelock") then
					nameLockPrice = 0
				end

				msg:addU32(off.id)
				msg:addU16(off.count or off.charges)
				msg:addU32(xpBoostPrice or nameLockPrice or off.price)
				msg:addByte(off.coinType or 0x00)

				msg:addByte((off.disabledReadonIndex ~= nil) and 1 or 0)
				if off.disabledReadonIndex ~= nil then
					msg:addByte(0x01)
					msg:addU16(off.disabledReadonIndex)
					off.disabledReadonIndex = nil -- Reseting the table to nil disable reason
				end

				if off.state then
					if off.state == GameStore.States.STATE_SALE then
						local daySub = off.validUntil - os.date("*t").day
						if daySub >= 0 then
							msg:addByte(off.state)
							msg:addU32(os.time() + daySub * 86400)
							msg:addU32(off.basePrice)
							haveSaleOffer = 1
						else
							msg:addByte(GameStore.States.STATE_NONE)
						end
					else
						msg:addByte(off.state)
					end
				else
					msg:addByte(GameStore.States.STATE_NONE)
				end
			end

			local tryOnType = 0
			local type = convertType(offer.type)

			msg:addByte(type)
			if type == GameStore.ConverType.SHOW_NONE then
				msg:addString(offer.icons[1], "sendShowStoreOffers - offer.icons[1]")
			elseif type == GameStore.ConverType.SHOW_MOUNT then
				local mount = Mount(offer.id)
				msg:addU16(mount:getClientId())

				tryOnType = 1
			elseif type == GameStore.ConverType.SHOW_ITEM then
				msg:addU16(offer.itemtype)
			elseif type == GameStore.ConverType.SHOW_OUTFIT then
				msg:addU16(player:getSex() == PLAYERSEX_FEMALE and offer.sexId.female or offer.sexId.male)
				local outfit = player:getOutfit()
				msg:addByte(outfit.lookHead)
				msg:addByte(outfit.lookBody)
				msg:addByte(outfit.lookLegs)
				msg:addByte(outfit.lookFeet)

				tryOnType = 1
			elseif type == GameStore.ConverType.SHOW_HIRELING then
				if player:getSex() == PLAYERSEX_MALE then
					msg:addByte(1)
				else
					msg:addByte(2)
				end
				msg:addU16(offer.sexId.male)
				msg:addU16(offer.sexId.female)
				local outfit = player:getOutfit()
				msg:addByte(outfit.lookHead)
				msg:addByte(outfit.lookBody)
				msg:addByte(outfit.lookLegs)
				msg:addByte(outfit.lookFeet)
			end

			msg:addByte(tryOnType) -- TryOn Type
			msg:addU16(0) -- Collection (to-do)
			msg:addU16(0) -- Popularity Score (to-do)
			msg:addU32(0) -- State New Until (timestamp)

			local configure = useOfferConfigure(offer.type)
			if configure == GameStore.ConfigureOffers.SHOW_CONFIGURE then
				msg:addByte(1)
			else
				msg:addByte(0)
			end

			msg:addU16(0) -- Products Capacity (unnused)
		end
	end

	if category.name == "Search" then
		msg:addByte(0) -- Too many search results
	end

	player:sendButtonIndication(haveSaleOffer, 1)
	msg:sendToPlayer(player)
	msg:delete()
end

local function sendShowStoreOffersOnOldProtocol(playerId, category)
	local player = Player(playerId)
	if not player then
		return false
	end

	local msg = NetworkMessage()
	local haveSaleOffer = 0
	msg:addByte(GameStore.SendingPackets.S_StoreOffers)
	msg:addString(category.name, "sendShowStoreOffersOnOldProtocol - category.name")

	if not category.offers then
		msg:addU16(0)
		msg:sendToPlayer(player)
		player:sendButtonIndication(haveSaleOffer, 1)
		return
	end

	local limit = 30
	local count = 0
	for _, offer in ipairs(category.offers) do
		if limit > 0 then
			-- Blocking offers that are not on coin currency. On old protocol we cannot change or validate any currency instead the default (Coin)
			if not offer.coinType or offer.coinType == GameStore.CoinType.Coin then
				count = count + 1
			end
			limit = limit - 1
		end
	end

	msg:addU16(count)
	for _, offer in ipairs(category.offers) do
		if count > 0 and offer.coinType == GameStore.CoinType.Coin then
			count = count - 1
			local name = ""
			if offer.type == GameStore.OfferTypes.OFFER_TYPE_ITEM and offer.count then
				name = offer.count .. "x "
			end

			if offer.type == GameStore.OfferTypes.OFFER_TYPE_STACKABLE and offer.count then
				name = offer.count .. "x "
			end

			name = name .. (offer.name or "Something Special")
			local newPrice = nil
			if offer.state == GameStore.States.STATE_SALE then
				local daySub = offer.validUntil - os.sdate("*t").day
				if daySub < 0 then
					newPrice = offer.basePrice
				end
			end

			local disabled, disabledReason = player:canBuyOffer(offer).disabled, player:canBuyOffer(offer).disabledReason
			local playerKV = player:kv()
			local purchaseExpCount = playerKV:get(GameStore.Kv.expBoostCount) or 0
			local offerPrice = offer.type == GameStore.OfferTypes.OFFER_TYPE_EXPBOOST and GameStore.ExpBoostValues[purchaseExpCount] or (newPrice or offer.price or 0xFFFF)
			msg:addU32(offer.id and offer.id or 0xFFFF)
			msg:addString(name, "sendShowStoreOffersOnOldProtocol - name")
			msg:addString(offer.description or GameStore.getDefaultDescription(offer.type, offer.count), "sendShowStoreOffersOnOldProtocol - offer.description or GameStore.getDefaultDescription(offer.type, offer.count)")
			msg:addU32(offerPrice)
			if offer.state then
				if offer.state == GameStore.States.STATE_SALE then
					local daySub = offer.validUntil - os.sdate("*t").day
					if daySub >= 0 then
						msg:addByte(offer.state)
						msg:addU32(os.stime() + daySub * 86400)
						msg:addU32(offer.basePrice)
						haveSaleOffer = 1
					else
						msg:addByte(GameStore.States.STATE_NONE)
					end
				else
					msg:addByte(offer.state)
				end
			else
				msg:addByte(GameStore.States.STATE_NONE)
			end

			msg:addByte(disabled)
			if disabled == 1 then
				msg:addString(disabledReason, "sendShowStoreOffersOnOldProtocol - disabledReason")
			end

			if offer.type == GameStore.OfferTypes.OFFER_TYPE_MOUNT then
				msg:addByte(1)
				msg:addString((offer.name):gsub("% ", "_") .. ".png", "sendShowStoreOffersOnOldProtocol - (offer.name).png")
			elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT then
				msg:addByte(2)
				msg:addString(offer.icons[1], "sendShowStoreOffersOnOldProtocol - offer.icons[1]")
				msg:addString(offer.icons[2], "sendShowStoreOffersOnOldProtocol - offer.icons[2]")
			else
				msg:addByte(#offer.icons)
				for k, icon in ipairs(offer.icons) do
					msg:addString(icon, "sendShowStoreOffersOnOldProtocol - icon")
				end
			end

			msg:addU16(0) -- Suboffers
		end
	end

	player:sendButtonIndication(haveSaleOffer, 1)
	msg:sendToPlayer(player)
end

local function sendStoreTransactionHistory(playerId, page, entriesPerPage)
	local player = Player(playerId)
	if not player then
		return false
	end

	local entries = GameStore.retrieveHistoryEntries(player:getAccountId(), page, entriesPerPage) -- this makes everything easy!
	if #entries == 0 then
		return addPlayerEvent(sendStoreError, 250, playerId, GameStore.StoreErrors.STORE_ERROR_HISTORY, "You don't have any entries yet.")
	end

	local oldProtocol = player:getClient().version < 1200
	local totalEntries = GameStore.retrieveHistoryTotalPages(player:getAccountId())
	local totalPages = math.ceil(totalEntries / entriesPerPage)

	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_OpenTransactionHistory)
	msg:addU32(totalPages > 0 and page - 1 or 0x0) -- current page
	msg:addU32(totalPages > 0 and totalPages or 0x0) -- total page
	msg:addByte(#entries)

	for k, entry in ipairs(entries) do
		if not oldProtocol then
			msg:addU32(0)
		end
		msg:addU32(entry.time)
		msg:addByte(entry.mode) -- 0 = normal, 1 = gift, 2 = refund
		msg:add32(entry.amount)
		if not oldProtocol then
			msg:addByte(entry.type or 0x00) -- 0 = transferable tibia coin, 1 = normal tibia coin
		end
		msg:addString(entry.description, "sendStoreTransactionHistory - entry.description")
		if not oldProtocol then
			msg:addByte(0) -- details
		end
	end
	msg:sendToPlayer(player)
end

local function sendStorePurchaseSuccessful(playerId, message)
	local player = Player(playerId)
	if not player then
		return false
	end

	local oldProtocol = player:getClient().version < 1200
	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_CompletePurchase)
	msg:addByte(0x00)
	msg:addString(message, "sendStorePurchaseSuccessful - message")
	if oldProtocol then
		-- Send all coins can be used for buy store offers
		msg:addU32(player:getTibiaCoins())
		-- Send transferable coins can be used on transfer
		msg:addU32(player:getTransferableCoins())
	end

	msg:sendToPlayer(player)
end

local function sendStoreError(playerId, errorType, message)
	local player = Player(playerId)
	if not player then
		return false
	end

	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_StoreError)
	msg:addByte(errorType)
	msg:addString(message, "sendStoreError - message")
	msg:sendToPlayer(player)
end

local function sendStoreBalanceUpdating(playerId, updating)
	local player = Player(playerId)
	if not player then
		return false
	end

	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_CoinBalanceUpdating)
	msg:addByte(0x00)
	msg:sendToPlayer(player)

	if updating then
		sendUpdatedStoreBalances(playerId)
	end
end

local function sendUpdatedStoreBalances(playerId)
	local player = Player(playerId)
	if not player then
		return false
	end

	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_CoinBalanceUpdating)
	msg:addByte(0x01)

	msg:addByte(GameStore.SendingPackets.S_CoinBalance)
	msg:addByte(0x01)

	-- Send total of coins (transferable and normal coin)
	msg:addU32(player:getTibiaCoins())
	msg:addU32(player:getTransferableCoins()) -- How many are Transferable

	local oldProtocol = player:getClient().version < 1200
	if not oldProtocol then
		-- How many are reserved for a Character Auction
		-- We currently do not have this system implemented, so we will send 0
		msg:addU32(0)
	end

	msg:sendToPlayer(player)
end

local function sendRequestPurchaseData(playerId, offerId, type)
	local player = Player(playerId)
	if not player then
		return false
	end

	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_RequestPurchaseData)
	msg:addU32(offerId)
	msg:addByte(type)
	msg:sendToPlayer(player)
end

local function getHomeOffers(playerId)
	local player = Player(playerId)
	if not player then
		return {}
	end

	local GameStoreCategories = GameStore.Categories

	local offers = {}
	if GameStoreCategories then
		for _, category in ipairs(GameStoreCategories) do
			if category.offers then
				for _, offer in ipairs(category.offers) do
					if offer.home then
						table.insert(offers, offer)
					end
				end
			end
		end
	end

	return offers
end

local function sendHomePage(playerId)
	local player = Player(playerId)
	if not player then
		return
	end

	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_StoreOffers)

	msg:addString("Home", "sendHomePage - Home")
	msg:addU32(0x0)
	msg:addByte(0x0)
	msg:addByte(0x0)
	msg:addU16(0x00)

	local disableReasons = {}
	local homeOffers = getHomeOffers(player:getId())
	for _, offer in pairs(homeOffers) do
		local canBuy = player:canBuyOffer(offer)
		if canBuy.disabled == 1 then
			for index, disableTable in ipairs(disableReasons) do
				if canBuy.disabledReason == disableTable.reason then
					offer.disabledReadonIndex = index
				end
			end

			if offer.disabledReadonIndex == nil then
				offer.disabledReadonIndex = #disableReasons
				table.insert(disableReasons, canBuy.disabledReason)
			end
		end
	end

	msg:addU16(#disableReasons)
	for _, reason in ipairs(disableReasons) do
		msg:addString(reason, "sendHomePage - reason")
	end

	msg:addU16(#homeOffers)
	for _, offer in pairs(homeOffers) do
		local playerKV = player:kv()
		local purchaseExpCount = playerKV:get(GameStore.Kv.expBoostCount) or 0
		local offerPrice = offer.type == GameStore.OfferTypes.OFFER_TYPE_EXPBOOST and GameStore.ExpBoostValues[purchaseExpCount] or offer.price
		if offer.type == GameStore.OfferTypes.OFFER_TYPE_NAMECHANGE and player:kv():get("namelock") then
			offerPrice = 0
		end

		msg:addString(offer.name, "sendHomePage - offer.name")
		msg:addByte(0x1)
		msg:addU32(offer.id or 0)
		msg:addU16(0x1)
		msg:addU32(offerPrice)
		msg:addByte(offer.coinType or 0x00)

		msg:addByte((offer.disabledReadonIndex ~= nil) and 1 or 0)
		if offer.disabledReadonIndex ~= nil then
			msg:addByte(0x01)
			msg:addU16(offer.disabledReadonIndex)
			offer.disabledReadonIndex = nil
		end

		if offer.state then
			if offer.state == GameStore.States.STATE_SALE then
				local daySub = offer.validUntil - os.date("*t").day
				if daySub >= 0 then
					msg:addByte(offer.state)
				else
					msg:addByte(GameStore.States.STATE_NONE)
				end
			else
				msg:addByte(offer.state)
			end
		else
			msg:addByte(GameStore.States.STATE_NONE)
		end

		local type = convertType(offer.type)

		msg:addByte(type)
		if type == GameStore.ConverType.SHOW_NONE then
			msg:addString(offer.icons[1], "sendHomePage - offer.icons[1]")
		elseif type == GameStore.ConverType.SHOW_MOUNT then
			local mount = Mount(offer.id)
			if not mount then
				msg:addU16(0)
			else
				msg:addU16(mount:getClientId())
			end
		elseif type == GameStore.ConverType.SHOW_ITEM then
			msg:addU16(offer.itemtype)
		elseif type == GameStore.ConverType.SHOW_OUTFIT then
			msg:addU16(player:getSex() == PLAYERSEX_FEMALE and offer.sexId.female or offer.sexId.male)
			local outfit = player:getOutfit()
			msg:addByte(outfit.lookHead)
			msg:addByte(outfit.lookBody)
			msg:addByte(outfit.lookLegs)
			msg:addByte(outfit.lookFeet)
		end

		msg:addByte(0)
		msg:addU16(0)
		msg:addU16(0)
		msg:addU32(0)
		msg:addByte(0)
		msg:addU16(0)
	end

	local banner = HomeBanners
	msg:addByte(#banner.images)
	for _, image in ipairs(banner.images) do
		msg:addString(image, "sendHomePage - image")
		msg:addByte(0x04)
		msg:addU32(0x00)
		msg:addByte(0)
		msg:addByte(0)
	end

	msg:addByte(banner.delay)

	msg:sendToPlayer(player)
end

senders.getCategoriesRook = getCategoriesRook
senders.openStore = openStore
senders.sendOfferDescription = sendOfferDescription
senders.sendShowStoreOffers = sendShowStoreOffers
senders.sendStoreTransactionHistory = sendStoreTransactionHistory
senders.sendStorePurchaseSuccessful = sendStorePurchaseSuccessful
senders.sendStoreError = sendStoreError
senders.sendStoreBalanceUpdating = sendStoreBalanceUpdating
senders.sendUpdatedStoreBalances = sendUpdatedStoreBalances
senders.sendRequestPurchaseData = sendRequestPurchaseData
senders.sendShowStoreOffersOnOldProtocol = sendShowStoreOffersOnOldProtocol
senders.sendHomePage = sendHomePage
senders.getHomeOffers = getHomeOffers

return senders
