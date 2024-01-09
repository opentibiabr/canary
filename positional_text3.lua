local textFloat3 = GlobalEvent("textFloat3")

local effects = {
    {position = Position(32357 , 32235 , 7), text = '', effect = 244},
    {position = Position(32361 , 32235 , 7), text = '', effect = 244},
    
    
}

function textFloat3.onThink(interval)
    for i = 1, #effects do
        local settings = effects[i]
        local spectators = Game.getSpectators(settings.position, false, true, 7, 7, 5, 5)
        if #spectators > 0 then
            if settings.text then
                for i = 1, #spectators do
                    spectators[i]:say(settings.text, TALKTYPE_MONSTER_SAY, false, spectators[i], settings.position)
                end
            end
            if settings.effect then
                settings.position:sendMagicEffect(settings.effect)
            end
        end
    end
   return true
end

textFloat3:interval(7000)
textFloat3:register()
