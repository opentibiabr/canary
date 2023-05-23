local gravediggerFlask = Action()
function gravediggerFlask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 3998 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission11) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission12) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission12, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Done! Report back to Omrabas.')
		player:addItem(19086, 1)
		item:remove()
	end
	return true
end

gravediggerFlask:id(19085)
gravediggerFlask:register()