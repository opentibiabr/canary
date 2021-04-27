local sandEntrance = MoveEvent()

function sandEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if (player:getStorageValue(Storage.CultsOfTibia.Life.Mission) < 1 and
	player:getStorageValue(Storage.CultsOfTibia.MotA.Mission)) < 1 then
	player:teleportTo(fromPosition, true)
	player:sendCancelMessage("You can't go there yet.")
	end
	return true
end

sandEntrance:type("stepin")
sandEntrance:aid(4999)
sandEntrance:register()
