local rewardBags = {
	[BAG_YOU_DESIRE] = {
		{ id = 34082, name = "soulcutter", weight = 0.05 },
		{ id = 34083, name = "soulshredder", weight = 0.01 },
		{ id = 34084, name = "soulbiter", weight = 0.05 },
		{ id = 34085, name = "souleater", weight = 0.01 },
		{ id = 34086, name = "soulcrusher", weight = 0.05 },
		{ id = 34087, name = "soulmaimer", weight = 0.05 },
		{ id = 34097, name = "pair of soulwalkers", weight = 0.05 },
		{ id = 34099, name = "soulbastion", weight = 0.05 },
		{ id = 34088, name = "soulbleeder", weight = 0.01 },
		{ id = 34089, name = "soulpiercer", weight = 0.05 },
		{ id = 34094, name = "soulshell", weight = 0.05 },
		{ id = 34098, name = "pair of soulstalkers", weight = 0.05 },
		{ id = 34090, name = "soultainter", weight = 0.01 },
		{ id = 34092, name = "soulshanks", weight = 0.05 },
		{ id = 34095, name = "soulmantle", weight = 0.05 },
		{ id = 34091, name = "soulhexer", weight = 0.01 },
		{ id = 34093, name = "soulstrider", weight = 0.05 },
		{ id = 34096, name = "soulshroud", weight = 0.05 },
		{ id = 50254, name = "soulgarb", weight = 0.05 },
		{ id = 50240, name = "soulsoles", weight = 0.05 },
		{ id = 50159, name = "soulkamas", weight = 0.01 },
	},

	[PRIMAL_BAG] = {
		{ id = 39147, name = "spiritthorn armor", weight = 0.01 },
		{ id = 39148, name = "spiritthorn helmet", weight = 0.01 },
		{ id = 39177, name = "charged spiritthorn ring", weight = 0.05 },
		{ id = 39149, name = "alicorn headguard", weight = 0.01 },
		{ id = 39150, name = "alicorn quiver", weight = 0.05 },
		{ id = 39180, name = "charged alicorn ring", weight = 0.05 },
		{ id = 39151, name = "arcanomancer regalia", weight = 0.05 },
		{ id = 39152, name = "arcanomancer folio", weight = 0.05 },
		{ id = 39183, name = "charged arcanomancer sigil", weight = 0.05 },
		{ id = 39153, name = "arboreal crown", weight = 0.05 },
		{ id = 39154, name = "arboreal tome", weight = 0.05 },
		{ id = 39186, name = "charged arboreal ring", weight = 0.05 },
		{ id = 50149, name = "charged ethereal ring", weight = 0.05 },
		{ id = 50188, name = "ethereal coned hat", weight = 0.01 },
	},

	[BAG_YOU_COVET] = {
		{ id = 43864, name = "sanguine blade", weight = 0.05 },
		{ id = 43866, name = "sanguine cudgel", weight = 0.05 },
		{ id = 43868, name = "sanguine hatchet", weight = 0.05 },
		{ id = 43870, name = "sanguine razor", weight = 0.02 },
		{ id = 43872, name = "sanguine bludgeon", weight = 0.05 },
		{ id = 43874, name = "sanguine battleaxe", weight = 0.05 },
		{ id = 43876, name = "sanguine legs", weight = 0.02 },
		{ id = 43877, name = "sanguine bow", weight = 0.01 },
		{ id = 43879, name = "sanguine crossbow", weight = 0.05 },
		{ id = 43881, name = "sanguine greaves", weight = 0.02 },
		{ id = 43882, name = "sanguine coil", weight = 0.02 },
		{ id = 43884, name = "sanguine boots", weight = 0.05 },
		{ id = 43885, name = "sanguine rod", weight = 0.02 },
		{ id = 43887, name = "sanguine galoshes", weight = 0.05 },
		{ id = 43865, name = "grand sanguine blade", weight = 0.00001 },
		{ id = 43867, name = "grand sanguine cudgel", weight = 0.00001 },
		{ id = 43869, name = "grand sanguine hatchet", weight = 0.00001 },
		{ id = 43871, name = "grand sanguine razor", weight = 0.00001 },
		{ id = 43873, name = "grand sanguine bludgeon", weight = 0.00001 },
		{ id = 43875, name = "grand sanguine battleaxe", weight = 0.00001 },
		{ id = 43878, name = "grand sanguine bow", weight = 0.00001 },
		{ id = 43880, name = "grand sanguine crossbow", weight = 0.00001 },
		{ id = 43883, name = "grand sanguine coil", weight = 0.00001 },
		{ id = 43886, name = "grand sanguine rod", weight = 0.00001 },
		{ id = 50146, name = "sanguine trousers", weight = 0.02 },
		{ id = 50157, name = "sanguine claws", weight = 0.02 },
	},
}

local randomItems = Action()
local warnedLegacyChanceField = false
_G.RewardBagSystem = _G.RewardBagSystem or {}
_G.RewardBagSystem.rewardBags = rewardBags

local function canAddItemToBackpackSilently(player, itemId, count)
	if type(count) ~= "number" or count < 1 or count ~= math.floor(count) then
		return false
	end

	local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
	if not backpack then
		return false
	end

	local itemType = ItemType(itemId)
	if not itemType then
		return false
	end

	local itemWeight = itemType:getWeight(count) / 100
	if (player:getFreeCapacity() / 100) < itemWeight then
		return false
	end

	local emptySlots = backpack:getEmptySlots(true)
	if itemType:isStackable() then
		local stackSize = itemType:getStackSize()
		local requiredSlots = math.max(1, math.ceil(count / stackSize))
		return emptySlots >= requiredSlots
	end

	return emptySlots >= count
end

local function addRewardToPlayer(player, itemId, count)
	if canAddItemToBackpackSilently(player, itemId, count) then
		local addToBackpack = player:addItem(itemId, count, false)
		if addToBackpack then
			return true, "backpack", addToBackpack
		end
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

local function getRewardWeight(reward)
	if reward.weight ~= nil then
		return reward.weight
	end

	if reward.chance ~= nil then
		if not warnedLegacyChanceField then
			logger.warn("[reward_bags] legacy field 'chance' detected. It is treated as relative weight. Rename to 'weight' to avoid confusion.")
			warnedLegacyChanceField = true
		end
		return reward.chance
	end

	return 0
end

local function selectReward(rewardBag)
	local totalWeight = 0
	for _, reward in ipairs(rewardBag) do
		totalWeight = totalWeight + getRewardWeight(reward)
	end

	if totalWeight <= 0 then
		return rewardBag[math.random(1, #rewardBag)]
	end

	local roll = math.random() * totalWeight
	local cumulative = 0
	for _, reward in ipairs(rewardBag) do
		cumulative = cumulative + getRewardWeight(reward)
		if roll <= cumulative then
			return reward
		end
	end

	return rewardBag[#rewardBag]
end
_G.RewardBagSystem.selectReward = selectReward

function randomItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardBag = rewardBags[item.itemid]
	if not rewardBag then
		return false
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
