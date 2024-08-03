-- Usage talkaction: "!emote on" or "!emote off"
local emoteSpell = TalkAction("!emote")

function emoteSpell.onSay(player, words, param)
	if configManager.getBoolean(configKeys.EMOTE_SPELLS) == false then
		player:sendTextMessage(MESSAGE_LOOK, "Emote spells have been disabled by the administrator.")
		return true
	end

	if param == "" then
		player:sendCancelMessage("Please specify the parameter: 'on' to activate or 'off' to deactivate.")
		return true
	end

	if param == "on" then
		player:setStorageValue(STORAGEVALUE_EMOTE, 1)
		player:sendTextMessage(MESSAGE_LOOK, "You have activated emote spells.")
	elseif param == "off" then
		player:setStorageValue(STORAGEVALUE_EMOTE, 0)
		player:sendTextMessage(MESSAGE_LOOK, "You have deactivated emote spells.")
	end
	return true
end

emoteSpell:separator(" ")
emoteSpell:groupType("normal")
emoteSpell:register()
