local inboxCommand = TalkAction("/inbox")

function inboxCommand.onSay(player, words, param)
	if not param or param:len() == 0 then
		player:sendTextMessage(MESSAGE_LOOK, string.format("Usage: /inbox {PlayerName},{add|remove},{itemId}[,charges]"))
		return false
	end

	local params = param:split(",")
	if #params < 3 then
		player:sendTextMessage(MESSAGE_LOOK, string.format("Usage: /inbox {PlayerName},{add|remove},{itemId}[,charges]"))
		return false
	end

	local targetName = params[1]:trim()
	local action = params[2]:lower():trim()
	local itemId = tonumber(params[3]:trim())
	local charges = tonumber(params[4]) or 0

	if not itemId then
		player:sendTextMessage(MESSAGE_LOOK, string.format("Invalid item ID."))
		return false
	end

	local target = Player(targetName)
	if not target then
		player:sendTextMessage(MESSAGE_LOOK, string.format("Player %s not found.", targetName))
		return false
	end

	local inbox = target:getStoreInbox()
	if not inbox then
		player:sendTextMessage(MESSAGE_LOOK, string.format("Target %s has no store inbox.", targetName))
		return false
	end

	if action == "remove" then
		local inboxSize = inbox:getSize()
		if inboxSize == 0 then
			player:sendTextMessage(MESSAGE_LOOK, string.format("%s's inbox is empty.", targetName))
			return false
		end

		local found = false
		for i = inboxSize - 1, 0, -1 do
			local item = inbox:getItem(i)
			if item and item:getId() == itemId then
				item:remove()
				player:sendTextMessage(MESSAGE_LOOK, string.format("Removed item %d from %s's inbox.", itemId, targetName))
				found = true
				break
			end
		end

		if not found then
			player:sendTextMessage(MESSAGE_LOOK, string.format("Item %d not found in %s's inbox.", itemId, targetName))
		end
	elseif action == "add" then
		local item = target:addItemStoreInbox(itemId, 1, true, false)
		if item then
			if charges > 0 then
				item:setAttribute(ITEM_ATTRIBUTE_CHARGES, charges)
			end
			player:sendTextMessage(MESSAGE_LOOK, string.format("Added item %d to %s's inbox with %d charges.", itemId, targetName, charges))
		else
			player:sendTextMessage(MESSAGE_LOOK, string.format("Failed to add item %d to %s's inbox.", itemId, targetName))
		end
	else
		player:sendTextMessage(MESSAGE_LOOK, string.format("Invalid action. Use 'add' or 'remove'."))
		return false
	end

	return true
end

inboxCommand:separator(" ")
inboxCommand:setDescription("[Usage]: /inbox {PlayerName},{add|remove},{itemId}[,charges]")
inboxCommand:groupType("god")
inboxCommand:register()
