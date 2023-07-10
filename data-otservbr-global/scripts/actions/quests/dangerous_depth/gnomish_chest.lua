local dangerousDepthChest = Action()
function dangerousDepthChest.onUse(player, item)
	if player:getStorageValue(Storage.DangerousDepths.Scouts.GnomishChest) == 1 then
		player:addItem(30733, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found gnomish pesticides.")
		player:setStorageValue(Storage.DangerousDepths.Scouts.GnomishChest, 2)
	elseif player:getStorageValue(Storage.DangerousDepths.Scouts.GnomishChest) == 2 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
	end
	return true
end

dangerousDepthChest:uid(57234)
dangerousDepthChest:register()