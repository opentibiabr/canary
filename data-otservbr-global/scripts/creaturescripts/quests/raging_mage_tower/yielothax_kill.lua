local yielothaxKill = CreatureEvent("YielothaxDeath")
function yielothaxKill.onDeath(creature)
	Game.setStorageValue(673003, Game.getStorageValue(673003) + 1)
	return true
end

yielothaxKill:register()
