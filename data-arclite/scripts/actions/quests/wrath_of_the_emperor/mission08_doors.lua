local doors = Action()
function doors.onUse(player, target)
	if not player then
		return true
	end
	local pos = player:getPosition()
	local tpos = target:getPosition()
	if pos.y == 31112 then
		player:teleportTo(Position(tpos.x, tpos.y-1, 12))
		pos:sendMagicEffect(CONST_ME_POFF)
	else
		player:teleportTo(Position(tpos.x, tpos.y+1, 12))
		pos:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

doors:id(11141)
doors:register()
