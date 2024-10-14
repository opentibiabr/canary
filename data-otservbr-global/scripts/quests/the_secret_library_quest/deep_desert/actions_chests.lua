local chests = {
	[1] = { position = Position(32970, 32314, 9), storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.FirstChest, reward = 28538, questlog = true },
	[2] = { position = Position(32980, 32308, 9), storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.SecondChest, reward = 28536, questlog = true },
	[3] = { position = Position(32955, 32282, 10), storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.ThirdChest, reward = 28537, questlog = false },
	[4] = { position = Position(32983, 32289, 10), storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.FourthChest, reward = 28535, questlog = false },
	[5] = { position = Position(32944, 32309, 8), storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.FifthChest, reward = 28818, questlog = true },
}

local actions_desert_chests = Action()

function actions_desert_chests.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for _, k in pairs(chests) do
		if toPosition == k.position then
			if player:getStorageValue(k.storage) ~= 1 then
				if k.questlog then
					player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Darashia.Questline, player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Darashia.Questline) + 1)
				end
				player:addItem(k.reward, 1)
				player:setStorageValue(k.storage, 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. ItemType(k.reward):getName():lower() .. ".")
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
			end
		end
	end

	return true
end

actions_desert_chests:aid(4931)
actions_desert_chests:register()
