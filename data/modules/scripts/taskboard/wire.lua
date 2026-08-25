return function(api)
	local wire = {}
	api.wire = wire

	local function sendResource(player, resource, value, wide)
		local client = type(player.getClient) == "function" and player:getClient() or nil
		if client and tonumber(client.version) and tonumber(client.version) < 1100 then
			return
		end
		local msg = NetworkMessage()
		msg:addByte(api.packet.resourceBalance)
		msg:addByte(resource)
		if wide then
			msg:addU64(math.max(0, tonumber(value) or 0))
		else
			msg:addU32(api.clampU32(value))
		end
		msg:sendToPlayer(player)
	end

	function wire.sendBalances(player, state)
		if not api.supportsOfficialTaskboard(player) then
			api.diagnostics.warn("send", "skipped balances for unsupported player='{}'", api.diagnostics.playerName(player))
			return
		end
		local taskPoints = type(player.getTaskHuntingPoints) == "function" and player:getTaskHuntingPoints() or 0
		api.diagnostics.info("send", "balances player='{}' bountyPoints={} taskPoints={} soulseals={}", api.diagnostics.playerName(player), state.general.bountyPoints, taskPoints, state.general.soulseals)
		sendResource(player, api.resource.bountyPoints, state.general.bountyPoints, false)
		sendResource(player, api.resource.taskHuntingPoints, taskPoints, true)
		sendResource(player, api.resource.soulseals, state.general.soulseals, false)
	end

	local function sendTaskFinished(player, eventType, raceId)
		if not api.supportsOfficialTaskboard(player) then
			return
		end
		local msg = NetworkMessage()
		msg:addByte(api.packet.serverClientEvent)
		msg:addByte(eventType)
		msg:addU16(api.clampU16(raceId))
		msg:sendToPlayer(player)
	end

	function wire.sendBountyTaskFinished(player, raceId)
		sendTaskFinished(player, api.clientEvent.bountyTaskFinished, raceId)
	end

	function wire.sendWeeklyTaskSpecificCreatureFinished(player, raceId)
		sendTaskFinished(player, api.clientEvent.weeklyTaskSpecificCreatureFinished, raceId)
	end

	local function sendHeader(msg, window)
		msg:addByte(api.packet.serverTaskboard)
		msg:addByte(window)
	end

	local function recordCount(records, maximum)
		if type(records) ~= "table" then
			return 0
		end
		return math.min(#records, maximum)
	end

	function wire.sendBounty(player, state)
		local msg = NetworkMessage()
		sendHeader(msg, api.window.bounty)
		local taskCount = recordCount(state.bounty.tasks, 0xFF)
		msg:addByte(taskCount)
		for index = 1, taskCount do
			local task = state.bounty.tasks[index]
			msg:addByte(api.clampByte(index - 1))
			msg:addU16(api.clampU16(task.raceId))
			msg:addU16(api.clampU16(task.required))
			msg:addU32(api.clampU32(task.experience))
			msg:addByte(api.clampByte(task.bountyPoints))
			msg:addU16(api.clampU16(task.current))
			msg:addByte(api.clampByte(task.state))
			-- The official record reserves this final byte for the task marker.
			msg:addByte(api.clampByte(task.marker))
		end

		msg:addByte(api.clampByte(state.bounty.dailyRerolls))
		msg:addByte(api.clampByte(api.rules.getRerollState(state)))
		msg:addByte(api.clampByte(state.bounty.difficulty))
		local upgradeLevels = {
			state.upgrades.damage,
			state.upgrades.lifeLeech,
			state.upgrades.moreLoot,
			state.upgrades.doubleBestiary,
		}
		for _, level in ipairs(upgradeLevels) do
			local cost = api.getUpgradeCost(level)
			local canUpgrade = level < api.config.upgrades.maxLevel and state.general.bountyPoints >= cost
			msg:addU16(api.clampU16(level))
			msg:addByte(canUpgrade and 1 or 0)
			msg:addU16(cost)
		end

		local preferenceCount = recordCount(state.bounty.preferences, 0xFF)
		msg:addByte(preferenceCount)
		for index = 1, preferenceCount do
			local preference = state.bounty.preferences[index]
			msg:addByte(preference.unlocked and 1 or 0)
			msg:addU16(api.clampU16(preference.preferredRace))
			msg:addU16(api.clampU16(preference.unwantedRace))
		end
		api.diagnostics.info("send", "window player='{}' opcode=0x{} window={} tasks={} preferences={}", api.diagnostics.playerName(player), api.diagnostics.hexByte(api.packet.serverTaskboard), api.window.bounty, taskCount, preferenceCount)
		msg:sendToPlayer(player)
		wire.sendBalances(player, state)
	end

	function wire.sendWeekly(player, state)
		local msg = NetworkMessage()
		sendHeader(msg, api.window.weekly)
		local anyCreature = state.weekly.anyCreature
		msg:addU16(api.clampU16(anyCreature.required))
		msg:addU16(api.clampU16(anyCreature.current))

		local killCount = recordCount(state.weekly.kills, 0xFF)
		msg:addByte(killCount)
		for index = 1, killCount do
			local task = state.weekly.kills[index]
			msg:addU16(api.clampU16(task.raceId))
			msg:addU16(api.clampU16(task.required))
			msg:addU16(api.clampU16(task.current))
		end

		local itemCount = recordCount(state.weekly.items, 0xFF)
		msg:addByte(itemCount)
		for index = 1, itemCount do
			local item = state.weekly.items[index]
			local current = item.current or 0
			if not item.completed then
				local _, _, total = api.rules.getWeeklyItemAvailability(player, item)
				current = math.min(item.required, total)
			end
			msg:addByte(api.clampByte(index - 1))
			msg:addU32(api.clampU32(item.itemId))
			msg:addU32(api.clampU32(item.required))
			msg:addU32(api.clampU32(current))
			msg:addByte(item.completed and 1 or 0)
		end

		msg:addByte(api.clampByte(state.weekly.difficulty))
		msg:addU32(api.clampU32(state.weekly.killExperience))
		msg:addU32(api.clampU32(state.weekly.itemExperience))
		msg:addByte(api.clampByte(state.weekly.killsCompleted))
		msg:addByte(api.clampByte(state.weekly.itemsCompleted))
		msg:addByte(state.weekly.selectionPending and 1 or 0)
		msg:addByte(api.clampByte(api.getDifficultyForLevel(player:getLevel())))
		msg:addU32(api.clampU32(state.meta.nextWeeklyReset))
		msg:addByte(state.general.thirdSlotUnlocked and 1 or 0)
		msg:addU32(api.clampU32(api.rules.getWeeklyRewardPoints(state)))
		local soulsealsTail = api.usesWeeklySoulsealsTail(player)
		if soulsealsTail then
			msg:addU32(api.clampU32(state.weekly.soulseals))
		end
		api.diagnostics.info("send", "window player='{}' opcode=0x{} window={} kills={} items={} selectionPending={} soulsealsTail={}", api.diagnostics.playerName(player), api.diagnostics.hexByte(api.packet.serverTaskboard), api.window.weekly, killCount, itemCount, state.weekly.selectionPending, soulsealsTail)
		msg:sendToPlayer(player)
		wire.sendBalances(player, state)
	end

	function wire.sendShop(player, state)
		local msg = NetworkMessage()
		sendHeader(msg, api.window.shop)
		local offers = api.config.shopOffers or {}
		local offerCount = api.getShopOfferCount()
		msg:addByte(offerCount + 1)
		for index = 1, offerCount do
			local offer = offers[index]
			msg:addByte(api.clampByte(offer.kind))
			msg:addString(tostring(offer.name or ""))
			msg:addString(tostring(offer.description or ""))
			if offer.kind == api.offerKind.outfit then
				local outfit = api.getOutfitOfferData(offer)
				msg:addU32(api.clampU32(api.getOutfitLookType(player, offer)))
				msg:addByte(api.clampByte(outfit and outfit.addon or 0))
			else
				msg:addU32(api.clampU32(offer.id))
			end
			if offer.kind == api.offerKind.decoration then
				msg:addU32(api.clampU32(offer.secondId))
			end
			msg:addU32(api.getShopOfferPrice(offer) or 0)
			msg:addByte(api.clampByte(api.rules.getShopOfferState(player, state, offer)))
		end

		local storedWheelMultiplier = api.normalizeWheelMultiplier(state.wheel.multiplier)
		local wheelMultiplier = math.min(storedWheelMultiplier, api.config.wheel.maximumMultiplier)
		local wheelPrice = api.getWheelPrice(wheelMultiplier)
		msg:addByte(api.offerKind.wheelBonus)
		msg:addU16(wheelMultiplier)
		msg:addU32(wheelPrice)
		local wheelState = api.offerState.available
		if storedWheelMultiplier > api.config.wheel.maximumMultiplier then
			wheelState = api.offerState.bought
		elseif (type(player.getTaskHuntingPoints) == "function" and player:getTaskHuntingPoints() or 0) < wheelPrice then
			wheelState = api.offerState.notEnoughPoints
		end
		msg:addByte(wheelState)
		api.diagnostics.info("send", "window player='{}' opcode=0x{} window={} offers={} wheelMultiplier={} wheelState={}", api.diagnostics.playerName(player), api.diagnostics.hexByte(api.packet.serverTaskboard), api.window.shop, offerCount + 1, wheelMultiplier, wheelState)
		msg:sendToPlayer(player)
		wire.sendBalances(player, state)
	end

	function wire.sendWindow(player, state, window)
		if window == api.window.weekly then
			return wire.sendWeekly(player, state)
		end
		if window == api.window.shop then
			return wire.sendShop(player, state)
		end
		return wire.sendBounty(player, state)
	end

	function wire.sendSoulpit(player, raceIds)
		local msg = NetworkMessage()
		msg:addByte(api.packet.serverSoulpit)
		local raceCount = recordCount(raceIds, 0xFFFF)
		msg:addU16(raceCount)
		for index = 1, raceCount do
			local raceId = raceIds[index]
			msg:addU16(api.clampU16(raceId))
		end
		msg:sendToPlayer(player)
	end
end
