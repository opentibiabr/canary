

local wormTunnel = MoveEvent()

function wormTunnel.onStepIn(creature, item, position, fromPosition)
	if creature:isPlayer() == false then
		return true
	end
	creature:setStorageValue(Storage.Quest.FeasterOfSouls.Bosses.ThePaleWorm.WeakSpot, 0)
	creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You dive deep into the ground! Right into the deadly miasma. Be quick! Don't stay too long!")
	local newPos = position
	newPos.z = newPos.z + 1
	creature:teleportTo(newPos)
	return true
end

wormTunnel:type("stepin")
wormTunnel:id(32590)

wormTunnel:register()