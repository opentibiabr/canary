local ec = EventCallback

function ec.onTurn(player, direction)
	if player:getGroup():getAccess() and player:getDirection() == direction then
		local nextPosition = player:getPosition()
		nextPosition:getNextPosition(direction)
		player:teleportTo(nextPosition, true)
	end
	return true
end

ec:register(--[[0]])
