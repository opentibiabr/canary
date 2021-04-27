local chance = {
	{90, "You unearthed a spirit\'s anger!!!", "Enraged Soul"},
	{80, "Your crude digging has angered some ancient ghost.", "Ghost"},
	{70, "You unearthed some not-so-death creature.", "Demon Skeleton"},
	{50, "You unearthed some not-so-death creature.", "Zombie"},
	{1, "You've found nothing special."}
}

local spikeTasksShovel = Action()
function spikeTasksShovel.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if isInArray({-1, 4}, player:getStorageValue(SPIKE_UPPER_MOUND_MAIN)) then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	if (target == nil) or not target:isItem() or (target:getId() ~= 21561) then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	target:transform(21562)
	target:decay()
	local luck = math.random(100)
	for i, result in ipairs(chance) do
		if luck >= result[1] then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, result[2])
			if result[3] then
				Game.createMonster(result[3], toPosition)
			end
			if i == 1 then
				local sum = player:getStorageValue(SPIKE_UPPER_MOUND_MAIN) + 1
				player:setStorageValue(SPIKE_UPPER_MOUND_MAIN, sum)
				if sum == 4 then
					item:remove()
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Report the task to Gnomilly.")
				end
			end
			break
		end
	end
	return toPosition:sendMagicEffect(35)
end

spikeTasksShovel:id(21553)
spikeTasksShovel:register()