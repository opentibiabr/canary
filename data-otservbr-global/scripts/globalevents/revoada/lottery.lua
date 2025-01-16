local lottery = GlobalEvent("lottery")

local config = {
	interval = 2, -- 2 hours
	rewards = {
		{ item = 3043, min = 5, max = 10 }, --crystal coin
		{ item = ITEM_REVOADA_COIN, min = 50, max = 400 }, --revoada coin
		{ item = 3043, min = 3, max = 5 }, --crystal coin
		{ item = 3043, min = 2, max = 7 }, --crystal coin
		{ item = 44740, min = 1, max = 2 }, --stamina refill
		{ item = 3043, min = 15, max = 30 }, --crystal coin
		{ item = ITEM_REVOADA_COIN, min = 50, max = 150 }, --revoada coin
		{ item = 37110, min = 1, max = 3 }, --exalted core
		{ item = 3043, min = 7, max = 12 }, --crystal coin
		{ item = 3043, min = 15, max = 25 }, --crystal coin
		{ item = 33893, min = 1, max = 3 }, --love dust
	}, -- Random Reward
	website = false,
	checkDuplicateIps = false,
}

function lottery.onThink(interval)
	local allPlayers = Game.getPlayers()
	if #allPlayers == 0 then
		return true
	end

	local players = {}
	local checkIp = {}
	for _, player in pairs(allPlayers) do
		local ip = player:getIp()
		if ip ~= 0 and (not config.checkDuplicateIps or not checkIp[ip]) then
			checkIp[ip] = true
			if player:getGroup():getId() < GROUP_TYPE_SENIORTUTOR then
				table.insert(players, player)
			end
		end
	end

	if #players < 4 then
		return true
	end

	local winner = players[math.random(#players)]
	local reward = config.rewards[math.random(#config.rewards)]
	local amount = math.random(reward.min, reward.max)
	winner:addItem(reward.item, amount)

	local it = ItemType(reward.item)
	local desc = amount == 1 and it:getArticle() .. " " .. it:getName() or amount .. " " .. it:getPluralName()

	broadcastMessage(string.format("[LOTTERY SYSTEM] %s won %s! Congratulations! (Next lottery in %i hours)", winner:getName(), desc, config.interval), MESSAGE_EVENT_ADVANCE)

	return true
end

lottery:interval(config.interval * 60 * 60 * 1000)
lottery:register()
