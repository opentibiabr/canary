local destroyPies = MoveEvent()

function destroyPies.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.WhatAFoolish.PieBoxTimer) > os.time() then
		player:getStorageValue(Storage.WhatAFoolish.PieBoxTimer, 1)
	end

	local pieBox = player:getItemById(7484, true)
	if not pieBox then
		return true
	end

	pieBox:transform(2250)
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	player:say("Stand still! These pies are confiscated!", 
		TALKTYPE_MONSTER_SAY, false, player, Position(33189, 31788, 7))
	player:say("Dirty pie smuggler!", TALKTYPE_MONSTER_SAY, false, player, Position(33193, 31788, 7))
	return true
end

destroyPies:type("stepin")
destroyPies:aid(4201)
destroyPies:register()
