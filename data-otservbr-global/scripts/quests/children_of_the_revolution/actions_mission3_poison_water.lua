local childrenPoison = Action()
function childrenPoison.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 8012 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Questline) == 10 then
		player:setStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Questline, 11)
		player:setStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission03, 2) --Questlog, Children of the Revolution "Mission 3: Zee Killing Fieldzz"
		item:remove()
		player:say("The rice has been poisoned. This will weaken the Emperor's army significantly. Return and tell Zalamon about your success.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

childrenPoison:id(10183)
childrenPoison:register()
