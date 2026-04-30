local testMode = {
	active = false,
	valueOpen = 100,
}

local rewardBags = {
	[BAG_YOU_DESIRE] = {
		{ id = 34082, name = "soulcutter", chance = 0.05 },
		{ id = 34083, name = "soulshredder", chance = 0.01 },
		{ id = 34084, name = "soulbiter", chance = 0.05 },
		{ id = 34085, name = "souleater", chance = 0.01 },
		{ id = 34086, name = "soulcrusher", chance = 0.05 },
		{ id = 34087, name = "soulmaimer", chance = 0.05 },
		{ id = 34097, name = "pair of soulwalkers", chance = 0.05 },
		{ id = 34099, name = "soulbastion", chance = 0.05 },
		{ id = 34088, name = "soulbleeder", chance = 0.01 },
		{ id = 34089, name = "soulpiercer", chance = 0.05 },
		{ id = 34094, name = "soulshell", chance = 0.05 },
		{ id = 34098, name = "pair of soulstalkers", chance = 0.05 },
		{ id = 34090, name = "soultainter", chance = 0.01 },
		{ id = 34092, name = "soulshanks", chance = 0.05 },
		{ id = 34095, name = "soulmantle", chance = 0.05 },
		{ id = 34091, name = "soulhexer", chance = 0.01 },
		{ id = 34093, name = "soulstrider", chance = 0.05 },
		{ id = 34096, name = "soulshroud", chance = 0.05 },
		{ id = 50254, name = "soulgarb", chance = 0.05 },
		{ id = 50240, name = "soulsoles", chance = 0.05 },
		{ id = 50159, name = "soulkamas", chance = 0.01 },
	},

	[PRIMAL_BAG] = {
		{ id = 39147, name = "spiritthorn armor", chance = 0.01 },
		{ id = 39148, name = "spiritthorn helmet", chance = 0.01 },
		{ id = 39177, name = "charged spiritthorn ring", chance = 0.05 },
		{ id = 39149, name = "alicorn headguard", chance = 0.01 },
		{ id = 39150, name = "alicorn quiver", chance = 0.05 },
		{ id = 39180, name = "charged alicorn ring", chance = 0.05 },
		{ id = 39151, name = "arcanomancer regalia", chance = 0.05 },
		{ id = 39152, name = "arcanomancer folio", chance = 0.05 },
		{ id = 39183, name = "charged arcanomancer sigil", chance = 0.05 },
		{ id = 39153, name = "arboreal crown", chance = 0.05 },
		{ id = 39154, name = "arboreal tome", chance = 0.05 },
		{ id = 39186, name = "charged arboreal ring", chance = 0.05 },
		{ id = 50149, name = "charged ethereal ring", chance = 0.05 },
		{ id = 50188, name = "ethereal coned hat", chance = 0.01 },
	},

	[BAG_YOU_COVET] = {
		{ id = 43864, name = "sanguine blade", chance = 0.05 },
		{ id = 43866, name = "sanguine cudgel", chance = 0.05 },
		{ id = 43868, name = "sanguine hatchet", chance = 0.05 },
		{ id = 43870, name = "sanguine razor", chance = 0.02 },
		{ id = 43872, name = "sanguine bludgeon", chance = 0.05 },
		{ id = 43874, name = "sanguine battleaxe", chance = 0.05 },
		{ id = 43876, name = "sanguine legs", chance = 0.02 },
		{ id = 43877, name = "sanguine bow", chance = 0.01 },
		{ id = 43879, name = "sanguine crossbow", chance = 0.05 },
		{ id = 43881, name = "sanguine greaves", chance = 0.02 },
		{ id = 43882, name = "sanguine coil", chance = 0.02 },
		{ id = 43884, name = "sanguine boots", chance = 0.05 },
		{ id = 43885, name = "sanguine rod", chance = 0.02 },
		{ id = 43887, name = "sanguine galoshes", chance = 0.05 },
		{ id = 43865, name = "grand sanguine blade", chance = 0.00001 },
		{ id = 43867, name = "grand sanguine cudgel", chance = 0.00001 },
		{ id = 43869, name = "grand sanguine hatchet", chance = 0.00001 },
		{ id = 43871, name = "grand sanguine razor", chance = 0.00001 },
		{ id = 43873, name = "grand sanguine bludgeon", chance = 0.00001 },
		{ id = 43875, name = "grand sanguine battleaxe", chance = 0.00001 },
		{ id = 43878, name = "grand sanguine bow", chance = 0.00001 },
		{ id = 43880, name = "grand sanguine crossbow", chance = 0.00001 },
		{ id = 43883, name = "grand sanguine coil", chance = 0.00001 },
		{ id = 43886, name = "grand sanguine rod", chance = 0.00001 },
		{ id = 50146, name = "sanguine trousers", chance = 0.02 },
		{ id = 50157, name = "sanguine claws", chance = 0.02 },
	},
}

local randomItems = Action()

local function addRewardToPlayer(player, itemId, count)
	local addToBackpack = player:addItem(itemId, count, false)
	if addToBackpack then
		return true, "backpack", addToBackpack
	end

	local addToInbox = player:addItemStoreInbox(itemId, count, true, false)
	if addToInbox then
		return true, "inbox", addToInbox
	end

	local storeInbox = player:getStoreInbox()
	if not storeInbox then
		return false, "no_inbox"
	end

	return false, "inbox_full"
end

local function selectReward(rewardBag)
	local totalWeight = 0
	for _, reward in ipairs(rewardBag) do
		totalWeight = totalWeight + (reward.chance or 0)
	end

	if totalWeight <= 0 then
		return rewardBag[math.random(1, #rewardBag)]
	end

	local roll = math.random() * totalWeight
	local cumulative = 0
	for _, reward in ipairs(rewardBag) do
		cumulative = cumulative + (reward.chance or 0)
		if roll <= cumulative then
			return reward
		end
	end

	return rewardBag[#rewardBag]
end

function randomItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardBag = rewardBags[item.itemid]
	if not rewardBag then
		return false
	end

	local isTestMode = testMode and testMode.active
	if isTestMode then
		local openCount = math.max(1, tonumber(testMode.valueOpen) or 1)
		local receivedSummary = {}
		local totalItemsReceived = 0
		local failedAdds = 0
		local backpackAdds = 0
		local inboxAdds = 0

		for _ = 1, openCount do
			local rewardItem = selectReward(rewardBag)
			local rewardCount = rewardItem.count or 1
			local success, destination, addedItem = addRewardToPlayer(player, rewardItem.id, rewardCount)
			if success then
				totalItemsReceived = totalItemsReceived + rewardCount
				if destination == "backpack" then
					backpackAdds = backpackAdds + rewardCount
				elseif destination == "inbox" then
					inboxAdds = inboxAdds + rewardCount
				end

				local current = receivedSummary[rewardItem.id]
				if current then
					current.count = current.count + rewardCount
				else
					receivedSummary[rewardItem.id] = {
						name = rewardItem.name,
						count = rewardCount,
					}
				end

				if destination == "backpack" then
					if not player:removeItem(rewardItem.id, rewardCount) then
						logger.warn(string.format("[reward_bags][test_mode] cleanup_failed player=%s rewardId=%d rewardName=%s count=%d destination=backpack", player:getName(), rewardItem.id, rewardItem.name, rewardCount))
					end
				elseif destination == "inbox" then
					if not addedItem or not addedItem:remove(rewardCount) then
						logger.warn(string.format("[reward_bags][test_mode] cleanup_failed player=%s rewardId=%d rewardName=%s count=%d destination=inbox", player:getName(), rewardItem.id, rewardItem.name, rewardCount))
					end
				end
			else
				failedAdds = failedAdds + 1
				logger.warn(string.format("[reward_bags][test_mode] failed_add player=%s bagId=%d rewardId=%d rewardName=%s count=%d reason=%s", player:getName(), item.itemid, rewardItem.id, rewardItem.name, rewardCount, destination))
			end
		end

		local summaryList = {}
		for itemId, summary in pairs(receivedSummary) do
			summaryList[#summaryList + 1] = {
				itemId = itemId,
				name = summary.name,
				count = summary.count,
			}
		end

		table.sort(summaryList, function(a, b)
			return a.count > b.count
		end)

		logger.info(string.format("[reward_bags][test_mode] player=%s item=%s itemId=%d opens=%d totalItems=%d uniqueItems=%d backpackAdds=%d inboxAdds=%d failedAdds=%d", player:getName(), item:getName(), item.itemid, openCount, totalItemsReceived, #summaryList, backpackAdds, inboxAdds, failedAdds))
		for _, entry in ipairs(summaryList) do
			logger.info(string.format("[reward_bags][test_mode] reward itemId=%d name=%s count=%d", entry.itemId, entry.name, entry.count))
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Test mode: opened %d reward bags, received %d total item(s) [backpack: %d, inbox: %d], failed adds: %d. Check server log for details.", openCount, totalItemsReceived, backpackAdds, inboxAdds, failedAdds))
		item:remove(1)
		return true
	end

	local rewardItem = selectReward(rewardBag)
	local rewardCount = rewardItem.count or 1
	local success, destination = addRewardToPlayer(player, rewardItem.id, rewardCount)
	if not success then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no room in your backpack or store inbox to receive the reward.")
		logger.warn(string.format("[reward_bags] failed_add player=%s bagId=%d rewardId=%d rewardName=%s count=%d reason=%s", player:getName(), item.itemid, rewardItem.id, rewardItem.name, rewardCount, destination))
		return true
	end

	local destinationText = destination == "inbox" and " to your store inbox" or ""
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received a " .. rewardItem.name .. destinationText .. ".")

	local text = player:getName() .. " received a " .. rewardItem.name .. " from a " .. item:getName() .. "."
	Webhook.sendMessage(":game_die: " .. player:getMarkdownLink() .. " received a **" .. rewardItem.name .. "** from a _" .. item:getName() .. "_.")
	Broadcast(text, function(targetPlayer)
		return targetPlayer ~= player
	end)

	item:remove(1)
	return true
end

for itemId, info in pairs(rewardBags) do
	randomItems:id(tonumber(itemId))
end

randomItems:register()
