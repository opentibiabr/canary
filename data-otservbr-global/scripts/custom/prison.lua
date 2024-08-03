--A prison system to punish player.  [Storages Used, 78913,78914] [Action ids used: 8032,8033]
local prison = {
    storage = 59999, -- used for material storage
    exhaustStorage = 60000, -- used for exhaust
    materialId = 45151, -- ore ID recieved from mining
    chance = 20, -- chance to receive materials
    miningExhaust = 2, -- based on seconds
    minedEffect = 50, -- effect on success
    failEffect = CONST_ME_POFF, -- effect on fail
    pickId = 31615, -- pick
    rockMineId = 1910, -- rock ID to use with pick
    smallRockId = 1913, -- ID to change to when mining successful
    rockMineRegeneration = 5, -- Seconds till it regenerate from the small rock to the mineRock
    position = Position(37302, 22072, 14), --position of your prison
    templePosition = Position(32369,32241,7), -- currently Thais Temple
    wagonAid = 39011, -- the actionid used for the ore wagon
    MiningRockActionId = 39012, -- the actionid used for rockMineId's inside the mine
}

--You would send them to prison for talkactions, setting a penalty X (storage). (/prison nick, 600)
local prisonTalkaction = TalkAction("/prison")  
function prisonTalkaction.onSay(player, words, param)
    if player:getGroup():getAccess() and param ~= "" then
        local split = param:split(",")
        local targetPlayer = Player(split[1])
        if not targetPlayer then
            player:sendCancelMessage('Player is offline or name is incorrect.')
            return false
        end
    targetPlayer:setStorageValue(prison.storage, tonumber(split[2]))
    targetPlayer:teleportTo(prison.position)
    targetPlayer:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "You have been jailed by "..player:getName()..".")
    player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "You have jailed "..targetPlayer:getName()..".")
    targetPlayer:addItem(prison.pickId)
    return false
    end
end
prisonTalkaction:separator(" ")
prisonTalkaction:groupType("god")
prisonTalkaction:register()
--They would be teleported to a prison, in this location there would be a mine with some rock piles, which would receive an actionID.

--The player must mine these rocks to collect a certain item, with an X% chance of finding that item.
local prisonPick = Action()
function prisonPick.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not Tile(toPosition):getItemById(prison.rockMineId) then
        return false
    end
    if not target:getActionId() == prison.MiningRockActionId then
        return false
    end
  
    if player:getStorageValue(prison.exhaustStorage) == prison.miningExhaust then
        --print("Exhausted")
        player:sendCancelMessage("You are exhausted.")
        return true
    end
    --print("player storage is set to "..player:getStorageValue(prison.exhaustStorage).." while exhaust is ".. prison.miningExhaust .."")
    player:setStorageValue(prison.exhaustStorage, prison.miningExhaust)
    addEvent(function()
        player:setStorageValue(prison.exhaustStorage, -1)
        player:sendCancelMessage("Swing!")
    end, prison.miningExhaust * 1000)
  
    local randomChance = math.random(1,100)
    if randomChance > prison.chance then
        target:getPosition():sendMagicEffect(prison.failEffect)
        player:sendCancelMessage("No materials found.")
        return true
    end
    target:getPosition():sendMagicEffect(prison.minedEffect)
    player:addItem(prison.materialId, 1)
    local pos = target:getPosition()
    target:remove(1)
    local smallRock = Game.createItem(prison.smallRockId, 1, pos)
  
    addEvent(function(pos)
        local smallRock = Tile(pos):getItemById(prison.smallRockId)
        if smallRock then
            smallRock:remove(1)
        end      
        local mineRock = Game.createItem(prison.rockMineId, 1, pos)
        mineRock:setActionId(prison.MiningRockActionId)
    end,prison.rockMineRegeneration * 1000, pos)
    return true
end

prisonPick:id(prison.pickId)
prisonPick:register()

--When collecting the item he must take it to a wagon, with another actionID, which will count these items.
    -- releaseCount = player:getStorageValue(prison.storage)

local wagon = Action()
function wagon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local releaseCount = player:getStorageValue(prison.storage)
    local count = player:getItemCount(prison.materialId)
    if count >= releaseCount then
        player:removeItem(prison.pickId, 1)
        player:removeItem(prison.materialId, count)
        player:setStorageValue(prison.storage, 0)
        player:sendTextMessage(MESSAGE_LOOK, "You have been released from prison, lets try not to return again.")
        player:teleportTo(prison.templePosition)
        return true
    end
    player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "You still need to mine "..releaseCount - count.." ore(s) to be released.")
    player:getPosition():sendMagicEffect(CONST_ME_POFF)
    return false
end

wagon:aid(prison.wagonAid)
wagon:register()
--Reaching an X value the player would be released (thrown to the temple)