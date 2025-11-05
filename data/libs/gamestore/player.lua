local senders = require("gamestore.senders")
local player = {}

local sendStoreBalanceUpdating = senders.sendStoreBalanceUpdating
local sendShowStoreOffers = senders.sendShowStoreOffers
local sendHomePage = senders.sendHomePage
local openStorePacket = senders.openStore

local function canBuyOffer(self, offer)
	local disabled, disabledReason = 0, ""
	if offer.disabled or not offer.type then
		disabled = 1
	end

	if
		offer.type ~= GameStore.OfferTypes.OFFER_TYPE_NAMECHANGE
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_EXPBOOST
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_PREYSLOT
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_HUNTINGSLOT
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_PREYBONUS
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_TEMPLE
		and offer.type ~= GameStore.OfferTypes.OFFER_TYPE_SEXCHANGE
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
		if offer.type == GameStore.OfferTypes.OFFER_TYPE_ITEM_UNIQUE then
			local item = self:getItemById(offer.itemtype, true)
			if item then
				disabled = 1
				disabledReason = "You already have a " .. ItemType(item:getId()):getName() .. "."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_BLESSINGS then
			if self:getBlessingCount(offer.blessid) >= 5 then
				disabled = 1
				disabledReason = "You reached the maximum amount for this blessing."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_ALLBLESSINGS then
			local hasAnyMaxBlessing = false
			for i = 2, 8 do
				if self:getBlessingCount(i) >= 5 then
					hasAnyMaxBlessing = true
					break
				end
			end
			if hasAnyMaxBlessing then
				disabled = 1
				disabledReason = "You already have all Blessings."
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
			if self:hasMount(offer.id) then
				disabled = 1
				disabledReason = "You already have this mount."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_INSTANT_REWARD_ACCESS then
			if self:getCollectionTokens() >= GameStore.ItemLimit.INSTANT_REWARD_ACCESS then
				disabled = 1
				disabledReason = "You already have maximum of reward tokens."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_PREYBONUS then
			if self:getPreyCards() >= GameStore.ItemLimit.PREY_WILDCARD then
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
			local playerKV = self:kv()
			local purchaseExpCount = playerKV:get(GameStore.Kv.expBoostCount) or 0
			if purchaseExpCount == GameStore.ItemLimit.EXPBOOST then
				disabled = 1
				disabledReason = "You can't buy XP Boost for today."
			end
			if self:getXpBoostTime() > 0 then
				disabled = 1
				disabledReason = "You already have an active XP boost."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING then
			if self:getHirelingsCount() >= GameStore.ItemLimit.HIRELING then
				disabled = 1
				disabledReason = "You already have bought the maximum number of allowed hirelings."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING_SKILL then
			if self:hasHirelingSkill(GetHirelingSkillNameById(offer.id)) then
				disabled = 1
				disabledReason = "This skill is already unlocked."
			end
			if self:getHirelingsCount() <= 0 then
				disabled = 1
				disabledReason = "You need to have a hireling."
			end
		elseif offer.type == GameStore.OfferTypes.OFFER_TYPE_HIRELING_OUTFIT then
			if self:hasHirelingOutfit(GetHirelingOutfitNameById(offer.id)) then
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

local function canReceiveStoreItems(self, offerId, offerCount)
	local inbox = self:getStoreInbox()
	if not inbox then
		return false, "No store inbox found."
	end

	local itemType = ItemType(offerId)
	local slotsNeeded = offerCount or 1
	if itemType and itemType:isStackable() then
		slotsNeeded = math.ceil(slotsNeeded / itemType:getStackSize())
	end

	local inboxItems = inbox:getItems(true)
	local slotsOccupied = #inboxItems
	local maxCapacity = inbox:getMaxCapacity()

	if slotsOccupied + slotsNeeded > maxCapacity then
		local slotsAvailable = maxCapacity - slotsOccupied
		return false, string.format("Not enough free slots in your store inbox. You need %d more slot(s). Currently occupied: %d/%d", slotsNeeded - slotsAvailable, slotsOccupied, maxCapacity)
	end

	local totalWeight = itemType:getWeight(offerCount or 1)
	if self:getFreeCapacity() < totalWeight then
		return false, "Please make sure you have enough free capacity to hold this item."
	end

	return true, ""
end

local function canRemoveCoins(self, coins)
	return self:getTibiaCoins() >= coins
end

local function removeCoinsBalance(self, coins)
	if self:canRemoveCoins(coins) then
		sendStoreBalanceUpdating(self:getId(), true)
		self:removeTibiaCoins(coins)
		return true
	end

	return false
end

local function addCoinsBalance(self, coins, update)
	self:addTibiaCoins(coins)
	if update then
		sendStoreBalanceUpdating(self:getId(), true)
	end
	return true
end

local function canRemoveTransferableCoins(self, coins)
	return self:getTransferableCoins() >= coins
end

local function removeTransferableCoinsBalance(self, coins)
	if self:canRemoveTransferableCoins(coins) then
		sendStoreBalanceUpdating(self:getId(), true)
		self:removeTransferableCoins(coins)
		return true
	end

	return false
end

local function addTransferableCoinsBalance(self, coins, update)
	self:addTransferableCoins(coins)
	if update then
		sendStoreBalanceUpdating(self:getId(), true)
	end
	return true
end

local function makeCoinTransaction(self, offer, desc)
	local op = false

	if desc then
		desc = offer.name .. " (" .. desc .. ")"
	else
		desc = offer.name
	end

	local isExpBoost = offer.type == GameStore.OfferTypes.OFFER_TYPE_EXPBOOST
	if isExpBoost then
		local playerKV = self:kv()
		local expBoostCount = tonumber(playerKV:get(GameStore.Kv.expBoostCount)) or 0
		if expBoostCount <= 0 or expBoostCount > 5 then
			expBoostCount = 1
		end
		local priceTable = GameStore.ExpBoostValues
		if GameStore.ExpBoostValuesCustom then
			priceTable = GameStore.ExpBoostValuesCustom
		end
		offer.price = priceTable[expBoostCount] or priceTable[1]
		playerKV:set(GameStore.Kv.expBoostCount, expBoostCount + 1)
	end

	if offer.coinType == GameStore.CoinType.Coin and self:canRemoveCoins(offer.price) then
		op = self:removeCoinsBalance(offer.price)
	elseif offer.coinType == GameStore.CoinType.Transferable and self:canRemoveTransferableCoins(offer.price) then
		op = self:removeTransferableCoinsBalance(offer.price)
	end

	if op then
		GameStore.insertHistory(self:getAccountId(), GameStore.HistoryTypes.HISTORY_TYPE_NONE, desc, offer.price * -1, offer.coinType)
	end

	return op
end

local function canPayForOffer(self, coinsToRemove, coinType)
	if coinType == GameStore.CoinType.Coin then
		return self:canRemoveCoins(coinsToRemove)
	end

	if coinType == GameStore.CoinType.Transferable then
		return self:canRemoveTransferableCoins(coinsToRemove)
	end

	return false
end

local function sendButtonIndication(self, value1, value2)
	local msg = NetworkMessage()
	msg:addByte(0x19)
	msg:addByte(value1)
	msg:addByte(value2)
	msg:sendToPlayer(self)
end

local function toggleSex(self)
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

local function openStore(self, serviceName)
	local playerId = self:getId()
	openStorePacket(playerId)

	local category = GameStore.Categories and GameStore.Categories[1] or nil

	if serviceName and serviceName:lower() == "home" then
		return sendHomePage(playerId)
	end

	if serviceName and GameStore.getCategoryByName(serviceName) then
		category = GameStore.getCategoryByName(serviceName)
	end

	if category then
		addPlayerEvent(sendShowStoreOffers, 50, playerId, category)
	end
end

player.canBuyOffer = canBuyOffer
player.canReceiveStoreItems = canReceiveStoreItems
player.canRemoveCoins = canRemoveCoins
player.removeCoinsBalance = removeCoinsBalance
player.addCoinsBalance = addCoinsBalance
player.canRemoveTransferableCoins = canRemoveTransferableCoins
player.removeTransferableCoinsBalance = removeTransferableCoinsBalance
player.addTransferableCoinsBalance = addTransferableCoinsBalance
player.makeCoinTransaction = makeCoinTransaction
player.canPayForOffer = canPayForOffer
player.sendButtonIndication = sendButtonIndication
player.toggleSex = toggleSex
player.openStore = openStore

return player
