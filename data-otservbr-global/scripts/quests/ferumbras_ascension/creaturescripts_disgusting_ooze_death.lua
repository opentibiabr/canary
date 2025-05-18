local disgustingOozeDeath = CreatureEvent("DisgustingOozeDeath")
function disgustingOozeDeath.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	if creature:getName():lower() ~= "disgusting ooze" then
		return true
	end

	if math.random(20) < 3 then
		for i = 1, 2 do
			local monster = Game.createMonster("disgusting ooze", creature:getPosition(), false, true)
			if not monster then
				return true
			end
			monster:setMaster(creature:getMaster())
		end
		creature:say("The ooze splits and regenerates.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

disgustingOozeDeath:register()
