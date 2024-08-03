local config = {
    teleportId = 1949,
    days = {
        ["Friday"] = {Position(33113, 31700, 7), Position(33114, 31699, 7)}, -- Morshabaal - monday-Segunda, tuesday-Terça, wednesday-Quarta, thursday-Quinta, friday-Sexta, saturday-Sabado and sunday-Domingo
    },
    bossPosition = Position(33114, 31699, 7),
    bossName     = 'Morshabaal',
    spawnTime    = '19:05:00'
}

local MorshabaalRespawn = GlobalEvent("MorshabaalRespawn")
function MorshabaalRespawn.onTime(interval)
    local day = config.days[os.date("%A")]
    if day then
        local item = Game.createItem(config.teleportId, 1, day[1])
        if item then
            if not item:isTeleport() then
                item:remove()
                return false
            end
            item:setDestination(day[2])
        end
        addEvent(function()
            Game.createMonster(config.bossName, config.bossPosition, false, true)
            Game.broadcastMessage(config.bossName .. ' In revenge for my brother death, I will devastate this continent!', MESSAGE_GAME_HIGHLIGHT)
        end, 5000)
    end
    return true
end

MorshabaalRespawn:time(config.spawnTime)
MorshabaalRespawn:register()