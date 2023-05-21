-- Usage talkaction: "!emote on" or "!emote off"
local emoteSpell = TalkAction("!emote")

function emoteSpell.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("You need to specify on/off param.")
		return false
	end
	if param == "on" then
		player:setStorageValue(STORAGEVALUE_EMOTE, 1)
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You activated emoted spells")
	elseif param == "off" then
		player:setStorageValue(STORAGEVALUE_EMOTE, 0)
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You desactivated emoted spells")
	end
	return true
end

emoteSpell:separator(" ")
emoteSpell:register()
