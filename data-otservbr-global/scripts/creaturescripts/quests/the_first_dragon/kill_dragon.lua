local killDragon = CreatureEvent("KillDragon")

function killDragon.onKill(player, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end
	if target:getName():lower() == "dragon" then
		local storage = player:getStorageValue(Storage.FirstDragon.DragonCounter)
		if storage >= 0 and storage < 200 then
			player:setStorageValue(Storage.FirstDragon.DragonCounter, player:getStorageValue(Storage.FirstDragon.DragonCounter) + 1)
		end
	end
	if player:getStorageValue(Storage.FirstDragon.TazhadurTimer) >= os.time() then
		return true
	end
	return true
end

killDragon:register()
