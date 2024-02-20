local wyda = CreatureEvent("Wyda")
function wyda.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	creature:say("It seems this was just an illusion.", TALKTYPE_MONSTER_SAY)
end

wyda:register()
