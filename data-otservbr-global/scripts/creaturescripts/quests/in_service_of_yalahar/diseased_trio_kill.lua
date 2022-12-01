local diseasedTrio = {
	['diseased bill'] = Storage.InServiceofYalahar.DiseasedBill,
	['diseased dan'] = Storage.InServiceofYalahar.DiseasedDan,
	['diseased fred'] = Storage.InServiceofYalahar.DiseasedFred
}

local diseasedTrioKill = CreatureEvent("DiseasedTrio")
function diseasedTrioKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	local bossStorage = diseasedTrio[targetMonster:getName():lower()]
	if not bossStorage then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(bossStorage) < 1 then
		player:setStorageValue(bossStorage, 1)
		player:say('You slayed ' .. targetMonster:getName() .. '.', TALKTYPE_MONSTER_SAY)
	end

	if (player:getStorageValue(Storage.InServiceofYalahar.DiseasedDan) == 1 and
	player:getStorageValue(Storage.InServiceofYalahar.DiseasedBill) == 1 and
	player:getStorageValue(Storage.InServiceofYalahar.DiseasedFred) == 1 and
	player:getStorageValue(Storage.InServiceofYalahar.AlchemistFormula) ~= 1) then
		player:setStorageValue(Storage.InServiceofYalahar.AlchemistFormula, 0)
	end
	return true
end

diseasedTrioKill:register()
