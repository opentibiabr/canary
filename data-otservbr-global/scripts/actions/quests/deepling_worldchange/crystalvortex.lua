local crystalvortex = Action()
function crystalvortex.onUse(player, item, fromPosition, target, toPosition, isHotkey)
		if player:getStorageValue(Storage.DeeplingsWorldChange.Crystal) == 4 then
			if table.contains({14157}, target.itemid) then
				player:removeItem(14162, 1)
				player:addItem(14018, 1)
				player:setStorageValue(Storage.DeeplingsWorldChange.Crystal, 5)
			end
		end
    return true
end
crystalvortex:id(14162)
crystalvortex:register()
