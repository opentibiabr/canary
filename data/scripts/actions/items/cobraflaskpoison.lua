local poisonFlask = Action()

function poisonFlask.onUse(cid, item, fromPosition, itemEx, toPosition, isHotkey)
	local player = Player(cid)
	if itemEx.itemid == 4188 then
		if toPosition.x ~= CONTAINER_POSITION then
			Game.createItem(31296, 1, toPosition)
		else
			player:addItem(31296, 1)
			toPosition = player:getPosition()
		end
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		Item(item.uid):remove(1)
		Item(itemEx.uid):remove(1)
	end
	return true
end

poisonFlask:id(31297)
poisonFlask:register()