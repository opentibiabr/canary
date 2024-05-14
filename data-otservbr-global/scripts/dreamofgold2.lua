if 💛 then
    -- Reload Case
    💛:setState('⏹️')
    if 💛.DEBUG then
        print("[Dream Of Gold]: Reloaded")
    end
end

💛 = {}

💛.saved_positions = {}
💛.DEBUG = true
💛.COMMAND = '!dream'
💛.DESCRIPTION = 'Dream Of Gold Event!'
--💛:VERSION: 1.0
--💛:AUTHOR: 𝓜𝓲𝓵𝓵𝓱𝓲𝓸𝓻𝓮 𝓑𝓣
💛.MAX_MC = 3
💛.MIN_LEVEL = 10
💛.MIN_PLAYERS = 2
💛.MAX_PLAYERS = 20

--[[
    🆔: The item id
    💸: The amount of items
    🎲: The chance of getting the item
    🔝: Only for top # player
]]--
💛.REWARD_BAG = 2856
💛.REWARD_BAG_REMOVE_EFFECT = CONST_ME_CAKE
💛.REWARDS = {
    -- Default:
	{ 🆔 = 'platinum coin', 💸 = 30 },

    -- TOP 1:
	{ 🆔 = 'platinum coin', 🔝 = 1, 💸 = 60 },
	{ 🆔 =  19082, 🔝 = 1, 💸 = 4 },

    -- TOP 2:
	{ 🆔 = 'platinum coin', 🔝 = 2, 💸 = 60 },
	{ 🆔 =  19082, 🔝 = 2, 💸 = 2 },

    -- TOP 3:
	{ 🆔 = 'platinum coin', 🔝 = 3, 💸 = 60 }
}

--[[
    🆔: The item id
    💸: The score gained
    🎲: The chance of generating the item
    🚷: Only usable.
    🌈: Animated Number Colour
]]--
💛.SCORE_ITEMS = {
    { 🆔 = 'gold coin', 💸 = 1, 🎲 = 100, 🌈 = TEXTCOLOR_YELLOW },
    { 🆔 = 'platinum coin', 💸 = 2, 🎲 = 50, 🌈 = TEXTCOLOR_LIGHTGREY },
    { 🆔 = 3043, 💸 = 3, 🎲 = 25, 🌈 = TEXTCOLOR_LIGHTBLUE },
    { 🆔 = 5675, 💸 = 1000, 🎲 = 2, 🚷 = true, 🌈 = TEXTCOLOR_YELLOW }
}

-- ActionID used by [🚷 = true] score items
💛.SCORE_ITEM_USABLE_ACTIONID = IMMOVABLE_ACTION_ID

💛.SCORE_ITEM_UPDATE = 33 -- When there are 33% of score items on the map the map is refilled.
💛.PLAYER_SPEED = 75
💛.JOIN_TIME = 15
💛.WAIT_TIME = 80
💛.PREPARE_TIME = 10
💛.GAME_TIME = 60 * 2.5
💛.FINISH_TIME = 10

-- Multiplier for the score gained when a player gives a score item.
💛.🎛MIN = 1
💛.🎛MAX = 10

-- Automatic calculate the speed
💛.PLAYER_SPEED = 💛.PLAYER_SPEED * 2
💛.EVENTS = {}
💛.SCOREBOARD = {}
💛.SCOREBOARD_TOP_COUNT = 10 -- The amount of top players to show on the scoreboard.
-- Display player name with a colour by top position
--[[ Example:
    Top 1: 🍇
    Top 2: 💧
    Top 3: 🍏

    Default: 🏴

    Available colours:
    🏴: gray
    🍏: green
    💧: blue
    🍇: purple
    🍋: yellow
]]
💛.SCOREBOARD_TOP_COLOURS = {'🍇', '💧', '🍏'}
💛.SCORE_ITEM_COUNT = 0
💛.SCORE_ITEM_COUNT_MAX = 0

-- Using a 24-hour clock (23) [00-23]
💛.SCHEDULE = {
	"02:29:00",
    "06:29:00",
	"10:29:00",
	"14:29:00",
	"18:29:00",
	"22:29:00",
}

--[[ STATES:
    ⏹️: Stopped
    🔴: Started
    🔵: Waiting for players
    📋: Preparing
    🔶: In progress
    🔷: Finished
]]
💛.STATE = '⏹️'

💛.GAMEAREA = {
    fromPos = Position(1498, 1335, 7),
    toPos = Position(1520, 1355, 7)
}

💛.LOBBYAREA = {
    fromPos = Position(1503, 1331, 7),
    toPos = Position(1515, 1333, 7)
}

💛.GAMEPOSITIONS = {}
for x = 💛.GAMEAREA.fromPos.x, 💛.GAMEAREA.toPos.x do
    for y = 💛.GAMEAREA.fromPos.y, 💛.GAMEAREA.toPos.y do
        for z = 💛.GAMEAREA.fromPos.z, 💛.GAMEAREA.toPos.z do
			if x == 1509 and y == 1345 and z == 7 then

			else
				💛.GAMEPOSITIONS[#💛.GAMEPOSITIONS + 1] = Position(x, y, z)
			end
        end
    end
end

-- Auto-calculate the game area
💛.GAMEAREA.width = 💛.GAMEAREA.toPos.x - 💛.GAMEAREA.fromPos.x
💛.GAMEAREA.height = 💛.GAMEAREA.toPos.y - 💛.GAMEAREA.fromPos.y
💛.GAMEAREA.center = Position(💛.GAMEAREA.fromPos.x + 💛.GAMEAREA.width / 2, 💛.GAMEAREA.fromPos.y + 💛.GAMEAREA.height / 2, 💛.GAMEAREA.fromPos.z)

-- Auto-calculate the lobby area
💛.LOBBYAREA.width = 💛.LOBBYAREA.toPos.x - 💛.LOBBYAREA.fromPos.x
💛.LOBBYAREA.height = 💛.LOBBYAREA.toPos.y - 💛.LOBBYAREA.fromPos.y
💛.LOBBYAREA.center = Position(💛.LOBBYAREA.fromPos.x + 💛.LOBBYAREA.width / 2, 💛.LOBBYAREA.fromPos.y + 💛.LOBBYAREA.height / 2, 💛.LOBBYAREA.fromPos.z)

💛.CHECK_IP = {}

💛.getRandomPos = function (💛, area)
    local x = math.random(area.fromPos.x, area.toPos.x)
    local y = math.random(area.fromPos.y, area.toPos.y)
    local z = math.random(area.fromPos.z, area.toPos.z)
    local randomTile = Tile(x, y, z)
    local now = os.time()
    while not randomTile or not randomTile:isWalkable() or randomTile:getCreatureCount() ~= 0 do
        x = math.random(area.fromPos.x, area.toPos.x)
        y = math.random(area.fromPos.y, area.toPos.y)
        z = math.random(area.fromPos.z, area.toPos.z)
        randomTile = Tile(x, y, z)
        if os.time() - now > 20 then
            if 💛.DEBUG then
                print("[Dream Of Gold - Warning]: 💛.getRandomPos valid tile not found.")
            end
            return
        end
    end
    return Position(x, y, z)
end

💛.getGamePlayers = function (💛)
    local rangeX = 💛.GAMEAREA.width / 2
    local rangeY = 💛.GAMEAREA.height / 2
    return Game.getSpectators(💛.GAMEAREA.center, false, true, rangeX, rangeX, rangeY, rangeY)
end

💛.getLobbyPlayers = function (💛)
    local rangeX = 💛.LOBBYAREA.width / 2
    local rangeY = 💛.LOBBYAREA.height / 2
    return Game.getSpectators(💛.LOBBYAREA.center, false, true, rangeX, rangeX, rangeY, rangeY)
end

-- These are itemIds that have a specific color in the loot message.
local LOOT_COLOR_GREEN = 3038
local LOOT_COLOR_PURPLE = 33780
local LOOT_COLOR_GRAY = 3035
local LOOT_COLOR_BLUE = 3043
local LOOT_COLOR_YELLOW = 33952

local codeColours = {
    ["<gray>"] = string.format('{%d|', LOOT_COLOR_GRAY),
    ["<green>"] = string.format('{%d|', LOOT_COLOR_GREEN),
    ["<blue>"] = string.format('{%d|', LOOT_COLOR_BLUE),
    ["<purple>"] = string.format('{%d|', LOOT_COLOR_PURPLE),
    ["<yellow>"] = string.format('{%d|', LOOT_COLOR_YELLOW),
    ["<>"] = "}"
}

💛.getTextColoured = function (💛, text)
    for index, value in pairs(codeColours) do
        text = string.gsub(text, index, value)
    end
    return text
end

💛.addEvent = function (💛, 💠, ⌚, ...)
    if not 💠(💛, ⌚, ...) and ⌚ > 0 then
        💛.EVENTS[#💛.EVENTS + 1] = addEvent(💛.addEvent, 1000, 💛, 💠, ⌚ - 1, ...)
    end
end

💛.setState = function (💛, newState)
    if newState == '⏹️' then
        💛.STATE = '⏹️'
        if 💛.DEBUG then
            print('[Dream Of Gold - Info]: Dream of Gold event stopped.')
        end
        💛:stopEvent()
    elseif newState == '🔴' then
        💛.STATE = '🔴'
        if 💛.DEBUG then
            print('[Dream Of Gold - Info]: Dream of Gold event started.')
        end
        💛:startEvent()
    elseif newState == '🔵' then
        💛.STATE = '🔵'
        if 💛.DEBUG then
            print('[Dream Of Gold - Info]: Dream of Gold event waiting for players.')
        end
        💛:waitForPlayers()
    elseif newState == '📋' then
        💛.STATE = '📋'
        if 💛.DEBUG then
            print('[Dream Of Gold - Info]: Dream of Gold event preparing.')
        end
        💛:prepareEvent()
    elseif newState == '🔶' then
        💛.STATE = '🔶'
        if 💛.DEBUG then
            print('[Dream Of Gold - Info]: Dream of Gold event in progress.')
        end
        💛:startGame()
    elseif newState == '🔷' then
        💛.STATE = '🔷'
        if 💛.DEBUG then
            print('[Dream Of Gold - Info]: Dream of Gold event finished.')
        end
        💛:finishEvent()
    end
end

💛.broadcastMessage = function (💛, message, ...)
    for _, player in pairs(Game.getPlayers()) do
        player:sendTextMessage(MESSAGE_LOOT, 💛:getTextColoured(message:format(...)))
    end
end

💛.broadcastGame = function (💛, message, ...)
    for _, gamePlayer in pairs(💛:getGamePlayers()) do
        gamePlayer:sendTextMessage(MESSAGE_LOOT, 💛:getTextColoured(message:format(...)))
    end
end

💛.broadcastLobby = function (💛, message, ...)
    for _, lobbyPlayer in pairs(💛:getLobbyPlayers()) do
        lobbyPlayer:sendTextMessage(MESSAGE_LOOT, 💛:getTextColoured(message:format(...)))
    end
end

💛.getTime = function (💛, ⌚)
    if ⌚ < 1 then
        return '0 second'
    end

    local seconds = ⌚ % 60
    local minutes = (⌚ - seconds) / 60
    if seconds > 0 and minutes > 0 then
        return string.format("%d minute%s and %d second%s", minutes, minutes > 1 and 's' or '', seconds, seconds > 1 and 's' or '')
    elseif minutes > 0 then
        return string.format("%d minute%s", minutes, minutes == 1 and '' or 's')
    elseif seconds > 0 then
        return string.format("%d second%s", seconds, seconds == 1 and '' or 's')
    end
end

💛.createItems = function (💛)
    for _, position in pairs(💛.GAMEPOSITIONS) do repeat
        local tile = Tile(position)
        if not tile or tile:getItemCount() ~= 0 then
            break
        end

        local now = os.time()
        while true do
            if os.time() - now > 20 then
                if 💛.DEBUG then
                    print("[Dream Of Gold - Warning]: 💛.createItems valid score item not found.")
                end
                return
            end

            local scoreItemIndex = math.random(#💛.SCORE_ITEMS)
            local scoreItem = 💛.SCORE_ITEMS[scoreItemIndex]
            if scoreItem and math.random(100) <= scoreItem.🎲 then
                local it = ItemType(scoreItem.🆔)
                if it then
                    local item = Game.createItem(scoreItem.🆔, it:isStackable() and math.random(75) or 1, position)
                    if item then
                        if scoreItem.🚷 then
                            item:setCustomAttribute('scoreItemIndex', scoreItemIndex)
                        end
                        item:setActionId(💛.SCORE_ITEM_USABLE_ACTIONID)
                        💛.SCORE_ITEM_COUNT = 💛.SCORE_ITEM_COUNT + 1
                    end
                    break
                end
            end
        end
    until true end
    💛.SCORE_ITEM_COUNT_MAX = 💛.SCORE_ITEM_COUNT
end

-- This is cosmetic only, don't bother changing these things. Wait! What are you doing here 😱?
local beautifulColours = {🏴="gray",🍏="green",💧="blue",🍇="purple",🍋="yellow"}

💛.getScoreboard = function (💛)
    local scoreboard = {}
    for playerGuid, score in pairs(💛.SCOREBOARD) do
        local player = Player(playerGuid)
        if player then
            scoreboard[#scoreboard + 1] = {
                name = player:getName(),
                💸 = score.💸
            }
        end
    end
    table.sort(scoreboard, function (a, b)
        return a.💸 > b.💸
    end)
    local description = {}
    for index = 1, 💛.SCOREBOARD_TOP_COUNT do
        local score = scoreboard[index]
        if score then
            description[#description + 1] = string.format('%d. <%s>%s<> - <yellow>%d<>', index, beautifulColours[💛.SCOREBOARD_TOP_COLOURS[index] or '🏴'], score.name, score.💸)
        end
    end
    return table.concat(description, "\n")
end

💛.startEvent = function (💛)
    💛:broadcastMessage(string.format("[<purple>Dream of Gold<>] is about to start.\n\nRules:\n1. <yellow>Collect many coins as you can by walking over them or using the treasure chest.<>\n2. <yellow>The collection efficiency will be reduced if you change your speed in the game.<>"))
    💛:addEvent(function (💛, ⌚)
        if ⌚ == 0 then
            💛:setState('🔵')
        end
    end, 💛.JOIN_TIME)
end

💛.waitForPlayers = function (💛)
    💛:addEvent(function (💛, ⌚)
        if ⌚ == 0 then
            local lobbyPlayers = 💛:getLobbyPlayers()
            if #lobbyPlayers < 💛.MIN_PLAYERS then
                💛:setState('⏹️')
                --💛:broadcastMessage("[<purple>Dream of Gold<>] event stopped.")
                return
            end
            💛:setState('📋')
            return
        end
        local lobbyPlayers = 💛:getLobbyPlayers()
        if #lobbyPlayers >= 💛.MAX_PLAYERS then
            💛:setState('📋')
            return true
        end
		if ⌚ == 10 then
			💛:broadcastMessage("[<purple>Dream of Gold<>] will start in <green>%s<>.\n\nType <blue>%s join<> or use a Peregrinaje token while being on a protection zone to join the event.", 💛:getTime(⌚), 💛.COMMAND)
		elseif ⌚ % math.floor(💛.WAIT_TIME / 2) == 0 then
			💛:broadcastMessage("[<purple>Dream of Gold<>] will start in <green>%s<>.\n\nType <blue>%s join<> or use a Peregrinaje token while being on a protection zone to join the event.", 💛:getTime(⌚), 💛.COMMAND)
		elseif ⌚ % math.floor(💛.WAIT_TIME / 4) == 0 then
			💛:broadcastMessage("[<purple>Dream of Gold<>] will start in <green>%s<>.", 💛:getTime(⌚))
        end
    end, 💛.WAIT_TIME)
end

💛.prepareEvent = function (💛)
    💛:broadcastMessage("[<purple>Dream of Gold<>] event started.")
    💛:createItems()
    💛:addEvent(function (💛, ⌚)
        if ⌚ == 0 then
            💛:setState('🔶')
        elseif ⌚ % math.floor(💛.PREPARE_TIME / 4) == 0 then
            💛:broadcastLobby("[<purple>Dream of Gold<>] event in preparing.\nIn <green>%s<> the game will start.", 💛:getTime(⌚))
        end
    end, 💛.PREPARE_TIME)
end

💛.startGame = function (💛)
    -- lobbyPlayers send to game
    for _, lobbyPlayer in pairs(💛:getLobbyPlayers()) do
        local randomPos = 💛:getRandomPos(💛.GAMEAREA)
        if not randomPos then
            return
        end

        💛.SCOREBOARD[lobbyPlayer:getGuid()] = { 💸 = 0, 🎛 = 1 }
        lobbyPlayer:removeCondition(CONDITION_HASTE)
        local speed = lobbyPlayer:getSpeed()
        if speed ~= 💛.PLAYER_SPEED then
            lobbyPlayer:changeSpeed(💛.PLAYER_SPEED - speed)
        end
        lobbyPlayer:teleportTo(randomPos, false)
        randomPos:sendMagicEffect(CONST_ME_TELEPORT)
    end

    💛:addEvent(function (💛, ⌚)
        local gamePlayers = 💛:getGamePlayers()
        if #gamePlayers == 0 then
            💛:setState('⏹️')
            💛:broadcastMessage("[<purple>Dream of Gold<>] event stopped.")
            if 💛.DEBUG then
                print("[Dream Of Gold > Stopped]: No players in game.")
            end
            return true
        else
            for _, lobbyPlayer in pairs(gamePlayers) do
                local speed = lobbyPlayer:getSpeed()
                if speed ~= 💛.PLAYER_SPEED then
                    local score = 💛.SCOREBOARD[lobbyPlayer:getGuid()]
                    if score.🎛 < 💛.🎛MAX and speed > 💛.PLAYER_SPEED then
                        lobbyPlayer:removeCondition(CONDITION_HASTE)
                        lobbyPlayer:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
                        lobbyPlayer:sendCancelMessage("The efficiency of collection will be affected shortly.")
                        score.🎛 = math.min(score.🎛 + 1, 💛.🎛MAX)
                    end
                end
            end
        end

        if ⌚ == 0 then
            💛:setState('🔷')
        elseif ⌚ % math.floor(💛.GAME_TIME / 4) == 0 then
            💛:broadcastGame("[<purple>Dream of Gold<>] event in progress.\nIn <green>%s<> the event will finish.", 💛:getTime(⌚))
        elseif ⌚ % math.floor(💛.GAME_TIME / 8) == 0 then
            💛:broadcastGame("[<purple>Dream of Gold<>] Scoreboard:\n\n%s", 💛:getScoreboard())
        end

        -- Automatic create score items
        if 💛.SCORE_ITEM_COUNT / 💛.SCORE_ITEM_COUNT_MAX < 💛.SCORE_ITEM_UPDATE / 100 then
            💛:createItems()
            if 💛.DEBUG then
                print("[Dream Of Gold - Debug]: Automatic create score items.")
            end
        end
    end, 💛.GAME_TIME)
end

💛.finishEvent = function (💛)
    -- Stoped players
    for playerGuid, score in pairs(💛.SCOREBOARD) do
        local player = Player(playerGuid)
        if player then
			player:setMoveLocked(true)
            player:setDirection(DIRECTION_SOUTH)
        end
    end
    -- Clear event
    for _, position in pairs(💛.GAMEPOSITIONS) do
        local tile = Tile(position)
        if tile then
            for _, item in pairs(tile:getItems()) do
                item:remove()
            end
        end
    end
    💛.SCORE_ITEM_COUNT = 0
    💛.SCORE_ITEM_COUNT_MAX = 0
    💛:broadcastMessage("[<purple>Dream of Gold<>] event finished.")
    💛:addEvent(function (💛, ⌚)
        if ⌚ == 0 then
            💛:sendRewards()
            💛:setState('⏹️')
            if 💛.DEBUG then
                print("[Dream Of Gold - Debug]: Stop event and send rewards.")
            end
        else
            💛:broadcastGame("[<purple>Dream of Gold<>] Scoreboard:\n\n%s", 💛:getScoreboard())
            for playerGuid, score in pairs(💛.SCOREBOARD) do
                local player = Player(playerGuid)
                if player then
                    player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
                end
            end
        end
    end, 💛.FINISH_TIME)
end

💛.sendRewards = function (💛)
    local scoreboard = {}
    for playerGuid, score in pairs(💛.SCOREBOARD) do
        scoreboard[#scoreboard + 1] = {
            playerGuid = playerGuid,
            💸 = score.💸
        }
    end
    table.sort(scoreboard, function (a, b)
        return a.💸 > b.💸
    end)
    for 🔝, score in pairs(scoreboard) do
        local player = Player(score.playerGuid)
        if player then
            local rewardBag = Game.createItem(💛.REWARD_BAG, 1)
            if rewardBag then
                for _, rewardIt in pairs(💛.REWARDS) do repeat
                    if rewardIt.🎲 and math.random(100) > rewardIt.🎲 then
                        break
                    end
                    if rewardIt.🔝 and rewardIt.🔝 ~= 🔝 then
                        break
                    end
                    local it = ItemType(rewardIt.🆔)
                    if not it or it:getId() == 0 then
                        if 💛.DEBUG then
                            print("[Dream Of Gold - Debug]: Reward item not found: " .. rewardIt.🆔)
                        end
                        break
                    end
                    local reward = Game.createItem(rewardIt.🆔, it:isStackable() and math.min(100, math.max(1, rewardIt.💸 or 1)) or 1)
                    if reward then
                        rewardBag:addItemEx(reward, FLAG_NOLIMIT)
                    end
                until true end
				local random_token = math.random(100)
				if random_token > 80 then
                    local free_token = Game.createItem(19082, 2)
                    if free_token then
                        rewardBag:addItemEx(free_token, FLAG_NOLIMIT)
						rewardBag:setAttribute(ITEM_ATTRIBUTE_NAME, "Improved Reward")
                    end
				else
					rewardBag:setAttribute(ITEM_ATTRIBUTE_NAME, "Reward")
				end
                local returnValue = player:addItemEx(rewardBag)
                if returnValue ~= RETURNVALUE_NOERROR then
                    local inbox = player:getInbox()
                    if inbox then
                        inbox:addItemEx(rewardBag, INDEX_WHERETHER, FLAG_NOLIMIT)
                        player:sendTextMessage(MESSAGE_LOOT, 💛:getTextColoured(string.format("You are the <green>TOP %d<> and your received in your <gray>inbox<>:\n%s", 🔝, rewardBag:getContentDescription())))
                    end
                else
                    player:sendTextMessage(MESSAGE_LOOT, 💛:getTextColoured(string.format("You are the <green>TOP %d<> and your received:\n%s", 🔝, rewardBag:getContentDescription())))
                end
            end
        end
    end
end

💛.stopEvent = function (💛)
    for _, eventId in pairs(💛.EVENTS) do
        stopEvent(eventId)
    end
    💛.EVENTS = {}
    if 💛.SCORE_ITEM_COUNT ~= 0 or 💛.SCORE_ITEM_COUNT_MAX ~= 0 then
        -- Clear event
        for _, position in pairs(💛.GAMEPOSITIONS) do
            local tile = Tile(position)
            if tile then
                for _, item in pairs(tile:getItems()) do
                    item:remove()
                end
            end
        end
        💛.SCORE_ITEM_COUNT = 0
        💛.SCORE_ITEM_COUNT_MAX = 0
    end
    💛.CHECK_IP = {}
    local lobbyPlayers = 💛:getLobbyPlayers()
    for _, lobbyPlayer in pairs(lobbyPlayers) do
		--consolation prize
		local rewardBag = Game.createItem(💛.REWARD_BAG, 1)
		if rewardBag then
			rewardBag:setAttribute(ITEM_ATTRIBUTE_NAME, "Consolation Prize")
			
			local reward = Game.createItem(19082, 1)
			if reward then
				rewardBag:addItemEx(reward, FLAG_NOLIMIT)
			end
		
			local returnValue = lobbyPlayer:addItemEx(rewardBag)
			if returnValue ~= RETURNVALUE_NOERROR then
				local inbox = lobbyPlayer:getInbox()
				if inbox then
					inbox:addItemEx(rewardBag, INDEX_WHERETHER, FLAG_NOLIMIT)
					lobbyPlayer:sendTextMessage(MESSAGE_LOOT, 💛:getTextColoured(string.format("Consolation Prize received in your <gray>inbox<>:\n%s", rewardBag:getContentDescription())))
				end
			else
				lobbyPlayer:sendTextMessage(MESSAGE_LOOT, 💛:getTextColoured(string.format("Consolation Prize received:\n%s", rewardBag:getContentDescription())))
			end
		end
		--send player to his old position or temple
		local player_guid = lobbyPlayer:getGuid()
		local player_back_position = 💛.saved_positions[player_guid] and 💛.saved_positions[player_guid] or lobbyPlayer:getTown():getTemplePosition()
		lobbyPlayer:teleportTo(player_back_position, false)
		player_back_position:sendMagicEffect(CONST_ME_TELEPORT)
		💛.saved_positions[player_guid] = nil
    end
    local gamePlayers = 💛:getGamePlayers()
    for _, gamePlayer in pairs(gamePlayers) do
        gamePlayer:removeCondition(CONDITION_HASTE)
        local speed = gamePlayer:getSpeed()
        local baseSpeed = gamePlayer:getBaseSpeed()
        if speed ~= baseSpeed then
            gamePlayer:changeSpeed(baseSpeed - speed)
        end
		--send player to his old position or temple
		local player_guid = gamePlayer:getGuid()
		local player_back_position = 💛.saved_positions[player_guid] and 💛.saved_positions[player_guid] or gamePlayer:getTown():getTemplePosition()
		gamePlayer:teleportTo(player_back_position, false)
		player_back_position:sendMagicEffect(CONST_ME_TELEPORT)
		💛.saved_positions[player_guid] = nil
		--
        gamePlayer:setMoveLocked(false)
    end
    💛.SCOREBOARD = {}
end

local 📣 = TalkAction(💛.COMMAND)

📣.onSay = function (player, words, param, type)
	if param == "" then
        if 💛.STATE == '🔵' or 💛.STATE == '📋' then
			param = "join"
		end
	end
    if param == 'join' then
        if 💛.STATE == '⏹️' then
            player:sendCancelMessage("[Dream Of Gold]: The event is closed.")
            return false
        elseif 💛.STATE ~= '🔵' then
            player:sendCancelMessage("[Dream Of Gold]: The event is not waiting for players.")
            return false
        end
		
		local playerPosition = player:getPosition()
		if not playerPosition:isProtectionZoneTile() then
			player:sendTextMessage(MESSAGE_LOOK, "You need to be on a Protection Zone to enter Dream of Gold.")
			playerPosition:sendMagicEffect(CONST_ME_POFF)
			return false
		end
		
        if player:getLevel() < 💛.MIN_LEVEL then
            player:sendCancelMessage("[Dream Of Gold]: You need level " .. 💛.MIN_LEVEL .. " or higher to join.")
            return false
        end

        local 🏷 = player:getIp()
        local MC = 💛.CHECK_IP[🏷] or 0
        if (MC - 1) >= 💛.MAX_MC then
            player:sendCancelMessage("[Dream Of Gold]: You have reached the maximum number of players.")
            return false
        end

        local lobbyPlayers = 💛:getLobbyPlayers()
        if #lobbyPlayers >= 💛.MAX_PLAYERS then
            player:sendCancelMessage("[Dream Of Gold]: The event is full.")
            return false
        end

        for _, lobbyPlayer in pairs(lobbyPlayers) do
            if lobbyPlayer:getGuid() == player:getGuid() then
                player:sendCancelMessage("[Dream Of Gold]: You are already in the lobby.")
                return false
            end
        end

        local randomPos = 💛:getRandomPos(💛.LOBBYAREA)
        if not randomPos then
            if 💛.DEBUG then
                print("[Dream Of Gold - Debug]: No random position found in lobby area.")
            end
            return false
        end
		
		playerPosition:sendMagicEffect(CONST_ME_TELEPORT)
		local player_guid = player:getGuid()
		💛.saved_positions[player_guid] = playerPosition
        💛.CHECK_IP[🏷] = MC + 1
        player:teleportTo(randomPos, false)
        randomPos:sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Dream Of Gold]: You have been teleported to the lobby.")
        return false
    elseif param == "leave" then
        if 💛.STATE == '⏹️' then
            player:sendCancelMessage("[Dream Of Gold]: The event is closed.")
            return false
        elseif 💛.STATE == '🔵' then
            for _, lobbyPlayer in pairs(💛:getLobbyPlayers()) do
                if lobbyPlayer:getGuid() == player:getGuid() then
					--send player to his old position or temple
					local player_guid = player:getGuid()
					local player_back_position = 💛.saved_positions[player_guid] and 💛.saved_positions[player_guid] or player:getTown():getTemplePosition()
					player:teleportTo(player_back_position, false)
					player_back_position:sendMagicEffect(CONST_ME_TELEPORT)
					💛.saved_positions[player_guid] = nil
					--
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Dream Of Gold]: You have been teleported to the exit.")
                    local 🏷 = player:getIp()
                    local MC = 💛.CHECK_IP[🏷] or 0
                    if MC > 0 then
                        💛.CHECK_IP[🏷] = MC - 1
                    end
                    return false
                end
            end
            player:sendCancelMessage("[Dream Of Gold]: You are not in the lobby.")
            return false
        elseif 💛.STATE == '🔶' then
            for _, gamePlayer in pairs(💛:getGamePlayers()) do
                if gamePlayer:getGuid() == player:getGuid() then
					--send player to his old position or temple
					local player_guid = player:getGuid()
					local player_back_position = 💛.saved_positions[player_guid] and 💛.saved_positions[player_guid] or player:getTown():getTemplePosition()
					player:teleportTo(player_back_position, false)
					player_back_position:sendMagicEffect(CONST_ME_TELEPORT)
					💛.saved_positions[player_guid] = nil
					--
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Dream Of Gold]: You have been teleported to the exit.")
                    local 🏷 = player:getIp()
                    local MC = 💛.CHECK_IP[🏷] or 0
                    if MC > 0 then
                        💛.CHECK_IP[🏷] = MC - 1
                    end
                    return false
                end
            end
            player:sendCancelMessage("[Dream Of Gold]: You are not in the game.")
            return false
        end
        return false
    elseif param == "start" then
        if player:getAccountType() < ACCOUNT_TYPE_GOD then
            if player:getGroup():getAccess() then
                player:sendCancelMessage("[Dream Of Gold]: You don't have enough rights.")
            end
            return false
        end

        if 💛.STATE ~= '⏹️' then
            player:sendCancelMessage("[Dream Of Gold]: The event already started.")
            return false
        end

        💛:setState('🔴')
        return false
    elseif param == "stop" then
        if player:getAccountType() < ACCOUNT_TYPE_GOD then
            if player:getGroup():getAccess() then
                player:sendCancelMessage("[Dream Of Gold]: You don't have enough rights.")
            end
            return false
        end

        if 💛.STATE == '⏹️' then
            player:sendCancelMessage("[Dream Of Gold]: The event is closed.")
            return false
        end

        💛:setState('⏹️')
        💛:broadcastMessage("[<purple>Dream of Gold<>] event stopped.")
        return false
    elseif param == "finish" then
        if player:getAccountType() < ACCOUNT_TYPE_GOD then
            if player:getGroup():getAccess() then
                player:sendCancelMessage("[Dream Of Gold]: You don't have enough rights.")
            end
            return false
        end

        if 💛.STATE ~= '🔶' then
            player:sendCancelMessage("[Dream Of Gold]: The event is not in progress.")
            return false
        end

        💛:setState('🔷')
        return false
    end

    player:popupFYI(string.format("%s\n\nCommands:\n1. %s join - To join game.\n2. %s leave - Leave the game.%s", 💛.DESCRIPTION, 💛.COMMAND, 💛.COMMAND, (player:getAccountType() >= ACCOUNT_TYPE_GOD and string.format("\n3. %s start - Start game.\n4. %s stop - Stop game.\n5. %s finish - Finish game.", 💛.COMMAND, 💛.COMMAND, 💛.COMMAND) or "")))
    return false
end

📣:separator(" ")
📣:groupType("normal")
📣:register()

local 🏃 = MoveEvent()

🏃.onStepIn = function (creature, item, pos, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local tile = Tile(pos)
    if not tile or 💛.STATE ~= '🔶' then
        return true
    end

    for _, it in pairs(💛.SCORE_ITEMS) do
        local foundItem = tile:getItemById(it.🆔)
        if foundItem and not it.🚷 then
            local score = 💛.SCOREBOARD[player:getGuid()]
            if not score then
                if 💛.DEBUG then
                    print(string.format("[Dream Of Gold]: Player %s has no score.", player:getName()))
                end
                return true
            end

            local scoreGained = (it.💸 * foundItem:getCount()) / score.🎛
            score.💸 = score.💸 + scoreGained
            player:sendTextMessage(MESSAGE_EXPERIENCE_OTHERS, nil, pos, scoreGained, it.🌈, 0, TEXTCOLOR_NONE)
            foundItem:remove()
            💛.SCORE_ITEM_COUNT = 💛.SCORE_ITEM_COUNT - 1
            return true
        end
    end
    return true
end

🏃:position(unpack(💛.GAMEPOSITIONS))
🏃:register()

local 🎬 = Action()

🎬.onUse = function (player, item, fromPos, target, toPos, isHotkey)
    if 💛.STATE ~= '🔶' then
        return true
    end

    local scoreItemIndex = item:getCustomAttribute("scoreItemIndex")
    if not scoreItemIndex then
        return true
    end

    local scoreItem = 💛.SCORE_ITEMS[scoreItemIndex]
    if not scoreItem then
        return true
    end

    local score = 💛.SCOREBOARD[player:getGuid()]
    if not score then
        if 💛.DEBUG then
            print(string.format("[Dream Of Gold]: Player %s has no score.", player:getName()))
        end
        return true
    end

    local scoreGained = scoreItem.💸 / score.🎛
    score.💸 = score.💸 + scoreGained
    player:sendTextMessage(MESSAGE_EXPERIENCE_OTHERS, nil, fromPos, scoreGained, scoreItem.🌈, 0, TEXTCOLOR_NONE)
    item:remove()
    💛.SCORE_ITEM_COUNT = 💛.SCORE_ITEM_COUNT - 1
    return true
end

🎬:aid(💛.SCORE_ITEM_USABLE_ACTIONID)
🎬:register()

for _, time in pairs(💛.SCHEDULE) do
    local 📡 = GlobalEvent(string.format("DreamOfGoldTimer_%s", time))

    📡.onTime = function (interval)
        if 💛.STATE ~= '⏹️' then
            if 💛.DEBUG then
                print("[Dream Of Gold]: Try to start the event but the event is already running.")
            end
            return
        end
        💛:setState('🔴')
        return true
    end

    📡:time(time)
    📡:register()
end

--prevent moving items to floor
local anti_throw_items = EventCallback()
anti_throw_items.playerOnMoveItem = function(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	
	--check if player is on dream of gold
	local player_guid = self:getGuid()
	if 💛.SCOREBOARD[player_guid] then
		--check if the movement is on floor
		local tile = Tile(toPosition)
		if tile then
			self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			self:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end
    return true
end

anti_throw_items:register()

--random teleport in the middle
local random_teleport = MoveEvent()
function random_teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if player then
        local randomPos = 💛:getRandomPos(💛.GAMEAREA)
        if not randomPos then
            return
        end

        player:teleportTo(randomPos, false)
		randomPos:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end
random_teleport:uid(65528)
random_teleport:register()

--token
local Peregrinaje_token = Action()
function Peregrinaje_token.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local playerPosition = player:getPosition()
	local player_guid = player:getGuid()
	local is_on_dream = 💛.SCOREBOARD[player_guid] or false
	local player_on_roulette = playerPosition.x > 1550 and playerPosition.x < 1574 and playerPosition.y > 1327 and playerPosition.y < 1361 and playerPosition.z == 6 or false
	
	local can_go_dream = false
	if 💛.STATE == '🔵' or 💛.STATE == '📋' then
		can_go_dream = true
	end
	
	if not playerPosition:isProtectionZoneTile() then
		player:sendTextMessage(MESSAGE_LOOK, "You need to be on a Protection Zone to use the token.")
		playerPosition:sendMagicEffect(CONST_ME_POFF)
	elseif can_go_dream then
        if player:getLevel() < 💛.MIN_LEVEL then
            player:sendCancelMessage("[Dream Of Gold]: You need level " .. 💛.MIN_LEVEL .. " or higher to join.")
            return false
        end

        local 🏷 = player:getIp()
        local MC = 💛.CHECK_IP[🏷] or 0
        if (MC - 1) >= 💛.MAX_MC then
            player:sendCancelMessage("[Dream Of Gold]: You have reached the maximum number of players.")
            return false
        end

        local lobbyPlayers = 💛:getLobbyPlayers()
        if #lobbyPlayers >= 💛.MAX_PLAYERS then
            player:sendCancelMessage("[Dream Of Gold]: The event is full.")
            return false
        end

        for _, lobbyPlayer in pairs(lobbyPlayers) do
            if lobbyPlayer:getGuid() == player:getGuid() then
                player:sendCancelMessage("[Dream Of Gold]: You are already in the lobby.")
                return false
            end
        end

        local randomPos = 💛:getRandomPos(💛.LOBBYAREA)
        if not randomPos then
            if 💛.DEBUG then
                print("[Dream Of Gold - Debug]: No random position found in lobby area.")
            end
            return false
        end
		
		💛.saved_positions[player_guid] = playerPosition
        💛.CHECK_IP[🏷] = MC + 1
        player:teleportTo(randomPos, false)
        randomPos:sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Dream Of Gold]: You have been teleported to the lobby.")
	elseif is_on_dream then
		player:sendTextMessage(MESSAGE_LOOK, "You cannot go to the Roulette right now.")
		playerPosition:sendMagicEffect(CONST_ME_POFF)
	elseif player_on_roulette then
		player:sendTextMessage(MESSAGE_LOOK, "You are already at the Roulette.")
		playerPosition:sendMagicEffect(CONST_ME_POFF)
	else
		playerPosition:sendMagicEffect(CONST_ME_TELEPORT)
		💛.saved_positions[player_guid] = playerPosition
		local roulette_position = Position(1562, 1350, 6)
		player:teleportTo(roulette_position)
		roulette_position:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

Peregrinaje_token:id(19082)
Peregrinaje_token:register()

local Roulette_teleport = MoveEvent()
function Roulette_teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if player then
		local player_guid = player:getGuid()
		local player_back_position = 💛.saved_positions[player_guid] and 💛.saved_positions[player_guid] or player:getTown():getTemplePosition()
		
		local randomTile = Tile(player_back_position.x, player_back_position.y, player_back_position.z)
		while not randomTile or not randomTile:isWalkable() or randomTile:getCreatureCount() ~= 0 do
			local random_one = math.random()
			if random_one < 0.5 then
				random_one = -1
			else
				random_one = 1
			end
			local random_two = math.random()
			if random_two < 0.5 then
				random_two = -1
			else
				random_two = 1
			end
			player_back_position.x = player_back_position.x + random_one
			player_back_position.y = player_back_position.y + random_two
			randomTile = Tile(player_back_position.x, player_back_position.y, player_back_position.z)
		end
		player:teleportTo(player_back_position, false)
		player_back_position:sendMagicEffect(CONST_ME_TELEPORT)
		💛.saved_positions[player_guid] = nil
	end	
	return true
end
Roulette_teleport:uid(65529)
Roulette_teleport:register()
