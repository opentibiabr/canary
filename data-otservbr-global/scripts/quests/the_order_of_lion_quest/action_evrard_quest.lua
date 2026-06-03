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
		local newItem = player:addItem(reward[item.uid], 1)
		if newItem and parchmentText[reward[item.uid]] then
			newItem:setAttribute(ITEM_ATTRIBUTE_TEXT, parchmentText[reward[item.uid]])
		end
		player:setStorageValue(item.uid, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. ItemType(reward[item.uid]):getName() .. ".")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
	end
	return true
end

for uniqueId, _ in pairs(reward) do
	evrardItems:uid(uniqueId)
end
evrardItems:register()
