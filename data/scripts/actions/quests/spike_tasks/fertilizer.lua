if not FERTILIZED_MUSHROOMS then
	FERTILIZED_MUSHROOMS = {}
end

local spikeTasksFertilizer = Action()
function spikeTasksFertilizer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if isInArray({-1, 4}, player:getStorageValue(SPIKE_MIDDLE_MUSHROOM_MAIN)) then
		return false
	end

	if (target == nil) or not target:isItem() or (target:getId() ~= 21565) then
		return false
	end

	if not FERTILIZED_MUSHROOMS[player:getGuid()] then
		FERTILIZED_MUSHROOMS[player:getGuid()] = {}
	end

	local mushPos = Position(toPosition.x, toPosition.y, toPosition.z)
	if isInArray(FERTILIZED_MUSHROOMS[player:getGuid()], mushPos) then
		return player:sendCancelMessage("You have already fertilised this mushroom.")
	end

	table.insert(FERTILIZED_MUSHROOMS[player:getGuid()], mushPos)
	local sum = player:getStorageValue(SPIKE_MIDDLE_MUSHROOM_MAIN) + 1
	player:setStorageValue(SPIKE_MIDDLE_MUSHROOM_MAIN, sum)

	if sum == 4 then
		item:remove()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Report the task to Gnombold.")
	end
	return toPosition:sendMagicEffect(46)
end

spikeTasksFertilizer:id(21564)
spikeTasksFertilizer:register()