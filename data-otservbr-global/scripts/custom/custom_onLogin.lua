local customLoginEvents = CreatureEvent("customLoginEvents")
function customLoginEvents.onLogin(player)
	local events = {
		"cityWarEventHealthChange",
		"cityWarEventPrepareDeath",
	}

	for i = 1, #events do
		player:registerEvent(events[i])
	end
	return true
end

customLoginEvents:register()
