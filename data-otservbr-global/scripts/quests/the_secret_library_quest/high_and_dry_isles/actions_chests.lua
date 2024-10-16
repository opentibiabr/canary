local chests = {
	[4920] = { storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Parchment, reward = 28650, amount = 1 },
	[4921] = { storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Sapphire, reward = 675, amount = 2 },
	[4922] = { storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Fishing, reward = 3483, amount = 1 },
	[4923] = { storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Shovel, reward = 3457, amount = 1 },
	[4925] = { storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Hawser, reward = 28707, amount = 1 },
}

local actions_isles_chests = Action()

function actions_isles_chests.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local chest = chests[item.uid]
	if not chests[item.uid] then
		return true
	end

	local article = "a"

	if player:getStorageValue(chest.storage) ~= 1 then
		player:addItem(chest.reward, chest.amount)
		player:setStorageValue(chest.storage, 1)
		if chest.amount > 1 then
			article = "" .. chest.amount
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have found %s %s.", article, ItemType(chest.reward):getName():lower()))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
	end

	return true
end

for uid in pairs(chests) do
	actions_isles_chests:uid(uid)
end

actions_isles_chests:register()
