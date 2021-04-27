local realmTeleport = MoveEvent()

function realmTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	--TODO check why has this hasBlessing here
	if player:getStorageValue(Storage.WrathoftheEmperor.Mission10) < 2 or not player:hasBlessing(1) then
		player:teleportTo(fromPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local realm = Position(33028, 31086, 13)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(realm)
	realm:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

realmTeleport:type("stepin")
realmTeleport:aid(8028)
realmTeleport:register()
