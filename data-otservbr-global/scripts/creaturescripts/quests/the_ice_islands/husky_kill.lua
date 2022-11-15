local huskyKill = CreatureEvent("HuskyKill")

function huskyKill.onKill(player, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end

	if target:getName():lower() == "husky" then
		player:setStorageValue(Storage.TheIceIslands.HuskyKill, player:getStorageValue(Storage.TheIceIslands.HuskyKill) + 1)
	end
	return true
end

huskyKill:register()
