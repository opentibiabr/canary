local items = {
	{itemid = 25387, count = 1},
	{itemid = 25387, count = 1},
	{itemid = 25387, count = 1},
	{itemid = 25387, count = 1},
	{itemid = 25393, count = 4},
	{itemid = 25431, count = 1},
	{itemid = 2160, count = 10},
	{itemid = 25172, count = 5}
}

local ferumbrasAscendantReward = Action()
function ferumbrasAscendantReward.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 12664 then
		return false
	end
	if player:getStorageValue(Storage.FerumbrasAscension.Reward) >= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The treasure chest is empty.')
		return true
	end
	player:addAchievement('Hat Hunter')
	player:addOutfitAddon(852, 3)
	player:addOutfitAddon(846, 3)
	local bag = Game.createItem(1987)
	for i = 1, #items do
		bag:addItem(items[i].itemid, items[i].count)
	end
	if player:addItemEx(bag) ~= RETURNVALUE_NOERROR then
		local weight = bag:getWeight()
		if player:getFreeCapacity() < weight then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format('You have found %s weighing %.2f oz. You have no capacity.', bag:getName(), (weight / 100)))
		else
			player:sendCancelMessage('You have found a bag, but you have no room to take it.')
		end
		return true
	end
	player:setStorageValue(Storage.FerumbrasAscension.Reward, 1)
	return true
end

ferumbrasAscendantReward:uid(1035)
ferumbrasAscendantReward:register()