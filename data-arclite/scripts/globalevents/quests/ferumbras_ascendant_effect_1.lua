local effects = {
    {position = Position(33472, 32383, 13), text = '', effect = 73},
    {position = Position(33469, 32382, 13), text = '', effect = 73},
    {position = Position(33359, 32431, 13), text = '', effect = 73},
    {position = Position(33356, 32433, 13), text = '', effect = 73},
    {position = Position(33614, 32671, 15), text = '', effect = 73},
    {position = Position(33619, 32672, 15), text = '', effect = 73},
    {position = Position(33672, 32748, 13), text = '', effect = 73},
    {position = Position(33678, 32751, 13), text = '', effect = 73},
    {position = Position(33205, 31502, 13), text = '', effect = 73},
    {position = Position(33203, 31506, 13), text = '', effect = 73},
    {position = Position(33426, 32844, 13), text = '', effect = 73},
    {position = Position(33427, 32849, 13), text = '', effect = 73},
    {position = Position(33434, 32841, 13), text = '', effect = 73},
    {position = Position(33453, 32811, 14), text = '', effect = 73},
    {position = Position(33461, 32810, 14), text = '', effect = 73}
}

local ferumbrasEffect1 = GlobalEvent("effect")
function ferumbrasEffect1.onThink(interval)
    for i = 1, #effects do
        local settings = effects[i]
        if settings.effect then
            settings.position:sendMagicEffect(settings.effect)
        end
    end
    return true
end

ferumbrasEffect1:interval(3000)
ferumbrasEffect1:register()
