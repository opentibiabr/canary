local range = {
	-- Only the Drillworms killed on this area count
	from = Position(32120, 32470, 13),
	to = Position(32345, 32710, 15),
}

local lowerSpikeKill = CreatureEvent("LowerSpikeDeath")
function lowerSpikeKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	if not creature:getPosition():isInRange(range.from, range.to) then
		return true
	end

	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if not table.contains({ -1, 7 }, player:getStorageValue(SPIKE_LOWER_KILL_MAIN)) then
			local sum = player:getStorageValue(SPIKE_LOWER_KILL_MAIN) + 1
			player:setStorageValue(SPIKE_LOWER_KILL_MAIN, sum)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have slayed " .. sum .. " out of 7 Drillworms.")
			if sum == 7 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Report the task to Gnomargery.")
			end
		end
	end)
	return true
end

lowerSpikeKill:register()
