local keeperKill = CreatureEvent("KeeperKill")
function keeperKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() == 'the keeper' then
		Game.setStorageValue(Storage.WrathoftheEmperor.Mission03, 0)
	end
	return true
end

keeperKill:register()
