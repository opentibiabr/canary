local movements_prohibit_entry = MoveEvent()

function movements_prohibit_entry.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local currentDate = os.date("*t")

	if currentDate.month < 4 or currentDate.month > 5 or (currentDate.month == 5 and currentDate.day > 1) then
		player:teleportTo(Position(32063, 31091, 7))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot pass here outside the period from April 1st to May 1st.")
		return true
	end

	return true
end

movements_prohibit_entry:type("stepin")
movements_prohibit_entry:aid(50000)
movements_prohibit_entry:register()
