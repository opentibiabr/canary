return function(api)
	local admin = {}
	api.admin = admin

	local maxSafeInteger = 9007199254740991

	local function normalizeAmount(amount)
		amount = api.toFiniteNumber(amount)
		if not amount or amount ~= math.floor(amount) or math.abs(amount) > maxSafeInteger then
			return nil
		end
		return amount
	end

	local function ensureState(player, persist)
		if not api.state or type(api.state.ensure) ~= "function" then
			return nil
		end
		return api.state.ensure(player, persist)
	end

	local function syncClientState(player, state, refreshWeekly)
		if refreshWeekly and api.wire and type(api.wire.sendWeekly) == "function" and api.supportsOfficialTaskboard(player) then
			api.wire.sendWeekly(player, state)
		elseif api.wire and type(api.wire.sendBalances) == "function" then
			api.wire.sendBalances(player, state)
		end
	end

	local function saveAndSync(player, state, refreshWeekly)
		if not api.state.save(player, state) then
			return false
		end

		syncClientState(player, state, refreshWeekly)
		return true
	end

	local function changeBalance(player, field, amount)
		amount = normalizeAmount(amount)
		if amount == nil then
			return false, nil, "invalid amount"
		end

		local state = ensureState(player, false)
		if not state or not state.general then
			return false, nil, "state unavailable"
		end

		local current = api.clampU32(state.general[field])
		if amount < 0 then
			local toRemove = math.abs(amount)
			if toRemove > current then
				return false, current, "insufficient balance"
			end
			state.general[field] = current - toRemove
		else
			state.general[field] = api.clampU32(current + amount)
		end

		if not saveAndSync(player, state) then
			return false, current, "state could not be saved"
		end
		return true, state.general[field]
	end

	function admin.getState(player)
		return ensureState(player)
	end

	function admin.adjustBountyPoints(player, amount)
		return changeBalance(player, "bountyPoints", amount)
	end

	function admin.adjustSoulseals(player, amount)
		return changeBalance(player, "soulseals", amount)
	end

	function admin.adjustTaskPoints(player, amount)
		amount = normalizeAmount(amount)
		if amount == nil then
			return false, nil, "invalid amount"
		end

		local state = ensureState(player)
		if not state or type(player.getTaskHuntingPoints) ~= "function" then
			return false, nil, "task points unavailable"
		end

		local current = math.max(0, tonumber(player:getTaskHuntingPoints()) or 0)
		if amount < 0 then
			if type(player.removeTaskHuntingPoints) ~= "function" then
				return false, current, "task points unavailable"
			end

			local ok, removed = pcall(player.removeTaskHuntingPoints, player, math.abs(amount))
			if not ok or removed ~= true then
				return false, current, "insufficient balance"
			end
		elseif amount > 0 then
			if type(player.addTaskHuntingPoints) ~= "function" then
				return false, current, "task points unavailable"
			end

			local ok, result = pcall(player.addTaskHuntingPoints, player, amount)
			if not ok or result == nil or result == false then
				return false, current, "task points unavailable"
			end
		end

		local updated = math.max(0, tonumber(player:getTaskHuntingPoints()) or 0)
		syncClientState(player, state)
		return true, updated
	end

	function admin.setThirdSlot(player, enabled)
		if type(enabled) ~= "boolean" then
			return false, nil, "invalid slot state"
		end

		local state = ensureState(player, false)
		if not state or not state.general then
			return false, nil, "state unavailable"
		end

		if type(player.taskHuntingThirdSlot) == "function" then
			local ok, result = pcall(player.taskHuntingThirdSlot, player, enabled)
			if not ok or result == nil or result == false then
				return false, state.general.thirdSlotUnlocked == true, "task slot unavailable"
			end
		end

		local previous = state.general.thirdSlotUnlocked == true
		state.general.thirdSlotUnlocked = enabled
		if not saveAndSync(player, state, true) then
			state.general.thirdSlotUnlocked = previous
			if type(player.taskHuntingThirdSlot) == "function" then
				pcall(player.taskHuntingThirdSlot, player, previous)
			end
			return false, previous, "state could not be saved"
		end
		return true, state.general.thirdSlotUnlocked == true
	end

	function admin.prepareWeeklyDeliveries(player)
		local state = ensureState(player, false)
		if not state or not state.weekly then
			return false, nil, "state unavailable"
		end
		if state.weekly.selectionPending then
			return false, nil, "weekly difficulty not selected"
		end
		if type(player.addItemStash) ~= "function" then
			return false, nil, "stash unavailable"
		end
		if #(state.weekly.items or {}) == 0 then
			if not api.rules.ensureWeeklyDeliveries(state) then
				return false, nil, "weekly delivery catalog unavailable"
			end
			if not api.state.save(player, state) then
				return false, nil, "state could not be saved"
			end
		end

		local summary = {
			pendingTasks = 0,
			preparedTasks = 0,
			alreadyReadyTasks = 0,
			addedItems = 0,
		}
		local additions = {}
		for _, item in ipairs(state.weekly.items or {}) do
			if not item.completed then
				summary.pendingTasks = summary.pendingTasks + 1
				local itemId = tonumber(item.itemId) or 0
				local required = math.max(0, tonumber(item.required) or 0)
				if itemId <= 0 or itemId > 0xFFFF or required <= 0 then
					return false, nil, "invalid weekly delivery"
				end

				local _, _, available = api.rules.getWeeklyItemAvailability(player, item)
				local missing = math.max(0, required - available)
				if missing > 0 then
					table.insert(additions, { itemId = itemId, amount = missing })
				else
					summary.alreadyReadyTasks = summary.alreadyReadyTasks + 1
				end
			end
		end

		if summary.pendingTasks == 0 then
			return false, nil, "no pending deliveries"
		end

		for _, addition in ipairs(additions) do
			local succeeded, added = pcall(player.addItemStash, player, addition.itemId, addition.amount)
			if not succeeded or added ~= true then
				return false, summary, "stash update failed"
			end
			summary.preparedTasks = summary.preparedTasks + 1
			summary.addedItems = summary.addedItems + addition.amount
		end

		syncClientState(player, state, true)
		return true, summary
	end
end
