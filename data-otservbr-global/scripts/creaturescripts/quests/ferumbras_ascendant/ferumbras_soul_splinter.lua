local ferumbrasSoulSplinter = CreatureEvent("FerumbrasSoulSplinter")
function ferumbrasSoulSplinter.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local monster = Game.createMonster("ferumbras essence", creature:getPosition(), true, true)
	if not monster then
		return true
	end
	return true
end

ferumbrasSoulSplinter:register()
