local savingEvent = 0
function saveLoop(delay)
	saveServer()
	SaveHirelings()
	Spdlog.info("Saved Hirelings")
	if delay > 0 then
		savingEvent = addEvent(saveLoop, delay, delay)
	end
end

local save = TalkAction("/save")

function save.onSay(player, words, param)
	if player:getGroup():getAccess() then
		if isNumber(param) then
			stopEvent(savingEvent)
			saveLoop(tonumber(param) * 60 * 1000)
		else
			saveServer()
			SaveHirelings()
			Spdlog.info("Saved Hirelings")
			player:sendTextMessage(MESSAGE_ADMINISTRADOR, "Server is saved ...")
		end
	end
end

save:separator(" ")
save:register()
