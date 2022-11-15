local moonlightCrystals = Action()

function moonlightCrystals.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 22060 then
		target:transform(22061)
		item:remove(1)
		return true
	elseif target.itemid == 22062 then
        if (player:getStorageValue(Storage.Grimvale.WereHelmetEnchant) == 0) or (player:getStorageValue(Storage.Grimvale.WereHelmetEnchant) == 1) then
            target:transform(24783) -- Magic level helmet
			item:remove(1)
        elseif player:getStorageValue(Storage.Grimvale.WereHelmetEnchant) == 2 then
            target:transform(22132) -- Paladin helmet
			item:remove(1)
        elseif player:getStorageValue(Storage.Grimvale.WereHelmetEnchant) == 3 then
            target:transform(22128) -- Knight club
			item:remove(1)
        elseif player:getStorageValue(Storage.Grimvale.WereHelmetEnchant) == 4 then
            target:transform(22130) -- Knight axe
			item:remove(1)
        elseif player:getStorageValue(Storage.Grimvale.WereHelmetEnchant) == 5 then
            target:transform(22129) -- Knight sword
			item:remove(1)
        else
            return false
        end
	    return true
	end
	return false
end

moonlightCrystals:id(22083)
moonlightCrystals:register()
