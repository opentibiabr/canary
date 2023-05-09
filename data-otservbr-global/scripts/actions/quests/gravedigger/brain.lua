local gravediggerBrain = Action()
function gravediggerBrain.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rightbrain = Tile(Position(33025, 32332, 10))
	local leftbrain = Tile(Position(33020, 32332, 10))
	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission08) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission09) < 1 then
		if leftbrain:getItemById(9659) and rightbrain:getItemById(9659) then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission09, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<brzzl> <frzzp> <fsssh>')
			leftbrain:getItemById(9659):remove()
			rightbrain:getItemById(9659):remove()
			Game.createItem(19078, 1, Position(33022, 32332, 10))
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'No brains')
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have already got your brain')
	end
	return true
end

gravediggerBrain:aid(4631)
gravediggerBrain:register()