local carts = {
    {clickPos = {x = 33543, y = 32912, z = 15}, destination = Position(33637, 32841, 15)},
    {clickPos = {x = 33637, y = 32840, z = 15}, destination = Position(33543, 32913, 15)},
    {clickPos = {x = 33546, y = 32911, z = 15}, destination = Position(33765, 32909, 15)},
    {clickPos = {x = 33765, y = 32908, z = 15}, destination = Position(33546, 32912, 15)},
    {clickPos = {x = 33549, y = 32912, z = 15}, destination = Position(33563, 32862, 15)},
    {clickPos = {x = 33562, y = 32862, z = 15}, destination = Position(33549, 32913, 15)},
    {clickPos = {x = 33571, y = 32868, z = 15}, destination = Position(33592, 32909, 15)},
    {clickPos = {x = 33591, y = 32909, z = 15}, destination = Position(33571, 32869, 15)},
    {clickPos = {x = 33597, y = 32914, z = 15}, destination = Position(33662, 32976, 15)},
    {clickPos = {x = 33661, y = 32976, z = 15}, destination = Position(33597, 32913, 15)},

}

local gnompronaCarts = Action()
function gnompronaCarts.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    for i = 1, #carts do
        if item:getPosition() == Position(carts[i].clickPos) then
            player:teleportTo(carts[i].destination)
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            return true
        end
    end
end

for j = 1, #carts do
    gnompronaCarts:position(carts[j].clickPos)
end
gnompronaCarts:register()
