local config = {
	entrance = {
		positions = {
			Position(32350, 31030, 3),
			Position(32349, 31030, 3),
		},
		destination = Position(32374, 31171, 8),
	},
	exit = {
		position = Position(32374, 31173, 8),
		destination = Position(32349, 31032, 3),
	},
}

local soulpitEntrance = MoveEvent()

function soulpitEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if not config.entrance.destination then
		return true
	end

	player:teleportTo(config.entrance.destination)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

soulpitEntrance:type("stepin")
for value in pairs(config.entrance.positions) do
	soulpitEntrance:position(config.entrance.positions[value])
end
soulpitEntrance:register()

local soulpitExit = MoveEvent()

function soulpitExit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if not config.exit then
		return true
	end

	player:teleportTo(config.exit.destination)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

soulpitExit:type("stepin")
soulpitExit:position(config.exit.position)
soulpitExit:register()
