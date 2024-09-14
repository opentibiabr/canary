local range = {
	-- Only the Demon Skeletons killed on this area count
	from = Position(32008, 32522, 8),
	to = Position(32365, 32759, 10),
}

local upperSpikeKill = CreatureEvent("UpperSpikeDeath")
function upperSpikeKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	if not creature:getPosition():isInRange(range.from, range.to) then
		return false
	end

	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if not table.contains({ -1, 7 }, player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Upper_Kill_Main)) then
			local sum = player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Upper_Kill_Main) + 1
			player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Upper_Kill_Main, sum)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have slayed " .. sum .. " out of 7 Demon Skeletons.")
			if sum == 7 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Report the task to Gnomilly.")
			end
		end
	end)
	return true
end

upperSpikeKill:register()
