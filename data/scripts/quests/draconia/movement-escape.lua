local escape = MoveEvent()

function escape.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local sacrificeItem = Tile({x = 32816, y = 31601, z = 9}):getItemById(2319)
	if not sacrificeItem then
		player:teleportTo({x = 32818, y = 31599, z = 9})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	if player:getStorageValue(Storage.Dragonfetish) == 1 then
		player:setStorageValue(Storage.Dragonfetish, 0)
	end
	player:teleportTo({x = 32701, y = 31639, z = 6})
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	sacrificeItem:remove()
	return true
end

escape:uid(35012)
escape:register()
