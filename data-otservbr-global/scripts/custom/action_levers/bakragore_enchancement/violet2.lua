local violet2 = Action()

function violet2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == 43504 and target:getId() == 43987 then 
        player:setStorageValue(345002, 1)
        target:transform(43988)
        item:remove(1)
    end
end

violet2:id(43504)
violet2:register()
