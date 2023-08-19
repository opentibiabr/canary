local flask = TalkAction("!flask")
local flaskOnOff = 8412314

function flask.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("You need to specify on/off param.")
		return true
	end
	if param == "on" and player:getStorageValue(flaskOnOff) ~= 1 then
		player:setStorageValue(STORAGEVALUE_EMOTE, 1)
		player:setStorageValue(flaskOnOff, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You will not receive flasks!")
		player:getPosition():sendMagicEffect(CONST_ME_REDSMOKE)
	elseif param == "off" then
		player:setStorageValue(STORAGEVALUE_EMOTE, 0) 
		player:setStorageValue(flaskOnOff, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You will receive flasks.")
		player:getPosition():sendMagicEffect(CONST_ME_REDSMOKE)
	end
	return true
end

flask:separator(" ")
flask:groupType("normal")
flask:register()