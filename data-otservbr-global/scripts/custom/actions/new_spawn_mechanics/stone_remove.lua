
local bridgeMechanic = MoveEvent()

local ITEM_ID = 1791
local POSITION = Position(31681, 31852, 7)
local DURATION = 30 -- in seconds

function removeItem()
    local tile = Tile(POSITION)
    if tile then
        local item = tile:getItemById(ITEM_ID)
        if item then
            item:remove()
        end
    end
end

function respawnItem()
    local tile = Tile(POSITION)
    if tile then
        local item = tile:getItemById(ITEM_ID)
        if not item then
            Game.createItem(ITEM_ID, 1, POSITION)
        end
    end
end


function bridgeMechanic.onStepIn(player, item, fromPosition, target, toPosition, isHotkey)
    local creatureStorage = {
        storage = player:getStorageValue(349401),
        storage2 = player:getStorageValue(349402),
        storage3 = player:getStorageValue(349403),
        storage4 = player:getStorageValue(349404)
        }
    if creatureStorage.storage == 1 and creatureStorage.storage2 == 1 and creatureStorage.storage3 == 1 and creatureStorage.storage4 == 1 then
    removeItem()
    addEvent(respawnItem, DURATION * 1000)
    else
    return true
    end
    return true
end


bridgeMechanic:aid(60841)
bridgeMechanic:type("stepin")
bridgeMechanic:register()
