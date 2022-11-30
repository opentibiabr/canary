-- This will kick the players in 1 min after the boss is dead AND add the 20 hours delay to go in again
local bossWarzoneDeath = CreatureEvent("BossWarzoneDeath")
function bossWarzoneDeath.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
    local info = warzoneConfig.findByName(creature:getName())
    if not info then
        return true
    end

    local spectators = Game.getSpectators(info.center, false, true, info.minRangeX, info.maxRangeX, info.minRangeY, info.maxRangeY)
    for i = 1, #spectators do
        spectators[i]:setStorageValue(info.storage, os.time() + info.interval)
        spectators[i]:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have one minute to loot the boss and leave the room.")
    end
    addEvent(warzoneConfig.resetRoom, 60 * 1000, info, "You were teleported out by the gnomish emergency device.", false)
    return true
end

bossWarzoneDeath:register()
