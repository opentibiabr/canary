local rewards = {
	[9302] = {
		storage = Storage.DeeplingBosses.Jaul,
		bossName = 'Jaul',
		items = {
			{rand = true, itemId = {13990, 14021}},
			{itemId = 3035, count = 50},
			{itemId = 14224},
			{itemId = 14042}
		}
	},
	[9303] = {
		storage = Storage.DeeplingBosses.Tanjis,
		bossName = 'Tanjis',
		items = {
			{rand = true, itemId = {14022, 3027}},
			{itemId = 14223},
			{itemId = 3035, count = 20},
			{itemId = 13990},
			{itemId = 14042}
		}
	},
	[9304] = {
		storage = Storage.DeeplingBosses.Obujos,
		bossName = 'Obujos',
		items = {
			{rand = true, itemId = {14023, 281}},
			{itemId = 14222},
			{itemId = 14043},
			{itemId = 3035, count = 30},
			{itemId = 13987}
		}
	}
}

local bossesReward = Action()

function bossesReward.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.uid > 25609 and item.uid < 25613 then
		local reward = rewards[item.uid]
		if not reward then
			return true
		end

		if player:getStorageValue(reward.storage) ~= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, reward.bossName .. ' defends his belongings and will not let you open his chest.')
			return true
		end


		for i = 1, #reward.items do
			local items = reward.items[i]
			if items.rand then
				if math.random(10) == 1 then
					player:addItem(items.itemId[math.random(#items.itemId)], 1)
				end
			else
				player:addItem(items.itemId, items.count or 1)
			end
		end

		player:setStorageValue(reward.storage, 0)
	end
	return true
end

bossesReward:uid(9302, 9303, 9304)
bossesReward:register()

