local symbol = MoveEvent()

function symbol.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.StrangeSymbols) < 1 and player:getStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission03) >= 2 then
		--Questlog, Children of the Revolution 'Mission 4: Zze Way of Zztonezz'
		player:setStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission04, 2)
		player:setStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.StrangeSymbols, 1)
		player:say("A part of the floor before you displays an arrangement of strange symbols.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

symbol:type("stepin")
symbol:position({ x = 33357, y = 31123, z = 5 })
symbol:register()
