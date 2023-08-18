local vip = TalkAction("!checkvip", "!vip")

function vip.onSay(player, words, param)
	local time = player:getVipTime()
	if time == 0 then
		local msg = 'You do not have VIP on your account.'
		player:sendCancelMessage(msg)
		player:sendTextMessage(MESSAGE_STATUS, msg)
	else
		if (player:getVipDays() == 0xFFFF) then
			player:sendTextMessage(MESSAGE_STATUS, 'You have infinite amount of VIP days left.')
			return true
		end

		local timeRemaining = time - os.time()
		local days = math.floor(timeRemaining / 86400)
		if days > 1 then
			player:sendTextMessage(MESSAGE_STATUS, string.format("You have %d VIP days left.", days))
			return true
		end

		local hours = math.floor((timeRemaining % 86400) / 3600)
		local minutes = math.floor((timeRemaining % 3600) / 60)
		local seconds = timeRemaining % 60
		player:sendTextMessage(MESSAGE_STATUS, string.format("You have %d hours, %d minutes and %d seconds VIP days left.", hours, minutes, seconds))
	end
	return true
end

vip:groupType("normal")
vip:register()
