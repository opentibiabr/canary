local function getTaskboard(player)
	local taskboard = rawget(_G, "Taskboard")
	if type(taskboard) ~= "table" or type(taskboard.isEnabled) ~= "function" or not taskboard.isEnabled() then
		player:sendCancelMessage("Task Board Lua module is disabled.")
		return nil
	end

	if type(taskboard.admin) ~= "table" then
		player:sendCancelMessage("Task Board administrative helpers are unavailable.")
		return nil
	end
	return taskboard
end

local function parseTargetAndAmount(player, param, usage)
	param = param or ""
	if param == "" then
		player:sendCancelMessage(usage)
		return nil, nil
	end

	local targetName, amountText = string.splitFirst(param, ",")
	targetName = string.trim(targetName or "")
	if targetName == "" then
		player:sendCancelMessage(usage)
		return nil, nil
	end

	local target = Player(targetName)
	if not target then
		player:sendCancelMessage("A player with that name is not online.")
		return nil, nil
	end

	if amountText == nil then
		return target, nil
	end

	amountText = string.trim(amountText)
	local amount = tonumber(amountText)
	if amount == nil or amount ~= math.floor(amount) or amount ~= amount or amount == math.huge or amount == -math.huge then
		player:sendCancelMessage("Invalid amount. Use a whole number.")
		return nil, nil
	end
	return target, amount
end

local function sendValueMessage(player, target, value, noun)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s now has %s %s.", target:getName(), tostring(value), noun))
	if target ~= player then
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your %s are now %s.", noun, tostring(value)))
	end
end

local function sendAdjustmentError(player, reason, noun)
	if reason == "insufficient balance" then
		player:sendCancelMessage("Target does not have enough " .. noun .. ".")
		return
	end
	player:sendCancelMessage("Could not update the target's " .. noun .. ".")
end

local function registerBalanceAction(command, noun, usage, readValue, adjust)
	local action = TalkAction(command)

	function action.onSay(player, words, param)
		if type(logCommand) == "function" then
			logCommand(player, words, param)
		end

		local taskboard = getTaskboard(player)
		if not taskboard then
			return true
		end

		local target, amount = parseTargetAndAmount(player, param, usage)
		if not target then
			return true
		end

		if amount == nil then
			local value = readValue(taskboard, target)
			if value == nil then
				player:sendCancelMessage("Could not read the target's " .. noun .. ".")
				return true
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has %s %s.", target:getName(), tostring(value), noun))
			return true
		end

		local success, value, reason = adjust(taskboard, target, amount)
		if not success then
			sendAdjustmentError(player, reason, noun)
			return true
		end

		sendValueMessage(player, target, value, noun)
		return true
	end

	action:separator(" ")
	action:groupType("god")
	action:register()
end

registerBalanceAction("/bountypoints", "bounty points", "Usage: /bountypoints <player>,<amount(optional)>", function(taskboard, target)
	local state = taskboard.admin.getState(target)
	return state and state.general and state.general.bountyPoints
end, function(taskboard, target, amount)
	return taskboard.admin.adjustBountyPoints(target, amount)
end)

registerBalanceAction("/soulseals", "soulseals", "Usage: /soulseals <player>,<amount(optional)>", function(taskboard, target)
	local state = taskboard.admin.getState(target)
	return state and state.general and state.general.soulseals
end, function(taskboard, target, amount)
	return taskboard.admin.adjustSoulseals(target, amount)
end)

registerBalanceAction("/taskpoints", "task points", "Usage: /taskpoints <player>,<amount(optional)>", function(_, target)
	if type(target.getTaskHuntingPoints) ~= "function" then
		return nil
	end
	return target:getTaskHuntingPoints()
end, function(taskboard, target, amount)
	return taskboard.admin.adjustTaskPoints(target, amount)
end)

local taskSlotAction = TalkAction("/taskslot")

function taskSlotAction.onSay(player, words, param)
	if type(logCommand) == "function" then
		logCommand(player, words, param)
	end

	local taskboard = getTaskboard(player)
	if not taskboard then
		return true
	end

	local usage = "Usage: /taskslot <player>,<0|1>"
	local target, enabled = parseTargetAndAmount(player, param, usage)
	if not target or enabled == nil then
		if target and enabled == nil then
			player:sendCancelMessage(usage)
		end
		return true
	end
	if enabled ~= 0 and enabled ~= 1 then
		player:sendCancelMessage(usage)
		return true
	end

	local success, current, reason = taskboard.admin.setThirdSlot(target, enabled == 1)
	if not success then
		player:sendCancelMessage("Could not update the target's task third slot (" .. tostring(reason) .. ").")
		return true
	end

	local status = current and "enabled" or "disabled"
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Task third slot for %s is now %s.", target:getName(), status))
	if target ~= player then
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your task third slot is now " .. status .. ".")
	end
	return true
end

taskSlotAction:separator(" ")
taskSlotAction:groupType("god")
taskSlotAction:register()
