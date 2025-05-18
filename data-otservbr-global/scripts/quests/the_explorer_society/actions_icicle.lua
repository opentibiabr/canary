local explorerSocietyIcicle = Action()
function explorerSocietyIcicle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 4994 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheIceDelivery) == 6 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 6 then
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheIceDelivery, 7)
		player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 7)
		player:addItem(4837, 1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

explorerSocietyIcicle:id(4872)
explorerSocietyIcicle:register()
