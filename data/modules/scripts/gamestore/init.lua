GameStore = {
	ModuleName = "GameStore",
	Developers = { "Cjaker", "metabob", "Rick" },
	Version = "1.1",
	LastUpdated = "25-07-2020 11:52AM",
}

--== Enums ==--
GameStore.OfferTypes = {
	OFFER_TYPE_NONE = 0,
	OFFER_TYPE_ITEM = 1,
	OFFER_TYPE_STACKABLE = 2,
	OFFER_TYPE_CHARGES = 3,
	OFFER_TYPE_OUTFIT = 4,
	OFFER_TYPE_OUTFIT_ADDON = 5,
	OFFER_TYPE_MOUNT = 6,
	OFFER_TYPE_NAMECHANGE = 7,
	OFFER_TYPE_SEXCHANGE = 8,
	OFFER_TYPE_HOUSE = 9,
	OFFER_TYPE_EXPBOOST = 10,
	OFFER_TYPE_PREYSLOT = 11,
	OFFER_TYPE_PREYBONUS = 12,
	OFFER_TYPE_TEMPLE = 13,
	OFFER_TYPE_BLESSINGS = 14,
	OFFER_TYPE_PREMIUM = 15,
	OFFER_TYPE_POUCH = 16,
	OFFER_TYPE_ALLBLESSINGS = 17,
	OFFER_TYPE_INSTANT_REWARD_ACCESS = 18,
	OFFER_TYPE_CHARMS = 19,
	OFFER_TYPE_HIRELING = 20,
	OFFER_TYPE_HIRELING_NAMECHANGE = 21,
	OFFER_TYPE_HIRELING_SEXCHANGE = 22,
	OFFER_TYPE_HIRELING_SKILL = 23,
	OFFER_TYPE_HIRELING_OUTFIT = 24,
	OFFER_TYPE_HUNTINGSLOT = 25,
	OFFER_TYPE_ITEM_BED = 26,
}

GameStore.SubActions = {
	PREY_THIRDSLOT_REAL = 0,
	PREY_WILDCARD = 1,
	INSTANT_REWARD = 2,
	BLESSING_TWIST = 3,
	BLESSING_SOLITUDE = 4,
	BLESSING_PHOENIX = 5,
	BLESSING_SUNS = 6,
	BLESSING_SPIRITUAL = 7,
	BLESSING_EMBRACE = 8,
	BLESSING_HEART = 9,
	BLESSING_BLOOD = 10,
	BLESSING_ALL_PVE = 11,
	BLESSING_ALL_PVP = 12,
	CHARM_EXPANSION = 13,
	TASKHUNTING_THIRDSLOT = 14,
	PREY_THIRDSLOT_REDIRECT = 15,
}

GameStore.ActionType = {
	OPEN_HOME = 0,
	OPEN_PREMIUM_BOOST = 1,
	OPEN_CATEGORY = 2,
	OPEN_USEFUL_THINGS = 3,
	OPEN_OFFER = 4,
	OPEN_SEARCH = 5,
}

GameStore.CoinType = {
	Coin = 0,
	Transferable = 1,
}

GameStore.Storages = {
	expBoostCount = 51052,
}

GameStore.ConverType = {
	SHOW_NONE = 0,
	SHOW_MOUNT = 1,
	SHOW_OUTFIT = 2,
	SHOW_ITEM = 3,
	SHOW_HIRELING = 4,
}

GameStore.ConfigureOffers = {
	SHOW_NORMAL = 0,
	SHOW_CONFIGURE = 1,
}

function convertType(type)
	local types = {
		[GameStore.OfferTypes.OFFER_TYPE_OUTFIT] = GameStore.ConverType.SHOW_OUTFIT,
		[GameStore.OfferTypes.OFFER_TYPE_OUTFIT_ADDON] = GameStore.ConverType.SHOW_OUTFIT,
		[GameStore.OfferTypes.OFFER_TYPE_MOUNT] = GameStore.ConverType.SHOW_MOUNT,
		[GameStore.OfferTypes.OFFER_TYPE_ITEM] = GameStore.ConverType.SHOW_ITEM,
		[GameStore.OfferTypes.OFFER_TYPE_STACKABLE] = GameStore.ConverType.SHOW_ITEM,
		[GameStore.OfferTypes.OFFER_TYPE_HOUSE] = GameStore.ConverType.SHOW_ITEM,
		[GameStore.OfferTypes.OFFER_TYPE_CHARGES] = GameStore.ConverType.SHOW_ITEM,
		[GameStore.OfferTypes.OFFER_TYPE_HIRELING] = GameStore.ConverType.SHOW_HIRELING,
		[GameStore.OfferTypes.OFFER_TYPE_ITEM_BED] = GameStore.ConverType.SHOW_NONE,
	}

	if not types[type] then
		return GameStore.ConverType.SHOW_NONE
	end

	return types[type]
end

function useOfferConfigure(type)
	local types = {
		[GameStore.OfferTypes.OFFER_TYPE_NAMECHANGE] = GameStore.ConfigureOffers.SHOW_CONFIGURE,
		[GameStore.OfferTypes.OFFER_TYPE_HIRELING] = GameStore.ConfigureOffers.SHOW_CONFIGURE,
		[GameStore.OfferTypes.OFFER_TYPE_HIRELING_NAMECHANGE] = GameStore.ConfigureOffers.SHOW_CONFIGURE,
		[GameStore.OfferTypes.OFFER_TYPE_HIRELING_SEXCHANGE] = GameStore.ConfigureOffers.SHOW_CONFIGURE,
	}

	if not types[type] then
		return GameStore.ConfigureOffers.SHOW_NORMAL
	end

	return types[type]
end

GameStore.ClientOfferTypes = {
	CLIENT_STORE_OFFER_OTHER = 0,
	CLIENT_STORE_OFFER_NAMECHANGE = 1,
	CLIENT_STORE_OFFER_HIRELING = 3,
}

GameStore.HistoryTypes = {
	HISTORY_TYPE_NONE = 0,
	HISTORY_TYPE_GIFT = 1,
	HISTORY_TYPE_REFUND = 2,
}

GameStore.States = {
	STATE_NONE = 0,
	STATE_NEW = 1,
	STATE_SALE = 2,
	STATE_TIMED = 3,
}

GameStore.StoreErrors = {
	STORE_ERROR_PURCHASE = 0,
	STORE_ERROR_NETWORK = 1,
	STORE_ERROR_HISTORY = 2,
	STORE_ERROR_TRANSFER = 3,
	STORE_ERROR_INFORMATION = 4,
}

GameStore.ServiceTypes = {
	SERVICE_STANDERD = 0,
	SERVICE_OUTFITS = 3,
	SERVICE_MOUNTS = 4,
	SERVICE_BLESSINGS = 5,
}

GameStore.SendingPackets = {
	S_CoinBalance = 0xDF, -- 223
	S_StoreError = 0xE0, -- 224
	S_RequestPurchaseData = 0xE1, -- 225
	S_CoinBalanceUpdating = 0xF2, -- 242
	S_OpenStore = 0xFB, -- 251
	S_StoreOffers = 0xFC, -- 252
	S_OpenTransactionHistory = 0xFD, -- 253
	S_CompletePurchase = 0xFE, -- 254
}

GameStore.RecivedPackets = {
	C_StoreEvent = 0xE9, -- 233
	C_TransferCoins = 0xEF, -- 239
	C_ParseHirelingName = 0xEC, -- 236
	C_OpenStore = 0xFA, -- 250
	C_RequestStoreOffers = 0xFB, -- 251
	C_BuyStoreOffer = 0xFC, -- 252
	C_OpenTransactionHistory = 0xFD, -- 253
	C_RequestTransactionHistory = 0xFE, -- 254
}

GameStore.ExpBoostValues = {
	[1] = 30,
	[2] = 45,
	[3] = 90,
	[4] = 180,
	[5] = 360,
}

GameStore.DefaultValues = {
	DEFAULT_VALUE_ENTRIES_PER_PAGE = 26,
}

GameStore.DefaultDescriptions = {
	OUTFIT = { "This outfit looks nice. Only high-class people are able to wear it!", "An outfit that was created to suit you. We are sure you'll like it.", "Legend says only smart people should wear it, otherwise you will burn!" },
	MOUNT = { "This is a fantastic mount that helps to become faster, try it!", "The first rider of this mount became the leader of his country! legends say that." },
	NAMECHANGE = { "Are you hunted? Tired of that? Get a new name, a new life!", "A new name to suit your needs!" },
	SEXCHANGE = { "Bored of your character's sex? Get a new sex for him now!!" },
	EXPBOOST = { "Are you tired of leveling slow? try it!" },
	PREYSLOT = {
		"It's hunting season! Activate a prey to gain a bonus when hunting a certain monster. Every character can purchase one Permanent Prey Slot, which enables the activation of an additional prey. \nIf you activate a prey, you can select one monster out of nine. The bonus for your prey will be selected randomly from one of the following: damage boost, damage reduction, bonus XP, improved loot. The bonus value may range from 5% to 50%. Your prey will be active for 2 hours hunting time: the duration of an active prey will only be reduced while you are hunting.",
	},
	PREYBONUS = {
		"You activated a prey but do not like the randomly selected bonus? Roll for a new one! Here you can purchase five Prey Bonus Rerolls! \nA Bonus Reroll allows you to get a bonus with a higher value (max. 50%). The bonus for your prey will be selected randomly from one of the following: damage boost, damage reduction, bonus XP, improved loot. The 2 hours hunting time will start anew once you have rolled for a new bonus. Your prey monster will stay the same.",
	},
	TEMPLE = { "Need a quick way home? Buy this transportation service to get instantly teleported to your home temple. \n\nNote, you cannot use this service while having a battle sign or a protection zone block. Further, the service will not work in no-logout zones or close to your home temple." },
}

--==Parsing==--
GameStore.isItsPacket = function(byte)
	for k, v in pairs(GameStore.RecivedPackets) do
		if v == byte then
			return true
		end
	end
	return false
end

function GameStore.fuzzySearchOffer(searchString)
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

function onRecvbyte(player, msg, byte)
	if not configManager.getBoolean(STOREMODULES) then
		return true
	end
	if player:getVocation():getId() == 0 and not GameStore.haveCategoryRook() then
		return player:sendCancelMessage("Store don't have offers for rookgaard citizen.")
	end

	if byte == GameStore.RecivedPackets.C_StoreEvent then
	elseif byte == GameStore.RecivedPackets.C_TransferCoins then
		parseTransferableCoins(player:getId(), msg)
	elseif byte == GameStore.RecivedPackets.C_OpenStore then
		parseOpenStore(player:getId(), msg)
	elseif byte == GameStore.RecivedPackets.C_RequestStoreOffers then
		parseRequestStoreOffers(player:getId(), msg)
	elseif byte == GameStore.RecivedPackets.C_BuyStoreOffer then
		parseBuyStoreOffer(player:getId(), msg)
	elseif byte == GameStore.RecivedPackets.C_OpenTransactionHistory then
		parseOpenTransactionHistory(player:getId(), msg)
	elseif byte == GameStore.RecivedPackets.C_RequestTransactionHistory then
		parseRequestTransactionHistory(player:getId(), msg)
	end

	if player:isUIExhausted(250) then
		player:sendCancelMessage("You are exhausted.")
		return false
	end

	player:updateUIExhausted()
	return true
end

function parseTransferableCoins(playerId, msg)
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

	-- Adding history for both reciver/sender
	GameStore.insertHistory(accountId, GameStore.HistoryTypes.HISTORY_TYPE_NONE, player:getName() .. " transfered you this amount.", amount, GameStore.CoinType.Coin)
	GameStore.insertHistory(player:getAccountId(), GameStore.HistoryTypes.HISTORY_TYPE_NONE, "You transfered this amount to " .. reciver, -1 * amount, GameStore.CoinType.Coin)
	openStore(playerId)
end

function parseOpenStore(playerId, msg)
	openStore(playerId)

	local category = GameStore.Categories and GameStore.Categories[1] or nil
	if category then
		addPlayerEvent(parseRequestStoreOffers, 50, playerId)
	end
end

function parseRequestStoreOffers(playerId, msg)
	local player = Player(playerId)
	if not player then
		return false
	end

	local actionType = msg:getByte()
	local oldProtocol = player:getClient().version < 1200

	if oldProtocol then
		local categoryName = msg:getString()
		local category = GameStore.getCategoryByName(categoryName)
		if category then
			addPlayerEvent(sendShowStoreOffersOnOldProtocol, 350, playerId, category)
		end
	elseif actionType == GameStore.ActionType.OPEN_CATEGORY then
		local categoryName = msg:getString()
		local category = GameStore.getCategoryByName(categoryName)
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
		local category = nil

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
		local category = nil
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
end

function parseBuyStoreOffer(playerId, msg)
	local player = Player(playerId)
	local id = msg:getU32()
	local offer = GameStore.getOfferById(id)
	local productType = msg:getByte()
	if not offer then
		return false
	end

	-- All guarding conditions under which the offer should not be processed must be included here
	if
		(table.contains(GameStore.OfferTypes, offer.type) == false) -- we've got an invalid offer type
		or not player
		or (player:getVocation():getId() == 0) and (not GameStore.haveOfferRook(id)) -- we don't have such offer
		or not offer
		or (offer.type == GameStore.OfferTypes.OFFER_TYPE_NONE) -- offer is disabled
		or (
			offer.type ~= GameStore.OfferTypes.OFFER_TYPE_NAMECHANGE
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_EXPBOOST
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_PREYBONUS
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_PREYSLOT
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_TEMPLE
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_SEXCHANGE
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_INSTANT_REWARD_ACCESS
			and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_POUCH
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
	local offerPrice = offer.type == GameStore.OfferTypes.OFFER_TYPE_EXPBOOST and GameStore.ExpBoostValues[player:getStorageValue(GameStore.Storages.expBoostCount)] or offer.price
	local offerCoinType = offer.coinType
	-- Check if offer can be honored
	if not player:canPayForOffer(offerPrice, offerCoinType) then
		return queueSendStoreAlertToUser("You don't have enough coins. Your purchase has been cancelled.", 250, playerId)
	end

	-- Use pcall to catch unhandled errors and send an alert to the user because the client expects it at all times; (OTClient will unlock UI)
	-- Handled errors are thrown to indicate that the purchase has failed;
	-- Handled errors have a code index and unhandled errors do not
	local pcallOk, pcallError = pcall(function()
		if offer.type == GameStore.OfferTypes.OFFER_TYPE_ITEM then
			GameStore.processItemPurchase(player, offer.itemtype, offer.count, offer.moveable)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_POUCH then
			GameStore.processItemPurchase(player, offer.itemtype, offer.count)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_INSTANT_REWARD_ACCESS then
			GameStore.processInstantRewardAccess(player, offer.count)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_CHARMS then
			GameStore.processCharmsPurchase(player)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_BLESSINGS then
			GameStore.processSignleBlessingPurchase(player, offer.blessid, offer.count)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_ALLBLESSINGS then
			GameStore.processAllBlessingsPurchase(player, offer.count)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_PREMIUM then
			GameStore.processPremiumPurchase(player, offer.id)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_STACKABLE then
			GameStore.processStackablePurchase(player, offer.itemtype, offer.count, offer.name, offer.moveable)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HOUSE then
			GameStore.processHouseRelatedPurchase(player, offer)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT then
			GameStore.processOutfitPurchase(player, offer.sexId, offer.addon)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT_ADDON then
			GameStore.processOutfitPurchase(player, offer.sexId, offer.addon)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_MOUNT then
			GameStore.processMountPurchase(player, offer.id)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_NAMECHANGE then
			local newName = msg:getString()
			GameStore.processNameChangePurchase(player, offer, productType, newName)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_SEXCHANGE then
			GameStore.processSexChangePurchase(player)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_EXPBOOST then
			GameStore.processExpBoostPuchase(player)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_PREYSLOT then
			GameStore.processPreyThirdSlot(player)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HUNTINGSLOT then
			GameStore.processTaskHuntingThirdSlot(player)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_PREYBONUS then
			GameStore.processPreyBonusReroll(player, offer.count)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_TEMPLE then
			GameStore.processTempleTeleportPurchase(player)
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_CHARGES then
			GameStore.processChargesPurchase(player, offer.itemtype, offer.name, offer.charges, offer.moveable)
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
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_ITEM_BED then
			GameStore.processHouseRelatedPurchase(player, offer)
		else
			-- This should never happen by our convention, but just in case the guarding condition is messed up...
			error({ code = 0, message = "This offer is unavailable [2]" })
		end
	end)

	if not pcallOk then
		local alertMessage = pcallError.code and pcallError.message or "Something went wrong. Your purchase has been cancelled."

		if not pcallError.code then -- unhandled error
			-- log some debugging info
			logger.warn("[parseBuyStoreOffer] - Purchase failed due to an unhandled script error. Stacktrace: {}", pcallError)
		end

		return queueSendStoreAlertToUser(alertMessage, 500, playerId)
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
	return true
end

-- Both functions use same formula!
function parseOpenTransactionHistory(playerId, msg)
	local page = 1
	GameStore.DefaultValues.DEFAULT_VALUE_ENTRIES_PER_PAGE = msg:getByte()
	sendStoreTransactionHistory(playerId, page, GameStore.DefaultValues.DEFAULT_VALUE_ENTRIES_PER_PAGE)
end

function parseRequestTransactionHistory(playerId, msg)
	local page = msg:getU32()
	sendStoreTransactionHistory(playerId, page + 1, GameStore.DefaultValues.DEFAULT_VALUE_ENTRIES_PER_PAGE)
end

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
function openStore(playerId)
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

	local GameStoreCategories, GameStoreCount = nil, 0
	if player:getVocation():getId() == 0 then
		GameStoreCategories, GameStoreCount = getCategoriesRook()
	else
		GameStoreCategories, GameStoreCount = GameStore.Categories, #GameStore.Categories
	end
	local addCategory = function(category)
		msg:addString(category.name)
		if oldProtocol then
			msg:addString(category.description)
		end

		msg:addByte(category.state or GameStore.States.STATE_NONE)
		local size = #category.icons > 255 and 255 or #category.icons
		msg:addByte(size)
		for _, icon in ipairs(category.icons) do
			if size > 0 then
				msg:addString(icon)
				size = size - 1
			end
		end

		if category.parent then
			msg:addString(category.parent)
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

function sendOfferDescription(player, offerId, description)
	local msg = NetworkMessage()
	msg:addByte(0xEA)
	msg:addU32(offerId)
	msg:addString(description)
	msg:sendToPlayer(player)
end

function Player.canBuyOffer(self, offer)
	local playerId = self:getId()
	local disabled, disabledReason = 0, ""
	if offer.disabled == true or not offer.type then
		disabled = 1
	end

	if
		offer.type ~= GameStore.OfferTypes.OFFER_TYPE_NAMECHANGE
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_EXPBOOST
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_PREYSLOT
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_PREYBONUS
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_TEMPLE
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_SEXCHANGE
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_POUCH
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_HIRELING_SKILL
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_HIRELING_OUTFIT
		and not offer.id
	then
		disabled = 1
	end

	if disabled == 1 and offer.disabledReason then
		-- dynamic disable
		disabledReason = offer.disabledReason
	end

	if disabled ~= 1 then
		if offer.type == GameStore.OfferTypes.OFFER_TYPE_POUCH then
			local pounch = self:getItemById(23721, true)
			if pounch then
				disabled = 1
				disabledReason = "You already have Loot Pouch."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_BLESSINGS then
			if self:getBlessingCount(offer.blessid) >= 5 then
				disabled = 1
				disabledReason = "You reached the maximum amount for this blessing."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_ALLBLESSINGS then
			for i = 1, 8 do
				if self:getBlessingCount(i) >= 5 then
					disabled = 1
					disabledReason = "You already have all Blessings."
					break
				end
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT or offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT_ADDON then
			local outfitLookType
			if self:getSex() == PLAYERSEX_MALE then
				outfitLookType = offer.sexId.male
			else
				outfitLookType = offer.sexId.female
			end

			if outfitLookType then
				if offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT and self:hasOutfit(outfitLookType) then
					disabled = 1
					disabledReason = "You already have this outfit."
				elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT_ADDON then
					if self:hasOutfit(outfitLookType) then
						if self:hasOutfit(outfitLookType, offer.addon) then
							disabled = 1
							disabledReason = "You already have this addon."
						end
					else
						disabled = 1
						disabledReason = "You don't have the outfit, you can't buy the addon."
					end
				end
			else
				disabled = 1
				disabledReason = "The offer is fake."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_MOUNT then
			local hasMount = self:hasMount(offer.id)
			if hasMount == true then
				disabled = 1
				disabledReason = "You already have this mount."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_INSTANT_REWARD_ACCESS then
			if self:getCollectionTokens() >= 90 then
				disabled = 1
				disabledReason = "You already have maximum of reward tokens."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_PREYBONUS then
			if self:getPreyCards() >= 50 then
				disabled = 1
				disabledReason = "You already have maximum of prey wildcards."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_CHARMS then
			if self:charmExpansion() then
				disabled = 1
				disabledReason = "You already have charm expansion."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HUNTINGSLOT then
			if self:taskHuntingThirdSlot() then
				disabled = 1
				disabledReason = "You already have 3 slots released."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_PREYSLOT then
			if self:preyThirdSlot() then
				disabled = 1
				disabledReason = "You already have 3 slots released."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_EXPBOOST then
			local remainingBoost = self:getExpBoostStamina()
			if self:getStorageValue(GameStore.Storages.expBoostCount) == 6 then
				disabled = 1
				disabledReason = "You can't buy XP Boost for today."
			end
			if remainingBoost > 0 then
				disabled = 1
				disabledReason = "You already have an active XP boost."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING then
			if self:getHirelingsCount() >= 10 then
				disabled = 1
				disabledReason = "You already have bought the maximum number of allowed hirelings."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING_SKILL then
			local skill = (HIRELING_STORAGE.SKILL + offer.id)
			if self:hasHirelingSkill(skill) then
				disabled = 1
				disabledReason = "This skill is already unlocked."
			end
			if self:getHirelingsCount() <= 0 then
				disabled = 1
				disabledReason = "You need to have a hireling."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING_OUTFIT then
			local outfit = offer.id - HIRELING_STORAGE.OUTFIT
			if self:hasHirelingOutfit(outfit) then
				disabled = 1
				disabledReason = "This hireling outfit is already unlocked."
			end
			if self:getHirelingsCount() <= 0 then
				disabled = 1
				disabledReason = "You need to have a hireling."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING_NAMECHANGE then
			if self:getHirelingsCount() <= 0 then
				disabled = 1
				disabledReason = "You need to have a hireling."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING_SEXCHANGE then
			if self:getHirelingsCount() <= 0 then
				disabled = 1
				disabledReason = "You need to have a hireling."
			end
		end
	end

	return { disabled = disabled, disabledReason = disabledReason }
end

function sendShowStoreOffers(playerId, category, redirectId)
	local player = Player(playerId)
	if not player then
		return false
	end

	local oldProtocol = player:getClient().version < 1200

	local msg = NetworkMessage()
	local haveSaleOffer = 0
	msg:addByte(GameStore.SendingPackets.S_StoreOffers)
	msg:addString(category.name)

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
		msg:addString(reason)
	end

	if count > categoryLimit then
		count = categoryLimit
	end

	msg:addU16(count)
	for name, offer in pairs(offers) do
		if count > 0 then
			count = count - 1
			msg:addString(name)
			msg:addByte(#offer.offers)
			sendOfferDescription(player, offer.id and offer.id or 0xFFFF, offer.description)
			for _, off in ipairs(offer.offers) do
				xpBoostPrice = nil
				if offer.type == GameStore.OfferTypes.OFFER_TYPE_EXPBOOST then
					xpBoostPrice = GameStore.ExpBoostValues[player:getStorageValue(GameStore.Storages.expBoostCount)]
				end

				msg:addU32(off.id)
				msg:addU16(off.count)
				msg:addU32(xpBoostPrice or off.price)
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
				msg:addString(offer.icons[1])
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

function sendShowStoreOffersOnOldProtocol(playerId, category)
	local player = Player(playerId)
	if not player then
		return false
	end

	local msg = NetworkMessage()
	local haveSaleOffer = 0
	msg:addByte(GameStore.SendingPackets.S_StoreOffers)
	msg:addString(category.name)

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
			local offerPrice = offer.type == GameStore.OfferTypes.OFFER_TYPE_EXPBOOST and GameStore.ExpBoostValues[player:getStorageValue(GameStore.Storages.expBoostCount)] or (newPrice or offer.price or 0xFFFF)
			msg:addU32(offer.id and offer.id or 0xFFFF)
			msg:addString(name)
			msg:addString(offer.description or GameStore.getDefaultDescription(offer.type, offer.count))
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
				msg:addString(disabledReason)
			end

			if offer.type == GameStore.OfferTypes.OFFER_TYPE_MOUNT then
				msg:addByte(1)
				msg:addString((offer.name):gsub("% ", "_") .. ".png")
			elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT then
				msg:addByte(2)
				msg:addString(offer.icons[1])
				msg:addString(offer.icons[2])
			else
				msg:addByte(#offer.icons)
				for k, icon in ipairs(offer.icons) do
					msg:addString(icon)
				end
			end

			msg:addU16(0) -- Suboffers
		end
	end

	player:sendButtonIndication(haveSaleOffer, 1)
	msg:sendToPlayer(player)
end

function sendStoreTransactionHistory(playerId, page, entriesPerPage)
	local player = Player(playerId)
	if not player then
		return false
	end
	local oldProtocol = player:getClient().version < 1200
	local totalEntries = GameStore.retrieveHistoryTotalPages(player:getAccountId())
	local totalPages = math.ceil(totalEntries / entriesPerPage)
	local entries = GameStore.retrieveHistoryEntries(player:getAccountId(), page, entriesPerPage) -- this makes everything easy!
	if #entries == 0 then
		return addPlayerEvent(sendStoreError, 250, playerId, GameStore.StoreErrors.STORE_ERROR_HISTORY, "You don't have any entries yet.")
	end

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
			msg:addByte(0x0) -- 0 = transferable tibia coin, 1 = normal tibia coin
		end
		msg:addString(entry.description)
		if not oldProtocol then
			msg:addByte(0) -- details
		end
	end
	msg:sendToPlayer(player)
end

function sendStorePurchaseSuccessful(playerId, message)
	local player = Player(playerId)
	if not player then
		return false
	end

	local oldProtocol = player:getClient().version < 1200
	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_CompletePurchase)
	msg:addByte(0x00)
	msg:addString(message)
	if oldProtocol then
		-- Send all coins can be used for buy store offers
		local totalCoins = player:getTibiaCoins() + player:getTransferableCoins()
		msg:addU32(totalCoins)
		-- Send transferable coins can be used on transfer
		msg:addU32(player:getTransferableCoins())
	end

	msg:sendToPlayer(player)
end

function sendStoreError(playerId, errorType, message)
	local player = Player(playerId)
	if not player then
		return false
	end

	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_StoreError)

	msg:addByte(errorType)
	msg:addString(message)

	msg:sendToPlayer(player)
end

function sendStoreBalanceUpdating(playerId, updating)
	local player = Player(playerId)
	if not player then
		return false
	end

	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_CoinBalanceUpdating)
	msg:addByte(0x00)
	msg:sendToPlayer(player)

	if updating == true then
		sendUpdatedStoreBalances(playerId)
	end
end

function sendUpdatedStoreBalances(playerId)
	local player = Player(playerId)
	if not player then
		return false
	end

	local oldProtocol = player:getClient().version < 1200
	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_CoinBalanceUpdating)
	msg:addByte(0x01)

	msg:addByte(GameStore.SendingPackets.S_CoinBalance)
	msg:addByte(0x01)

	-- Send total of coins (transferable and normal coin)
	local totalCoins = player:getTibiaCoins() + player:getTransferableCoins()
	msg:addU32(totalCoins)
	msg:addU32(player:getTransferableCoins()) -- How many are Transferable
	if not oldProtocol then
		-- How many are reserved for a Character Auction
		-- We currently do not have this system implemented, so we will send 0
		msg:addU32(0)
	end

	msg:sendToPlayer(player)
end

function sendRequestPurchaseData(playerId, offerId, type)
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

--==GameStoreFunctions==--
GameStore.getCategoryByName = function(name)
	for k, category in ipairs(GameStore.Categories) do
		if category.name:lower() == name:lower() then
			if not category.offers then
				return GameStore.getCategoryByName(category.subclasses[1])
			end
			return category
		end
	end
	return nil
end

GameStore.getCategoryByOffer = function(id)
	for Cat_k, category in ipairs(GameStore.Categories) do
		if category.offers then
			for Off_k, offer in ipairs(category.offers) do
				if type(offer.id) == "number" then
					if offer.id == id then
						if not category.offers then
							return GameStore.getCategoryByName(category.subclasses[1])
						end
						return category
					end
				elseif type(offer.id) == "table" then
					for m, offerId in pairs(offer.id) do
						-- in case of outfits we have offer.id = {male = ..., female = ...}
						if offerId == id then
							if not category.offers then
								return GameStore.getCategoryByName(category.subclasses[1])
							end
							return category
						end
					end
				end
			end
		end
	end
	return nil
end

GameStore.getOfferById = function(id)
	for Cat_k, category in ipairs(GameStore.Categories) do
		if category.offers then
			for Off_k, offer in ipairs(category.offers) do
				if type(offer.id) == "number" then
					if offer.id == id then
						return offer
					end
				elseif type(offer.id) == "table" and (offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT or offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT_ADDON) then
					for m, offerId in pairs(offer.id) do
						-- in case of outfits we have offer.id = {male = ..., female = ...}
						if offerId == id then
							return offer
						end
					end

					-- case multi offer
				elseif type(offer.id) == "table" then
					local newoffer = offer
					for i = 1, #offer.id do
						local offerId = offer.id[i]
						if offerId == id then
							newoffer.id = offerId
							newoffer.price = offer.price[i]
							return newoffer
						end
					end
				end
			end
		end
	end
	return nil
end

-- Using for multi offer
function GameStore.getOffersByName(name)
	local offers = {}
	for Cat_k, category in ipairs(GameStore.Categories) do
		if category.offers then
			for Off_k, offer in ipairs(category.offers) do
				if offer.name:lower() == name:lower() then
					table.insert(offers, offer)
				end
			end
		end
	end
	return offers
end

GameStore.haveCategoryRook = function()
	for Cat_k, category in ipairs(GameStore.Categories) do
		if category.offers and category.rookgaard then
			return true
		end
	end

	return false
end

GameStore.haveOfferRook = function(id)
	for Cat_k, category in ipairs(GameStore.Categories) do
		if category.offers and category.rookgaard then
			for Off_k, offer in ipairs(category.offers) do
				if offer.id == id then
					return true
				end
			end
		end
	end
	return nil
end

GameStore.insertHistory = function(accountId, mode, description, coinAmount, coinType)
	return db.query(string.format("INSERT INTO `store_history`(`account_id`, `mode`, `description`, `coin_type`, `coin_amount`, `time`) VALUES (%s, %s, %s, %s, %s, %s)", accountId, mode, db.escapeString(description), coinType, coinAmount, os.time()))
end

GameStore.retrieveHistoryTotalPages = function(accountId)
	local resultId = db.storeQuery("SELECT count(id) as total FROM store_history WHERE account_id = " .. accountId)
	if resultId == false then
		return 0
	end

	local totalPages = Result.getNumber(resultId, "total")
	Result.free(resultId)
	return totalPages
end

GameStore.retrieveHistoryEntries = function(accountId, currentPage, entriesPerPage)
	local entries = {}
	local offset = currentPage > 1 and entriesPerPage * (currentPage - 1) or 0

	local resultId = db.storeQuery("SELECT * FROM `store_history` WHERE `account_id` = " .. accountId .. " ORDER BY `time` DESC LIMIT " .. offset .. ", " .. entriesPerPage .. ";")
	if resultId ~= false then
		repeat
			local entry = {
				mode = Result.getNumber(resultId, "mode"),
				description = Result.getString(resultId, "description"),
				amount = Result.getNumber(resultId, "coin_amount"),
				type = Result.getNumber(resultId, "coin_type"),
				time = Result.getNumber(resultId, "time"),
			}
			table.insert(entries, entry)
		until not Result.next(resultId)
		Result.free(resultId)
	end
	return entries
end

GameStore.getDefaultDescription = function(offerType, count)
	local t, descList = GameStore.OfferTypes
	if offerType == t.OFFER_TYPE_OUTFIT or offerType == t.OFFER_TYPE_OUTFIT_ADDON then
		descList = GameStore.DefaultDescriptions.OUTFIT
	elseif offerType == t.OFFER_TYPE_MOUNT then
		descList = GameStore.DefaultDescriptions.MOUNT
	elseif offerType == t.OFFER_TYPE_NAMECHANGE then
		descList = GameStore.DefaultDescriptions.NAMECHANGE
	elseif offerType == t.OFFER_TYPE_SEXCHANGE then
		descList = GameStore.DefaultDescriptions.SEXCHANGE
	elseif offerType == t.OFFER_TYPE_EXPBOOST then
		descList = GameStore.DefaultDescriptions.EXPBOOST
	elseif offerType == t.OFFER_TYPE_PREYSLOT then
		descList = GameStore.DefaultDescriptions.PREYSLOT
	elseif offerType == t.OFFER_TYPE_PREYBONUS then
		descList = GameStore.DefaultDescriptions.PREYBONUS
	elseif offerType == t.OFFER_TYPE_TEMPLE then
		descList = GameStore.DefaultDescriptions.TEMPLE
	end

	return descList[math.floor(math.random(1, #descList))] or ""
end

GameStore.canUseHirelingName = function(name)
	local result = {
		ability = false,
	}
	if name:len() < 3 or name:len() > 14 then
		result.reason = "The length of the hireling name must be between 3 and 14 characters."
		return result
	end

	local match = name:gmatch("%s+")
	local count = 0
	for v in match do
		count = count + 1
	end

	local matchtwo = name:match("^%s+")
	if matchtwo then
		result.reason = "The hireling name can't have whitespace at begin."
		return result
	end

	local matchthree = name:match("[^a-zA-Z ]")
	if matchthree then
		result.reason = "The hireling name has invalid characters"
		return result
	end

	if count > 1 then
		result.reason = "The hireling name have more than 1 whitespace."
		return result
	end

	-- just copied from znote aac.
	local words = { "owner", "gamemaster", "hoster", "admin", "staff", "tibia", "account", "god", "anal", "ass", "fuck", "sex", "hitler", "pussy", "dick", "rape", "adm", "cm", "gm", "tutor", "counsellor" }
	local split = name:split(" ")
	for k, word in ipairs(words) do
		for k, nameWord in ipairs(split) do
			if nameWord:lower() == word then
				result.reason = "You can't use word \"" .. word .. '" in your hireling name.'
				return result
			end
		end
	end

	local tmpName = name:gsub("%s+", "")
	for i = 1, #words do
		if tmpName:lower():find(words[i]) then
			result.reason = "You can't use word \"" .. words[i] .. '" with whitespace in your hireling name.'
			return result
		end
	end

	result.ability = true
	return result
end

GameStore.canChangeToName = function(name)
	local result = {
		ability = false,
	}
	if name:len() < 3 or name:len() > 14 then
		result.reason = "The length of your new name must be between 3 and 14 characters."
		return result
	end

	local match = name:gmatch("%s+")
	local count = 0
	for v in match do
		count = count + 1
	end

	local matchtwo = name:match("^%s+")
	if matchtwo then
		result.reason = "Your new name can't have whitespace at begin."
		return result
	end

	if count > 1 then
		result.reason = "Your new name have more than 1 whitespace."
		return result
	end

	-- just copied from znote aac.
	local words = { "owner", "gamemaster", "hoster", "admin", "staff", "tibia", "account", "god", "anal", "ass", "fuck", "sex", "hitler", "pussy", "dick", "rape", "adm", "cm", "gm", "tutor", "counsellor" }
	local split = name:split(" ")
	for k, word in ipairs(words) do
		for k, nameWord in ipairs(split) do
			if nameWord:lower() == word then
				result.reason = "You can't use word \"" .. word .. '" in your new name.'
				return result
			end
		end
	end

	local tmpName = name:gsub("%s+", "")
	for i = 1, #words do
		if tmpName:lower():find(words[i]) then
			result.reason = "You can't use word \"" .. words[i] .. '" with whitespace in your new name.'
			return result
		end
	end

	if MonsterType(name) then
		result.reason = 'Your new name "' .. name .. "\" can't be a monster's name."
		return result
	elseif Npc(name) then
		result.reason = 'Your new name "' .. name .. "\" can't be a npc's name."
		return result
	end

	local letters = "{}|_*+-=<>0123456789@#%^&()/*'\\.,:;~!\"$"
	for i = 1, letters:len() do
		local c = letters:sub(i, i)
		for i = 1, name:len() do
			local m = name:sub(i, i)
			if m == c then
				result.reason = "You can't use this letter \"" .. c .. '" in your new name.'
				return result
			end
		end
	end
	result.ability = true
	return result
end

--
-- PURCHASE PROCESSOR FUNCTIONS
-- Must throw an error when the purchase has not been made. The error must of
-- take a table {code = ..., message = ...} if the error is handled. When no code
-- index is present the error is assumed to be unhandled.

function GameStore.processItemPurchase(player, offerId, offerCount, moveable)
	if player:getFreeCapacity() < ItemType(offerId):getWeight(offerCount) then
		return error({ code = 0, message = "Please make sure you have free capacity to hold this item." })
	end

	local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
	if inbox then
		for t = 1, offerCount do
			local inboxItem = inbox:addItem(offerId, offerCount or 1)
			if moveable ~= true and inboxItem then
				inboxItem:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
			end
		end
	else
		return error({ code = 0, message = "Please make sure you have free slots in your store inbox." })
	end
end

function GameStore.processChargesPurchase(player, itemtype, name, charges, moveable)
	if player:getFreeCapacity() < ItemType(itemtype):getWeight(1) then
		return error({ code = 0, message = "Please make sure you have free capacity to hold this item." })
	end

	local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
	if inbox then
		local inboxItem = inbox:addItem(itemtype, charges)

		if moveable ~= true and inboxItem then
			inboxItem:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
		end
	else
		return error({ code = 0, message = "Please make sure you have free slots in your store inbox." })
	end
end

function GameStore.processSignleBlessingPurchase(player, blessId, count)
	player:addBlessing(blessId, count)
end

function GameStore.processAllBlessingsPurchase(player, count)
	player:addBlessing(1, count)
	player:addBlessing(2, count)
	player:addBlessing(3, count)
	player:addBlessing(4, count)
	player:addBlessing(5, count)
	player:addBlessing(6, count)
	player:addBlessing(7, count)
	player:addBlessing(8, count)
end

function GameStore.processInstantRewardAccess(player, offerCount)
	if player:getCollectionTokens() + offerCount >= 91 then
		return error({ code = 1, message = "You cannot own more than 90 reward tokens." })
	end
	player:setCollectionTokens(player:getCollectionTokens() + offerCount)
end

function GameStore.processCharmsPurchase(player)
	player:charmExpansion(true)
end

function GameStore.processPremiumPurchase(player, offerId)
	player:addPremiumDays(offerId - 3000)
	if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
		player:onAddVip(offerId - 3000)
	end
end

function GameStore.processStackablePurchase(player, offerId, offerCount, offerName, moveable)
	local function isKegItem(itemId)
		return itemId >= ITEM_KEG_START and itemId <= ITEM_KEG_END
	end

	local PARCEL_ID = 3504
	local isKeg = isKegItem(offerId)

	if isKeg then
		if player:getFreeCapacity() < ItemType(offerId):getWeight(1) + ItemType(PARCEL_ID):getWeight() then
			return error({ code = 0, message = "Please make sure you have free capacity to hold this item." })
		end
	elseif player:getFreeCapacity() < ItemType(offerId):getWeight(offerCount) + ItemType(PARCEL_ID):getWeight() then
		return error({ code = 0, message = "Please make sure you have free capacity to hold this item." })
	end

	local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
	if inbox then
		if (isKeg and offerCount > 500) or offerCount > 100 then
			local parcel = inbox:addItem(PARCEL_ID, 1)
			parcel:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
			if parcel then
				parcel:setAttribute(ITEM_ATTRIBUTE_NAME, "" .. offerCount .. "x " .. offerName .. " package.")
				local pendingCount = offerCount
				local limit = isKeg and 500 or 100
				while pendingCount > 0 do
					local pack
					if pendingCount > limit then
						pack = limit
					else
						pack = pendingCount
					end
					if isKeg then
						local kegItem = parcel:addItem(offerId, 1)
						kegItem:setAttribute(ITEM_ATTRIBUTE_CHARGES, pack)

						if moveable ~= true and kegItem then
							kegItem:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
						end
					else
						local parcelItem = parcel:addItem(offerId, pack)
						if moveable ~= true and parcelItem then
							parcelItem:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
						end
					end
					pendingCount = pendingCount - pack
				end
			end
		else
			local item = inbox:addItem(offerId, isKeg and 1 or offerCount)
			if moveable ~= true and item then
				item:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
			end
			if item and isKeg then
				item:setAttribute(ITEM_ATTRIBUTE_CHARGES, offerCount)
			end
		end
	else
		return error({ code = 0, message = "Please make sure you have free slots in your store inbox." })
	end
end

function GameStore.processHouseRelatedPurchase(player, offer)
	local function isCaskItem(itemId)
		return (itemId >= ITEM_HEALTH_CASK_START and itemId <= ITEM_HEALTH_CASK_END) or (itemId >= ITEM_MANA_CASK_START and itemId <= ITEM_MANA_CASK_END) or (itemId >= ITEM_SPIRIT_CASK_START and itemId <= ITEM_SPIRIT_CASK_END)
	end

	local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
	local itemIds = offer.itemtype
	if type(itemIds) ~= "table" then
		itemIds = { itemIds }
	end
	if inbox then
		for _, itemId in ipairs(itemIds) do
			local decoKit = inbox:addItem(ITEM_DECORATION_KIT, 1)
			if decoKit then
				decoKit:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "You bought this item in the Store.\nUnwrap it in your own house to create a <" .. ItemType(itemId):getName() .. ">.")
				decoKit:setCustomAttribute("unWrapId", itemId)
				if isCaskItem(itemId) then
					decoKit:setAttribute(ITEM_ATTRIBUTE_DATE, offer.count)
				end

				if offer.moveable ~= true then
					decoKit:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
				end
			end
		end
		player:sendUpdateContainer(inbox)
	else
		return error({ code = 0, message = "Please make sure you have free slots in your store inbox." })
	end
end

function GameStore.processOutfitPurchase(player, offerSexIdTable, addon)
	local looktype
	local _addon = addon and addon or 0

	if player:getSex() == PLAYERSEX_MALE then
		looktype = offerSexIdTable.male
	elseif player:getSex() == PLAYERSEX_FEMALE then
		looktype = offerSexIdTable.female
	end

	if not looktype then
		return error({ code = 0, message = "This outfit seems not to suit your sex, we are sorry for that!" })
	elseif (not player:hasOutfit(looktype, 0)) and (_addon == 1 or _addon == 2) then
		return error({ code = 0, message = "You must own the outfit before you can buy its addon." })
	elseif player:hasOutfit(looktype, _addon) then
		return error({ code = 0, message = "You already own this outfit." })
	else
		if
			not (player:addOutfitAddon(looktype, _addon)) -- TFS call failed
			or (not player:hasOutfit(looktype, _addon)) -- Additional check; if the looktype doesn't match player sex for example,
			--   then the TFS check will still pass... bug? (TODO)
		then
			error({ code = 0, message = "There has been an issue with your outfit purchase. Your purchase has been cancelled." })
		else
			player:addOutfitAddon(offerSexIdTable.male, _addon)
			player:addOutfitAddon(offerSexIdTable.female, _addon)
		end
	end
end

function GameStore.processMountPurchase(player, offerId)
	if player:hasMount(offerId) then
		return error({ code = 0, message = "You already own this mount." })
	end

	player:addMount(offerId)
end

function GameStore.processNameChangePurchase(player, offer, productType, newName)
	local playerId = player:getId()

	if productType == GameStore.ClientOfferTypes.CLIENT_STORE_OFFER_NAMECHANGE then
		local tile = Tile(player:getPosition())
		if tile then
			if not tile:hasFlag(TILESTATE_PROTECTIONZONE) then
				return error({ code = 1, message = "You can change name only in Protection Zone." })
			end
		end

		local resultId = db.storeQuery("SELECT * FROM `players` WHERE `name` = " .. db.escapeString(newName) .. "")
		if resultId ~= false then
			return error({ code = 1, message = "This name is already used, please try again!" })
		end

		local result = GameStore.canChangeToName(newName)
		if not result.ability then
			return error({ code = 1, message = result.reason })
		end

		player:makeCoinTransaction(offer)

		local message = string.format("You have purchased %s for %d coins.", offer.name, offer.price)
		addPlayerEvent(sendStorePurchaseSuccessful, 500, playerId, message)

		newName = newName:lower():gsub("(%l)(%w*)", function(a, b)
			return string.upper(a) .. b
		end)
		db.query("UPDATE `players` SET `name` = " .. db.escapeString(newName) .. " WHERE `id` = " .. player:getGuid())
		message = "You have successfully changed you name, relogin!"
		addEvent(function()
			local player = Player(playerId)
			if not player then
				return false
			end

			player:remove()
		end, 1000)
		-- If not, we ask him to do!
	else
		return addPlayerEvent(sendRequestPurchaseData, 250, playerId, offer.id, GameStore.ClientOfferTypes.CLIENT_STORE_OFFER_NAMECHANGE)
	end
end

function GameStore.processSexChangePurchase(player)
	player:toggleSex()
end

function GameStore.processExpBoostPuchase(player)
	local currentExpBoostTime = player:getExpBoostStamina()
	local expBoostCount = player:getStorageValue(GameStore.Storages.expBoostCount)

	player:setStoreXpBoost(50)
	player:setExpBoostStamina(currentExpBoostTime + 3600)

	if player:getStorageValue(GameStore.Storages.expBoostCount) == -1 or expBoostCount == 6 then
		player:setStorageValue(GameStore.Storages.expBoostCount, 1)
	end

	player:setStorageValue(GameStore.Storages.expBoostCount, expBoostCount + 1)
end

function GameStore.processPreyThirdSlot(player)
	if player:preyThirdSlot() then
		return error({ code = 1, message = "You already have unlocked all prey slots." })
	end
	player:preyThirdSlot(true)
end

function GameStore.processTaskHuntingThirdSlot(player)
	if player:taskHuntingThirdSlot() then
		return error({ code = 1, message = "You already have unlocked all task hunting slots." })
	end
	player:taskHuntingThirdSlot(true)
end

function GameStore.processPreyBonusReroll(player, offerCount)
	if player:getPreyCards() + offerCount >= 51 then
		return error({ code = 1, message = "You cannot own more than 50 prey wildcards." })
	end
	player:addPreyCards(offerCount)
end

function GameStore.processTempleTeleportPurchase(player)
	if player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) or player:isPzLocked() then
		return error({ code = 0, message = "You can't use temple teleport in fight!" })
	end

	player:teleportTo(player:getTown():getTemplePosition())
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been teleported to your hometown.")
end

function GameStore.processHirelingPurchase(player, offer, productType, hirelingName, chosenSex)
	local playerId = player:getId()
	local offerId = offer.id

	if player:getClient().version < 1200 then
		return error({ code = 1, message = "You cannot buy hirelings on client 10, please relog on client 12 and try again." })
	end

	if productType == GameStore.ClientOfferTypes.CLIENT_STORE_OFFER_HIRELING then
		local result = GameStore.canUseHirelingName(hirelingName)
		if not result.ability then
			return error({ code = 1, message = result.reason })
		end

		hirelingName = hirelingName:lower():gsub("(%l)(%w*)", function(a, b)
			return string.upper(a) .. b
		end)

		local hireling = player:addNewHireling(hirelingName, chosenSex)
		if not hireling then
			return error({ code = 1, message = "Error delivering your hireling lamp, try again later." })
		end

		player:makeCoinTransaction(offer, hirelingName)
		local message = "You have successfully bought " .. hirelingName
		return addPlayerEvent(sendStorePurchaseSuccessful, 650, playerId, message)
		-- If not, we ask him to do!
	else
		if player:getHirelingsCount() >= 10 then
			return error({ code = 1, message = "You cannot have more than 10 hirelings." })
		end
		-- TODO: Use the correct dialog (byte 0xDB) on client 1205+
		-- for compatibility, request name using the change name dialog
		return addPlayerEvent(sendRequestPurchaseData, 250, playerId, offerId, GameStore.ClientOfferTypes.CLIENT_STORE_OFFER_HIRELING)
	end
end

function GameStore.processHirelingChangeNamePurchase(player, offer, productType, newHirelingName)
	local playerId = player:getId()
	local offerId = offer.id

	if player:getClient().version < 1200 then
		return error({ code = 1, message = "You cannot buy hireling change name on client 10, please relog on client 12 and try again." })
	end

	if productType == GameStore.ClientOfferTypes.CLIENT_STORE_OFFER_NAMECHANGE then
		local result = GameStore.canUseHirelingName(newHirelingName)
		if not result.ability then
			return error({ code = 1, message = result.reason })
		end

		newHirelingName = newHirelingName:lower():gsub("(%l)(%w*)", function(a, b)
			return string.upper(a) .. b
		end)

		local message = "Close the store window to select which hireling should be renamed to " .. newHirelingName
		addPlayerEvent(sendStorePurchaseSuccessful, 200, playerId, message)

		addPlayerEvent(HandleHirelingNameChange, 550, playerId, offer, newHirelingName)
	else
		return addPlayerEvent(sendRequestPurchaseData, 250, playerId, offerId, GameStore.ClientOfferTypes.CLIENT_STORE_OFFER_NAMECHANGE)
	end
end

function GameStore.processHirelingChangeSexPurchase(player, offer)
	local playerId = player:getId()

	if player:getClient().version < 1200 then
		return error({ code = 1, message = "You cannot buy hireling change sex on client 10, please relog on client 12 and try again." })
	end

	local message = "Close the store window to select which hireling should have the sex changed."
	addPlayerEvent(sendStorePurchaseSuccessful, 200, playerId, message)

	addPlayerEvent(HandleHirelingSexChange, 550, playerId, offer)
end

function GameStore.processHirelingSkillPurchase(player, offer)
	if player:getClient().version < 1200 then
		return error({ code = 1, message = "You cannot buy hireling skill on client 10, please relog on client 12 and try again." })
	end

	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	local skill = offer.id - HIRELING_STORAGE.SKILL
	player:enableHirelingSkill(skill)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A new hireling skill has been added to all your hirelings")
end

function GameStore.processHirelingOutfitPurchase(player, offer)
	if player:getClient().version < 1200 then
		return error({ code = 1, message = "You cannot buy hireling outfit on client 10, please relog on client 12 and try again." })
	end

	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	local outfit = offer.id - HIRELING_STORAGE.OUTFIT
	player:enableHirelingOutfit(outfit)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A new hireling outfit has been added to all your hirelings")
end

--==Player==--
-- Character auction coins
function Player.canRemoveCoins(self, coins)
	if self:getTibiaCoins() < coins then
		return false
	end
	return true
end

function Player.removeCoinsBalance(self, coins)
	if self:canRemoveCoins(coins) then
		sendStoreBalanceUpdating(self:getId(), true)
		return self:removeTibiaCoins(coins)
	end

	return false
end

function Player.addCoinsBalance(self, coins, update)
	self:addTibiaCoins(coins)
	if update then
		sendStoreBalanceUpdating(self:getId(), true)
	end
	return true
end

-- Transferable + normal coin
function Player.canRemoveAllCoins(self, coins)
	if self:getTibiaCoins() + self:getTransferableCoins() < coins then
		return false
	end
	return true
end

--[[
	Removes a specified amount of coins from the player's inventory.
	@param coins (number) - The amount of coins to be removed.
	@return (boolean) - Returns true if the coins were successfully removed, false otherwise.
--]]
function Player.removeAllCoins(self, coins)
	-- Check if it is possible to remove all the coins.
	if self:canRemoveAllCoins(coins) then
		local tibiaCoins = self:getTibiaCoins()
		-- Check if there are enough Tibia coins to remove.
		if tibiaCoins >= coins then
			self:removeTibiaCoins(coins)
		else
			-- Remove the available Tibia coins and calculate the remaining amount to remove from transferable coins.
			self:removeTibiaCoins(tibiaCoins)
			self:removeTransferableCoins(coins - tibiaCoins)
		end

		sendStoreBalanceUpdating(self:getId(), true)
		return true
	end

	return false
end

-- Transferable coins
function Player.canRemoveTransferableCoins(self, coins)
	if self:getTransferableCoins() < coins then
		return false
	end
	return true
end

function Player.removeTransferableCoinsBalance(self, coins)
	if self:canRemoveTransferableCoins(coins) then
		sendStoreBalanceUpdating(self:getId(), true)
		return self:removeTransferableCoins(coins)
	end

	return false
end

function Player.addTransferableCoinsBalance(self, coins, update)
	self:addTransferableCoins(coins)
	if update then
		sendStoreBalanceUpdating(self:getId(), true)
	end
	return true
end

--- Support Functions
function Player.makeCoinTransaction(self, offer, desc)
	local op = true

	if desc then
		desc = offer.name .. " (" .. desc .. ")"
	else
		desc = offer.name
	end

	-- First try remove normal coins, later the transferable coins
	if self:canRemoveAllCoins(offer.price) then
		op = self:removeAllCoins(offer.price)
	elseif self:canRemoveCoins(offer.price) then
		-- Remove normal coins
		op = self:removeCoinsBalance(offer.price)
	else
		-- Remove transferable coins
		op = self:removeTransferableCoinsBalance(offer.price)
	end

	-- When the transaction is suscessfull add to the history
	if op then
		GameStore.insertHistory(self:getAccountId(), GameStore.HistoryTypes.HISTORY_TYPE_NONE, desc, offer.price * -1, offer.coinType)
	end

	return op
end

-- Verifies if the player has enough resources to afford a given offer.
-- @param coinsToRemove (number) - The amount of coins required for the offer.
-- @param coinType (string) - The type of the offer.
-- @return (boolean) - Returns true if the player can pay for the offer, false otherwise.
function Player.canPayForOffer(self, coinsToRemove, coinType)
	local can_remove_coins = self:canRemoveCoins(coinsToRemove)
	local can_remove_transferable_coins = self:canRemoveTransferableCoins(coinsToRemove)

	-- Check if the player has the required amount of regular coins and the offer type is regular.
	if self:getTibiaCoins() >= coinsToRemove and coinType == GameStore.CoinType.Coin then
		return can_remove_coins
	end

	-- Check if the player has the required amount of transferable coins and the offer type is transferable.
	if self:getTransferableCoins() >= coinsToRemove and coinType == GameStore.CoinType.Transferable then
		return can_remove_transferable_coins
	end

	-- Check if the player has either the required amount of regular coins or transferable coins,
	-- or both amounts combined.
	local remove_all_coins = self:canRemoveAllCoins(coinsToRemove)
	return remove_all_coins or (can_remove_coins or can_remove_transferable_coins)
end

--- Other players functions

function Player.sendButtonIndication(self, value1, value2)
	local msg = NetworkMessage()
	msg:addByte(0x19)
	msg:addByte(value1) -- Sale
	msg:addByte(value2) -- New Item
	msg:sendToPlayer(self)
end

function Player.toggleSex(self)
	local currentSex = self:getSex()
	local playerOutfit = self:getOutfit()

	playerOutfit.lookAddons = 0
	if currentSex == PLAYERSEX_FEMALE then
		self:setSex(PLAYERSEX_MALE)
		playerOutfit.lookType = 128
	else
		self:setSex(PLAYERSEX_FEMALE)
		playerOutfit.lookType = 136
	end
	self:setOutfit(playerOutfit)
end

local function getHomeOffers(playerId)
	local player = Player(playerId)
	if not player then
		return {}
	end

	local GameStoreCategories = GameStore.Categories

	local offers = {}
	if GameStoreCategories then
		for k, category in ipairs(GameStoreCategories) do
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

function sendHomePage(playerId)
	local player = Player(playerId)
	if not player then
		return
	end

	local msg = NetworkMessage()
	msg:addByte(GameStore.SendingPackets.S_StoreOffers)

	msg:addString("Home")
	msg:addU32(0x0) -- Redirect ID (not used here)
	msg:addByte(0x0) -- Window Type
	msg:addByte(0x0) -- Collections Size
	msg:addU16(0x00) -- Collection Name

	local disableReasons = {}
	local homeOffers = getHomeOffers(player:getId())
	for p, offer in pairs(homeOffers) do
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
		msg:addString(reason)
	end

	msg:addU16(#homeOffers) -- offers

	for p, offer in pairs(homeOffers) do
		msg:addString(offer.name)
		msg:addByte(0x1) -- ?
		msg:addU32(offer.id or 0) -- id
		msg:addU16(0x1)
		msg:addU32(offer.price)
		msg:addByte(offer.coinType or 0x00)

		msg:addByte((offer.disabledReadonIndex ~= nil) and 1 or 0)
		if offer.disabledReadonIndex ~= nil then
			msg:addByte(0x01)
			msg:addU16(offer.disabledReadonIndex)
			offer.disabledReadonIndex = nil -- Reseting the table to nil disable reason
		end

		msg:addByte(0x00)

		local type = convertType(offer.type)

		msg:addByte(type)
		if type == GameStore.ConverType.SHOW_NONE then
			msg:addString(offer.icons[1])
		elseif type == GameStore.ConverType.SHOW_MOUNT then
			local mount = Mount(offer.id)
			msg:addU16(mount:getClientId())
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

		msg:addByte(0) -- TryOn Type
		msg:addU16(0) -- Collection
		msg:addU16(0) -- Popularity Score
		msg:addU32(0) -- State New Until
		msg:addByte(0) -- User Configuration
		msg:addU16(0) -- Products Capacity
	end

	local banner = HomeBanners
	msg:addByte(#banner.images)
	for m, image in ipairs(banner.images) do
		msg:addString(image)
		msg:addByte(0x04) -- Banner Type (offer)
		msg:addU32(0x00) -- Offer Id
		msg:addByte(0)
		msg:addByte(0)
	end

	msg:addByte(banner.delay) -- Delay to swtich images

	msg:sendToPlayer(player)
end

function Player:openStore(serviceName) --exporting the method so other scripts can use to open store
	openStore(self:getId())

	--local serviceType = msg:getByte()
	local category = GameStore.Categories and GameStore.Categories[1] or nil

	if serviceName and serviceName:lower() == "home" then
		return sendHomePage(self:getId())
	end

	if serviceName and GameStore.getCategoryByName(serviceName) then
		category = GameStore.getCategoryByName(serviceName)
	end

	if category then
		addPlayerEvent(sendShowStoreOffers, 50, playerId, category)
	end
end

-- Hireling Helpers
function HandleHirelingNameChange(playerId, offer, newHirelingName)
	local player = Player(playerId)

	local cb = function(playerId, data, hireling)
		local offer = data.offer
		local newHirelingName = data.newHirelingName
		local player = Player(playerId)
		if not hireling then
			return player:showInfoModal("Error", "Your must select a hireling.")
		end

		if hireling.active > 0 then
			return player:showInfoModal("Error", "Your hireling must be inside his/her lamp.")
		end

		local oldName = hireling.name
		hireling.name = newHirelingName

		if not player:makeCoinTransaction(data.offer, oldName .. " to " .. newHirelingName) then
			return player:showInfoModal("Error", "Transaction error")
		end

		local lamp = player:findHirelingLamp(hireling:getId())
		if lamp then
			lamp:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This mysterious lamp summons your very own personal hireling.\nThis item cannot be traded.\nThis magic lamp is the home of " .. hireling:getName() .. ".")
		end
		logger.debug("{} has been renamed to {}", oldName, newHirelingName)
		sendUpdatedStoreBalances(playerId)
	end

	player:sendHirelingSelectionModal("Choose a Hireling", "Select a hireling below", cb, { offer = offer, newHirelingName = newHirelingName })
end

function HandleHirelingSexChange(playerId, offer)
	local player = Player(playerId)

	local cb = function(playerId, data, hireling)
		local player = Player(playerId)
		if not hireling then
			return player:showInfoModal("Error", "Your must select a hireling.")
		end

		if hireling.active > 0 then
			return player:showInfoModal("Error", "Your hireling must be inside his/her lamp.")
		end

		if not player:makeCoinTransaction(data.offer, hireling:getName()) then
			return player:showInfoModal("Error", "Transaction error")
		end

		local changeTo, sexString, lookType
		if hireling.sex == HIRELING_SEX.FEMALE then
			changeTo = HIRELING_SEX.MALE
			sexString = "male"
			lookType = HIRELING_OUTFIT_DEFAULT.male
		else
			changeTo = HIRELING_SEX.FEMALE
			sexString = "female"
			lookType = HIRELING_OUTFIT_DEFAULT.female
		end

		hireling.sex = changeTo
		hireling.looktype = lookType

		logger.debug("{} sex was changed to {}", hireling:getName(), sexString)
		sendUpdatedStoreBalances(playerId)
	end

	player:sendHirelingSelectionModal("Choose a Hireling", "Select a hireling below", cb, { offer = offer })
end
