local bookdeepling = Action()

function bookdeepling.onUse(player, item, frompos, item2, topos)
	if player:getStorageValue(Storage.TheSecretLibrary.LiquidDeath) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"The descriptions in this book look like plans detailing the launch of a large-scale assault.")
		player:setStorageValue(Storage.TheSecretLibrary.LiquidDeath, 2)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "oh sorry")
	end
	return true
end

bookdeepling:uid(1073)
bookdeepling:register()
