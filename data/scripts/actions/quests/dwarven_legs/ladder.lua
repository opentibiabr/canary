local dwarvenLadder = Action()
function dwarvenLadder.onUse(player, item, fromPosition, itemEx, toPosition)
	if player:getStorageValue(Storage.DwarvenLegs) < 1 then
		player:teleportTo({x = 32681, y = 31507, z = 10})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	else
		player:say("Zzz Dont working.", TALKTYPE_ORANGE_1)
		return true
	end
	return false
end

dwarvenLadder:aid(42139)
dwarvenLadder:register()