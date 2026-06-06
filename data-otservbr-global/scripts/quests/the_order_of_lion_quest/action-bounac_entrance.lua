local bounacEntrance = Action()
function bounacEntrance.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:getActionId() == 59602 then
		if player:getLevel() < 250 then
			player:sendCancelMessage("You need at least level 250.")
			toPosition:sendMagicEffect(CONST_ME_POFF)
		else
			player:teleportTo(Position(32423, 32448, 7))
			toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
			Position(32423, 32448, 7):sendMagicEffect(CONST_ME_WATERSPLASH)
		end
	elseif item:getActionId() == 59603 then
		player:teleportTo(Position(33183, 31756, 7))
		Position(33183, 31756, 7):sendMagicEffect(CONST_ME_WATERSPLASH)
		toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
	end
	return true
end

bounacEntrance:aid(59602)
bounacEntrance:aid(59603)
bounacEntrance:register()

SimpleTeleport(Position(32475, 32497, 7), Position(32475, 32496, 6), nil, true)
SimpleTeleport(Position(32475, 32497, 6), Position(32475, 32498, 7), nil, true)
