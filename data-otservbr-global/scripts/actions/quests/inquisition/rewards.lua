local rewards = {
	[1300] = 8062,
	[1301] = 8090,
	[1302] = 8053,
	[1303] = 8060,
	[1304] = 8023,
	[1305] = 8096,
	[1306] = 8100,
	[1307] = 8102,
	[1308] = 8026
}

local inquisitionRewards = Action()
function inquisitionRewards.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheInquisition.Reward) < 1 then
		player:setStorageValue(Storage.TheInquisition.Reward, 1)
		player:setStorageValue(Storage.TheInquisition.Questline, 25)
		player:setStorageValue(Storage.TheInquisition.Mission07, 5) -- The Inquisition Questlog- "Mission 7: The Shadow Nexus"
		player:addItem(rewards[item.uid], 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. ItemType(rewards[item.uid]):getName() .. ".")
		player:addAchievement('Master of the Nexus')
		player:addOutfitAddon(288, 2)
		player:addOutfitAddon(288, 1)
		player:addOutfitAddon(289, 1)
		player:addOutfitAddon(289, 2)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
	end
	return true
end

for uniqueId, info in pairs(rewards) do
	inquisitionRewards:uid(uniqueId)
end

inquisitionRewards:register()
