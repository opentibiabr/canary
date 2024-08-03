local ferumbrasSoulSplinter = CreatureEvent("FerumbrasSoulSplinterDeath")

function ferumbrasSoulSplinter.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local monster = Game.createMonster("ferumbras essence", creature:getPosition(), true, true)
	if not monster then
		logger.error("[ferumbrasSoulSplinter.onDeath] cannot create monster on position {}", creature:getPosition():toString())
		return true
	end
	return true
end

ferumbrasSoulSplinter:register()

local ferumbrasEssenceImmortal = CreatureEvent("FerumbrasEssenceImmortal")
function ferumbrasEssenceImmortal.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	return 0, 0, 0, 0
end

ferumbrasEssenceImmortal:register()
