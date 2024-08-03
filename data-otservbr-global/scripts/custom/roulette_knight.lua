local config = {
    actionId = 18564, -- on lever
    lever = {
        left = 21126,
        right = 21130
    },
    playItem = {
        itemId = 45248, -- item required to pull lever
        count = 1
    },
    rouletteOptions = {
        rareItemChance_broadcastThreshold = 500,
        ignoredItems = {1617}, -- if you have tables/counters/other items on the roulette tiles, add them here
        winEffects = {CONST_ANI_FIRE, CONST_ME_SOUND_YELLOW, CONST_ME_SOUND_PURPLE, CONST_ME_SOUND_BLUE, CONST_ME_SOUND_WHITE}, -- first effect needs to be distance effect
        effectDelay = 333,
        spinTime = {min = 8, max = 12}, -- seconds
        spinSlowdownRamping = 5,
        rouletteStorage = 48553 -- required storage to avoid player abuse (if they logout/die before roulette finishes.. they can spin again for free)
    },
    prizePool = {

		{itemId = 34109, count = {1, 1},    chance = 750 }, -- bag you desire 
		{itemId = 45248, count = {1, 1},    chance = 1500 }, -- roullete coin
		{itemId = 49606, count = {1, 1},    chance = 1500 }, -- bp
		{itemId = 49605, count = {1, 1},    chance = 1450 }, -- bp2
		{itemId = 49604, count = {1, 1},    chance = 1400 }, -- bp3
		{itemId = 49662, count = {1, 1},    chance = 1350 }, -- bp4
		{itemId = 49661, count = {1, 1},    chance = 1300 }, -- bp 5
		{itemId = 49614, count = {1, 1},    chance = 1200 }, -- ratmiral chest
		{itemId = 49610, count = {1, 1},    chance = 1150 }, -- skarlet chest
		{itemId = 49609, count = {1, 1},    chance = 1100 }, -- falcon chest
		{itemId = 49613, count = {1, 1},    chance = 1050 }, -- brainstealer chest
		{itemId = 49612, count = {1, 1},    chance = 1000 }, -- timira chest
		{itemId = 49611, count = {1, 1},    chance = 950 }, -- drume chest
		{itemId = 43860, count = {1, 1},    chance = 650 }, -- bag you covet
		{itemId = 36836, count = {1, 1},    chance = 900 }, -- eldricth caket
		{itemId = 39546, count = {1, 1},    chance = 700 }, -- primal bag
		{itemId = 20063, count = {1, 1},    chance = 1550 }, -- dream matter
		{itemId = 49614, count = {1, 1},    chance = 600 }, -- knight chest
		{itemId = 49747, count = {1, 1},    chance = 550 }, -- sword box
		{itemId = 49748, count = {1, 1},    chance = 500 }, -- club box 49750
		{itemId = 49750, count = {1, 1},    chance = 450 }, -- axe axe 49750
		{itemId = 33313, count = {1, 1},    chance = 1250}, -- Supreme Teleport Cube
        {itemId = 3555, count = {1, 1},    chance = 800  }  -- golden boots
    
    },
    roulettePositions = { -- hard-coded to 7 positions.
        Position(1285, 853, 7),
        Position(1286, 853, 7),
        Position(1287, 853, 7),
        Position(1288, 853, 7),-- position 4 in this list is hard-coded to be the reward location, which is the item given to the player {x = 1288, y = 853, z = 7}
        Position(1289, 853, 7),
        Position(1290, 853, 7),
        Position(1291, 853, 7),
    }
}

local chancedItems = {} -- used for broadcast. don't edit

local function resetLever(position)
    local lever = Tile(position):getItemById(config.lever.right)
    lever:transform(config.lever.left)
end

local function updateRoulette(newItemInfo)
    local positions = config.roulettePositions
    for i = #positions, 1, -1 do
        local item = Tile(positions[i]):getTopVisibleThing()
        if item and item:getId() ~= Tile(positions[i]):getGround():getId() and not table.contains(config.rouletteOptions.ignoredItems, item:getId()) then
            if i ~= 7 then
                item:moveTo(positions[i + 1])
            else
                item:remove()
            end
        end
    end
    if ItemType(newItemInfo.itemId):getCharges() then
        local item = Game.createItem(newItemInfo.itemId, 1, positions[1])
        item:setAttribute("charges", newItemInfo.count)
    else
        Game.createItem(newItemInfo.itemId, newItemInfo.count, positions[1])
    end
end

local function clearRoulette(newItemInfo)
    local positions = config.roulettePositions
    for i = #positions, 1, -1 do
        local item = Tile(positions[i]):getTopVisibleThing()
        if item and item:getId() ~= Tile(positions[i]):getGround():getId() and not table.contains(config.rouletteOptions.ignoredItems, item:getId()) then
            item:remove()
        end
        if newItemInfo == nil then
            positions[i]:sendMagicEffect(CONST_ME_POFF)
        else
            if ItemType(newItemInfo.itemId):getCharges() then
                local item = Game.createItem(newItemInfo.itemId, 1, positions[i])
                item:setAttribute("charges", newItemInfo.count)
            else
                Game.createItem(newItemInfo.itemId, newItemInfo.count, positions[i])
            end
        end
    end
end

local function chanceNewReward()
    local newItemInfo = {itemId = 0, count = 0}
    
    local rewardTable = {}
    while #rewardTable < 1 do
        for i = 1, #config.prizePool do
            if config.prizePool[i].chance >= math.random(10000) then
                rewardTable[#rewardTable + 1] = i
            end
        end
    end
    
    local rand = math.random(#rewardTable)
    newItemInfo.itemId = config.prizePool[rewardTable[rand]].itemId
    newItemInfo.count = math.random(config.prizePool[rewardTable[rand]].count[1], config.prizePool[rewardTable[rand]].count[2])
    chancedItems[#chancedItems + 1] = config.prizePool[rewardTable[rand]].chance
    
    return newItemInfo
end

local function initiateReward(leverPosition, effectCounter)
    if effectCounter < #config.rouletteOptions.winEffects then
        effectCounter = effectCounter + 1
        if effectCounter == 1 then
            config.roulettePositions[1]:sendDistanceEffect(config.roulettePositions[4], config.rouletteOptions.winEffects[1])
            config.roulettePositions[7]:sendDistanceEffect(config.roulettePositions[4], config.rouletteOptions.winEffects[1])
        else
            for i = 1, #config.roulettePositions do
                config.roulettePositions[i]:sendMagicEffect(config.rouletteOptions.winEffects[effectCounter])
            end
        end
        if effectCounter == 2 then
            local item = Tile(config.roulettePositions[4]):getTopVisibleThing()
            local newItemInfo = {itemId = item:getId(), count = item:getCount()}
            clearRoulette(newItemInfo)
        end
        addEvent(initiateReward, config.rouletteOptions.effectDelay, leverPosition, effectCounter)
        return
    end
end

local function rewardPlayer(playerId, leverPosition)
    local player = Player(playerId)
    if not player then
        return
    end
    
    local item = Tile(config.roulettePositions[4]):getTopVisibleThing()
    
    if ItemType(item:getId()):getCharges() then
        local addedItem = player:addItem(item:getId(), 1, true)
        addedItem:setAttribute("charges", item:getCharges())
    else
        player:addItem(item:getId(), item:getCount(), true)
    end

    player:setStorageValue(config.rouletteOptions.rouletteStorage, -1)
    if chancedItems[#chancedItems - 3] <= config.rouletteOptions.rareItemChance_broadcastThreshold then
        Game.broadcastMessage("The player " .. player:getName() .. " has won " .. item:getName() .. " from the roulette!", MESSAGE_EVENT_ADVANCE)
    end
end

local function roulette(playerId, leverPosition, spinTimeRemaining, spinDelay)
    local player = Player(playerId)
    if not player then
        resetLever(leverPosition)
        return
    end
    
    local newItemInfo = chanceNewReward()
    updateRoulette(newItemInfo)
    
    if spinTimeRemaining > 0 then
        spinDelay = spinDelay + config.rouletteOptions.spinSlowdownRamping
        addEvent(roulette, spinDelay, playerId, leverPosition, spinTimeRemaining - (spinDelay - config.rouletteOptions.spinSlowdownRamping), spinDelay)
        return
    end
    
    initiateReward(leverPosition, 0)
    rewardPlayer(playerId, leverPosition)
end

local casinoRoulette1 = Action()

function casinoRoulette1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == config.lever.right then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Casino Roulette is currently in progress. Please wait.")
        return true
    end
    
    if player:getItemCount(config.playItem.itemId) < config.playItem.count then
        if player:getStorageValue(config.rouletteOptions.rouletteStorage) < 1 then
            player:sendTextMessage(MESSAGE_STATUS_SMALL, "Casino Roulette requires " .. config.playItem.count .. " " .. (ItemType(config.playItem.itemId):getName()) .. " to use.")
            return true
        end
        -- player:sendTextMessage(MESSAGE_STATUS_SMALL, "Free Spin being used due to a previous unforeseen error.")
    end
    
    item:transform(config.lever.right)
    clearRoulette()
    chancedItems = {}
    
    player:removeItem(config.playItem.itemId, config.playItem.count)
    player:setStorageValue(config.rouletteOptions.rouletteStorage, 1)
    
    local spinTimeRemaining = math.random((config.rouletteOptions.spinTime.min * 1000), (config.rouletteOptions.spinTime.max * 1000))
    roulette(player:getId(), toPosition, spinTimeRemaining, 100)
    return true
end

casinoRoulette1:aid(config.actionId)
casinoRoulette1:register()


local disableMovingItemsToRoulettePositions = MoveEvent()

disableMovingItemsToRoulettePositions.onAddItem = function(moveitem, tileitem, position, item, count, fromPosition, toPosition)
    for v, k in pairs(config.roulettePositions) do
        if toPosition == k then
            return false
        end
    end
    return true
end

disableMovingItemsToRoulettePositions:position(config.roulettePositions)
disableMovingItemsToRoulettePositions:register()