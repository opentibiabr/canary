local stone = {
    {clickPos = {x = 33221, y = 31703, z = 7}, destination = Position(33876, 31886, 8)},
}

local entranceFeasterEdron = Action()
function entranceFeasterEdron.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    for i = 1, #stone do
        if item:getPosition() == Position(stone[i].clickPos) then
            player:teleportTo(stone[i].destination)
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            return true
        end
    end
end

for j = 1, #stone do
    entranceFeasterEdron:position(stone[j].clickPos)
end
entranceFeasterEdron:register()