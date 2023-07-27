local vip = TalkAction("!vip")

function vip.onSay(player, words, param)
	local days = player:getVipDays()
	if days == 0 then
		player:sendCancelMessage('You do not have VIP on your account.')
		player:sendTextMessage(MESSAGE_STATUS, 'You do not have VIP on your account.')
	else
		player:sendTextMessage(MESSAGE_STATUS, 'You have ' .. days .. ' days of VIP on your account.')
	end
	return false
end

vip:register()
