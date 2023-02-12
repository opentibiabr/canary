local erayoHouse = MoveEvent()

function erayoHouse.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if not player:getItemById(3086, deepSearch) and not player:getCondition(CONDITION_INVISIBLE) then
		player:teleportTo(Position(32519, 32914, 7))
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:say("Why are you sneaking around to my house? Think I don't see you?", TALKTYPE_MONSTER_SAY)
	end
	return true
end

erayoHouse:position({x = 32517, y = 32909, z = 7})
erayoHouse:register()
