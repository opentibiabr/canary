local config = {
	[34323] = {
		toPosition = Position(33630, 32651, 12),
		backPosition = Position(33630, 32651, 12),
		timer = Storage.FerumbrasAscension.HabitatsTimer
	}
}

local habitatsAccess = MoveEvent()

function habitatsAccess.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local setting = config[item.actionid]
	if not setting then
		return true
	end

	if item.actionid == 34323 then
		if player:getStorageValue(Storage.FerumbrasAscension.HabitatsAccess) >= 1 then
			if player:getStorageValue(setting.timer) < os.time() then
				player:teleportTo(setting.toPosition)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			else
			local pos = position
			pos.y = pos.y + 2
			player:teleportTo(pos)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:say('You have to wait to challenge this enemy again!', TALKTYPE_MONSTER_SAY)
			return true
		end
			else
			local pos = position
			pos.y = pos.y + 2
			player:teleportTo(pos)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You not proven your worth. There is no escape for you here.')
			item:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
	return true
end

habitatsAccess:type("stepin")
habitatsAccess:aid(34323)
habitatsAccess:register()
