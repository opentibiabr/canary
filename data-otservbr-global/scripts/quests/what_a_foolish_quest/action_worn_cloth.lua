local whatFoolishWorn = Action()

function whatFoolishWorn.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 4203 then
		if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Questline) ~= 34 or player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.OldWornCloth) == 1 then
			return false
		end

		player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.OldWornCloth, 1)
		player:say("Amazing! That was quite fast!", TALKTYPE_MONSTER_SAY)
		toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
		item:transform(143)
		return true
	else
		return false
	end
end

whatFoolishWorn:id(142)
whatFoolishWorn:register()
