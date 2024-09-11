local diseasedTrio = {
	["diseased bill"] = Storage.Quest.U8_4.InServiceOfYalahar.DiseasedBill,
	["diseased dan"] = Storage.Quest.U8_4.InServiceOfYalahar.DiseasedDan,
	["diseased fred"] = Storage.Quest.U8_4.InServiceOfYalahar.DiseasedFred,
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

		if player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.DiseasedDan) == 1 and player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.DiseasedBill) == 1 and player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.DiseasedFred) == 1 and player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.AlchemistFormula) ~= 1 then
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.AlchemistFormula, 0)
		end
	end)
	return true
end

diseasedTrioKill:register()
