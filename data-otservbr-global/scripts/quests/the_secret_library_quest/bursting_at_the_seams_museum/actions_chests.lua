local chests = {
	[4900] = { storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.SampleBlood, reward = 27874 },
	[4901] = { storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.BonyRod, reward = 27847 },
	[4902] = { storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.BrokenCompass, reward = 25746 },
}

local actions_museum_chests = Action()

function actions_museum_chests.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local chest = chests[item.uid]

	if not chests[item.uid] then
		return true
	end

	if player:getStorageValue(chest.storage) ~= 1 then
		player:addItem(chest.reward, 1)
		player:setStorageValue(chest.storage, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. ItemType(chest.reward):getName():lower() .. ".")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
	end

	return true
end

for uid in pairs(chests) do
	actions_museum_chests:uid(uid)
end

actions_museum_chests:register()
