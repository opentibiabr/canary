local firewalkerBootsKill = CreatureEvent("PythiusTheRottenKill")
function firewalkerBootsKill.onKill(player, target)
	if not target:isMonster() or target:getName():lower() ~= "pythius the rotten" then
		return true
	end

	target:say("NICE FIGHTING LITTLE WORM, YOUR VICTORY SHALL BE REWARDED!", TALKTYPE_MONSTER_SAY, false, player, Position(32572, 31405, 15))

	player:teleportTo(Position(32577, 31403, 15))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

firewalkerBootsKill:register()
