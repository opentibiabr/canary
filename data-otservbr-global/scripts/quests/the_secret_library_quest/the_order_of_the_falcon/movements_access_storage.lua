local falconAccess = MoveEvent()

function falconAccess.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.Access) < 1 then
		player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.Access, 1)
	end

	return true
end

falconAccess:position(Position(33344, 31348, 7))
falconAccess:type("stepin")
falconAccess:register()
