local autoLoot = TalkAction("!autoloot")

function autoLoot.onSay(player, words, param)
	if not configManager.getBoolean(configKeys.AUTOLOOT) then
		return true
	end
	if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) and configManager.getBoolean(configKeys.VIP_AUTOLOOT_VIP_ONLY) and not player:isVip() then
		player:sendCancelMessage("You need to be VIP to use this command!")
		return true
	end
	if param == "" then
		player:sendCancelMessage("You need to specify on/off param.")
		return true
	end
	if param == "on" then
		player:setStorageValue(STORAGEVALUE_AUTO_LOOT, 1)
		player:sendTextMessage(MESSAGE_LOOK, "You have successfully enabled your automatic looting!")
	elseif param == "off" then
		player:setStorageValue(STORAGEVALUE_AUTO_LOOT, -1)
		player:sendTextMessage(MESSAGE_LOOK, "You have successfully disabled your automatic looting!")
	end
	return true
end

autoLoot:separator(" ")
autoLoot:groupType("normal")
autoLoot:register()
