local lizardMagistratusKill = CreatureEvent("LizardMagistratusKill")
function lizardMagistratusKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'lizard magistratus' then
		return true
	end

	local player = creature:getPlayer()
	local storage = player:getStorageValue(Storage.WrathoftheEmperor.Mission06)
	if storage >= 0 and storage < 4 then
		player:setStorageValue(Storage.WrathoftheEmperor.Mission06, math.max(1, storage) + 1)
	end

	return true
end

lizardMagistratusKill:register()
