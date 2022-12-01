local explorerSocietyBotanist = Action()
function explorerSocietyBotanist.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 3874 and player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 18 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 18 then
		player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 19)
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 19)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4868)
	elseif target.itemid == 3885 and player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 21 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 21 then
		player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 22)
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 22)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4869)
	elseif target.itemid == 3878 and player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 24 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 24 then
		player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 25)
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 25)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4870)
	elseif target.itemid == 5658 and target.uid == 3152 then
		if player:getStorageValue(53051) < 1 then
			toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
			item:transform(5937)
			player:setStorageValue(53051, 1)
			player:say("You successfully took a sample of the rare griffinclaw flower.", TALKTYPE_ORANGE_1)
		else
			toPosition:sendMagicEffect(CONST_ME_POFF)
			player:say("You already took a sample of the rare griffinclaw flower.", TALKTYPE_ORANGE_1)
		end
	end
	return true
end

explorerSocietyBotanist:id(4867)
explorerSocietyBotanist:register()