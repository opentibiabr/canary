local spikeTasksFork = Action()
function spikeTasksFork.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if isInArray({-1, 7}, player:getStorageValue(SPIKE_UPPER_PACIFIER_MAIN)) then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	if (target == nil) or not target:isItem() or (target:getId() ~= 21558) then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	local sum = player:getStorageValue(SPIKE_UPPER_PACIFIER_MAIN) + 1
	player:setStorageValue(SPIKE_UPPER_PACIFIER_MAIN, sum)

	if sum == 7 then
		item:remove()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Report the task to Gnomilly.")
	end

	target:transform(21563)
	target:decay()
	toPosition:sendMagicEffect(24)
	return true
end

spikeTasksFork:id(21554)
spikeTasksFork:register()