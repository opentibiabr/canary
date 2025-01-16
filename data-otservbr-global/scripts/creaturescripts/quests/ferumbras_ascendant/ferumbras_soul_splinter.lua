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

local config = AscendingFerumbrasConfig
local ferumbrasSoulSplinterCustom = CreatureEvent("FerumbrasSoulSplinterDeathCustom")
function ferumbrasSoulSplinterCustom.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.FerumbrasEssence, Game.getStorageValue(GlobalStorage.FerumbrasAscendant.FerumbrasEssence) + 1)
	if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.FerumbrasEssence) >= 8 then
		Game.createMonster("Destabilized Ferumbras", config.bossPos, true, true)
		local spectators = Game.getSpectators(config.bossPos, false, false, 20, 20, 20, 20)
		for i = 1, #spectators do
			local spectator = spectators[i]
			if spectator:isMonster() and spectator:getName():lower() == "rift invader" then
				spectator:remove()
			end
		end
		for i = 1, config.maxSummon do
			Game.createMonster("Rift Fragment", Position(math.random(33381, 33403), math.random(31462, 31483), 14), true, true)
		end
	end
	return true
end
ferumbrasSoulSplinterCustom:register()

local ferumbrasEssenceImmortal = CreatureEvent("FerumbrasEssenceImmortal")
function ferumbrasEssenceImmortal.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	return 0, 0, 0, 0
end

ferumbrasEssenceImmortal:register()
