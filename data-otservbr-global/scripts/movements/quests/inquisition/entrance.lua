local throneStorages = {
	Storage.Quest.U7_9.ThePitsOfInferno.ThroneInfernatil,
	Storage.Quest.U7_9.ThePitsOfInferno.ThroneTafariel,
	Storage.Quest.U7_9.ThePitsOfInferno.ThroneVerminor,
	Storage.Quest.U7_9.ThePitsOfInferno.ThroneApocalypse,
	Storage.Quest.U7_9.ThePitsOfInferno.ThroneBazir,
	Storage.Quest.U7_9.ThePitsOfInferno.ThroneAshfalor,
	Storage.Quest.U7_9.ThePitsOfInferno.ThronePumin,
}

local function hasTouchedOneThrone(player)
	for i = 1, #throneStorages do
		if player:getStorageValue(throneStorages[i]) == 1 then
			return true
		end
	end
	return false
end

local entrance = MoveEvent()

function entrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if hasTouchedOneThrone(player) and player:getLevel() >= 100 and player:getStorageValue(Storage.TheInquisition.Questline) >= 20 then
		local destination = Position(33168, 31683, 15)
		player:teleportTo(destination)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	player:teleportTo(fromPosition, true)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

entrance:type("stepin")
entrance:uid(9014)
entrance:register()
