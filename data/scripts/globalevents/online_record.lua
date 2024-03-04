local onlineRecord = GlobalEvent("OnlineRecord")

function onlineRecord.onRecord(current, old)
	addEvent(Game.broadcastMessage, 150, "New record: " .. current .. " players are logged in.", MESSAGE_LOGIN)
	return true
end

onlineRecord:register()
