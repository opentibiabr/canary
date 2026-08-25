local callback = EventCallback("TaskboardPlayerOnLoginComplete")

function callback.playerOnLoginComplete(player)
	local taskboard = rawget(_G, "Taskboard")
	if not taskboard then
		if logger and logger.warn then
			logger.warn("[Taskboard][login-sync] API unavailable for player='{}'", player:getName())
		end
		return
	end

	local enabled = taskboard.isEnabled()
	local supported = taskboard.supportsOfficialTaskboard(player)
	local eligible = taskboard.isTaskboardEligible(player)
	local version, build = taskboard.diagnostics.client(player)
	taskboard.diagnostics.info("login-sync", "player='{}' enabled={} eligible={} supported={} client={} build='{}'", taskboard.diagnostics.playerName(player), enabled, eligible, supported, version, build)
	if not enabled or not supported or not eligible then
		return
	end

	local state = taskboard.state.ensure(player)
	taskboard.diagnostics.info("login-sync", "sending initial bounty and weekly windows player='{}'", taskboard.diagnostics.playerName(player))
	taskboard.wire.sendBounty(player, state)
	taskboard.wire.sendWeekly(player, state)
end

callback:register()
