local thePrimalMenaceDeath = CreatureEvent("ThePrimalMenaceDeath")

function thePrimalMenaceDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if not creature then
		return
	end

	local damageMap = creature:getMonster():getDamageMap()
	local gnompronaHazard = Hazard.getByName("hazard:gnomprona-gardens")
	local _, hazardPoints = gnompronaHazard:getHazardPlayerAndPoints(damageMap)

	for key, value in pairs(damageMap) do
		local player = Player(key)
		if player then
			if player:getStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Bosses.ThePrimalMenaceKilled) < 1 then
				player:setStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Bosses.ThePrimalMenaceKilled, 1)
			end

			if player:getHazardSystemPoints() == hazardPoints then
				gnompronaHazard:levelUp(player)
			end
		end

	end


end

thePrimalMenaceDeath:register()
