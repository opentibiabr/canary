local timeMachine = Action()
function timeMachine.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getPosition() == Position(32870, 32723, 15) then
		player:teleportTo(Position(32870, 32724, 14))
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The mechanism takes you back in time.")
		return true
	elseif player:getPosition() == Position(32870, 32723, 14) then
		if player:canFightBoss("The Time Guardian") then
			player:teleportTo(Position(32870, 32724, 15))
			player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The mechanism takes you back in time.")
			return true
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait a while before travel in time!")
			return true
		end
	end

	if player:getPosition() == Position(33453, 31029, 8) then
		player:teleportTo(Position(32430, 32167, 8))
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The mechanism takes you back in time.")
		return true
	elseif player:getPosition() == Position(32430, 32166, 8) then
		player:teleportTo(Position(33453, 31030, 8))
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The mechanism takes you back in time.")
		return true
	end

	return false
end

timeMachine:id(25096)
timeMachine:register()
