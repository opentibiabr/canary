local redFire = Action()

function redFire.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == 43503 and target:getId() == 43985 then 
        player:setStorageValue(345000, 1)
        target:transform(43986)
        item:remove(1)
    end
end

redFire:id(43503)
redFire:register()
