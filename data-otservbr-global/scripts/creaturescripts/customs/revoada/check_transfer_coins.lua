local checkLogin = CreatureEvent("CheckTransferCoins")

function checkLogin.onLogin(player)
	local msg = player:kv():get("msg-exchange-revoada-coins")
	if msg then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msg)
		player:kv():remove("msg-exchange-revoada-coins")
	end
	return true
end

checkLogin:register()