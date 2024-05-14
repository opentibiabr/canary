local talkAction = TalkAction("/counter")

function talkAction.onSay(player, words, param, type)
    Game.createMonsterCounter({
        position = player:getPosition(),
        seconds = 10,
        prefix = "Counter: ",
        suffix = "seconds",
        onEnd = function(position)
            Game.createMonster("Orc Warrior", position, true, true)
        end,
        onThink = function(seconds, position)
            position:sendMagicEffect(232)
            if seconds == 5 then
                Game.createMonster("Rotworm", position, true, true)
            end
        end
    })
    return false
end

talkAction:separator(" ")
talkAction:groupType("gamemaster")
talkAction:register()