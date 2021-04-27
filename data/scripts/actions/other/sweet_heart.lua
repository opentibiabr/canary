local sweetHeart = Action()

function sweetHeart.onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if (not player) then
        return false
    end

    if (player:getSlotItem(CONST_SLOT_RING)) then
        if (player:getSlotItem(CONST_SLOT_RING):getId() == item:getId()) then
            player:getPosition():sendMagicEffect(CONST_ME_HEARTS)
        end
    else
        return false
    end
    return true
end

sweetHeart:id(24324)
sweetHeart:register()
