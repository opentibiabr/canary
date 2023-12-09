local talkaction = TalkAction("!hiddenshop")

function talkaction.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("You need to specify on/off param.")
		return true
	end
	if param == "on" then
		player:kv():set("npc-shop-hidden-sell-item", true)
		player:sendTextMessage(MESSAGE_LOOK, "You activated hidden sell shop items.")
	elseif param == "off" then
		player:kv():set("npc-shop-hidden-sell-item", false)
		player:sendTextMessage(MESSAGE_LOOK, "You deactivated hidden sell shop items")
	end
	return true
end

talkaction:separator(" ")
talkaction:groupType("normal")
talkaction:register()
