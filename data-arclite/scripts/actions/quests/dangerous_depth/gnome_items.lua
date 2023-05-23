local dangerousDepthItems = Action()
function dangerousDepthItems.onUse(player, item)
	if item:getUniqueId() == 57235 then
		if player:getStorageValue(Storage.DangerousDepths.Gnomes.GnomeChartPaper) == 1 then -- Permissão para usar o baú == 1 then
			player:addItem(31931, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a gnome charts.")
			player:setStorageValue(Storage.DangerousDepths.Gnomes.GnomeChartPaper, 2)
		elseif player:getStorageValue(Storage.DangerousDepths.Gnomes.GnomeChartPaper) == 2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can not use this item again.")
		end
	elseif item:getUniqueId() == 57236 then
		if player:getStorageValue(Storage.DangerousDepths.Gnomes.GnomeChartChest) == 1 then -- Permissão para usar o baú == 1 then
			player:addItem(31930, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a gnome trignometre.")
			player:setStorageValue(Storage.DangerousDepths.Gnomes.GnomeChartChest, 2)
		elseif player:getStorageValue(Storage.DangerousDepths.Gnomes.GnomeChartChest) == 2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
		end
	end
	return true
end

dangerousDepthItems:uid(57235,57236)
dangerousDepthItems:register()