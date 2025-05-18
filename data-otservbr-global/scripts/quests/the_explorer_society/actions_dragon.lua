local explorerSocietyDragon = Action()
function explorerSocietyDragon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheIslandofDragons) == 57 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 57 then
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheIslandofDragons, 58)
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 58)
		player:addItem(7314, 1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

explorerSocietyDragon:uid(40042)
explorerSocietyDragon:register()
