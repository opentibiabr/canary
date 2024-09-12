local config = {
	[3255] = 1,
	[3261] = 2,
	[3258] = 3,
	[3260] = 4,
	[3257] = 5,
}

local storage = Storage.Quest.U7_4.TheAncientTombs.VashresamunInstruments

local theAncientRuinsInstru = Action()
function theAncientRuinsInstru.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetValue = config[item.itemid]
	if not targetValue then
		player:setStorageValue(storage, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You played it wrong, now you must begin with the first again!")
		doTargetCombatHealth(0, player, COMBAT_PHYSICALDAMAGE, -20, -20, CONST_ME_GROUNDSHAKER)
		return true
	end

	local currentValue = player:getStorageValue(storage)
	if currentValue == -1 then
		currentValue = 0
	end

	if currentValue + 1 == targetValue then
		player:setStorageValue(storage, targetValue)
		fromPosition:sendMagicEffect(CONST_ME_SOUND_BLUE)
		if targetValue == 5 then
			player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.VashresamunsDoor, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You played them in the correct order and got access through the door!")
			if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.VashresamunsTreasure) <= 1 then
				player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.VashresamunsTreasure, 2)
			end
		end
	else
		player:setStorageValue(storage, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You played it wrong, now you must begin with the first again!")
		doTargetCombatHealth(0, player, COMBAT_PHYSICALDAMAGE, -20, -20, CONST_ME_GROUNDSHAKER)
	end
	return true
end

theAncientRuinsInstru:aid(12106)
theAncientRuinsInstru:register()
