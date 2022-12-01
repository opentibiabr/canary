local lizardNobleKill = CreatureEvent("LizardNobleKill")
function lizardNobleKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'lizard noble' then
		return true
	end

	local player = creature:getPlayer()
	local storage = player:getStorageValue(Storage.WrathoftheEmperor.Mission07)
	if storage >= 0 and storage < 6 then
		player:setStorageValue(Storage.WrathoftheEmperor.Mission07, math.max(1, storage) + 1)
	end

	return true
end

lizardNobleKill:register()
