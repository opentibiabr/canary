local theHiddenCoalWagon = Action()
function theHiddenCoalWagon.onUse(player, item, fromPosition, itemEx, toPosition)
	if player:getStorageValue(Storage.DwarvenLegs) < 1 then
		player:teleportTo({x = 32693, y = 31460, z = 13})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	else
		player:say("Zzz Dont working.", TALKTYPE_ORANGE_1)
		return true
	end
	return false
end

theHiddenCoalWagon:aid(50117)
theHiddenCoalWagon:register()