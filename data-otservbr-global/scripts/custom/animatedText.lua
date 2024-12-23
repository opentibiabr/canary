-- Table containing the effects to be applied to the positions
local effects = {
    {text = "Trainers", position = Position(32365, 32236, 7), effect = CONST_ME_TUTORIALSQUARE},
    {text = "Event Room", position = Position(32373, 32236, 7), effect = CONST_ME_TUTORIALSQUARE},
}

-- Create the global event
local animatedTextsEvent = GlobalEvent("Animated Texts")

-- Function that will be called every 20 seconds by the event
function animatedTextsEvent.onThink(interval)
    -- Iterate over the effects table
    for i, effect in ipairs(effects) do
        -- Retrieve the list of players that are watching the specific position
        local spectators = Game.getSpectators(effect.position, false, true, 8, 8, 8, 8)
        if #spectators > 0 then
            -- If there's a text to display, make all the spectators say the text
            if effect.text then
                for i = 1, #spectators do
                    spectators[i]:say(effect.text, TALKTYPE_MONSTER_SAY, false, spectators[i], effect.position)
                end
            end

            -- If there's an effect to display, send the effect to the position
            if effect.magicEffect then
                effect.position:sendMagicEffect(effect.magicEffect)
            end
        end
    end
    return true
end

-- Register the event and set the interval between onThink calls to 20 seconds
animatedTextsEvent:interval(4 * 1000)
animatedTextsEvent:register()