local ec = EventCallback

function ec.onLookInTrade(player, partner, item, distance, description)
	return "You see " .. item:getDescription(distance)
end

ec:register(--[[0]])
