local thePrimalMenaceDeath = CreatureEvent("ThePrimalMenaceDeath")
function thePrimalMenaceDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	local damageMap = creature:getMonster():getDamageMap()

	for key, value in pairs(damageMap) do
		local player = Player(key)
		if player and player:getStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Bosses.ThePrimalMenaceKilled) < 1 then
			player:setStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Bosses.ThePrimalMenaceKilled, 1)
		end
	end
end

thePrimalMenaceDeath:register()
