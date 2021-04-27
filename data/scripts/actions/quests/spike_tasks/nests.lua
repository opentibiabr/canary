local summon = {"Spider", "Larva", "Scarab", "Tarantula"}

local spikeTasksNests = Action()
function spikeTasksNests.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if isInArray({-1, 8}, player:getStorageValue(SPIKE_MIDDLE_NEST_MAIN)) then
		return false
	end

	if player:getOutfit().lookType ~= 307 then
		return false
	end

	local sum = player:getStorageValue(SPIKE_MIDDLE_NEST_MAIN) + 1
	player:setStorageValue(SPIKE_MIDDLE_NEST_MAIN, sum)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have destroyed a monster nest.")

	if sum == 8 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Report the task to Gnombold.")
	end

	if math.random(100) > 60 then
		Game.createMonster(summon[math.random(#summon)], player:getPosition())
	end

	item:transform(21560)
	item:decay()
	toPosition:sendMagicEffect(17)
	return true
end

spikeTasksNests:id(21559)
spikeTasksNests:register()