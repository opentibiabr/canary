return function(api)
	local actions = {}
	api.actions = actions

	local bytePayload = {
		[api.action.chooseBountyDifficulty] = true,
		[api.action.selectBounty] = true,
		[api.action.upgradeTalisman] = true,
		[api.action.deliverWeeklyItem] = true,
		[api.action.chooseWeeklyDifficulty] = true,
	}

	local u16Payload = {
		[api.action.buyShopOffer] = true,
		[api.action.unlockPreference] = true,
		[api.action.clearPreferred] = true,
		[api.action.clearUnwanted] = true,
	}

	local twoU16Payload = {
		[api.action.assignPreferred] = true,
		[api.action.assignUnwanted] = true,
	}

	local knownActions = {}
	for action = api.action.openBounty, api.action.assignUnwanted do
		knownActions[action] = true
	end

	local function readByte(msg)
		if msg:getUnreadBytes() < 1 then
			return nil
		end
		return msg:getByte()
	end

	local function readU16(msg)
		if msg:getUnreadBytes() < 2 then
			return nil
		end
		return msg:getU16()
	end

	local function parse(msg)
		local action = readByte(msg)
		if action == nil or not knownActions[action] then
			return nil, "unknown action", action
		end

		local payload = {}
		if bytePayload[action] then
			payload[1] = readByte(msg)
			if payload[1] == nil then
				return nil, "missing byte payload", action
			end
		elseif u16Payload[action] then
			payload[1] = readU16(msg)
			if payload[1] == nil then
				return nil, "missing u16 payload", action
			end
		elseif twoU16Payload[action] then
			payload[1] = readU16(msg)
			payload[2] = readU16(msg)
			if payload[1] == nil or payload[2] == nil then
				return nil, "missing two-u16 payload", action
			end
		end

		if msg:getUnreadBytes() > 0 then
			return nil, "unexpected trailing bytes", action
		end
		return action, payload
	end

	local function logMalformed(player, reason, action, unreadBefore, unreadAfter)
		api.diagnostics.trace("parse", "rejected player='{}' action={}({}) reason='{}' unreadBefore={} unreadAfter={}", api.diagnostics.playerName(player), tostring(action), api.diagnostics.actionName(action), reason, unreadBefore, unreadAfter)
	end

	local function refreshIcons(player)
		if type(player.refreshVisibleCreatureIcons) == "function" then
			player:refreshVisibleCreatureIcons()
		end
	end

	function actions.handle(player, msg)
		local unreadBefore = api.diagnostics.unreadBytes(msg)
		local action, payloadOrReason, rejectedAction = parse(msg)
		if not action then
			logMalformed(player, payloadOrReason, rejectedAction, unreadBefore, api.diagnostics.unreadBytes(msg))
			return
		end
		api.diagnostics.trace("action", "parsed player='{}' action={}({}) payload='{}' unreadBefore={}", api.diagnostics.playerName(player), action, api.diagnostics.actionName(action), api.diagnostics.payload(payloadOrReason), unreadBefore)
		if not api.isTaskboardEligible(player) then
			api.diagnostics.trace("action", "rejected ineligible player='{}' action={}({})", api.diagnostics.playerName(player), action, api.diagnostics.actionName(action))
			if api.rules.syncCreatureIcons(player, nil) then
				refreshIcons(player)
			end
			return
		end

		local state = api.state.ensure(player, false)
		local changed = false
		local responseWindow = api.window.bounty
		if action == api.action.openWeekly then
			responseWindow = api.window.weekly
		elseif action == api.action.openShop then
			responseWindow = api.window.shop
		elseif action == api.action.chooseBountyDifficulty then
			changed = api.rules.chooseBountyDifficulty(player, state, payloadOrReason[1])
		elseif action == api.action.rerollBounty then
			changed = api.rules.rerollBounty(player, state)
		elseif action == api.action.claimDailyReroll then
			changed = api.rules.claimDailyReroll(state)
		elseif action == api.action.selectBounty then
			changed = api.rules.selectBounty(state, payloadOrReason[1])
		elseif action == api.action.claimBounty then
			changed = api.rules.claimBounty(player, state)
		elseif action == api.action.upgradeTalisman then
			changed = api.rules.upgradeTalisman(state, payloadOrReason[1])
		elseif action == api.action.deliverWeeklyItem then
			responseWindow = api.window.weekly
			changed = api.rules.deliverWeeklyItem(player, state, payloadOrReason[1])
		elseif action == api.action.chooseWeeklyDifficulty then
			responseWindow = api.window.weekly
			changed = api.rules.chooseWeeklyDifficulty(player, state, payloadOrReason[1])
		elseif action == api.action.buyShopOffer then
			responseWindow = api.window.shop
			changed = api.rules.purchaseShopOffer(player, state, payloadOrReason[1])
		elseif action == api.action.unlockPreference then
			changed = api.rules.unlockPreference(state)
		elseif action == api.action.clearPreferred then
			changed = api.rules.clearPreference(state, payloadOrReason[1], true)
		elseif action == api.action.clearUnwanted then
			changed = api.rules.clearPreference(state, payloadOrReason[1], false)
		elseif action == api.action.assignPreferred then
			changed = api.rules.assignPreference(state, payloadOrReason[1], payloadOrReason[2], true)
		elseif action == api.action.assignUnwanted then
			changed = api.rules.assignPreference(state, payloadOrReason[1], payloadOrReason[2], false)
		end

		local shouldSyncIcons = changed or action == api.action.openBounty or action == api.action.openWeekly or action == api.action.openShop
		if shouldSyncIcons and api.rules.syncCreatureIcons(player, state) then
			refreshIcons(player)
		end
		if responseWindow == api.window.shop then
			api.rules.syncShopOutfitOwnership(player, state)
		end
		local saved = api.state.save(player, state)
		api.diagnostics.trace("action", "handled player='{}' action={}({}) changed={} saved={} responseWindow={}", api.diagnostics.playerName(player), action, api.diagnostics.actionName(action), changed, saved, responseWindow)
		api.wire.sendWindow(player, state, responseWindow)
	end
end
