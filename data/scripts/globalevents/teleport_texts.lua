local effects = {
    {position = Position(32358, 32241, 7), text = 'KOLISEUM!!', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(32365, 32236, 7), text = 'TRAINERS', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(32378, 32239, 7), text = 'TASKS!', effect = CONST_ME_GROUNDSHAKER},    
    {position = Position(1116, 1092, 7), text = 'ENTER', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(1114, 1096, 7), text = 'EXIT', effect = CONST_ME_GROUNDSHAKER},  
    {position = Position(32361, 32243, 7), text = 'KOLISEUM SPECTATOR!', effect = CONST_ME_GROUNDSHAKER},  
    {position = Position(32375, 32239, 7), text = 'LOW LEVEL TELEPORTS!', effect = CONST_ME_GROUNDSHAKER},  
    {position = Position(32286, 32211, 7), text = 'Thais!', effect = CONST_ME_GROUNDSHAKER},    
}

local animatedText = GlobalEvent("AnimatedText") 
function animatedText.onThink(interval)
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

animatedText:interval(4150)
animatedText:register()