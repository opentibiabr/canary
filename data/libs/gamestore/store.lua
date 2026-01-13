local store = {}

local function getCategoryByName(name)
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

local function getCategoryByOffer(id)
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

local function getOfferById(id)
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
local function getOffersByName(name)
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

local function haveCategoryRook()
	for Cat_k, category in ipairs(GameStore.Categories) do
		if category.offers and category.rookgaard then
			return true
		end
	end

	return false
end

local function haveOfferRook(id)
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

local function insertHistory(accountId, mode, description, coinAmount, coinType)
	return db.query(string.format("INSERT INTO `store_history`(`account_id`, `mode`, `description`, `coin_type`, `coin_amount`, `time`) VALUES (%s, %s, %s, %s, %s, %s)", accountId, mode, db.escapeString(description), coinType, coinAmount, os.time()))
end

local function retrieveHistoryTotalPages(accountId)
	local resultId = db.storeQuery("SELECT count(id) as total FROM store_history WHERE account_id = " .. accountId)
	if not resultId then
		return 0
	end

	local totalPages = Result.getNumber(resultId, "total")
	Result.free(resultId)
	return totalPages
end

local function retrieveHistoryEntries(accountId, currentPage, entriesPerPage)
	local entries = {}
	local offset = currentPage > 1 and entriesPerPage * (currentPage - 1) or 0

	local resultId = db.storeQuery("SELECT * FROM `store_history` WHERE `account_id` = " .. accountId .. " ORDER BY `time` DESC LIMIT " .. offset .. ", " .. entriesPerPage .. ";")
	if resultId then
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

local function getDefaultDescription(offerType, count)
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

	if not descList or #descList == 0 then
		return ""
	end

	return descList[math.floor(math.random(1, #descList))] or ""
end

local function resolveState(state, context)
	if state == nil then
		return GameStore.States.STATE_NONE
	end

	for _, value in pairs(GameStore.States) do
		if value == state then
			return state
		end
	end

	local message = "Invalid Game Store state"
	if context then
		message = message .. " (" .. context .. ")"
	end

	error(message .. ": " .. tostring(state))
end

local function normalizeOffer(offer)
	if type(offer.type) ~= "number" then
		offer.type = GameStore.OfferTypes.OFFER_TYPE_NONE
	end

	if offer.coinType == nil then
		offer.coinType = GameStore.CoinType.Transferable
	else
		local isValidCoinType = false
		for _, value in pairs(GameStore.CoinType) do
			if value == offer.coinType then
				isValidCoinType = true
				break
			end
		end
		if not isValidCoinType then
			error(string.format("Invalid Game Store coin type: %s", tostring(offer.coinType)))
		end
	end

	offer.state = GameStore.resolveState(offer.state)

	local description = offer.description
	if description == nil or description == "" then
		local defaultDescription = GameStore.getDefaultDescription(offer.type, offer.count)
		if defaultDescription ~= "" then
			description = defaultDescription
		else
			description = description or ""
		end
	end
	offer.description = description

	return offer
end

local function canUseHirelingName(name)
	local result = {
		ability = false,
	}
	if name:len() < 3 or name:len() > 18 then
		result.reason = "The length of the hireling name must be between 3 and 18 characters."
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
	for wordIndex, word in ipairs(words) do
		for partIndex, nameWord in ipairs(split) do
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

local function canChangeToName(name)
	local result = {
		ability = false,
	}

	if name:len() < 3 or name:len() > 29 then
		result.reason = "The length of your new name must be between 3 and 29 characters."
		return result
	end

	local match = name:gmatch("%s+")
	local count = 0
	for _ in match do
		count = count + 1
	end

	local matchtwo = name:match("^%s+")
	if matchtwo then
		result.reason = "Your new name can't have whitespace at the beginning."
		return result
	end

	if count > 2 then
		result.reason = "Your new name can't have more than 2 spaces."
		return result
	end

	if name:match("%s%s") then
		result.reason = "Your new name can't have consecutive spaces."
		return result
	end

	-- just copied from znote aac.
	local words = { "owner", "gamemaster", "hoster", "admin", "staff", "tibia", "account", "god", "anal", "ass", "fuck", "sex", "hitler", "pussy", "dick", "rape", "adm", "cm", "gm", "tutor", "counsellor" }
	local split = name:split(" ")
	for _, word in ipairs(words) do
		for _, nameWord in ipairs(split) do
			if nameWord:lower() == word then
				result.reason = "You can't use the word '" .. word .. "' in your new name."
				return result
			end
		end
	end

	local tmpName = name:gsub("%s+", "")
	for _, word in ipairs(words) do
		if tmpName:lower():find(word) then
			result.reason = "You can't use the word '" .. word .. "' even with spaces in your new name."
			return result
		end
	end

	if MonsterType(name) then
		result.reason = "Your new name '" .. name .. "' can't be a monster's name."
		return result
	elseif Npc(name) then
		result.reason = "Your new name '" .. name .. "' can't be an NPC's name."
		return result
	end

	local letters = "{}|_*+-=<>0123456789@#%^&()/*'\\.,:;~!\"$"
	for i = 1, letters:len() do
		local c = letters:sub(i, i)
		for j = 1, name:len() do
			local m = name:sub(j, j)
			if m == c then
				result.reason = "You can't use this character '" .. c .. "' in your new name."
				return result
			end
		end
	end

	result.ability = true
	return result
end

--

store.getCategoryByName = getCategoryByName
store.getCategoryByOffer = getCategoryByOffer
store.getOfferById = getOfferById
store.getOffersByName = getOffersByName
store.haveCategoryRook = haveCategoryRook
store.haveOfferRook = haveOfferRook
store.insertHistory = insertHistory
store.retrieveHistoryTotalPages = retrieveHistoryTotalPages
store.retrieveHistoryEntries = retrieveHistoryEntries
store.getDefaultDescription = getDefaultDescription
store.resolveState = resolveState
store.normalizeOffer = normalizeOffer
store.canUseHirelingName = canUseHirelingName
store.canChangeToName = canChangeToName

return store
