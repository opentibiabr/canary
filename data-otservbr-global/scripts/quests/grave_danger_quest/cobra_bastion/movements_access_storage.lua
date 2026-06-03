local cobraAccess = MoveEvent()

function cobraAccess.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U12_20.GraveDanger.CobraBastion.Access) < 1 then
		player:setStorageValue(Storage.Quest.U12_20.GraveDanger.CobraBastion.Access, 1)
	end

	return true
end

cobraAccess:position(Position(33384, 32627, 7))
cobraAccess:type("stepin")
cobraAccess:register()
