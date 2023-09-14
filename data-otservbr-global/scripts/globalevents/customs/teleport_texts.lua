local effects = {
    {position = Position(32369, 32241, 7), text = 'Bem-vindo ao Meraki!', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(32365, 32236, 7), text = 'TRAINERS', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(32373, 32236, 7), text = 'EVENTS', effect = CONST_ME_GROUNDSHAKER},    
    {position = Position(32373, 32239, 7), text = 'NPC ISLAND', effect = CONST_ME_GROUNDSHAKER}, 
    {position = Position(32350, 32223, 7), text = 'TP Boss', effect = CONST_ME_GROUNDSHAKER}, 
    {position = Position(34238, 31032, 6), text = 'Proximas Hunts', effect = CONST_ME_GROUNDSHAKER}, 
    {position = Position(32350, 32224, 7), text = 'Hunts', effect = CONST_ME_GROUNDSHAKER}, 
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