local bpItems = {
	{name = 'ancient coin', count = 1},
	{name = 'draken sulphur', count = 1},
	{name = 'seacrest hair', count = 2},
	{name = 'mystical hourglass', count = 2},
	{name = 'gold token', count = 3},
	{name = 'blue gem', count = 1},
	{name = 'yellow gem', count = 1},
	{name = 'red gem', count = 1},
	{name = 'demon horn', count = 2},
	{name = 'slime heart', count = 2},
	{name = 'energy vein', count = 2},
	{name = 'petrified scream', count = 2},
	{name = 'brimstone shell', count = 2},
	{name = 'deepling wart', count = 2},
	{name = 'wyrm scale', count = 2},
	{name = 'hellspawn tail', count = 2}
}

local chests = {
	[14021] = {
		name = "porcelain mask",
		count = 1
	},
	[14022] = {
		name = "backpack",
		count = 1
	},
	[14023] = {
		name = "colourful feathers",
		count = 3
	}
}

local finalReward = Action()
function finalReward.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local setting = chests[item.uid]
	if not setting then
		return true
	end
	if item.uid == 14021 and player:getStorageValue(Storage.FirstDragon.RewardFeather) < os.time() then
		player:addItem(setting.name, setting.count, true)
		player:setStorageValue(Storage.FirstDragon.RewardFeather, os.time() + 24 * 3600)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You found ' ..setting.count.. ' ' ..setting.name..'.')
	elseif item.uid == 14022 and player:getStorageValue(Storage.FirstDragon.RewardBackpack) < os.time() then
		local bp = Game.createItem('Backpack', 1)
		if bp then
			for i = 1, #bpItems do
				bp:addItem(bpItems[i].name, count)
			end
			bp:moveTo(player)
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You found a backpack.')
		player:setStorageValue(Storage.FirstDragon.RewardBackpack, os.time() + 60 * 60 * 365 * 24)
	elseif item.uid == 14023 and player:getStorageValue(Storage.FirstDragon.RewardMask) < os.time() then
		player:addItem(setting.name, setting.count, true)
		player:setStorageValue(Storage.FirstDragon.RewardMask, os.time() + 60 * 60 * 5 * 24)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You found ' ..setting.count.. ' ' ..setting.name..'.')
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The ' ..getItemName(setting.itemId).. ' is empty.')
	end
	return true
end

for uniqueRange = 14021, 14023 do
	finalReward:uid(uniqueRange)
end

finalReward:register()
