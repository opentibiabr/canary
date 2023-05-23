local effects = {
    {position = Position(33463, 32385, 13), text = '', effect = 73},
    {position = Position(33468, 32387, 13), text = '', effect = 73},
    {position = Position(33363, 32435, 13), text = '', effect = 73},
    {position = Position(33354, 32437, 13), text = '', effect = 73},
    {position = Position(33608, 32669, 15), text = '', effect = 73},
    {position = Position(33611, 32676, 15), text = '', effect = 73},
    {position = Position(33675, 32753, 13), text = '', effect = 73},
    {position = Position(33684, 32754, 13), text = '', effect = 73},
    {position = Position(33198, 31506, 13), text = '', effect = 73},
    {position = Position(33211, 31504, 13), text = '', effect = 73},
    {position = Position(33421, 32847, 13), text = '', effect = 73},
    {position = Position(33429, 32845, 13), text = '', effect = 73},
    {position = Position(33458, 32813, 14), text = '', effect = 73},
    {position = Position(33464, 32817, 14), text = '', effect = 73},
}

local ferumbrasEffect2 = GlobalEvent("effcts")
function ferumbrasEffect2.onThink(interval)
    for i = 1, #effects do
        local settings = effects[i]
        if settings.effect then
            settings.position:sendMagicEffect(settings.effect)
        end
    end
    return true
end

ferumbrasEffect2:interval(4000)
ferumbrasEffect2:register()
