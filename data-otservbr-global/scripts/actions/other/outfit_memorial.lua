local CACHE_UPDATE_INTERVAL = 1 * 60 -- 1 minute for update cache
local lastUpdatedGolden = 0
local lastUpdatedRoyal = 0

local function updateOutfitCache(storageKey, lastUpdated)
	if os.time() < lastUpdated + CACHE_UPDATE_INTERVAL then
		return nil
	end

	local cache = { [1] = {}, [2] = {}, [3] = {} }

	local query = "SELECT `name`, `value` FROM `player_storage` INNER JOIN `players` as `p` ON `p`.`id` = `player_id` WHERE `key` = " .. storageKey .. " AND `value` >= 1;"
	local resultId = db.storeQuery(query)

	if resultId then
		repeat
			table.insert(cache[Result.getNumber(resultId, "value")], Result.getString(resultId, "name"))
		until not Result.next(resultId)
	end
	Result.free(resultId)

	lastUpdated = os.time()
	return cache
end

local goldenOutfitCache
local royalOutfitCache

local outfitMemorial = Action()

function outfitMemorial.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	goldenOutfitCache, lastUpdatedGolden = updateOutfitCache(Storage.OutfitQuest.GoldenOutfit, lastUpdatedGolden)
	royalOutfitCache, lastUpdatedRoyal = updateOutfitCache(Storage.OutfitQuest.RoyalCostumeOutfit, lastUpdatedRoyal)
	local response = NetworkMessage()
	response:addByte(0xB0)

	response:addU32(500000000) -- Armor price
	response:addU32(750000000) -- Armor + helmet price
	response:addU32(1000000000) -- Armor + helmet + boots price

	for i = 1, 3 do
		response:addU16(#goldenOutfitCache[i])
		for j = 1, #goldenOutfitCache[i] do
			response:addString(goldenOutfitCache[i][j])
		end
	end

	for i = 1, 3 do
		response:addU16(30000) -- price in silver tokens
		response:addU16(25000) -- price in golden tokens
	end

	for i = 1, 3 do
		response:addU16(#royalOutfitCache[i])
		for j = 1, #royalOutfitCache[i] do
			response:addString(royalOutfitCache[i][j])
		end
	end

	response:sendToPlayer(player)
	return true
end

outfitMemorial:id(31518, 31519, 31520, 31521, 31522, 31523)
outfitMemorial:register()
