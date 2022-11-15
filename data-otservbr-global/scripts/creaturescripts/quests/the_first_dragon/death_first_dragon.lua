local deathFirstDragon = CreatureEvent("FirstDragonDeath")

local destinations = {
	Position(33616, 31020, 13),
	Position(33617, 31020, 13),
	Position(33618, 31020, 13),
	Position(33616, 31021, 13),
	Position(33617, 31021, 13),
	Position(33618, 31021, 13),
	Position(33616, 31022, 13),
	Position(33617, 31022, 13),
	Position(33618, 31022, 13),
	Position(33616, 31023, 13),
	Position(33617, 31023, 13),
	Position(33618, 31023, 13),
	Position(33616, 31024, 13),
	Position(33617, 31024, 13),
	Position(33618, 31024, 13)
}

function deathFirstDragon.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local spectators = Game.getSpectators(Position(33617, 31023, 14), false, false, 14, 14, 14, 14)
	for i = 1, #spectators do
		local spec = spectators[i]
		if spec:isPlayer() then
			spec:teleportTo(Position(33617, 31020, 13))
			spec:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spec:setStorageValue(Storage.FirstDragon.Feathers, 1)
		end
	end
	return true
end

deathFirstDragon:register()
