local keeperKill = CreatureEvent("TheKeeperDeath")
function keeperKill.onDeath(creature)
	Game.setStorageValue(Storage.WrathoftheEmperor.Mission03, 0)
	return true
end

keeperKill:register()
