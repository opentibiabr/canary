local goblinKill = CreatureEvent("MorrisGoblinKill")

function onKill(player, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end

	if not target:getName():lower() == "muglex clan footman" then
		return true
	end

	local killAmount = player:getStorageValue(Storage.Quest.Dawnport.MorrisGoblinCount)
	if player:getStorageValue(Storage.Quest.Dawnport.MorrisGoblin) == 1 and killAmount < 20 then
		player:setStorageValue(Storage.Quest.Dawnport.MorrisGoblinCount, killAmount + 1)
	end
	return true
end

goblinKill:register()
