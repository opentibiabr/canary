local teleportToFiend = TalkAction("/gotoinfluenced")

function teleportToFiend.onSay(player, words, param)
    logCommand(player, words, param)

    local influencedMonsters = Game.getInfluencedMonsters()
    if #influencedMonsters == 0 then
        player:sendCancelMessage("No Influenced creatures found.")
        return true
    end

    local randomIndex = math.random(1, #influencedMonsters)
    local monsterId = influencedMonsters[randomIndex]
    local monster = Creature(monsterId)

    if monster then
        local position = monster:getPosition()
        player:teleportTo(position)
    else
        player:sendCancelMessage("Influenced creature not found.")
    end

    return true
end

teleportToFiend:separator(" ")
teleportToFiend:groupType("god")
teleportToFiend:register()