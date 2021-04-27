local specialQuests = {
	[2016] = Storage.DreamersChallenge.Reward,
	[10544] = Storage.PitsOfInferno.WeaponReward,
	[12513] = Storage.ThievesGuild.Reward,
	[12374] = Storage.WrathoftheEmperor.mainReward,
	[26300] = Storage.SvargrondArena.RewardGreenhorn,
	[27300] = Storage.SvargrondArena.RewardScrapper,
	[28300] = Storage.SvargrondArena.RewardWarlord
}

local questsExperience = {
	[2217] = 1 -- dummy values
}

local questLog = {
	[9130] = Storage.HiddenCityOfBeregar.DefaultStart
}

local tutorialIds = {
	[50080] = 5,
	[50082] = 6,
	[50084] = 10,
	[50086] = 11
}

local hotaQuest = {50950, 50951, 50952, 50953, 50954, 50955}

local questSystem1 = Action()

function questSystem1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local storage = specialQuests[item.actionid]
	if not storage then
		storage = item.uid
		if storage > 65535 then
			return false
		end
	end

	if storage == 26300 or storage == 27300 or storage == 28300 then
		player:setStorageValue(Storage.SvargrondArena.PitDoor, -1)
	end

	if player:getStorageValue(storage) > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The ' .. ItemType(item.itemid):getName() .. ' is empty.')
		return true
	end

	local items, reward = {}
	local size = item:isContainer() and item:getSize() or 0
	if size == 0 then
		reward = item:clone()
	else
		local container = Container(item.uid)
		for i = 0, container:getSize() - 1 do
			items[#items + 1] = container:getItem(i):clone()
		end
	end

	size = #items
	if size == 1 then
		reward = items[1]:clone()
	end

	local result = ''
	if reward then
		local ret = ItemType(reward.itemid)
		if ret:isRune() then
			result = ret:getArticle() .. ' ' ..  ret:getName() .. ' (' .. reward.type .. ' charges)'
		elseif ret:isStackable() and reward:getCount() > 1 then
			result = reward:getCount() .. ' ' .. ret:getPluralName()
		elseif ret:getArticle() ~= '' then
			result = ret:getArticle() .. ' ' .. ret:getName()
		else
			result = ret:getName()
		end
	else
		if size > 20 then
			reward = Game.createItem(item.itemid, 1)
		elseif size > 8 then
			reward = Game.createItem(1988, 1)
		else
			reward = Game.createItem(1987, 1)
		end

		for i = 1, size do
			local tmp = items[i]
			if reward:addItemEx(tmp) ~= RETURNVALUE_NOERROR then
				Spdlog.warn("[questSystem1.onUse] - Could not add quest reward to container")
			end
		end
		local ret = ItemType(reward.itemid)
		result = ret:getArticle() .. ' ' .. ret:getName()
	end

	if player:addItemEx(reward) ~= RETURNVALUE_NOERROR then
		local weight = reward:getWeight()
		if player:getFreeCapacity() < weight then
			player:sendCancelMessage(string.format('You have found %s weighing %.2f oz. You have no capacity.', result, (weight / 100)))
		else
			player:sendCancelMessage('You have found ' .. result .. ', but you have no room to take it.')
		end
		return true
	end

	if questsExperience[storage] then
		player:addExperience(questsExperience[storage], true)
	end

	if questLog[storage] then
		player:setStorageValue(questLog[storage], 1)
	end

	if tutorialIds[storage] then
		player:sendTutorial(tutorialIds[storage])
		if item.uid == 50080 then
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 3)
		end
	end

	if isInArray(hotaQuest, item.uid) then
		if player:getStorageValue(Storage.TheAncientTombs.DefaultStart) ~= 1 then
			player:setStorageValue(Storage.TheAncientTombs.DefaultStart, 1)
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found ' .. result .. '.')
	player:setStorageValue(storage, 1)
	return true
end

for index, value in pairs(specialQuests) do
	questSystem1:aid(index)
end

questSystem1:aid(2000)
questSystem1:register()
