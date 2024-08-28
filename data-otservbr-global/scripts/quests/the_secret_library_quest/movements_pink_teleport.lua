local pinkTeleport = MoveEvent()

function pinkTeleport.onStepIn(creature, item, toPosition, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.TheSecretLibrary.Peacock) == 2 then
		player:teleportTo(Position(32880, 32828, 11))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

pinkTeleport:aid(26698)
pinkTeleport:register()
