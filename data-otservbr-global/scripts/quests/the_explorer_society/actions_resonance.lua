local explorerSocietyResonance = Action()
function explorerSocietyResonance.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid == 40043 then
		if player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheIceMusic) == 60 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 60 then
			player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheIceMusic, 61)
			player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 61)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			item:transform(7315)
			player:say("You recorded the ice music.", TALKTYPE_MONSTER_SAY)
		end
	end
	return true
end

explorerSocietyResonance:id(7242)
explorerSocietyResonance:register()
