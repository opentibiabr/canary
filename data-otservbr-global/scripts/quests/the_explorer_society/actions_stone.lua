local explorerSocietyStone = Action()
function explorerSocietyStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid == 25018 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheSpectralStone) == 53 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 53 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.SpectralStone) == 1 then -- mission taken from Angus
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheSpectralStone, 54)
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 54)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif target.uid == 25019 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheSpectralStone) == 54 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 54 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.SpectralStone) == 1 then -- mission taken from Angus
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheSpectralStone, 55)
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 55)
		player:removeItem(4840, 1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif target.uid == 25019 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheSpectralStone) == 53 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 53 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.SpectralStone) == 2 then -- mission taken from Mortimer
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheSpectralStone, 54)
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 54)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif target.uid == 25018 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheSpectralStone) == 54 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 54 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.SpectralStone) == 2 then -- mission taken from Mortimer
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheSpectralStone, 55)
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 55)
		player:removeItem(4840, 1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

explorerSocietyStone:id(4840)
explorerSocietyStone:register()
