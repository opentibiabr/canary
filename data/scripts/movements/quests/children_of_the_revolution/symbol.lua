local symbol = MoveEvent()

function symbol.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.ChildrenoftheRevolution.StrangeSymbols) < 1 and
	player:getStorageValue(Storage.ChildrenoftheRevolution.Mission03) >= 2 then
		--Questlog, Children of the Revolution 'Mission 4: Zze Way of Zztonezz'
		player:setStorageValue(Storage.ChildrenoftheRevolution.Mission04, 2)
		player:setStorageValue(Storage.ChildrenoftheRevolution.StrangeSymbols, 1)
		player:say('A part of the floor before you displays an arrangement of strange symbols.', TALKTYPE_MONSTER_SAY)
	end
	return true
end

symbol:type("stepin")
symbol:uid(3166)
symbol:register()
