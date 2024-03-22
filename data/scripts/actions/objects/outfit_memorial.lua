local goldenOutfitCache = { [1] = {}, [2] = {}, [3] = {} }
local royalOutfitCache = { [1] = {}, [2] = {}, [3] = {} }
local lastUpdatedGolden = os.time()
local lastUpdatedRoyal = os.time()

local function updateOutfitCache(storageKey, cache, lastUpdated)
	local currentTime = os.time()
	if currentTime < lastUpdated + 60 * 10 then
		return cache, lastUpdated
	end

	local newCache = { [1] = {}, [2] = {}, [3] = {} }
	local resultId = db.storeQuery("SELECT `key_name`, `timestamp`, `value` FROM `kv_store` WHERE `key_name` LIKE '%" .. storageKey .. "%'")

	if resultId then
		repeat
			local value = Result.getNumber(resultId, "value")
			local keyName = Result.getString(resultId, "key_name")

			if value and newCache[value] then
				table.insert(newCache[value], keyName)
			end
		until not Result.next(resultId)

		Result.free(resultId)
	end
	return newCache, currentTime
end

local outfitMemorial = Action()

function outfitMemorial.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	goldenOutfitCache, lastUpdatedGolden = updateOutfitCache("golden-outfit-quest", goldenOutfitCache, lastUpdatedGolden)
	royalOutfitCache, lastUpdatedRoyal = updateOutfitCache("royal-costume-outfit-quest", royalOutfitCache, lastUpdatedRoyal)

	local msg = NetworkMessage()
	msg:addByte(0xB0)

	local goldenOutfitPrices = { 500000000, 750000000, 1000000000 }
	for i, price in ipairs(goldenOutfitPrices) do
		msg:addU32(goldenOutfitPrices)
	end

	for i = 1, 3 do
		msg:addU16(#goldenOutfitCache[i])

		for j = 1, #goldenOutfitCache[i] do
			msg:addString(goldenOutfitCache[i][j], "outfitMemorial.onUse - goldenOutfitCache[i][j]")
		end
	end

	local royalCostumePrices = { 30000, 25000 }
	for i = 1, 3 do
		for _, price in ipairs(royalCostumePrices) do
			msg:addU16(price)
		end
	end

	for i = 1, 3 do
		msg:addU16(#royalOutfitCache[i])

		for j = 1, #royalOutfitCache[i] do
			msg:addString(royalOutfitCache[i][j], "outfitMemorial.onUse - royalOutfitCache[i][j]")
		end
	end

	msg:sendToPlayer(player)
	msg:delete()
	return true
end

outfitMemorial:id(31518, 31519, 31520, 31521, 31522, 31523)
outfitMemorial:register()
