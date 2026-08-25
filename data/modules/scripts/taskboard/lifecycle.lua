return function(api)
	local lifecycle = {}
	api.lifecycle = lifecycle

	function lifecycle.onLogin(player)
		api.diagnostics.info("login", "state initialization player='{}' enabled={} eligible={}", api.diagnostics.playerName(player), api.isEnabled(), api.isTaskboardEligible(player))
		if not api.isEnabled() then
			return true
		end
		if not api.isTaskboardEligible(player) then
			if api.rules.syncCreatureIcons(player, nil) and type(player.refreshVisibleCreatureIcons) == "function" then
				player:refreshVisibleCreatureIcons()
			end
			return true
		end

		local state = api.state.ensure(player)
		if api.rules.syncCreatureIcons(player, state) and type(player.refreshVisibleCreatureIcons) == "function" then
			player:refreshVisibleCreatureIcons()
		end
		return true
	end

	local loginEvent = CreatureEvent("TaskboardLogin")
	function loginEvent.onLogin(player)
		return lifecycle.onLogin(player)
	end
	loginEvent:register()
end
