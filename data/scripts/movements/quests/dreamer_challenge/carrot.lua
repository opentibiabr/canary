local carrot = MoveEvent()

function carrot.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.uid == 2241 then
		if player:getItemCount(2684) > 0 then
			player:teleportTo(Position(32861, 32235, 9))
			player:removeItem(2684, 1)
		else
			player:teleportTo(fromPosition)
			doAreaCombatHealth(player, COMBAT_FIREDAMAGE, fromPosition, 0, -10, -20, CONST_ME_HITBYFIRE)
		end
	elseif item.uid == 2242 then
		player:teleportTo(Position(32861, 32240, 9))
	end
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

carrot:type("stepin")
carrot:uid(2241, 2242)
carrot:register()
