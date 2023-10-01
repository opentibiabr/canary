local green = Action()

function green.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == 43502 and target:getId() == 43983 then 
        player:setStorageValue(345003, 1)
        target:transform(43984)
        item:remove(1)
    end
end

green:id(43502)
green:register()
