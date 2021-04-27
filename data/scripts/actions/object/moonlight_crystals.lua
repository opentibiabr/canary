local moonlightCrystals = Action()

function moonlightCrystals.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 24716 then
		target:transform(24717)
		item:remove(1)
		return true
	elseif target.itemid == 24718 then
        if (player:getStorageValue(Storage.Grimvale.WereHelmetEnchant) == 0) or (player:getStorageValue(Storage.Grimvale.WereHelmetEnchant) == 1) then
            target:transform(24783) -- Magic level helmet
			item:remove(1)
        elseif player:getStorageValue(Storage.Grimvale.WereHelmetEnchant) == 2 then
            target:transform(24788) -- Paladin helmet
			item:remove(1)
        elseif player:getStorageValue(Storage.Grimvale.WereHelmetEnchant) == 3 then
            target:transform(24784) -- Knight club
			item:remove(1)
        elseif player:getStorageValue(Storage.Grimvale.WereHelmetEnchant) == 4 then
            target:transform(24786) -- Knight axe
			item:remove(1)
        elseif player:getStorageValue(Storage.Grimvale.WereHelmetEnchant) == 5 then
            target:transform(24785) -- Knight sword
			item:remove(1)
        else
            return false
        end
	return true
	end
	return false
end

moonlightCrystals:id(24739)
moonlightCrystals:register()
