local reward = {
	[47404] = 635, -- parchment
	[47405] = 2822, -- map
}

local parchmentText = {
	[635] = [[Shovels - 19 pieces
Lockpicks - 43 pieces
Buckets - 20 pieces
Trousers - 8 pairs
Flour - 3 sacks
Tows - 26 pieces
Cheese - 5 wheels       *Who needs so much cheese...? -Belethor
Longswords - 47 pieces
Longbows - 35 pieces
Boots - 27 pairs]],
	[2822] = "A map of several known as well as completely exotic locations.",
}

local evrardItems = Action()
function evrardItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(item.uid) ~= 1 then
		local rewardId = reward[item.uid]
		local itemWeight = ItemType(rewardId):getWeight()
		if player:getFreeCapacity() < itemWeight then
			player:sendCancelMessage("You do not have enough capacity.")
			return true
		end

		local newItem = player:addItem(rewardId, 1)
		if not newItem then
			player:sendCancelMessage("You have no room to take it.")
			return true
		end

		if parchmentText[rewardId] then
			newItem:setAttribute(ITEM_ATTRIBUTE_TEXT, parchmentText[rewardId])
		end
		player:setStorageValue(item.uid, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. ItemType(rewardId):getName() .. ".")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
	end
	return true
end

for uniqueId, _ in pairs(reward) do
	evrardItems:uid(uniqueId)
end
evrardItems:register()