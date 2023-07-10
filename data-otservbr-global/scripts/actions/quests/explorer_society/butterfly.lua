local explorerSocietyButterfly = Action()
function explorerSocietyButterfly.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 4992 and player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 9  and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 9 then
		player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 10)
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 10)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4864)
		target:remove()
	elseif target.itemid == 4993 and player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 12 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 12 then
		player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 13)
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 13)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4865)
		target:remove()
	elseif target.itemid == 4991 and player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 15 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 15 then
		player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 16)
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 16)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4866)
		target:remove()
	end
	return true
end

explorerSocietyButterfly:id(4863)
explorerSocietyButterfly:register()