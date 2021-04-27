local chayenneReward = Action()
function chayenneReward.onUse(player, item, fromPosition, itemEx, toPosition)
	if player:getStorageValue(Storage.ChayenneReward) < 1 then
		local backpack = player:addItem(5949, 1)
		backpack:addItem(18511, 1)
		backpack:addItem(2745, 1)
		backpack:addItem(9948, 1)
		backpack:addItem(2144, 1)
		backpack:addItem(5882, 1)
		backpack:addItem(5791, 1)
		backpack:addItem(2114, 1)
		backpack:addItem(6570, 1)
		player:setStorageValue(Storage.ChayenneReward, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a beach backpack.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already got your reward.")
	end
	return true
end

chayenneReward:aid(55023)
chayenneReward:register()