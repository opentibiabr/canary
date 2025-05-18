local items = {
	{ itemid = 22731, count = 1 },
	{ itemid = 22731, count = 1 },
	{ itemid = 22731, count = 1 },
	{ itemid = 22731, count = 1 },
	{ itemid = 22737, count = 4 },
	{ itemid = 22775, count = 1 },
	{ itemid = 3043, count = 10 },
	{ itemid = 22516, count = 5 },
}

local ferumbrasAscendantReward = Action()
function ferumbrasAscendantReward.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 4073 then
		return false
	end
	if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Reward) >= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The treasure chest is empty.")
		return true
	end
	player:addAchievement("Hat Hunter")
	player:addOutfitAddon(852, 3)
	player:addOutfitAddon(846, 3)
	local bag = Game.createItem(2853)
	for i = 1, #items do
		bag:addItem(items[i].itemid, items[i].count)
	end
	if player:addItemEx(bag) ~= RETURNVALUE_NOERROR then
		local weight = bag:getWeight()
		if player:getFreeCapacity() < weight then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have found %s weighing %.2f oz. You have no capacity.", bag:getName(), (weight / 100)))
		else
			player:sendCancelMessage("You have found a bag, but you have no room to take it.")
		end
		return true
	end
	player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Reward, 1)
	return true
end

ferumbrasAscendantReward:uid(1035)
ferumbrasAscendantReward:register()
