local horseDeath = CreatureEvent("HorseDeath")

function horseDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local targetMonster = creature:getMonster()
	if not targetMonster then
		return true
	end

	local name = targetMonster:getName():lower()
	if name == "horse" or name == "wild horse" then
		targetMonster:say("With its last strength the horse runs to safety.", TALKTYPE_MONSTER_SAY)
	end

	return true
end

horseDeath:register()
