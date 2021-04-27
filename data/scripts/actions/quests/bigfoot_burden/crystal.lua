local function returnCrystal(position, id)
	local tile = Tile(position):getItemById(18311)
	if tile then
		tile:transform(id)
	end
end

local bigfootCrystal = Action()
function bigfootCrystal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local repairedCount = player:getStorageValue(Storage.BigfootBurden.RepairedCrystalCount)
	if repairedCount == 5 or player:getStorageValue(Storage.BigfootBurden.MissionCrystalKeeper) ~= 1 then
		return false
	end

	if target.itemid == 18307 or target.itemid == 18228 then
		player:setStorageValue(Storage.BigfootBurden.RepairedCrystalCount, repairedCount + 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have repaired a damaged crystal!')
		addEvent(returnCrystal, math.random(50, 140) * 1000, toPosition, target.itemid)
		target:transform(18311)
		toPosition:sendMagicEffect(CONST_ME_ENERGYAREA)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This is no damaged crystal!')
	end
	return true
end

bigfootCrystal:id(18219)
bigfootCrystal:register()