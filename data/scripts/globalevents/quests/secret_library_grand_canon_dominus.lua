local config = {
    monsterName = 'Grand Canon Dominus',
    bossPosition = Position(33384, 31282, 6),
    centerPosition = Position(33384, 31282, 6),
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

local canonDominus = GlobalEvent("canon dominus")
function canonDominus.onThink(interval, lastExecution)
    if checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName) then
        return true
    end

    local boss =
    Game.createMonster(config.monsterName, config.bossPosition, true, true)
    boss:setReward(true)
    return true
end

canonDominus:interval(900000)
canonDominus:register()
