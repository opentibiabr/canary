local CACHE_UPDATE_INTERVAL = 60 -- 1 minute for update cache

local goldenOutfitCache = { [1] = {}, [2] = {}, [3] = {} }
local royalOutfitCache = { [1] = {}, [2] = {}, [3] = {} }
local lastUpdatedGolden = 0
local lastUpdatedRoyal = 0

local function updateOutfitCache(storageKey, cache, lastUpdated)
	if os.time() < lastUpdated + CACHE_UPDATE_INTERVAL then
		return cache, lastUpdated
	end

	local newCache = { [1] = {}, [2] = {}, [3] = {} }

	local resultId = db.storeQuery("SELECT `name`, `value` FROM `player_storage` INNER JOIN `players` as `p` ON `p`.`id` = `player_id` WHERE `key` = " .. storageKey .. " AND `value` >= 1;")
	if resultId then
		repeat
			table.insert(newCache[Result.getNumber(resultId, "value")], Result.getString(resultId, "name"))
		until not Result.next(resultId)
		Result.free(resultId)
	end

	return newCache, os.time()
end

local outfitMemorial = Action()

function outfitMemorial.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	goldenOutfitCache, lastUpdatedGolden = updateOutfitCache(Storage.Quest.U12_15.GoldenOutfits, goldenOutfitCache, lastUpdatedGolden)
	royalOutfitCache, lastUpdatedRoyal = updateOutfitCache(Storage.OutfitQuest.RoyalCostumeOutfit, royalOutfitCache, lastUpdatedRoyal)
	local response = NetworkMessage()
	response:addByte(0xB0)

	-- Golden outfit bytes
	response:addU32(500000000) -- Armor price
	response:addU32(750000000) -- Armor + helmet price
	response:addU32(1000000000) -- Armor + helmet + boots price

	for i = 1, 3 do
		response:addU16(#goldenOutfitCache[i])
		for j = 1, #goldenOutfitCache[i] do
			response:addString(goldenOutfitCache[i][j], "outfitMemorial.onUse - goldenOutfitCache[i][j]")
		end
	end

	-- Royal outfit bytes
	for i = 1, 3 do
		response:addU16(30000) -- price in silver tokens
		response:addU16(25000) -- price in golden tokens
	end

	for i = 1, 3 do
		response:addU16(#royalOutfitCache[i])
		for j = 1, #royalOutfitCache[i] do
			response:addString(royalOutfitCache[i][j], "outfitMemorial.onUse - royalOutfitCache[i][j]")
		end
	end

	response:sendToPlayer(player)
	return true
end

outfitMemorial:id(31518, 31519, 31520, 31521, 31522, 31523)
outfitMemorial:register()
