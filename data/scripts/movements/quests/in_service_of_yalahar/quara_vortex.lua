local quaraVortex = MoveEvent()

function quaraVortex.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local headItem = player:getSlotItem(CONST_SLOT_HEAD)
	if headItem and table.contains({5461, 12541, 15408}, headItem.itemid) then
		player:teleportTo(Position(32950, 31181, 9))
		player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
		player:say("The vortex throws you out in this vicious place.", TALKTYPE_MONSTER_SAY)
	else
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must wear an underwater exploration helmet in order to dive.")
	end
	return true
end

quaraVortex:type("stepin")
quaraVortex:aid(7812)
quaraVortex:register()
