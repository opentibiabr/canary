return function(api)
	local expansion = {}
	api.expansion = expansion

	local function syncClient(player, state)
		if api.wire and type(api.wire.sendWeekly) == "function" and api.supportsOfficialTaskboard(player) then
			api.wire.sendWeekly(player, state)
		elseif api.wire and type(api.wire.sendBalances) == "function" then
			api.wire.sendBalances(player, state)
		end
	end

	function expansion.isUnlocked(player)
		return api.state.isWeeklyExpansionUnlocked(player)
	end

	function expansion.setUnlocked(player, enabled)
		if type(enabled) ~= "boolean" then
			return false, nil, "invalid expansion state"
		end

		local state = api.state.ensure(player, false)
		if not state or not state.general then
			return false, nil, "state unavailable"
		end

		local previous = state.general.weeklyExpansionUnlocked == true
		if previous == enabled then
			return true, previous
		end

		state.general.weeklyExpansionUnlocked = enabled
		api.rules.ensureWeeklyAssignments(player, state)
		if not api.state.save(player, state) then
			state.general.weeklyExpansionUnlocked = previous
			return false, previous, "state could not be saved"
		end

		syncClient(player, state)
		return true, enabled
	end

	function expansion.unlock(player)
		if expansion.isUnlocked(player) then
			return false, "Permanent Weekly Task Expansion is already unlocked."
		end

		local changed, _, reason = expansion.setUnlocked(player, true)
		if not changed then
			return false, reason or "Permanent Weekly Task Expansion is unavailable."
		end
		return true
	end
end
