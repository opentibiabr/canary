local callback = EventCallback("TaskboardPlayerOnLoginComplete")

function callback.playerOnLoginComplete(player)
	local taskboard = rawget(_G, "Taskboard")
	if not taskboard or not taskboard.isEnabled() or not taskboard.supportsOfficialTaskboard(player) or not taskboard.isTaskboardEligible(player) then
		return
	end

	local state = taskboard.state.ensure(player)
	taskboard.wire.sendBounty(player, state)
	taskboard.wire.sendWeekly(player, state)
end

callback:register()
