local curseDeath = CreatureEvent("CursedChestsDeath")
function curseDeath.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	return CursedChests_onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
end

curseDeath:register()
