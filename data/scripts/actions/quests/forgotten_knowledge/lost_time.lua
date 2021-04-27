local forgottenKnowledgeLostTime = Action()
function forgottenKnowledgeLostTime.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target:getName():lower() ~= 'time waster' then
		return false
	end
	target:getPosition():sendMagicEffect(CONST_ME_POFF)
	target:remove()
	item:remove()
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The time waster hungrily consumes the time and vanishes.')
	return true
end

forgottenKnowledgeLostTime:id(26397)
forgottenKnowledgeLostTime:register()