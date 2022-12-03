local devourerStorage = CreatureEvent("DevourerStorage")
function devourerStorage.onDeath(player)
	player:setStorageValue(14334, -1)
	player:setStorageValue(14335, -1)
	player:setStorageValue(14336, -1)
	player:unregisterEvent("DevourerStorage")
	return true
end
devourerStorage:register()
