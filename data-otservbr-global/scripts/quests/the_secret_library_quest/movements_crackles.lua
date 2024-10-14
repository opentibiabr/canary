local movements_crackles = MoveEvent()

function movements_crackles.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local player = Player(creature:getId())

	player:teleportTo(Position(player:getPosition().x, player:getPosition().y, player:getPosition().z + 1))

	return true
end

movements_crackles:aid(4910)
movements_crackles:register()