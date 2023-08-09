local vip = TalkAction("!checkvip", "!vip")

function vip.onSay(player, words, param)
	local days = player:getVipDays()
	if days == 0 then
		local msg = 'You do not have VIP on your account.'
		player:sendCancelMessage(msg)
		player:sendTextMessage(MESSAGE_STATUS, msg)
	else
		player:sendTextMessage(MESSAGE_STATUS, string.format('You have %s VIP day%s left.', (days == 0xFFFF and 'infinite amount of' or days), (days == 1 and '' or 's')))
	end
	return false
end

vip:groupType("normal")
vip:register()
