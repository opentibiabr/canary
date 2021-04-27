local minotaurKill = CreatureEvent("MorrisMinotaurKill")

function minotaurKill.onKill(player, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end

	if not target:getName():lower() == "minotaur bruiser" then
		return true
	end

	local killAmount = player:getStorageValue(Storage.Quest.Dawnport.MorrisMinosCount)
	if player:getStorageValue(Storage.Quest.Dawnport.MorrisMinos) == 1 and killAmount < 20 then
		player:setStorageValue(Storage.Quest.Dawnport.MorrisMinosCount, killAmount + 1)
	end
	return true
end

minotaurKill:register()
