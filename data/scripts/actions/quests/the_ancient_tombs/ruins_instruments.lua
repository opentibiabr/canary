local config = {
	[2367] = 1,
	[2373] = 2,
	[2370] = 3,
	[2372] = 4,
	[2369] = 5
}

local storage = Storage.TheAncientTombs.VashresamunInstruments

local theAncientRuinsInstru = Action()
function theAncientRuinsInstru.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetTable = config[item.itemid]
	if not targetTable then
		player:setStorageValue(storage, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You played them wrong, now you must begin with first again!')
		doTargetCombatHealth(0, player, COMBAT_PHYSICALDAMAGE, -20, -20, CONST_ME_GROUNDSHAKER)
		return true
	end

	if player:getStorageValue(storage) == targetTable and targetTable < 4 then
		player:setStorageValue(storage, math.max(1, player:getPlayerStorageValue(storage)) + 1)
		fromPosition:sendMagicEffect(CONST_ME_SOUND_BLUE)
	else
		player:setStorageValue(Storage.TheAncientTombs.VashresamunsDoor, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You played them in correct order and got the access through door!')
	end
	return true
end

theAncientRuinsInstru:aid(12105)
theAncientRuinsInstru:register()