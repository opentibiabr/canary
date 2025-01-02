local spikeTasksFork = Action()
function spikeTasksFork.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains({ -1, 7 }, player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Upper_Pacifier_Main)) then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	if not target or type(target) ~= "userdata" or not target:isItem() or (target:getId() ~= 19208) then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	local sum = player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Upper_Pacifier_Main) + 1
	player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Upper_Pacifier_Main, sum)

	if sum == 7 then
		item:remove()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Report the task to Gnomilly.")
	end

	target:transform(19213)
	target:decay()
	toPosition:sendMagicEffect(24)
	return true
end

spikeTasksFork:id(19204)
spikeTasksFork:register()
