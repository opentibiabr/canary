local config = {
    actionId = 18562, -- on lever
    lever = {
        left = 2772,
        right = 2773
    },
    playItem = {
        itemId = 37317, -- item required to pull lever "Casino Token"
        count = 1
    },
    rouletteOptions = {
        rareItemChance_broadcastThreshold = 500,
        ignoredItems = {}, -- if you have tables/counters/other items on the roulette tiles, add them here
        winEffects = {CONST_ANI_FIRE, CONST_ME_SOUND_YELLOW, CONST_ME_SOUND_PURPLE, CONST_ME_SOUND_BLUE, CONST_ME_SOUND_WHITE}, -- first effect needs to be distance effect
        effectDelay = 333,
        spinTime = {min = 6, max = 12}, -- seconds
        spinSlowdownRamping = 5,
        rouletteStorage = 48550 -- required storage to avoid player abuse (if they logout/die before roulette finishes.. they can spin again for free)
    },
    prizePool = {
        {itemId = 3043, count = {50, 50},   chance = 5012}, -- crystal coins
        {itemId = 37317, count = {1, 2},   chance = 6011}, -- otro token
        {itemId = 23488, count = {1, 1},    chance = 6012 }, -- surprise box
        {itemId = 23488, count = {1, 1},    chance = 6012 }, -- surprise box
        {itemId = 23488, count = {1, 1},    chance = 6012 }, -- surprise box
        {itemId = 6529, count = {1, 1},    chance = 6011 }, -- soft boots
        {itemId = 23542, count = {1, 1},    chance = 6011 }, -- collar of blue plasma --
        {itemId = 23544, count = {1, 1},    chance = 6011 }, -- collar of red plasma
        {itemId = 23543, count = {1, 1},    chance = 6011 }, -- collar of green plasma ---
        {itemId = 16244, count = {1, 1},    chance = 1211 }, -- music box
        {itemId = 37110, count = {1, 1},    chance = 2530 }, -- exalted core
        {itemId = 28484, count = {1, 1},   chance = 1211 }, -- blueberry cupcake
        {itemId = 28485, count = {1, 1},   chance = 1211 }, -- strawberry cupcake
        {itemId = 37536, count = {1, 1},   chance = 1211 }, -- changing backpack
        {itemId = 32770, count = {20, 20}, chance = 5010 }, -- diamantes 20
        {itemId = 27845, count = {1, 1},   chance = 1000 }, -- mounts doll
        {itemId = 22721, count = {10, 10}, chance = 3100 }, -- gold tokens
        {itemId = 22516, count = {10, 10}, chance = 2530 }, -- silver tokens
        {itemId = 44610, count = {1, 1}, chance = 1513 }, -- greater sage gem
        {itemId = 44604, count = {1, 1}, chance = 1513 }, -- greater guardian gem
        {itemId = 44607, count = {1, 1}, chance = 1513 }, -- greater marksman gem
        {itemId = 44613, count = {1, 1}, chance = 1513 }, -- greater mystic gem
        {itemId = 23536, count = {5, 5}, chance = 4030 }, -- folded void carpet
        {itemId = 22737, count = {5, 5}, chance = 4040 }, -- folded rift carpet
        {itemId = 21947, count = {1, 1}, chance = 950 }, -- midnight panther doll
        {itemId = 6104, count = {1, 1}, chance = 2499 }, -- jewel case
        {itemId = 10346, count = {1, 1}, chance = 3550 }, -- santa backpack
        {itemId = 36727, count = {1, 1}, chance = 1621 }, -- wealth duplex
        {itemId = 19357, count = {1, 1}, chance = 1621 }, -- shrunken head necklace
        {itemId = 20273, count = {1, 1}, chance = 2504 }, -- golden prison key
        {itemId = 20270, count = {1, 1}, chance = 2504 }, -- silver prison key
        {itemId = 20271, count = {1, 1}, chance = 2504 }, -- copper prison key
        {itemId = 12669, count = {1, 1}, chance = 1000 }, -- nebula ring
    
    },
    roulettePositions = { -- hard-coded to 7 positions.
        Position(32366, 32232, 6),
        Position(32367, 32232, 6),
        Position(32368, 32232, 6), 
        Position(32369, 32232, 6),-- position 4 in this list is hard-coded to be the reward location, which is the item given to the player
        Position(32370, 32232, 6),
        Position(32371, 32232, 6),
        Position(32372, 32232, 6),
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
        Game.createItem(newItemInfo.itemId, newItemInfo.count, positions[1])
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
                Game.createItem(newItemInfo.itemId, newItemInfo.count, positions[i])
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
    resetLever(leverPosition)
end

local function rewardPlayer(playerId, leverPosition)
    local player = Player(playerId)
    if not player then
        return
    end
    
    local item = Tile(config.roulettePositions[4]):getTopVisibleThing()
    

    player:addItem(item:getId(), item:getCount(), true)

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

local casinoRoulette = Action()

function casinoRoulette.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == config.lever.right then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Casino Roulette is currently in progress. Please wait.")
        return true
    end
    
    if player:getItemCount(config.playItem.itemId) < config.playItem.count then
        if player:getStorageValue(config.rouletteOptions.rouletteStorage) < 1 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Casino Roulette requires " .. config.playItem.count .. " " .. (ItemType(config.playItem.itemId):getName()) .. " to use.")
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

casinoRoulette:aid(config.actionId)
casinoRoulette:register()

