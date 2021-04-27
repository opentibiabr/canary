local globalevent = GlobalEvent("Player Record")

function globalevent.onRecord(current, old)
	addEvent(broadcastMessage, 150, "New record: " .. current .. " players are logged in.", MESSAGE_STATUS_DEFAULT)
	return true
end

globalevent:register()
