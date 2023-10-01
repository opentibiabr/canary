local sanctuaryEntrance = MoveEvent()

function sanctuaryEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if item:getActionId() == 62346 then
			player:teleportTo(Position(31528, 32044, 8))
			player:getPosition():sendMagicEffect(252)
	elseif item:getActionId() == 62347 then
			player:teleportTo(Position(31526, 32021, 5))
			player:getPosition():sendMagicEffect(252)
	end
	return true
end

sanctuaryEntrance:type("stepin")
sanctuaryEntrance:aid(62346, 62347)
sanctuaryEntrance:register()
