local violet1 = Action()

function violet1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == 43501 and target:getId() == 43987 then 
        player:setStorageValue(345001, 1)
        target:transform(43988)
        item:remove(1)
    end
end

violet1:id(43501)
violet1:register()
