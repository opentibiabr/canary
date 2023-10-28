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
		if not table.contains({ -1, 7 }, player:getStorageValue(SPIKE_UPPER_KILL_MAIN)) then
			local sum = player:getStorageValue(SPIKE_UPPER_KILL_MAIN) + 1
			player:setStorageValue(SPIKE_UPPER_KILL_MAIN, sum)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have slayed " .. sum .. " out of 7 Demon Skeletons.")
			if sum == 7 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Report the task to Gnomilly.")
			end
		end
	end)
	return true
end

upperSpikeKill:register()
