local fount = MoveEvent()

function fount.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end
	if player:getStorageValue(Storage.ForgottenKnowledge.Phial) >= 1 then
		player:teleportTo(Position(32722, 32242, 8))
		player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
		return true
	else
		player:teleportTo(Position(32614, 32269, 7))
		player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
	end
	return true
end

fount:type("stepin")
fount:id(27803, 27804, 27805, 27806)
fount:register()
