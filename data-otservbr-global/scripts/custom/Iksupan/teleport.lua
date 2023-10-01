local IksupanTp = Action()
function IksupanTp.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:getActionId() == 14552 then
			player:teleportTo({x = 32728, y = 32876, z = 7})
			toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
			Position({x = 32942, y = 32031, z = 7}):sendMagicEffect(CONST_ME_WATERSPLASH)
	elseif item:getActionId() == 25018 then		
		player:teleportTo({x = 34016, y = 31920, z = 8})
		Position({x = 33774, y = 31347, z = 7}):sendMagicEffect(CONST_ME_WATERSPLASH)
		toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
	elseif item:getActionId() == 14553 then		
		player:teleportTo({x = 34045, y = 31750, z = 10})
		Position({x = 33774, y = 31347, z = 7}):sendMagicEffect(CONST_ME_WATERSPLASH)
		toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
	end	
	return true
end
IksupanTp:aid(25018, 14552, 14553)
IksupanTp:register()


