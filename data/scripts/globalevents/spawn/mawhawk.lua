local config = {
    monsterName = 'Mawhawk',
    bossPosition = Position(33703, 32461, 7),
    centerPosition = Position(33703, 32461, 7),
    rangeX = 50,
    rangeY = 50
}

local function checkBoss(centerPosition, rangeX, rangeY, bossName)
    local spectators, spec = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
    for i = 1, #spectators do
        spec = spectators[i]
        if spec:isMonster() then
            if spec:getName() == bossName then
                return true
            end
        end
    end
    return false
end

local mawhawk = GlobalEvent("mawhawk")
function mawhawk.onThink(interval, lastExecution)
    if checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName) then
        return true
    end
    addEvent(Game.broadcastMessage, 150, 'Beware! Mawhawk!', MESSAGE_EVENT_ADVANCE)
    local boss =
    Game.createMonster(config.monsterName, config.bossPosition, true, true)
    boss:setReward(true)
    return true
end

mawhawk:interval(14399999)
mawhawk:register()
