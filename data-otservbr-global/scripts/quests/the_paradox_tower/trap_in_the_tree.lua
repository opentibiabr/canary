local trap_in_the_tree = MoveEvent()

local trapPositions = {
	{ x = 32497, y = 31889, z = 07 },
	{ x = 32499, y = 31890, z = 07 },
	{ x = 32497, y = 31890, z = 07 },
	{ x = 32498, y = 31890, z = 07 },
	{ x = 32496, y = 31890, z = 07 },
	{ x = 32494, y = 31888, z = 07 },
	{ x = 32502, y = 31890, z = 07 },
}

function trap_in_the_tree.onStepIn(creature, item, toPosition, fromPosition)
	if creature:isPlayer() and Tile({ x = 32502, y = 31890, z = 07 }):getThingCount() == 2 then
		doTargetCombatHealth(0, creature, COMBAT_EARTHDAMAGE, -200, -200)
		for _, pos in ipairs(trapPositions) do
			Game.createItem(2121, 1, pos)
		end
	end
end

trap_in_the_tree:uid(25011)
trap_in_the_tree:register()
