local config = {
	[24901] = {backPos = Position(33619, 32306, 9)
	}
}

local kroazurExit = MoveEvent()

function kroazurExit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	
	local teleport = config[item.actionid]
	if not teleport then
		return true
	end
	position:sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(teleport.backPos)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

kroazurExit:type("stepin")
kroazurExit:aid(24901)
kroazurExit:register()
