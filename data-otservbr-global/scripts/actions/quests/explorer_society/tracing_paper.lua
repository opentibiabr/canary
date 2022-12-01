local explorerSocietyPaper = Action()
function explorerSocietyPaper.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 2199 and target.uid == 3010 and player:getStorageValue(Storage.ExplorerSociety.TheRuneWritings) == 42 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 42 then
		player:setStorageValue(Storage.ExplorerSociety.TheRuneWritings, 43)
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 43)
		item:transform(4843)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

explorerSocietyPaper:id(4842)
explorerSocietyPaper:register()