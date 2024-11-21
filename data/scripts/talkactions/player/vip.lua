local vip = TalkAction("!checkvip", "!vip")

function vip.onSay(player, words, param)
	if player:isVip() then
		player:sendVipStatus()
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You do not have VIP on your account.")
	end
	return true
end

vip:groupType("normal")
vip:register()
