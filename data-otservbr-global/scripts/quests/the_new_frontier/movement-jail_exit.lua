local destination = Position(33145, 31247, 6)
local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local jailExit = MoveEvent()

function jailExit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(TheNewFrontier.Mission08) >= 1 then
		player:teleportTo(destination)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	player:teleportTo(fromPosition)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this area.")
	return false
end

jailExit:position({x = 33163, y = 31227, z= 11})
jailExit:register()
