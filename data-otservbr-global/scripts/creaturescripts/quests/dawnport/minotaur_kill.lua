local minotaurKill = CreatureEvent("MorrisMinotaurKill")
function minotaurKill.onKill(player, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end

	if target:getName():lower() ~= "minotaur bruiser" then
		return true
	end

	local killAmount = player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinosCount)
	if player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinos) == 1 and killAmount < 20 then
		player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinosCount, killAmount + 1)
	end
	return true
end

minotaurKill:register()
