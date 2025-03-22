local teleportToFiend = TalkAction("/gotofiend")

function teleportToFiend.onSay(player, words, param)
    logCommand(player, words, param)

    local fiendishMonsters = Game.getFiendishMonsters()
    if #fiendishMonsters == 0 then
        player:sendCancelMessage("No fiendish creatures found.")
        return true
    end

    local randomIndex = math.random(1, #fiendishMonsters)
    local monsterId = fiendishMonsters[randomIndex]
    local monster = Creature(monsterId)

    if monster then
        local position = monster:getPosition()
        player:teleportTo(position)
    else
        player:sendCancelMessage("Fiendish creature not found.")
    end

    return true
end

teleportToFiend:separator(" ")
teleportToFiend:groupType("god")
teleportToFiend:register()
