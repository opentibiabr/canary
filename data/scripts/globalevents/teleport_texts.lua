local effects = {
	{position = Position(32369, 32241, 7), text = 'Bem vindo ao GordonsOT', effect = CONST_ME_GROUNDSHAKER},
	{position = Position(32356, 32222, 7), text = 'GordonsOT', effect = CONST_ME_GROUNDSHAKER},
	{position = Position(32361, 32222, 7), text = 'GordonsOT', effect = CONST_ME_GROUNDSHAKER},
	{position = Position(32344, 32221, 6), text = 'Bem vindo ao GordonsOT', effect = CONST_ME_GROUNDSHAKER},
	{position = Position(32336, 32231, 6), text = 'TRAINERS', effect = CONST_ME_GROUNDSHAKER}, 
	{position = Position(32341, 32224, 6), text = 'Premium', effect = CONST_ME_GROUNDSHAKER}, 
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