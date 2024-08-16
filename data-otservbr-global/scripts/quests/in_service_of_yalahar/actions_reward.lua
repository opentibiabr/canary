local inServiceYalaharReward = Action()
function inServiceYalaharReward.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.uid == 3088 then
		if player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 53 then
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline, 54)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission10, 5) -- StorageValue for Questlog "Mission 10: The Final Battle"
			player:addItem(8862, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a yalahari armor.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		end
	elseif item.uid == 3089 then
		if player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 53 then
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline, 54)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission10, 5) -- StorageValue for Questlog "Mission 10: The Final Battle"
			player:addItem(8864, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a yalahari mask.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		end
	elseif item.uid == 3090 then
		if player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 53 then
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline, 54)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission10, 5) -- StorageValue for Questlog "Mission 10: The Final Battle"
			player:addItem(8863, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a yalahari leg piece.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		end
	end

	return true
end

inServiceYalaharReward:uid(3088, 3089, 3090)
inServiceYalaharReward:register()
