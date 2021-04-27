local cultsOfTibiaCrate = Action()
function cultsOfTibiaCrate.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local posCrate = Position(33300, 32277, 12)
	-- Document
	if item:getPosition() == posCrate then
		if player:getStorageValue(Storage.CultsOfTibia.MotA.Mission) == 7 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Perfect! You took a wonderful loupe from this crate.")
			player:addItem(28667, 1)
			player:setStorageValue(Storage.CultsOfTibia.MotA.Mission, 8)
			elseif player:getStorageValue(Storage.CultsOfTibia.MotA.Mission) > 7 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already took the magnifier.")
			else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This crate belongs to Angelo. You should talk to him before taking something out.")
		end
	end
	return true
end

cultsOfTibiaCrate:aid(5523)
cultsOfTibiaCrate:register()