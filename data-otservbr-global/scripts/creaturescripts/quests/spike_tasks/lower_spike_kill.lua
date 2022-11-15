local range = {
	-- Only the Drillworms killed on this area count
	from = Position(32120, 32470, 13),
	to = Position(32345, 32710, 15)
}

local lowerSpikeKill = CreatureEvent("LowerSpikeKill")
function lowerSpikeKill.onKill(creature, target)
	if not isInArray({-1, 7}, creature:getStorageValue(SPIKE_LOWER_KILL_MAIN)) then
		if creature:getPosition():isInRange(range.from, range.to) then
			if target:isMonster() and (target:getMaster() == nil) and (target:getName():lower() == "drillworm") then
				local sum = creature:getStorageValue(SPIKE_LOWER_KILL_MAIN) + 1
				creature:setStorageValue(SPIKE_LOWER_KILL_MAIN, sum)
				creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have slayed " .. sum .. " out of 7 Drillworms.")
				if sum == 7 then
					creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Report the task to Gnomargery.")
				end
			end
		end
	end
end

lowerSpikeKill:register()
