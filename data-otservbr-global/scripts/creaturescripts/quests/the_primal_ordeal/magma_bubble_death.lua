local magmaBubbleDeath = CreatureEvent("MagmaBubbleDeath")
function magmaBubbleDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if not creature then
		return
	end

	local damageMap = creature:getMonster():getDamageMap()

	for key, value in pairs(damageMap) do
		local player = Player(key)
		if player and player:getStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Bosses.MagmaBubbleKilled) < 1 then
			player:setStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Bosses.MagmaBubbleKilled, 1) -- Access to The primal menace boss fight
		end
	end
end

magmaBubbleDeath:register()
