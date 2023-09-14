local dodge = TalkAction("!dodge")

function dodge.onSay(player, words, param)
	local qnt = player:getDodgeLevel(player)
	
	if qnt == 100 then
		player:sendTextMessage(MESSAGE_STATUS, "Full Dodge!" .. qnt)
	else
		player:sendTextMessage(MESSAGE_STATUS, "[".. qnt .."/100] Dodge!")
	end
	return true
end

dodge:register()
