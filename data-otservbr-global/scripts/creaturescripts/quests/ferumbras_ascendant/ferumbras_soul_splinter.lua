local ferumbrasSoulSplinter = CreatureEvent("FerumbrasSoulSplinter")
function ferumbrasSoulSplinter.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local targetMonster = creature:getMonster()
	if not targetMonster or targetMonster:getName():lower() ~= 'ferumbras soul splinter' then
		return true
	end

	local monster = Game.createMonster('ferumbras essence', targetMonster:getPosition(), true, true)
	if not monster then
		return true
	end
	return true
end

ferumbrasSoulSplinter:register()
