local testLog = TalkAction("/testlog")

function testLog.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Log level and message required.")
		logger.error("[testLog.onSay] - Log level and message not found")
		return true
	end

	local split = param:split(",")
	local logLevel = split[1]:trim():lower()
	local message = string.trimSpace(split[2])

	if message == "" then
		player:sendCancelMessage("Log message required.")
		return false
	end

	if logLevel == "info" then
		logger.info("[testLog] - {}", message)
	elseif logLevel == "warn" then
		logger.warn("[testLog] - {}", message)
	elseif logLevel == "error" then
		logger.error("[testLog] - {}", message)
	elseif logLevel == "debug" then
		logger.debug("[testLog] - {}", message)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid log level. Use 'info', 'warn', 'error' or 'debug'.")
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Logged message [" .. message .. "] at '" .. logLevel .. "' level.")
	return true
end

testLog:separator(" ")
testLog:groupType("god")
testLog:register()

-- @module ContainerTalkAction
-- @function Handles the "!testcontainer" TalkAction command for testing the ContainerIterator functionality.
--
-- This module defines a TalkAction that allows players to inspect their backpack containers.
-- It can optionally remove items from the container based on the provided parameter.
-- The command logs the total number of items and subcontainers found in the backpack.
-- This is primarily used to verify the correctness of changes made to the ContainerIterator.
local containerTalkAction = TalkAction("!testcontainer")

function containerTalkAction.onSay(player, words, param)
	local container = player:getSlotItem(CONST_SLOT_BACKPACK)
	if not container then
		player:sendCancelMessage("Your backpack does not contain a valid container.")
		logger.error("[!container] - Player: {} has a backpack without a valid container.", player:getName())
		return true
	end

	local shouldRemove = (param and param:lower() == "remove") and true or false
	local items = container:getItems(true)
	local totalItems = 0
	local totalSubContainers = 0
	for i, item in pairs(items) do
		if shouldRemove and item then
			item:remove()
		end

		if item:getContainer() then
			totalSubContainers = totalSubContainers + 1
		else
			totalItems = totalItems + 1
		end
	end

	local actionMessage = shouldRemove and "removed " or "have "
	local playerMessage = actionMessage .. totalItems .. " items and " .. totalSubContainers .. " subcontainers from your backpack."
	local finalMessage = string.format("[!testcontainer] - Player: %s, %s items from backpack: %d, subcontainers count: %d", player:getName(), actionMessage, totalItems, totalSubContainers)

	logger.info(finalMessage)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You " .. playerMessage)
	return true
end

containerTalkAction:separator(" ")
containerTalkAction:groupType("god")
containerTalkAction:register()
