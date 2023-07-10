local goblinKill = CreatureEvent("MorrisGoblinKill")
function goblinKill.onKill(player, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end

	if target:getName():lower() ~= "muglex clan footman" then
		return true
	end

	local killAmount = player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblinCount)
	if player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblin) == 1 and killAmount < 20 then
		player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblinCount, killAmount + 1)
	end
	return true
end

goblinKill:register()
