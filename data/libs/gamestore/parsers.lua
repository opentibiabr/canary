local helpers = require("gamestore.helpers")
local senders = require("gamestore.senders")
local parsing = {}

local useOfferConfigure = helpers.useOfferConfigure
local openStore = senders.openStore
local sendShowStoreOffers = senders.sendShowStoreOffers
local sendShowStoreOffersOnOldProtocol = senders.sendShowStoreOffersOnOldProtocol
local sendStoreError = senders.sendStoreError
local sendStorePurchaseSuccessful = senders.sendStorePurchaseSuccessful
local sendUpdatedStoreBalances = senders.sendUpdatedStoreBalances
local sendStoreTransactionHistory = senders.sendStoreTransactionHistory
local sendHomePage = senders.sendHomePage

local function isItsPacket(byte)
	for k, v in pairs(GameStore.RecivedPackets) do
		if v == byte then
			return true
		end
	end
	return false
end

local function fuzzySearchOffer(searchString)
	local results = {}
	for i, category in ipairs(GameStore.Categories) do
		if category.offers then
			for j, offer in ipairs(category.offers) do
				if string.match(offer.name:lower(), searchString:lower()) then
					table.insert(results, offer)
				end
			end
		end
	end
	return results
end

local function queueSendStoreAlertToUser(message, delay, playerId, storeErrorCode)
	storeErrorCode = storeErrorCode and storeErrorCode or GameStore.StoreErrors.STORE_ERROR_NETWORK
	addPlayerEvent(sendStoreError, delay, playerId, storeErrorCode, message)
end

local function onRecvbyte(player, msg, byte)
	if player:getVocation():getId() == 0 and not GameStore.haveCategoryRook() then
		player:sendCancelMessage("Store don't have offers for rookgaard citizen.")
		return false
	end

	if player:isUIExhausted(250) then
		player:sendCancelMessage("You are exhausted.")
		return true
	end

	local playerId = player:getId()

	if byte == GameStore.RecivedPackets.C_TransferCoins then
		parseTransferableCoins(playerId, msg)
	elseif byte == GameStore.RecivedPackets.C_OpenStore then
		parseOpenStore(playerId, msg)
	elseif byte == GameStore.RecivedPackets.C_RequestStoreOffers then
		parseRequestStoreOffers(playerId, msg)
	elseif byte == GameStore.RecivedPackets.C_BuyStoreOffer then
		parseBuyStoreOffer(playerId, msg)
	elseif byte == GameStore.RecivedPackets.C_OpenTransactionHistory then
		parseOpenTransactionHistory(playerId, msg)
	elseif byte == GameStore.RecivedPackets.C_RequestTransactionHistory then
		parseRequestTransactionHistory(playerId, msg)
	end

	return true
end

local function parseTransferableCoins(playerId, msg)
	local player = Player(playerId)
	if not player then
		return false
	end

	local reciver = msg:getString()
	local amount = msg:getU32()

	if player:getTransferableCoins() < amount then
		return addPlayerEvent(sendStoreError, 350, playerId, GameStore.StoreErrors.STORE_ERROR_TRANSFER, "You don't have this amount of coins.")
	end

	if reciver:lower() == player:getName():lower() then
		return addPlayerEvent(sendStoreError, 350, playerId, GameStore.StoreErrors.STORE_ERROR_TRANSFER, "You can't transfer coins to yourself.")
	end

	local resultId = db.storeQuery("SELECT `account_id` FROM `players` WHERE `name` = " .. db.escapeString(reciver:lower()) .. "")
	if not resultId then
		return addPlayerEvent(sendStoreError, 350, playerId, GameStore.StoreErrors.STORE_ERROR_TRANSFER, "We couldn't find that player.")
	end

	local accountId = Result.getNumber(resultId, "account_id")
	if accountId == player:getAccountId() then
		return addPlayerEvent(sendStoreError, 350, playerId, GameStore.StoreErrors.STORE_ERROR_TRANSFER, "You cannot transfer coin to a character in the same account.")
	end

	db.query("UPDATE `accounts` SET `coins_transferable` = `coins_transferable` + " .. amount .. " WHERE `id` = " .. accountId)
	player:removeTransferableCoinsBalance(amount)
	addPlayerEvent(sendStorePurchaseSuccessful, 550, playerId, "You have transfered " .. amount .. " coins to " .. reciver .. " successfully")

	-- Adding history for both receiver/sender
	GameStore.insertHistory(accountId, GameStore.HistoryTypes.HISTORY_TYPE_NONE, player:getName() .. " transferred you this amount.", amount, GameStore.CoinType.Transferable)
	GameStore.insertHistory(player:getAccountId(), GameStore.HistoryTypes.HISTORY_TYPE_NONE, "You transferred this amount to " .. reciver, -1 * amount, GameStore.CoinType.Transferable)
	openStore(playerId)
	player:updateUIExhausted()
end

local function parseOpenStore(playerId, msg)
	openStore(playerId)

	local category = GameStore.Categories and GameStore.Categories[1] or nil
	if category then
		addPlayerEvent(parseRequestStoreOffers, 50, playerId)
	end
end

local function parseRequestStoreOffers(playerId, msg)
	local player = Player(playerId)
	if not player then
		return false
	end

	local actionType = msg:getByte()
	local oldProtocol = player:getClient().version < 1200

	if oldProtocol then
		local stringParam = msg:getString()
		local category = GameStore.getCategoryByName(stringParam)
		if category then
			addPlayerEvent(sendShowStoreOffersOnOldProtocol, 350, playerId, category)
		end
	elseif actionType == GameStore.ActionType.OPEN_CATEGORY then
		local stringParam = msg:getString()
		local category = GameStore.getCategoryByName(stringParam)
		if category then
			addPlayerEvent(sendShowStoreOffers, 50, playerId, category)
		end
	elseif actionType == GameStore.ActionType.OPEN_HOME then
		sendHomePage(player:getId())
		if category then
			addPlayerEvent(sendShowStoreOffers, 50, playerId, "Home Offers")
		end
	elseif actionType == GameStore.ActionType.OPEN_PREMIUM_BOOST then
		local subAction = msg:getByte()
		local category

		local premiumCategoryName = "Premium Time"
		if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
			premiumCategoryName = "VIP Shop"
		end
		if subAction == 0 then
			category = GameStore.getCategoryByName(premiumCategoryName)
		else
			category = GameStore.getCategoryByName("Boosts")
		end

		if category then
			addPlayerEvent(sendShowStoreOffers, 50, playerId, category)
		end
	elseif actionType == GameStore.ActionType.OPEN_USEFUL_THINGS then
		local subAction = msg:getByte()
		local offerId = subAction
		local category
		if subAction >= GameStore.SubActions.BLESSING_TWIST and subAction <= GameStore.SubActions.BLESSING_ALL_PVP then
			category = GameStore.getCategoryByName("Blessings")
		else
			category = GameStore.getCategoryByName("Useful Things")
		end

		if subAction == GameStore.SubActions.PREY_THIRDSLOT_REAL then
			offerId = GameStore.SubActions.PREY_THIRDSLOT_REDIRECT
		end
		if category then
			addPlayerEvent(sendShowStoreOffers, 50, playerId, category, offerId)
		end
	elseif actionType == GameStore.ActionType.OPEN_OFFER then
		local offerId = msg:getU32()
		local category = GameStore.getCategoryByOffer(offerId)
		if category then
			addPlayerEvent(sendShowStoreOffers, 50, playerId, category, offerId)
		end
	elseif actionType == GameStore.ActionType.OPEN_SEARCH then
		local searchString = msg:getString()
		local results = GameStore.fuzzySearchOffer(searchString)
		if not results or #results == 0 then
			return addPlayerEvent(sendStoreError, 250, playerId, GameStore.StoreErrors.STORE_ERROR_INFORMATION, 'No results found for "' .. searchString .. '".')
		end

		local searchResultsCategory = {
			name = "Search",
			offers = results,
		}

		addPlayerEvent(sendShowStoreOffers, 250, playerId, searchResultsCategory)
	end
	player:updateUIExhausted()
end

-- Used on cyclopedia store summary
local function insertPlayerTransactionSummary(player, offer)
	local id = offer.id
	if offer.type == GameStore.OfferTypes.OFFER_TYPE_HOUSE then
		id = offer.itemtype
	elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_BLESSINGS then
		id = offer.blessid
	end
	player:createTransactionSummary(offer.type, math.max(1, offer.count or 1), id)
end

local function parseBuyStoreOffer(playerId, msg)
	local player = Player(playerId)
	local id = msg:getU32()
	local offer = GameStore.getOfferById(id)
	local productType = msg:getByte()
	if not offer then
		return false
	end

	-- Cooldown Purchase
	local playerKV = player:kv()
	local purchaseCooldown = playerKV:get(GameStore.Kv.purchaseCooldown) or 0
	local currentTime = os.time()
	local waittime = purchaseCooldown - currentTime
	if waittime > 0 then
		queueSendStoreAlertToUser("You are making many purchases simultaneously in a few moments.", 250, playerId)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are making many purchases simultaneously in a few moments.")
		return false
	end
	playerKV:set(GameStore.Kv.purchaseCooldown, os.time() + 5)

	-- All guarding conditions under which the offer should not be processed must be included here
	if
		not table.contains(GameStore.OfferTypes, offer.type) -- we've got an invalid offer type
		or not player
		or (player:getVocation():getId() == 0) and (not GameStore.haveOfferRook(id)) -- we don't have such offer
		or not offer
		or (offer.type == GameStore.OfferTypes.OFFER_TYPE_NONE) -- offer is disabled
		or (
			offer.type ~= GameStore.OfferTypes.OFFER_TYPE_NAMECHANGE
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_EXPBOOST
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_PREYBONUS
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_PREYSLOT
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_HUNTINGSLOT
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_TEMPLE
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_SEXCHANGE
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_INSTANT_REWARD_ACCESS
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_HIRELING
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_HIRELING_NAMECHANGE
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_HIRELING_SEXCHANGE
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_HIRELING_SKILL
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_HIRELING_OUTFIT
			and not offer.id
		)
	then
		return queueSendStoreAlertToUser("This offer is unavailable [1]", 350, playerId, GameStore.StoreErrors.STORE_ERROR_INFORMATION)
	end

	-- At this point the purchase is assumed to be formatted correctly
	local purchaseExpCount = playerKV:get(GameStore.Kv.expBoostCount) or 0
	local offerPrice = offer.type == GameStore.OfferTypes.OFFER_TYPE_EXPBOOST and GameStore.ExpBoostValues[purchaseExpCount] or offer.price
	local offerCoinType = offer.coinType
	if offer.type == GameStore.OfferTypes.OFFER_TYPE_NAMECHANGE and player:kv():get("namelock") then
		offerPrice = 0
	end
	-- Check if offer can be honored
	if offerPrice > 0 and not player:canPayForOffer(offerPrice, offerCoinType) then
		return queueSendStoreAlertToUser("You don't have enough coins. Your purchase has been cancelled.", 250, playerId)
	end

	-- Use pcall to catch unhandled errors and send an alert to the user because the client expects it at all times; (OTClient will unlock UI)
	-- Handled errors are thrown to indicate that the purchase has failed;
	-- Handled errors have a code index and unhandled errors do not
	local pcallOk, pcallError = pcall(function()
		if offer.type == GameStore.OfferTypes.OFFER_TYPE_ITEM or offer.type == GameStore.OfferTypes.OFFER_TYPE_ITEM_UNIQUE then
			GameStore.processItemPurchase(player, offer.itemtype, offer.count or 1, offer.movable, offer.setOwner)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_INSTANT_REWARD_ACCESS then
			GameStore.processInstantRewardAccess(player, offer.count)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_CHARMS then
			GameStore.processCharmsPurchase(player)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_BLESSINGS then
			GameStore.processSingleBlessingPurchase(player, offer.blessid, offer.count)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_ALLBLESSINGS then
			GameStore.processAllBlessingsPurchase(player, offer.count)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_PREMIUM then
			GameStore.processPremiumPurchase(player, offer.id)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_STACKABLE then
			GameStore.processStackablePurchase(player, offer.itemtype, offer.count, offer.name, offer.movable, offer.setOwner)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HOUSE or offer.type == GameStore.OfferTypes.OFFER_TYPE_ITEM_BED then
			GameStore.processHouseRelatedPurchase(player, offer)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT or offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT_ADDON then
			GameStore.processOutfitPurchase(player, offer.sexId, offer.addon)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_MOUNT then
			GameStore.processMountPurchase(player, offer.id)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_NAMECHANGE then
			local newName = msg:getString()
			GameStore.processNameChangePurchase(player, offer, productType, newName)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_SEXCHANGE then
			GameStore.processSexChangePurchase(player)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_EXPBOOST then
			GameStore.processExpBoostPurchase(player)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HUNTINGSLOT then
			GameStore.processTaskHuntingThirdSlot(player)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_PREYSLOT then
			GameStore.processPreyThirdSlot(player)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_PREYBONUS then
			GameStore.processPreyBonusReroll(player, offer.count)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_TEMPLE then
			GameStore.processTempleTeleportPurchase(player)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_CHARGES then
			GameStore.processChargesPurchase(player, offer.itemtype, offer.name, offer.charges, offer.movable, offer.setOwner)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING then
			local hirelingName = msg:getString()
			local sex = msg:getByte()
			GameStore.processHirelingPurchase(player, offer, productType, hirelingName, sex)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING_NAMECHANGE then
			local hirelingName = msg:getString()
			GameStore.processHirelingChangeNamePurchase(player, offer, productType, hirelingName)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING_SEXCHANGE then
			GameStore.processHirelingChangeSexPurchase(player, offer)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING_SKILL then
			GameStore.processHirelingSkillPurchase(player, offer)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING_OUTFIT then
			GameStore.processHirelingOutfitPurchase(player, offer)
		else
			-- This should never happen by our convention, but just in case the guarding condition is messed up...
			error({ code = 0, message = "This offer is unavailable [2]" })
		end
	end)

	if not pcallOk then
		local alertMessage = pcallError.code and pcallError.message or "Something went wrong. Your purchase has been cancelled."

		-- unhandled error
		if not pcallError.code then
			logger.warn("[parseBuyStoreOffer] - Purchase failed due to an unhandled script error. Stacktrace: {}", pcallError)
		end

		return queueSendStoreAlertToUser(alertMessage, 500, playerId)
	end

	if table.contains({ GameStore.OfferTypes.OFFER_TYPE_HOUSE, GameStore.OfferTypes.OFFER_TYPE_EXPBOOST, GameStore.OfferTypes.OFFER_TYPE_PREYBONUS, GameStore.OfferTypes.OFFER_TYPE_BLESSINGS, GameStore.OfferTypes.OFFER_TYPE_ALLBLESSINGS, GameStore.OfferTypes.OFFER_TYPE_INSTANT_REWARD_ACCESS }, offer.type) then
		insertPlayerTransactionSummary(player, offer)
	end
	local configure = useOfferConfigure(offer.type)
	if configure ~= GameStore.ConfigureOffers.SHOW_CONFIGURE then
		if not player:makeCoinTransaction(offer) then
			return player:showInfoModal("Error", "Purchase transaction error")
		end

		local message = string.format("You have purchased %s for %d coins.", offer.name, offerPrice)
		sendUpdatedStoreBalances(playerId)
		return addPlayerEvent(sendStorePurchaseSuccessful, 650, playerId, message)
	end

	player:updateUIExhausted()
	return true
end

-- Both functions use same formula!
local function parseOpenTransactionHistory(playerId, msg)
	local player = Player(playerId)
	if not player then
		return
	end

	local page = 1
	GameStore.DefaultValues.DEFAULT_VALUE_ENTRIES_PER_PAGE = msg:getByte()
	sendStoreTransactionHistory(playerId, page, GameStore.DefaultValues.DEFAULT_VALUE_ENTRIES_PER_PAGE)
	player:updateUIExhausted()
end

local function parseRequestTransactionHistory(playerId, msg)
	local player = Player(playerId)
	if not player then
		return
	end

	local page = msg:getU32()
	sendStoreTransactionHistory(playerId, page + 1, GameStore.DefaultValues.DEFAULT_VALUE_ENTRIES_PER_PAGE)
	player:updateUIExhausted()
end

parsing.isItsPacket = isItsPacket
parsing.fuzzySearchOffer = fuzzySearchOffer
parsing.onRecvbyte = onRecvbyte
parsing.parseTransferableCoins = parseTransferableCoins
parsing.parseOpenStore = parseOpenStore
parsing.parseRequestStoreOffers = parseRequestStoreOffers
parsing.parseBuyStoreOffer = parseBuyStoreOffer
parsing.parseOpenTransactionHistory = parseOpenTransactionHistory
parsing.parseRequestTransactionHistory = parseRequestTransactionHistory

return parsing
