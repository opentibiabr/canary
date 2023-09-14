local criticalTalk = TalkAction("!critical", "!critico", "!cric")

function criticalTalk.onSay(player, words, param)
	local qnt = player:getCriticalLevel(player)
	
	if qnt == 100 then
		player:sendTextMessage(MESSAGE_STATUS, "Full Critical!")
	else
		player:sendTextMessage(MESSAGE_STATUS, "[".. qnt .."/100] Critical!")
	end
	return true
end

criticalTalk:register()
