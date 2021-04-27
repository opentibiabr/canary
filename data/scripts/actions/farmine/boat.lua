local config = {
    [57601] = Position(33326, 31351, 7),
    [57602] = Position(33382, 31292, 7),
    [57603] = Position(33374, 31310, 7),
    [64007] = Position(33346, 31349, 7),
}

local boat = Action()

function boat.onUse(player, item, fromPosition, itemEx, toPosition)
    for actionId, destination in pairs(config) do
        if item.actionid == actionId then
            player:teleportTo(destination)
            destination:sendMagicEffect(CONST_ME_POFF)
            fromPosition:sendMagicEffect(CONST_ME_POFF)
            return true
        end
    end
end

boat:aid(57601, 57602, 57603, 64007)
boat:register()
