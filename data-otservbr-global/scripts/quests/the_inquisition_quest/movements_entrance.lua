local throneConfig = {
	{ storage = Storage.Quest.U7_9.ThePitsOfInferno.ThroneInfernatil, value = 1 },
	{ storage = Storage.Quest.U7_9.ThePitsOfInferno.ThroneTafariel, value = 1 },
	{ storage = Storage.Quest.U7_9.ThePitsOfInferno.ThroneVerminor, value = 1 },
	{ storage = Storage.Quest.U7_9.ThePitsOfInferno.ThroneApocalypse, value = 1 },
	{ storage = Storage.Quest.U7_9.ThePitsOfInferno.ThroneBazir, value = 1 },
	{ storage = Storage.Quest.U7_9.ThePitsOfInferno.ThroneAshfalor, value = 1 },
	{ storage = Storage.Quest.U7_9.ThePitsOfInferno.ThronePumin, value = 10 },
}

local function hasTouchedOneThrone(player)
	for i = 1, #throneConfig do
		local config = throneConfig[i]
		if player:getStorageValue(config.storage) == config.value then
			return true
		end
	end
	return false
end

local config = {
	{ position = { x = 33192, y = 31691, z = 14 }, destination = { x = 33168, y = 31683, z = 15 } },
}

local entrance = MoveEvent()
function entrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if hasTouchedOneThrone(player) and player:getLevel() >= 100 and player:getStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Questline) >= 20 then
		for i = 1, #config do
			local cfg = config[i]
			if Position(cfg.position.x, cfg.position.y, cfg.position.z) == player:getPosition() then
				local destination = Position(cfg.destination.x, cfg.destination.y, cfg.destination.z)
				player:teleportTo(destination)
				position:sendMagicEffect(CONST_ME_TELEPORT)
				destination:sendMagicEffect(CONST_ME_TELEPORT)
				return true
			end
		end
	end

	player:teleportTo(fromPosition, true)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

entrance:type("stepin")
for i = 1, #config do
	entrance:position(Position(config[i].position.x, config[i].position.y, config[i].position.z))
end

entrance:register()
