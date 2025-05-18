local childrenGrease = Action()

function childrenGrease.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 8013 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Questline) == 13 then
		player:setStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Questline, 14)
		player:setStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission04, 4) --Questlog, Children of the Revolution "Mission 4: Zze Way of Zztonezz"
		item:remove()
		player:say("Due to being extra greasy, the leavers can now be moved.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

childrenGrease:id(10189)
childrenGrease:register()
