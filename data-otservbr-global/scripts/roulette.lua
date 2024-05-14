local config = {
    uniqueId = 30000, -- on lever

    lever = {
        left = 2772,
        right = 2773
    },

    playItem = {
        itemId = 19082,
        count = 1
    },

    rouletteOptions = {
        ignoredItems = {40471, 40472, 30881, 30882}, -- if you have tables/counters/other items on the roulette tiles, add them here
        winEffects = {CONST_ANI_FIRE, CONST_ME_SOUND_YELLOW, CONST_ME_SOUND_PURPLE, CONST_ME_SOUND_BLUE, CONST_ME_SOUND_WHITE}, -- first effect needs to be distance effect
        effectDelay = 333,
        spinTime = {min = 8, max = 8}, -- seconds
        spinSlowdownRamping = 40,
        rouletteStorage = "roulette-finishes" -- required storage to avoid player abuse (if they logout/die before roulette finishes.. they can spin again for free)
    },
	
	--{itemId = itemid, count = {min, max}, chance = chance/10000}
	--runes are given as stackable items, even tho they have 'charges'
    prizePool = {
		--100%
        {itemId = 19082, count = {2, 4},   chance = 10000}, --gold raid token
		
		--90%
        {itemId = 3155, count = {30, 100},   chance = 9000 }, --sudden death rune
		{itemId = 3160, count = {30, 100},   chance = 9000 }, --ultimate healing rune
		{itemId = 3179, count = {30, 100},   chance = 9000 }, --stalagmite
		{itemId = 3189, count = {30, 100},   chance = 9000 }, --fireball
		{itemId = 3158, count = {30, 100},   chance = 9000 }, --icicle rune
		{itemId = 3198, count = {30, 100},   chance = 9000 }, --heavy magic missile rune
		{itemId = 3182, count = {30, 100},   chance = 9000 }, --holy missile rune rune
		{itemId = 3161, count = {20, 100},   chance = 9000 }, --avalanche rune
		{itemId = 3191, count = {20, 100},   chance = 9000 }, --gfb rune
		{itemId = 3175, count = {20, 100},   chance = 9000 }, --stone shower rune
		{itemId = 3202, count = {20, 100},   chance = 9000 }, --thunderstorm rune
		{itemId = 3035, count = {20, 100},   chance = 9000 }, --platinum coin
		{itemId = 3052, count = {1, 1},   chance = 9000 }, --life ring
		
		--40%
		{itemId = 3418, count = {1, 1},   chance = 4000 }, --bonelord shield
		
		--35%
		{itemId = 3055, count = {1, 1},   chance = 3500 }, --platinum amulet
		{itemId = 3385, count = {1, 1},   chance = 3500 }, --crown helmet
		{itemId = 3416, count = {1, 1},   chance = 3500 }, --dragon shield

		--25%
		{itemId = 3043, count = {1, 25},   chance = 2500 }, --crystal coin
		{itemId = 3370, count = {1, 1},   chance = 2500 }, --knight armor
		{itemId = 3371, count = {1, 1},   chance = 2500 }, --knight legs
		{itemId = 3428, count = {1, 1},   chance = 2500 }, --tower shield
		
		--20%
		{itemId = 3381, count = {1, 1},   chance = 2000 }, --crown armor
		{itemId = 3382, count = {1, 1},   chance = 2000 }, --crown legs
		{itemId = 3419, count = {1, 1},   chance = 2000 }, --crown shield
		{itemId = 17858, count = {1, 1},   chance = 2000 }, --bufalo
		
		--15%
		{itemId = 10457, count = {1, 1},   chance = 1500 }, --beettle necklace
		{itemId = 5801, count = {1, 1},   chance = 1500 }, --jewelled backpack
		{itemId = 18339, count = {1, 1},   chance = 1500 }, --zaoan chess box
		{itemId = 12519, count = {1, 1},   chance = 1500 }, --caracol
		{itemId = 3057, count = {1, 1},   chance = 1500 }, --AOL
		
		--10%
		{itemId = 3043, count = {1, 50},   chance = 1000 }, --crystal coin
		{itemId = 10387, count = {1, 1},   chance = 1000 }, --zaoan legs
		{itemId = 3364, count = {1, 1},   chance = 1000 }, --golden legs
		{itemId = 3079, count = {1, 1},   chance = 1000 }, --boots of haste
		{itemId = 3554, count = {1, 1},   chance = 1000 }, --steel boots
		{itemId = 8063, count = {1, 1},   chance = 1000 }, --paladin armor
		{itemId = 8043, count = {1, 1},   chance = 1000 }, --focus cape		
		{itemId = 3434, count = {1, 1},   chance = 1000 }, --vampire shield	
		{itemId = 12549, count = {1, 1},   chance = 1000 }, --bamboo leaves
		{itemId = 14143, count = {1, 1},   chance = 1000 }, --marikita
		{itemId = 22118, count = {5, 20},   chance = 1000 }, --tibia coins
		
		--9%
		{itemId = 10385, count = {1, 1},   chance = 900 }, --zaoan helmet
		
		--7%
		{itemId = 5803, count = {1, 1},   chance = 700 }, --arbalest
		{itemId = 3420, count = {1, 1},   chance = 700 }, --demon shield
		
		--6%
		{itemId = 16244, count = {1, 1},   chance = 600 }, --music box
		
		--4%
		{itemId = 3366, count = {1, 1},   chance = 400 }, --magic plate armor
		{itemId = 16096, count = {1, 1},   chance = 400 }, --wand of defiance	
		{itemId = 16115, count = {1, 1},   chance = 400 }, --wand of everblazing	
		{itemId = 16117, count = {1, 1},   chance = 400 }, --muck rod	
		{itemId = 16118, count = {1, 1},   chance = 400 }, --glacial rod	
		{itemId = 3398, count = {1, 1},   chance = 400 }, --Dwarven Legs
		{itemId = 3414, count = {1, 1},   chance = 400 }, --mastermind shield
		{itemId = 19359, count = {1, 1},   chance = 400 }, --horn ring 1 armor
		{itemId = 11674, count = {1, 1},   chance = 400 }, --cobra crown
		{itemId = 3387, count = {1, 1},   chance = 400 }, --demon helmet
		{itemId = 9594, count = {1, 1},   chance = 400 }, --multiusos 1
		{itemId = 9596, count = {1, 1},   chance = 400 }, --multiusos 2
		{itemId = 9598, count = {1, 1},   chance = 400 }, --multiusos 3
		
		--3%
		{itemId = 8026, count = {1, 1},   chance = 300 }, --warsinger bow
		
		--less than 5%
		{itemId = 3309, count = {1, 1},   chance = 3 }, --thunder hammer 0.03%
		{itemId = 6529, count = {1, 1},   chance = 3 }, --soft boots 0.03%
		{itemId = 3363, count = {1, 1},   chance = 3 }, --dragon scale legs 0.03%		

    },

    roulettePositions = {
		Position(1553, 1335, 6),
		Position(1554, 1335, 6),
		Position(1555, 1335, 6),
		Position(1556, 1335, 6),
		Position(1557, 1335, 6),
		Position(1558, 1335, 6),
		Position(1559, 1335, 6),
		Position(1560, 1335, 6),
        Position(1561, 1335, 6),
		Position(1562, 1335, 6), --position 7 in this list is hard-coded to be the reward location, which is the item given to the player
        Position(1563, 1335, 6),
        Position(1564, 1335, 6),
        Position(1565, 1335, 6),
        Position(1566, 1335, 6),
        Position(1567, 1335, 6), 
        Position(1568, 1335, 6),
        Position(1569, 1335, 6),
        Position(1570, 1335, 6),
        Position(1571, 1335, 6),
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
            if i ~= 19 then
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
            config.roulettePositions[19]:sendDistanceEffect(config.roulettePositions[10], config.rouletteOptions.winEffects[1])
            config.roulettePositions[19]:sendDistanceEffect(config.roulettePositions[10], config.rouletteOptions.winEffects[1])
        else
            for i = 1, #config.roulettePositions do
                config.roulettePositions[i]:sendMagicEffect(config.rouletteOptions.winEffects[effectCounter])
            end
        end

        if effectCounter == 2 then
            local item = Tile(config.roulettePositions[10]):getTopVisibleThing()
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

    local item = Tile(config.roulettePositions[10]):getTopVisibleThing()
    local inbox = player:getInbox()
	local stack_size = item:getCount() or 1
	local item_id = item:getId()
    if inbox then
        local addedItem = inbox:addItem(item_id, stack_size, INDEX_WHEREEVER, FLAG_NOLIMIT)
    end

	local show_message = false
	for num, table in pairs(config.prizePool) do
		if table and table.itemId == item_id then
			if table.chance < 1000 then
				show_message = true
			end
			if item_id == 3043 and stack_size > 9 then
				show_message = true
			end
		end
	end
	
	local playerUid = player:getGuid()
	if stack_size > 1 then
		logRoulette("Roulette", 1, " Player id: " .. playerUid .. " has won " .. stack_size .. " " .. item:getName())
		player:sendTextMessage(MESSAGE_LOOK, "Congratulations! You have won " .. stack_size .. " " .. item:getName() .. ". The items has been sent to your inbox.")
		if show_message then
			Game.broadcastMessage("The player " .. player:getName() .. " has won " .. stack_size .. " " .. item:getName() .. " from the roulette!")
		end
	else
		logRoulette("Roulette", 1, " Player id: " .. playerUid .. " has won " .. item:getName())
		player:sendTextMessage(MESSAGE_LOOK, "Congratulations! You have won " .. item:getName() .. ". The item has been sent to your inbox.")
		if show_message then
			Game.broadcastMessage("The player " .. player:getName() .. " has won " .. item:getName() .. " from the roulette!")
		end
	end
	
    player:kv():set(config.rouletteOptions.rouletteStorage, -1)
    player:setMoveLocked(false)
	
end

local function roulette(playerId, leverPosition, spinTimeRemaining, spinDelay)
    local player = Player(playerId)
    if not player then
        resetLever(leverPosition)
        return
    end

    local newItemInfo = chanceNewReward()
    updateRoulette(newItemInfo)

    if spinTimeRemaining > 5000 then
        addEvent(roulette, spinDelay, playerId, leverPosition, spinTimeRemaining - spinDelay, spinDelay)
        return
    elseif spinTimeRemaining > 500 then
        spinDelay = spinDelay + config.rouletteOptions.spinSlowdownRamping
        addEvent(roulette, spinDelay, playerId, leverPosition, spinTimeRemaining - (spinDelay - config.rouletteOptions.spinSlowdownRamping), spinDelay)
        return
    elseif spinTimeRemaining > 0 then
        spinDelay = spinDelay + (config.rouletteOptions.spinSlowdownRamping * 3)
        addEvent(roulette, spinDelay, playerId, leverPosition, spinTimeRemaining - (spinDelay - config.rouletteOptions.spinSlowdownRamping), spinDelay)
        return
    end

    initiateReward(leverPosition, 0)
    rewardPlayer(playerId, leverPosition)
end

local casinoRoulette = Action()

function casinoRoulette.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == config.lever.right then
        player:sendTextMessage(MESSAGE_LOOK, "Peregrinaje Roulette is currently in progress. Please wait.")
        return true
    end

    if player:getItemCount(config.playItem.itemId) < config.playItem.count then
        if player:kv():get(config.rouletteOptions.rouletteStorage) < 1 then
            player:sendTextMessage(MESSAGE_LOOK, "Peregrinaje Roulette requires " .. config.playItem.count .. " " .. (ItemType(config.playItem.itemId):getName()) .. " to use.")
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

local disableMovingItemsToRoulettePositions = EventCallback()

disableMovingItemsToRoulettePositions.playerOnMoveItem = function(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
    for v, k in pairs(config.roulettePositions) do
        if toPosition == k then
            return false
        end
    end
    return true
end

disableMovingItemsToRoulettePositions:register()

local rouletteLogout = CreatureEvent("Roulette Logout")

function rouletteLogout.onLogout(player)
    if player:kv():get(config.rouletteOptions.rouletteStorage) == 1 then
        player:sendTextMessage(MESSAGE_LOOK, "You cannot disconnect while using Peregrinaje roulette!")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end
    return true
end

rouletteLogout:register()