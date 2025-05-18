local whatFoolishCushion = Action()
function whatFoolishCushion.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4202 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Questline) ~= 17 or player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.WhoopeeCushion) == 1 then
		return false
	end

	player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.WhoopeeCushion, 1)
	player:say("*chuckles maniacally*", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	player:say("Woooosh!", TALKTYPE_MONSTER_SAY, false, player, toPosition)
	item:remove()
	return true
end

whatFoolishCushion:id(121)
whatFoolishCushion:register()
