local addReward = TalkAction("/addreward")

function addReward.onSay(player, words, param)
	local args = param:split(",")
	local itemInput = (args[1] or ""):trim()
	local amount = tonumber(args[2]) or 1
	local targetName = args[3] and args[3]:trim() or player:getName()

	if itemInput == "" then
		player:sendCancelMessage("Usage: /addreward item_name_or_id, amount[, target_player]")
		return false
	end

	-- resolve target
	local target = Player(targetName)
	if not target then
		player:sendCancelMessage("Target player not found.")
		return false
	end

	-- resolve item
	local it = ItemType(itemInput)
	if it:getId() == 0 then
		it = ItemType(tonumber(itemInput) or -1)
	end
	if it:getId() == 0 then
		player:sendCancelMessage("Invalid item name or ID.")
		return false
	end

	if amount < 1 then
		player:sendCancelMessage("Invalid amount.")
		return false
	end

	-- create/get the reward chest with a unique timestamp
	local timestamp = systemTime()
	local rewardBag = target:getReward(timestamp, true)

	-- **this** will split your `amount` across as many
	-- containers as necessary and return the total added
	local added = target:addItemBatchToPaginedContainer(rewardBag, it:getId(), amount)
	if added > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Added %d x %s to %s's reward chest(s).", added, it:getName(), target:getName()))
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You received %d x %s in your reward chest(s).", added, it:getName()))
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	else
		player:sendCancelMessage("Could not add item to reward chest.")
	end

	return false
end

addReward:separator(" ")
addReward:groupType("god")
addReward:register()
