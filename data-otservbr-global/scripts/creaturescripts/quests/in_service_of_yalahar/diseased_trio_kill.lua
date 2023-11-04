local diseasedTrio = {
	["diseased bill"] = Storage.InServiceofYalahar.DiseasedBill,
	["diseased dan"] = Storage.InServiceofYalahar.DiseasedDan,
	["diseased fred"] = Storage.InServiceofYalahar.DiseasedFred,
}

local diseasedTrioKill = CreatureEvent("DiseasedTrioDeath")
function diseasedTrioKill.onDeath(creature)
	local bossStorage = diseasedTrio[creature:getName():lower()]
	if not bossStorage then
		return true
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(bossStorage) < 1 then
			player:setStorageValue(bossStorage, 1)
			player:say("You slayed " .. creature:getName() .. ".", TALKTYPE_MONSTER_SAY)
		end

		if player:getStorageValue(Storage.InServiceofYalahar.DiseasedDan) == 1 and player:getStorageValue(Storage.InServiceofYalahar.DiseasedBill) == 1 and player:getStorageValue(Storage.InServiceofYalahar.DiseasedFred) == 1 and player:getStorageValue(Storage.InServiceofYalahar.AlchemistFormula) ~= 1 then
			player:setStorageValue(Storage.InServiceofYalahar.AlchemistFormula, 0)
		end
	end)
	return true
end

diseasedTrioKill:register()
