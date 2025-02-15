local talk = TalkAction("!autoloot")

function talk.onSay(player, words, param)
	if not configManager.getBoolean(configKeys.AUTOLOOT) then
		return true
	end

	if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) and configManager.getBoolean(configKeys.VIP_AUTOLOOT_VIP_ONLY) and not player:isVip() then
		player:sendCancelMessage("You need to be VIP to use this command!")
		return true
	end

	if param == "" then
		player:sendCancelMessage("You need to specify a valid parameter (all, on, off).")
		return true
	end

	if param == "all" then
		player:kv():scoped("features"):set("autoloot", 2)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "AutoLoot is now enabled for all kills (including bosses).")
	elseif param == "on" then
		player:kv():scoped("features"):set("autoloot", 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "AutoLoot is now enabled for all regular kills (no bosses).")
	elseif param == "off" then
		player:kv():scoped("features"):set("autoloot", 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "AutoLoot is now disabled.")
	else
		player:sendCancelMessage("Invalid parameter. Use 'all', 'on', or 'off'.")
	end
	return true
end

talk:separator(" ")
talk:setDescription("[Usage]: !autoloot <all|on|off> - Enable or disable AutoLoot for kills.")
talk:groupType("normal")
talk:register()
