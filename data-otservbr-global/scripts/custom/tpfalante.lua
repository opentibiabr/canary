local effects = {
    {position = Position(32364, 32231, 7), text = 'TRAINERS', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(32364, 32235, 7), text = 'SALA DE BOSSES', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(32364, 32233, 7), text = 'HUNTS', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(32374, 32235, 7), text = 'ROLETA DA SORTE', effect = CONST_ME_GROUNDSHAKER},    
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

animatedText:interval(4550)
animatedText:register()