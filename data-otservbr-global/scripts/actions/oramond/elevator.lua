local firstFloor = Position(33638, 31903, 6)
local secondFloor =  Position(33638, 31903, 5)
local elevatorPusherItemId = 21053
local elevatorStructureItemId = 21057
local elevatorBaseItemId = 21061

local elevator = Action()

function elevator.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getPosition() ~= firstFloor and player:getPosition() ~= secondFloor  then
        return true
    end

    local firstTile = Tile(firstFloor)
    local secondTile = Tile(secondFloor)
    local fromTile = nil
    local toTile = nil

    if firstTile:getItemById(elevatorBaseItemId, -1) then
        fromTile = firstTile
        toTile = secondTile
    else
        fromTile = secondTile
        toTile = firstTile
    end

    local elevatorStructureItem = fromTile:getItemById(elevatorStructureItemId, -1)
    local elevatorBaseItem = fromTile:getItemById(elevatorBaseItemId, -1)

    elevatorBaseItem:moveTo(toTile)
    player:teleportTo(toTile:getPosition())
    elevatorStructureItem:moveTo(toTile)

    local elevatorPusherItem = toTile:getItemById(elevatorPusherItemId, -1)
    if not elevatorPusherItem then
        elevatorPusherItem = fromTile:getItemById(elevatorPusherItemId, -1)
        elevatorPusherItem:moveTo(toTile)
    else
        elevatorPusherItem:moveTo(fromTile)
    end

    return true
end

elevator:id(21051, 21058)
elevator:register()
