local ITEM_ID = 5770
local POSITION = Position(31652, 31844, 6)
local POSITION2 = Position(31653, 31844, 6)
local DURATION = 30 

local bridgeMechanic = MoveEvent()

function bridgeMechanic.onStepIn(player, item, fromPosition, target, toPosition, isHotkey)
    local tile = Tile(POSITION)
    local tile2 = Tile(POSITION2)
    if not tile and not tile2 then
        return false
    end

    local groundItem = tile:getGround()
    local groundItem2 = tile2:getGround()
    if groundItem and groundItem2 then
        return false 
    end

    local createdItem = Game.createItem(ITEM_ID, 1, POSITION)
    local createdItem2 = Game.createItem(ITEM_ID, 1, POSITION2)
    if not createdItem and not createdItem2 then
        return false 
    end
    player:getPosition():sendMagicEffect(244)
    player:say('The Bridge is repaired.', TALKTYPE_MONSTER_SAY)
    addEvent(function()
        if createdItem then
            createdItem:remove()
        end
        if createdItem2 then
            createdItem2:remove()
        end
    end, DURATION * 1000)
    
    return true
end

bridgeMechanic:aid(60839)
bridgeMechanic:type("stepin")
bridgeMechanic:register()
