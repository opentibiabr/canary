local energyPrismDeath = CreatureEvent("EnergyPrismDeath")

function energyPrismDeath.onKill(creature, target)
	stopEvent(Storage.ForgottenKnowledge.LloydEvent)
	local tile = Tile(Position(32799, 32826, 14))
	if not tile then
		return false
	end
	local lloyd = tile:getTopCreature()
	if lloyd then
		lloyd:teleportTo(Position(32799, 32829, 14))
		lloyd:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

energyPrismDeath:register()
