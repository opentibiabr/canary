local thePrimalMenaceDeath = CreatureEvent("ThePrimalMenaceDeath")

function thePrimalMenaceDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if not creature then
		return
	end

	local damageMap = creature:getMonster():getDamageMap()
	local hazard = Hazard.getByName("hazard.gnomprona-gardens")
	if not hazard then
		return
	end
	local _, hazardPoints = hazard:getHazardPlayerAndPoints(damageMap)

	for key, value in pairs(damageMap) do
		local player = Player(key)
		if player then
			if player:getStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Bosses.ThePrimalMenaceKilled) < 1 then
				player:setStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Bosses.ThePrimalMenaceKilled, 1)
			end

			if hazard:getPlayerMaxLevel(player) == hazardPoints then
				hazard:levelUp(player)
			end
		end
	end
end

thePrimalMenaceDeath:register()
