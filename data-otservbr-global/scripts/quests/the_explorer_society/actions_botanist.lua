local explorerSocietyBotanist = Action()

function explorerSocietyBotanist.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 3874 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.ThePlantCollection) == 18 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 18 then
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.ThePlantCollection, 19)
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 19)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4868)
	elseif target.itemid == 3885 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.ThePlantCollection) == 21 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 21 then
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.ThePlantCollection, 22)
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 22)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4869)
	elseif target.itemid == 3878 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.ThePlantCollection) == 24 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 24 then
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.ThePlantCollection, 25)
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 25)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4870)
	elseif target.itemid == 5658 and target.uid == 3152 and player:getStorageValue(Storage.Quest.U7_8.DruidOutfits.GriffinclawFlower) ~= 1 then --Mission-independent function that uses the same item
		toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
		item:transform(5937)
		target:transform(5687)
		player:setStorageValue(Storage.Quest.U7_8.DruidOutfits.GriffinclawFlower, 1)
		player:say("You successfully took a sample of the rare griffinclaw flower.", TALKTYPE_MONSTER_SAY)
	end

	return true
end

explorerSocietyBotanist:id(4867)
explorerSocietyBotanist:register()
