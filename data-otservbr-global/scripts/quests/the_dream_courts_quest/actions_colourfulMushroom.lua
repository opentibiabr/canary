local actions_colourfulMushroom = Action()

function actions_colourfulMushroom.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.MushRoom) == 1 then
		player:removeItem(30009, 1)
		player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.MushRoom, 2)
		player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Count, player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Count) + 1)
		return true
	end
end

actions_colourfulMushroom:id(30009)
actions_colourfulMushroom:register()
