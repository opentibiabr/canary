local textFloat2 = GlobalEvent("textFloat2")

local effects = {
    {position = Position(32356 , 32237 , 7), text = '', effect = 244},
    {position = Position(32362 , 32237 , 7), text = '', effect = 244},
    
    
}

function textFloat2.onThink(interval)
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

textFloat2:interval(3000)
textFloat2:register()
