local chests = {
	[1002] = {itemid = 3389, count = 1},
	[1003] = {itemid = 8077, count = 1},
	[1004] = {itemid = 14768, count = 1},
	[1005] = {itemid = 14769, count = 1}
}

local demonOakChest = Action()
function demonOakChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if chests[item.uid] then
		if player:getStorageValue(Storage.DemonOak.Done) ~= 2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'It\'s empty.')
			return true
		end

		local chest = chests[item.uid]
		local itemType = ItemType(chest.itemid)
		if itemType then
			local article = itemType:getArticle()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found ' .. (#article > 0 and article .. ' ' or '') .. itemType:getName() .. '.')
		end

		player:addItem(chest.itemid, chest.count)
		player:setStorageValue(Storage.DemonOak.Done, 3)
	end
	return true
end

for unique, itemInfo in pairs(chests) do
	demonOakChest:uid(unique)
end

demonOakChest:register()
