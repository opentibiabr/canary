local yielothaxKill = CreatureEvent("YielothaxDeath")
function yielothaxKill.onDeath(creature)
	setGlobalStorageValue(673003, getGlobalStorageValue(673003) + 1)
	return true
end

yielothaxKill:register()
