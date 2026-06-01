local rewardBagTest = TalkAction("/rewardbag")
local MAX_TEST_OPENS = 10000

local function sendUsage(player)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Usage: /rewardbag <bagItemId>, <opens>\nID Bags: You Desire: 34109 - Primal: 39546 - You Covet: 43895")
end

function rewardBagTest.onSay(player, words, param)
	local rewardBagSystem = _G.RewardBagSystem
	if not rewardBagSystem or not rewardBagSystem.rewardBags or not rewardBagSystem.selectReward then
		player:sendCancelMessage("Reward bag system is unavailable.")
		return true
	end

	local cleanedParam = param:trim()
	if cleanedParam == "" then
		sendUsage(player)
		return true
	end

	local split = cleanedParam:split(",")
	local bagItemId = tonumber(split[1] and split[1]:trim() or nil)
	if not bagItemId then
		sendUsage(player)
		return true
	end

	local rewardBag = rewardBagSystem.rewardBags[bagItemId]
	if not rewardBag then
		player:sendCancelMessage("Invalid reward bag item id.")
		return true
	end

	local openCount = math.max(1, math.min(tonumber(split[2] and split[2]:trim() or nil) or 1, MAX_TEST_OPENS))
	local receivedSummary = {}
	local totalItemsReceived = 0

	for _ = 1, openCount do
		local rewardItem = rewardBagSystem.selectReward(rewardBag)
		local rewardCount = rewardItem.count or 1
		totalItemsReceived = totalItemsReceived + rewardCount

		local current = receivedSummary[rewardItem.id]
		if current then
			current.count = current.count + rewardCount
		else
			receivedSummary[rewardItem.id] = {
				name = rewardItem.name,
				count = rewardCount,
			}
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

	logger.info(string.format("[rewardbagtest] player=%s bagItemId=%d opens=%d totalItems=%d uniqueItems=%d", player:getName(), bagItemId, openCount, totalItemsReceived, #summaryList))
	for _, entry in ipairs(summaryList) do
		local percent = (entry.count / totalItemsReceived) * 100
		logger.info(string.format("[rewardbagtest] reward itemId=%d name=%s count=%d normalized=%.4f%%", entry.itemId, entry.name, entry.count, percent))
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Reward bag test: simulated %d opens and %d total item(s). Check server log for details.", openCount, totalItemsReceived))
	return true
end

rewardBagTest:separator(" ")
rewardBagTest:groupType("gamemaster")
rewardBagTest:register()
