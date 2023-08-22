local statusTime = TalkAction("!time")
function statusTime.onSay(player, words, param)
	local formattedTime = getFormattedWorldTime(getWorldTime())
	local dayOrNight = getTibiaTimerDayOrNight(formattedTime)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Now is %s in Tibia Time, time now is %s.", dayOrNight, formattedTime))
	return true
end

statusTime:groupType("normal")
statusTime:register()
