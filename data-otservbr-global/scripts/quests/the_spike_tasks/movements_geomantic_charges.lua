local condition = Condition(CONDITION_OUTFIT)
condition:setParameter(CONDITION_PARAM_TICKS, 120000)
condition:setOutfit(0, 307, 0, 0, 0, 0)

local geomanticCharges = MoveEvent()

function geomanticCharges.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local tasksLoaded = {}
	if not table.contains({ -1, 8 }, player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Middle_Nest_Main)) then
		tasksLoaded["NEST"] = true
	end
	if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Middle_Charge_Main) == 1 then
		tasksLoaded["CHARGE"] = true
	end

	if not tasksLoaded["NEST"] and not tasksLoaded["CHARGE"] then
		player:teleportTo(fromPosition, true)
		return true
	end

	if tasksLoaded["NEST"] then
		if player:getCondition(CONDITION_OUTFIT) or (player:getOutfit().lookType == 307) then
			player:teleportTo(fromPosition, true)
			return true
		end
		player:addCondition(condition)
		player:getPosition():sendMagicEffect(11)
	end

	if tasksLoaded["CHARGE"] then
		player:getPosition():sendMagicEffect(12)
		player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Middle_Charge_Main, 2)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have charged your body with geomantic energy and can report about it.")
	end
	return true
end

geomanticCharges:type("stepin")
geomanticCharges:aid(56421)
geomanticCharges:register()
