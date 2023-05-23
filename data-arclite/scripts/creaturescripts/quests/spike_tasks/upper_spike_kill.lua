local range = {
	-- Only the Demon Skeletons killed on this area count
	from = Position(32008, 32522, 8),
	to = Position(32365, 32759, 10)
}

local upperSpikeKill = CreatureEvent("UpperSpikeKill")
function upperSpikeKill.onKill(creature, target)
	if not isInArray({-1, 7}, creature:getStorageValue(SPIKE_UPPER_KILL_MAIN)) then
		if creature:getPosition():isInRange(range.from, range.to) then
			if target:isMonster() and (target:getMaster() == nil) and (target:getName():lower() == "demon skeleton") then
				local sum = creature:getStorageValue(SPIKE_UPPER_KILL_MAIN) + 1
				creature:setStorageValue(SPIKE_UPPER_KILL_MAIN, sum)
				creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have slayed " .. sum .. " out of 7 Demon Skeletons.")
				if sum == 7 then
					creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Report the task to Gnomilly.")
				end
			end
		end
	end
end

upperSpikeKill:register()
