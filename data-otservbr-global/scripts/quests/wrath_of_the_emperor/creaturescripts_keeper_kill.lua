local keeperKill = CreatureEvent("TheKeeperDeath")
function keeperKill.onDeath(creature)
	Game.setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission03, 0)
	return true
end

keeperKill:register()
