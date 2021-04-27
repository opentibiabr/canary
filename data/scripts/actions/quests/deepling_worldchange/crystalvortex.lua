local crystalvortex = Action()
function crystalvortex.onUse(player, item, fromPosition, target, toPosition, isHotkey)
		if player:getStorageValue(Storage.DeeplingsWorldChange.Crystal) == 4 then
			if table.contains({15560}, target.itemid) then
				player:removeItem(15565, 1)
				player:addItem(15431, 1)
				player:setStorageValue(Storage.DeeplingsWorldChange.Crystal, 5)
			end
		end
    return true
end
crystalvortex:id(15565)
crystalvortex:register()
