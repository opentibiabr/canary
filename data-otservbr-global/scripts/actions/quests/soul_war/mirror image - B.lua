local MIRROR_ACTION_ID = 50052
local MIRROR_ITEM_ID = 33782
local TRANSFORMED_MIRROR_ITEM_ID = 33783
local TRANSFORMATION_DURATION = 900 * 1000 -- 15 minutos

local mirrored = Action()
function onUseMirror(player, item, fromPosition, target, toPosition, isHotkey)
    if not player or not player:isPlayer() then
        return false
    end

    if item.actionid == MIRROR_ACTION_ID and item.itemid == MIRROR_ITEM_ID then
        local mirrorImage = Game.createMonster("Mirror Image", toPosition)
        if not mirrorImage then
            return false
        end

        local mirror = Tile(toPosition):getItemById(MIRROR_ITEM_ID)
        if mirror then
            mirror:transform(TRANSFORMED_MIRROR_ITEM_ID)
            addEvent(function()
                local revertedMirror = Tile(toPosition):getItemById(TRANSFORMED_MIRROR_ITEM_ID)
                if revertedMirror then
                    revertedMirror:transform(MIRROR_ITEM_ID)
                end
            end, TRANSFORMATION_DURATION)
        end
    end
    return true
end

mirrored.onUse = onUseMirror
mirrored:aid(MIRROR_ACTION_ID)
mirrored:register()
