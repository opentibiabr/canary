local ferumbrasSoulSplinter = CreatureEvent("FerumbrasSoulSplinterDeath")

function ferumbrasSoulSplinter.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	Game.createMonster("ferumbras essence", creature:getPosition(), true, true)
	return true
end

ferumbrasSoulSplinter:register()

local ferumbrasEssenceImmortal = CreatureEvent("FerumbrasEssenceImmortal")
function ferumbrasEssenceImmortal.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	return 0, 0, 0, 0
end

ferumbrasEssenceImmortal:register()
