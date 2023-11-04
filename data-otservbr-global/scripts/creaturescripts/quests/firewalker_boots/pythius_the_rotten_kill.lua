local firewalkerBootsKill = CreatureEvent("PythiusTheRottenDeath")
function firewalkerBootsKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	creature:say("NICE FIGHTING LITTLE WORM, YOUR VICTORY SHALL BE REWARDED!", TALKTYPE_MONSTER_SAY, false, player, Position(32572, 31405, 15))

	local player = Player(mostDamageKiller)
	player:teleportTo(Position(32577, 31403, 15))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

firewalkerBootsKill:register()
