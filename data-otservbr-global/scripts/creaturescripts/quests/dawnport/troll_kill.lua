local trollKill = CreatureEvent("MorrisTrollKill")
function trollKill.onKill(player, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end

	if target:getName():lower() ~= "mountain troll" then
		return true
	end

	local killAmount = player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisTrollCount)
	if player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorriskTroll) == 1 and killAmount < 20 then
		player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisTrollCount, killAmount + 1)
	end
	return true
end

trollKill:register()
