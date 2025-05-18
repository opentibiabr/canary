function onRecvbyte(player, msg, byte)
	if IsRunningGlobalDatapack() and player then
		local storageDeathFake = player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Barkless.Death)
		if storageDeathFake == 1 then
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Barkless.Death, 0)
			player:addHealth(player:getMaxHealth())
			player:addMana(player:getMaxMana())
			player:setHiddenHealth(false)
			player:removeCondition(CONDITION_OUTFIT)
			player:teleportTo(player:getTown():getTemplePosition(), true)
		end
	end
end
