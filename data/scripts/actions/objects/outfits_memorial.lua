local lastUpdated = 0
local goldenOutfitCache

local function updateGoldenOutfitCache()
	if os.time() < lastUpdated + 10 * 60 then
		return
	end

	goldenOutfitCache = { [1] = {}, [2] = {}, [3] = {} }

	local resultId = db.storeQuery("SELECT `key_name`, `timestamp`, `value` FROM `kv_store` WHERE `key_name` = '" .. "golden-outfit-quest" .. "'")

	if resultId ~= 0 then
		repeat
			local addons = result.getNumber(resultId, "value")
			local name = result.getString(resultId, "name")
			if not goldenOutfitCache[addons] then
				goldenOutfitCache[addons] = {}
			end

			table.insert(goldenOutfitCache[addons], name)
		until not result.next(resultId)
		result.free(resultId)
	end

	lastUpdated = os.time()
end

local memorial = Action()

function memorial.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	updateGoldenOutfitCache()

	local msg = NetworkMessage()
	msg:addByte(0xB0)

	local prices = { 500000000, 750000000, 1000000000 }
	for i, price in ipairs(prices) do
		msg:addU32(price)
	end

	for i = 1, 3 do
		msg:addU16(#goldenOutfitCache[i])

		for j = 1, #goldenOutfitCache[i] do
			msg:addString(goldenOutfitCache[i][j])
		end
	end

	-- royal costume
	for i = 1, 3 do
		msg:addU16(0) -- price in silver tokens
		msg:addU16(0) -- price in golden tokens
	end

	for i = 1, 3 do
		msg:addU16(0) -- list of spenders
	end

	msg:sendToPlayer(player)
	msg:delete()
	return true
end

memorial:id(31518, 31519, 31520, 31521, 31522, 31523)
memorial:register()
