local servantDeath = CreatureEvent("ServantDeath")
function servantDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified)
    return Servant_onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified)
end

servantDeath:register()
