local explorerSocietyIcicle = Action()
function explorerSocietyIcicle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 4995 and player:getStorageValue(Storage.ExplorerSociety.TheIceDelivery) == 5 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 5 then
		player:setStorageValue(Storage.ExplorerSociety.TheIceDelivery, 6)
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 6)
		player:addItem(4848, 1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

explorerSocietyIcicle:id(4856)
explorerSocietyIcicle:register()