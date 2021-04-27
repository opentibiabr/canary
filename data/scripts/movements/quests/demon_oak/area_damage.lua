local areaDamage = MoveEvent()

function areaDamage.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if math.random(24) == 1 then
		doTargetCombatHealth(0, player, COMBAT_EARTHDAMAGE, -270, -310, CONST_ME_BIGPLANTS)
	end
	return true
end

areaDamage:type("stepin")
areaDamage:id(8292)
areaDamage:register()
