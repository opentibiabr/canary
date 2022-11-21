local wigglerKill = CreatureEvent("WigglerKill")
function wigglerKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'wiggler' then
		return true
	end

	local player = creature:getPlayer()
	local value = player:getStorageValue(Storage.BigfootBurden.ExterminatedCount)
	if value < 10 and player:getStorageValue(Storage.BigfootBurden.MissionExterminators) == 1 then
		player:setStorageValue(Storage.BigfootBurden.ExterminatedCount, value + 1)
	end
	return true
end

wigglerKill:register()
