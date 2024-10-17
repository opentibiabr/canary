local chests = {
	[4910] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.StrandHair, reward = 28490 },
	[4911] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.SkeletonNotes, reward = 28518, message = "You have discovered a skeleton. It seems to hold an old letter and its skull is missing." },
	[4912] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.EyeKey, reward = 28477 },
	[4913] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.ScribbledNotes, reward = 28515 },
	[4914] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.LotusKey, reward = 28476 },
	[4915] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.PeacockBallad, reward = 28710 },
	[4916] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.BlackSkull, reward = 28489 },
	[4917] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.EbonyPiece, reward = 28491 },
	[4918] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.SilverChimes, reward = 28494, message = "You see silver chimes dangling on the dragon statue in this room." },
}

local actions_asura_chests = Action()

function actions_asura_chests.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local chest = chests[item.uid]
	if not chests[item.uid] then
		return true
	end
	if player:getStorageValue(chest.storage) ~= 1 then
		player:addItem(chest.reward, 1)
		player:setStorageValue(chest.storage, 1)
		if not chest.message then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. ItemType(chest.reward):getName():lower() .. ".")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, chest.message)
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
	end
	return true
end

for uid in pairs(chests) do
	actions_asura_chests:uid(uid)
end

actions_asura_chests:register()
