local textFloat = GlobalEvent("textFloat")

local effects = {
    {position = Position(32361, 32237, 7), text = '8+', effect = 244},
    {position = Position(32360, 32237, 7), text = '100+', effect = 5},
    {position = Position(32359, 32237, 7), text = '250+', effect = 5},
    {position = Position(32358, 32237, 7), text = '400+', effect = 5},
    {position = Position(32357, 32237, 7), text = '650+', effect = 244},

    {position = Position(31701, 32302, 11), text = 'SOMENTE IDA', effect = 38},
    {position = Position(31707, 32302, 11), text = 'TPS SEM VOLTA', effect = 38},

    {position = Position(31701, 32313, 11), text = 'SOMENTE IDA', effect = 38},
    {position = Position(31707, 32313, 11), text = 'TPS SEM VOLTA', effect = 38},

    
    {position = Position(31799, 32171, 8), text = 'SOMENTE IDA', effect = 38},
    {position = Position(31805, 32171, 8), text = 'TPS SEM VOLTA', effect = 38},




	{position = Position(32359, 32236, 7), text = 'Teleport Hunts!', effect = 38},

	{position = Position(32376, 32243, 7), text = 'Teleports!', effect = 38},
    {position = Position(32365, 32236, 7), text = 'Trainers', effect = 242},
    {position = Position(32356, 32219, 7), text = 'Trainers', effect = 242},
    {position = Position(32361, 32219, 7), text = 'Trade Island', effect = 242},
    {position = Position(32060, 31884, 5), text = 'Assassin Class', effect = 244},
    {position = Position(32065, 31884, 5), text = 'Knight Class', effect = 242},
    {position = Position(32056, 31890, 5), text = 'Sorcerer Class', effect = 241},
    {position = Position(32064, 31900, 5), text = 'Druid Class', effect = 43},
    {position = Position(32074, 31890, 5), text = 'Paladin Class', effect = 40},
    {position = Position(31526, 32023, 5), text = 'Sanctuary', effect = 252},
    {position = Position(31891, 32024, 9), text = 'Sanctuary', effect = 249},

    {position = Position(32356, 32233, 7), text = 'BOSSES!', effect = 38},
    {position = Position(32356, 32235, 7), text = 'Quests!', effect = 38},
    
}

function textFloat.onThink(interval)
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

textFloat:interval(8000)
textFloat:register()
