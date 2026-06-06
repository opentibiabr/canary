local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if toPosition.x == 32363 and toPosition.y == 32416 and toPosition.z == 7 then
		if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.GrumpyStone) == 4 then
			player:addItem(25698, 1)
			player:addItem(25737, 5)
			player:addItem(24390, 5)
			player:say("You discover something shiny that is hidden beneath the stones.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.GrumpyStone, 5)
			return true
		else
			return false
		end
	end
	return false
end

action:id(25380)
action:register()
