local nomadKill = CreatureEvent("NomadKill")
function nomadKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= "nomad" then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(Storage.ThievesGuild.Mission04) == 3 then
		player:setStorageValue(Storage.ThievesGuild.Mission04, 4)
	end

	return true
end

nomadKill:register()
