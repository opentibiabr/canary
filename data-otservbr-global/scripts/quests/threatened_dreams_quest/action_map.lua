local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getItemCount(24943) >= 1 and player:getItemCount(24944) >= 1 and player:getItemCount(24945) >= 1 and player:getItemCount(24946) >= 1 then
		player:removeItem(24943, 1)
		player:removeItem(24944, 1)
		player:removeItem(24945, 1)
		player:removeItem(24946, 1)
		player:addItem(24947, 1)
		player:say("The old map is artfully drawn. It tells you to search for a stone sun mosaic in the very south of Thais.", TALKTYPE_MONSTER_SAY)
		player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.GrumpyStone, 4)
		return true
	else
		player:say("You need all four map parts to assemble the complete map.", TALKTYPE_MONSTER_SAY)
		return false
	end
end

action:id(24943)
action:id(24944)
action:id(24945)
action:id(24946)
action:register()
