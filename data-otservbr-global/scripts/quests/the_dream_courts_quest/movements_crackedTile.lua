local movements_crackedTile = MoveEvent()

function movements_crackedTile.onStepIn(creature, item, position, fromPosition)
	local player = Player(creature:getId())

	if not player then
		return true
	end

	local min = player:getMaxHealth() * 0.2
	local max = player:getMaxHealth() * 0.5

	doTargetCombat(0, player, COMBAT_DEATHDAMAGE, -min, -max, CONST_ME_MORTAREA, ORIGIN_NONE)

	return true
end

movements_crackedTile:aid(23106)
movements_crackedTile:register()
