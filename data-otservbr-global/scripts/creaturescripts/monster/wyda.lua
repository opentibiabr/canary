local wyda = CreatureEvent("Wyda")
function wyda.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	creature:say("It seems this was just an illusion.", TALKTYPE_ORANGE_1)
end
wyda:register()
