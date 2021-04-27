local createSugarOat = Action()

function createSugarOat.onUse(cid, item, fromPosition, itemEx, toPosition, isHotkey)
     local player = Player(cid)
     if itemEx.itemid == 2694 then
         if toPosition.x ~= CONTAINER_POSITION then
             Game.createItem(13939, 1, toPosition)
         else
             player:addItem(13939, 1)
             toPosition = player:getPosition()
         end
         toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
         Item(item.uid):remove(1)
         Item(itemEx.uid):remove(1)
     end
     return true
end

createSugarOat:id(5467)
createSugarOat:register()
