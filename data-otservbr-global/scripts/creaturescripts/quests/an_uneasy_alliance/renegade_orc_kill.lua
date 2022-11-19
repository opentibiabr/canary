local renegadeOrcKill = CreatureEvent("RenegadeOrcKill")
function renegadeOrcKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end
	if targetMonster:getName():lower() ~= "renegade orc" then
		return true
	end
	local player = creature:getPlayer()
	if player:getStorageValue(Storage.Quest.U8_54.AnUneasyAlliance.QuestDoor) == 0 then
		player:setStorageValue(Storage.Quest.U8_54.AnUneasyAlliance.QuestDoor, 1)
	end
	return true
end

renegadeOrcKill:register()
