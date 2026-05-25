local reward = {
	[58104] = 8453,
}
local bloodCrystal = Action()
function bloodCrystal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(58104) ~= 1 then
		player:addItem(reward[item.uid], 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a blood crystal.")
		player:setStorageValue(58104, 1)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
	end
	return true
end
for uniqueId, _ in pairs(reward) do
	bloodCrystal:uid(uniqueId)
end
bloodCrystal:register()
