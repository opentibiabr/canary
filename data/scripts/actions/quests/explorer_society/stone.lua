local explorerSocietyStone = Action()
function explorerSocietyStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid == 25018 and player:getStorageValue(Storage.ExplorerSociety.TheSpectralStone) == 53 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 53 and player:getStorageValue(Storage.ExplorerSociety.SpectralStone) == 1 then -- mission taken from Angus
		player:setStorageValue(Storage.ExplorerSociety.TheSpectralStone, 54)
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 54)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif target.uid == 25019 and player:getStorageValue(Storage.ExplorerSociety.TheSpectralStone) == 54 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 54 and player:getStorageValue(Storage.ExplorerSociety.SpectralStone) == 1 then -- mission taken from Angus
		player:setStorageValue(Storage.ExplorerSociety.TheSpectralStone, 55)
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 55)
		player:removeItem(4851, 1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif target.uid == 25019 and player:getStorageValue(Storage.ExplorerSociety.TheSpectralStone) == 53 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 53 and player:getStorageValue(Storage.ExplorerSociety.SpectralStone) == 2 then -- mission taken from Mortimer
		player:setStorageValue(Storage.ExplorerSociety.TheSpectralStone, 54)
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 54)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif target.uid == 25018 and player:getStorageValue(Storage.ExplorerSociety.TheSpectralStone) == 54 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 54  and player:getStorageValue(Storage.ExplorerSociety.SpectralStone) == 2 then -- mission taken from Mortimer
		player:setStorageValue(Storage.ExplorerSociety.TheSpectralStone, 55)
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 55)
		player:removeItem(4851, 1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

explorerSocietyStone:id(4851)
explorerSocietyStone:register()