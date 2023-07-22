local config = {
    centerPosition = Position(33443, 31545, 13), -- Center Room  
	rangeX = 11,
	rangeY = 11,
}

local KingzelosDeath = CreatureEvent("zelosDeath")
local removeMonsters = false

function KingzelosDeath.onPrepareDeath(creature)
    local spectators = Game.getSpectators(config.centerPosition, false, false, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
    for _, cid in pairs(spectators) do
        if removeMonsters and cid:isMonster() and not cid:getMaster() then
            cid:remove()
        elseif cid:isPlayer() then
            if cid:getStorageValue(67099) == -1 then
                cid:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations you won Hand of the Inquisition Outfit.")
                cid:addOutfit(1244, 0)
                cid:addOutfit(1243, 0)
                cid:setStorageValue(67099, 1)
            end
        end
    end

    return true
end

KingzelosDeath:register()