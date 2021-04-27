local savingEvent = 0
function save(delay)
	saveServer()
	if delay > 0 then
		savingEvent = addEvent(save, delay, delay)
	end
end

local save = TalkAction("/save")

function save.onSay(player, words, param)
	if player:getGroup():getAccess() then
		if isNumber(param) then
			stopEvent(savingEvent)
			save(tonumber(param) * 60 * 1000)
		else
			saveServer()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Server is saved ...")
		end
	end
end

save:separator(" ")
save:register()
