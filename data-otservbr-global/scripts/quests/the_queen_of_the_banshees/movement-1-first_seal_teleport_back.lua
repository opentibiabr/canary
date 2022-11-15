local teleportBack = MoveEvent()

function teleportBack.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if item.actionid ~= 25019 or not player then
		return true
	end

	player:teleportTo({x = 32266, y = 31886, z = 12})
	return true
end

teleportBack:aid(25019)
teleportBack:register()
