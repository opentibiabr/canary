local destination = {
	[26667] = {
		position = Position(32273, 31053, 13),
		storage = Storage.ForgottenKnowledge.AccessMachine
	}
}

local iceTeleport = MoveEvent()

function iceTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local teleport = destination[item.actionid]
	if not teleport then
		return
	end

	if player:getStorageValue(teleport.storage) >= 1 then
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(teleport.position)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		local pos = position
		item:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		pos.x = pos.x + 1
		player:teleportTo(pos)
		player:say("You haven't permission to use this teleport.", TALKTYPE_MONSTER_SAY, false, nil, position)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

iceTeleport:type("stepin")
iceTeleport:aid(26667)
iceTeleport:register()
