local range = {
	-- Only the Crystalcrushers killed on this area count
	from = Position(32100, 32470, 11),
	to = Position(32380, 32725, 12),
}

local middleSpikeKill = CreatureEvent("MiddleSpikeDeath")
function middleSpikeKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	if not creature:getPosition():isInRange(range.from, range.to) then
		return true
	end
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if not table.contains({ -1, 7 }, player:getStorageValue(SPIKE_MIDDLE_KILL_MAIN)) then
			local sum = player:getStorageValue(SPIKE_MIDDLE_KILL_MAIN) + 1
			player:setStorageValue(SPIKE_MIDDLE_KILL_MAIN, sum)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have slayed " .. sum .. " out of 7 Crystalcrushers.")
			if sum == 7 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Report the task to Gnombold.")
			end
		end
	end)
	return true
end

middleSpikeKill:register()
