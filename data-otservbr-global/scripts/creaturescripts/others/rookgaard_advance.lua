local rookgaardAdvance = CreatureEvent("RookgaardAdvance")
function rookgaardAdvance.onAdvance(player, skill, oldLevel, newLevel)
	if skill ~= SKILL_LEVEL or newLevel ~= 8 or player:getVocation():getId() ~= 0 then
		return true
	end

	if player:getStorageValue(Storage.Quest.U10_55.Dawnport.GoMain) == 1 then
		player:setStorageValue(Storage.Quest.U10_55.Dawnport.GoMain, 2)
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You are ready to leave this island and choose a vocation now. Go see the Oracle over the academy in Rookgaard before you advance to level 10!")
	return true
end

rookgaardAdvance:register()
