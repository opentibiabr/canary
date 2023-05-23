local goldenOutfitCache
local lastUpdated = 0

local function updateGoldenOutfitCache()
	if os.time() < lastUpdated + (5 * 60) then  -- Memorial cache update interval (5 minutes)
		return
	end

	goldenOutfitCache = {[1] = {}, [2] = {}, [3] = {}}

	local resultId = db.storeQuery("SELECT `name`, `value` FROM `player_storage` INNER JOIN `players` as `p` ON `p`.`id` = `player_id` WHERE `key` = " .. Storage.OutfitQuest.GoldenOutfit .. " AND `value` >= 1;")
	if not resultId then
		Result.free(resultId)
		lastUpdated = os.time()
		return
	end

	repeat
		table.insert(goldenOutfitCache[Result.getNumber(resultId, "value")], Result.getString(resultId, "name"))
	until not Result.next(resultId)
	Result.free(resultId)

	lastUpdated = os.time()
end

local goldenOutfitMemorial = Action()

function goldenOutfitMemorial.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	updateGoldenOutfitCache()
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
		response:addU16(0) -- price in silver tokens
		response:addU16(0) -- price in golden tokens
	end

	for i = 1, 3 do
		response:addU16(0) -- list of spenders
	end

	response:sendToPlayer(player)
	return true
end

goldenOutfitMemorial:id(31518, 31519, 31520, 31521, 31522, 31523)
goldenOutfitMemorial:register()
