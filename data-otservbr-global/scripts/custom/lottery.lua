local lottery = GlobalEvent("lottery")

local config = {
    interval = 60, -- 30 minute
    rewards = {
        {3043, 10}, 	-- Crystal Coin, 10
		{3043, 25}, 	-- Crystal Coin, 25
		{3043, 50}, 	-- Crystal Coin, 50
		{3043, 100},	-- Crystal Coin, 100
        {22721, 5},		-- Gold Token, 10
		{22721, 10},	-- Gold Token, 5
		{22516, 10},	-- Silver Token, 10
		{19083, 3},		-- Silver Raid Token, 3
		{19083, 6},		-- Silver Raid Token, 6
        {16129, 10},	-- Major Crystalline Token, 10
		{16128, 10},	-- Minor Crystalline Token, 10
		{20062, 25},	-- Cluster of Solace, 25
		{20063, 3},		-- Dream Matter, 3
		{20063, 5},		-- Dream Matter, 5
        {20264, 5},		-- Unrealized Dream, 5
		{37110, 1},		-- Exalted Core, 1
		{37110, 2},		-- Exalted Core, 2
		{37110, 3},		-- Exalted Core, 3
		{37109, 25},	-- Sliver, 25
        {36725, 1},		-- Stamina Extension
		{16244, 1},		-- Music Box
		{14112, 25},	-- Bar of Gold, 25
		{14112, 50},	-- Bar of Gold, 50
        {12548, 1},		-- Bag of Apple Slices, 1
		{12549, 1},		-- Bamboo Leaves, 1
		{27605, 1},		-- Candle Stump, 1
		{12311, 1},		-- Carrot on a Stick, 1
		{12547, 1},		-- Diapason, 1
        {16155, 1},		-- Decorative Ribbon, 1
		{12308, 1},		-- Reins, 1
		{12546, 1},		-- Fist on a Stick, 1
		{16153, 1},		-- Iron Loadstone, 1
		{12550, 1},		-- Golden Fir Cone, 1
        {14143, 1},		-- Four-Leaf Clover, 1
		{16154, 1},		-- Glow Wine, 1
		{14142, 1},		-- Foxtail, 1
		{21439, 1},		-- Lion's Heart, 1
		{12306, 1},		-- Leather Whip, 1
		{12307, 1},		-- Harness, 1
        {12260, 1},		-- Hunting Horn, 1
		{12509, 1},		-- Scorpion Sceptre, 1
		{12519, 1},		-- Slug Drug, 1
		{12305, 1},		-- Tin Key, 1
		{12318, 1},		-- Giant Shrimp, 1
        {12304, 1},		-- Maxilla Maximus, 1
		{12801, 1},		-- Golden Can of Oil, 1
		{21186, 1},		-- Control Unit, 1
		{5907, 1},		-- Slingshot, 1
		{17858, 1},		-- Leech, 1
		{12320, 1}		-- Sweet Smelling Bait, 1
    },
    website = false
}

function lottery.onThink(interval)
    local players = {}
    for _, player in ipairs(Game.getPlayers()) do
        if not player:getGroup():getAccess() then
            table.insert(players, player)
        end
    end

    local c = #players
    if c <= 0 then
        return true
    end

    local winner = players[math.random(#players)]

    local reward = config.rewards[math.random(#config.rewards)]
    local itemid, amount = reward[1], reward[2]
    winner:addItem(itemid, amount)

    local it = ItemType(itemid)
    local name = (amount == 1) and (it:getArticle() .. " " .. it:getName()) or (amount .. " " .. it:getPluralName())

    broadcastMessage("[LOTTERY SYSTEM] " .. winner:getName() .. " won " .. name .. "! Congratulations! (Next lottery in " .. config.interval .. " minute)")

    return true
end

lottery:interval(config.interval * 60 * 1000) -- Convert minutes to milliseconds
lottery:register()