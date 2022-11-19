function onRecvbyte(player, msg, byte)
	if player then
		local storageDeathFake = player:getStorageValue(Storage.CultsOfTibia.Barkless.Death)
		if storageDeathFake == 1 then
			player:setStorageValue(Storage.CultsOfTibia.Barkless.Death, 0)
			player:addHealth(player:getMaxHealth())
			player:addMana(player:getMaxMana())
			player:setHiddenHealth(false)
			player:removeCondition(CONDITION_OUTFIT)
			player:teleportTo(player:getTown():getTemplePosition(), true)
		end
	end
end
