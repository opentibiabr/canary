local config = {
    uniqueId = 64000, -- on lever

    lever = {
        left = 8911,
        right = 8912
    },

    playItem = {
        itemId = 37317,
        count = 1
    },

    rouletteOptions = {
        ignoredItems = {15487}, -- if you have tables/counters/other items on the roulette tiles, add them here
        winEffects = {CONST_ANI_FIRE, CONST_ME_SOUND_YELLOW, CONST_ME_SOUND_PURPLE, CONST_ME_SOUND_BLUE, CONST_ME_SOUND_WHITE}, -- first effect needs to be distance effect
        effectDelay = 333,
        spinTime = {min = 8, max = 12}, -- seconds
        spinSlowdownRamping = 5,
        rouletteStorage = "roulette-finishes" -- required storage to avoid player abuse (if they logout/die before roulette finishes.. they can spin again for free)
    },

    prizePool = {
        {itemId = 3079, count = {1, 1},    chance = 30000 }, -- Boots of Haste
        {itemId = 3420, count = {1, 1},    chance = 29000 }, -- Demon Shield
        {itemId = 3043, count = {5, 45}, chance = 29000 }, -- Crystal Coins
        {itemId = 9019, count = {1, 1},   chance = 25000}, -- Firewalker boots
        {itemId = 3366, count = {1, 1},    chance = 15000 }, -- MPA
        {itemId = 37317, count = {1, 3},   chance = 10000 }, -- Tibia Coins
        {itemId = 28717, count = {1, 1},    chance = 3000 },  -- Falcon Wand
        {itemId = 28715, count = {1, 1},    chance = 3000 }, -- Falcon Coif
        {itemId = 28720, count = {1, 1},    chance = 800 }, -- Falcon Greaves
        {itemId = 28719, count = {1, 1},    chance = 800 }, -- Falcon Plate
        {itemId = 30400, count = {1, 1},    chance = 800 }, -- Cobra Rod
        {itemId = 27647, count = {1, 1},    chance = 800 }, -- Gnome Helmet
        {itemId = 34153, count = {1, 1},    chance = 700 }, -- Lion Spellbook
        {itemId = 28714, count = {1, 1},    chance = 700 }, -- Falcon Circlet
        {itemId = 30397, count = {1, 1},    chance = 700 }, -- Cobra Hood        
        {itemId = 39546, count = {1, 1},    chance = 200 }, -- Primal Bag
        {itemId = 34109, count = {1, 1},    chance = 200 }, -- Bag you Desire
        {itemId = 43895, count = {1, 1},    chance = 100 } -- Bag you Covet
    },

    roulettePositions = {
        Position(32041, 33342, 7),
        Position(32042, 33342, 7),
        Position(32043, 33342, 7),
        Position(32044, 33342, 7),
        Position(32045, 33342, 7), -- position 11 in this list is hard-coded to be the reward location, which is the item given to the player
        Position(32046, 33342, 7),
        Position(32047, 33342, 7),
        Position(32048, 33342, 7),
        Position(32049, 33342, 7)
    }
}

local chancedItems = {}

local function resetLever(position)
    local lever = Tile(position):getItemById(config.lever.right)
    lever:transform(config.lever.left)
end

local function updateRoulette(newItemInfo)
    local positions = config.roulettePositions
    for i = #positions, 1, -1 do
        local item = Tile(positions[i]):getTopVisibleThing()
        if item and item:getId() ~= Tile(positions[i]):getGround():getId() and not table.contains(config.rouletteOptions.ignoredItems, item:getId()) then
            if i ~= 9 then
                item:moveTo(positions[i + 1])
            else
                item:remove()
            end
        end
    end

    if ItemType(newItemInfo.itemId):getCharges() then
        local item = Game.createItem(newItemInfo.itemId, 1, positions[1])
        item:setAttribute(ITEM_ATTRIBUTE_CHARGES, newItemInfo.count)
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
                item:setAttribute(ITEM_ATTRIBUTE_CHARGES, newItemInfo.count)
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
            config.roulettePositions[9]:sendDistanceEffect(config.roulettePositions[5], config.rouletteOptions.winEffects[1])
            config.roulettePositions[9]:sendDistanceEffect(config.roulettePositions[5], config.rouletteOptions.winEffects[1])
        else
            for i = 1, #config.roulettePositions do
                config.roulettePositions[i]:sendMagicEffect(config.rouletteOptions.winEffects[effectCounter])
            end
        end

        if effectCounter == 2 then
            local item = Tile(config.roulettePositions[5]):getTopVisibleThing()
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

    local item = Tile(config.roulettePositions[5]):getTopVisibleThing()
    local inbox = player:getInbox()
    if inbox then
        local addedItem = inbox:addItem(item:getId(), 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
        if addedItem and ItemType(item:getId()):getCharges() then
            addedItem:setAttribute(ITEM_ATTRIBUTE_CHARGES, item:getCharges())
        end
    end

    player:kv():set(config.rouletteOptions.rouletteStorage, -1)
    player:setMoveLocked(false)
    --player:sendColoredMessage("{yellow|[ROULETTE WINNER]} Congratulations! You have won a {blue|rare item} and {green|5000 gold}.")
    player:sendTextMessage(MESSAGE_LOOT, string.format("{%d|%s} You have won a {%d|%s}. It was sent to your inbox.", MESSAGE_COLOR_YELLOW, "[ROULETTE WINNER]", item:getId(), item:getName()))
    
    if isInArray({ 3079, 3420, 3043, 9019, 3366 }, item:getId()) then
        -- Dont alert in Blue Equipment reward
        --Game.broadcastMessage(string.format("{%d|%s} The player %s has won {%d|%s}", MESSAGE_COLOR_YELLOW, "[ROULETTE WINNER]", player:getName(), MESSAGE_COLOR_BLUE, item:getName()), MESSAGE_LOOT)
    elseif isInArray({ 37317, 28717, 28715, 28720, 28719, 30400, 27647 }, item:getId()) then
        Game.broadcastMessage(string.format("{%d|%s} The player %s has won {%d|%s}", MESSAGE_COLOR_YELLOW, "[ROULETTE WINNER]", player:getName(), MESSAGE_COLOR_PURPLE, item:getName()), MESSAGE_LOOT)
    elseif isInArray({ 34153, 28714, 30397, 39546, 34109, 43898 }, item:getId()) then
        Game.broadcastMessage(string.format("{%d|%s} The player %s has won {%d|%s}", MESSAGE_COLOR_YELLOW, "[ROULETTE WINNER]", player:getName(), MESSAGE_COLOR_YELLOW, item:getName()), MESSAGE_LOOT)
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
        player:sendTextMessage(MESSAGE_FAILURE, "Casino Roulette is currently in progress. Please wait.")
        return true
    end

    if player:getItemCount(config.playItem.itemId) < config.playItem.count then
        if player:kv():get(config.rouletteOptions.rouletteStorage) < 1 then
            player:sendTextMessage(MESSAGE_FAILURE, "Casino Roulette requires " .. config.playItem.count .. " " .. (ItemType(config.playItem.itemId):getName()) .. " to use.")
            return true
        end
    end

    item:transform(config.lever.right)
    clearRoulette()
    chancedItems = {}

    player:removeItem(config.playItem.itemId, config.playItem.count)
    player:kv():set(config.rouletteOptions.rouletteStorage, 1)
    player:setMoveLocked(true)

    local spinTimeRemaining = math.random((config.rouletteOptions.spinTime.min * 1000), (config.rouletteOptions.spinTime.max * 1000))
    roulette(player:getId(), toPosition, spinTimeRemaining, 100)
    return true
end

casinoRoulette:uid(config.uniqueId)
casinoRoulette:register()

disableMovingItemsToRoulettePositions = EventCallback("RouletteMovingPlyer")
function disableMovingItemsToRoulettePositions.playerOnMoveItem(self, item, count, fromPos, toPos, fromCylinder, toCylinder)
    for v, k in pairs(config.roulettePositions) do
        if toPos == k then
            return false
        end
    end
    return true
end
disableMovingItemsToRoulettePositions:register()

local rouletteLogout = CreatureEvent("Roulette Logout")

function rouletteLogout.onLogout(player)
    if player:kv():get(config.rouletteOptions.rouletteStorage) == 1 then
        player:sendTextMessage(MESSAGE_FAILURE, "You cannot disconnect while using roulette!")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end
    return true
end

rouletteLogout:register()