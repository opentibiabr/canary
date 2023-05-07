local vip = TalkAction("!checkvip")

function vip.onSay(player, words, param)
	local days = player:getVipDays()
	if days == 0 then
		player:sendCancelMessage('You do not have vip on your account.')
		player:sendTextMessage(MESSAGE_STATUS, 'You do not have vip on your account.')
	else
		player:sendTextMessage(MESSAGE_STATUS, string.format('You have %s vip day%s left.', (days == 0xFFFF and 'infinite amount of' or days), (days == 1 and '' or 's')))
	end
	return false
end

vip:register()
