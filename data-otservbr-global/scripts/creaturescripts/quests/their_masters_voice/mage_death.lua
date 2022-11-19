local mageDeath = CreatureEvent("MageDeath")
function mageDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified)
    return Mage_onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified)
end

mageDeath:register()
