hot_lava_pools = { --all range areas of the 9 lava pools
	{Position(32263, 32481, 13), Position(32274, 32490, 13)},
	{Position(32163, 32558, 13), Position(32173, 32567, 13)},
	{Position(32201, 32667, 13), Position(32211, 32672, 13)},
	{Position(32135, 32606, 14), Position(32143, 32614, 14)},
	{Position(32330, 32519, 14), Position(32339, 32521, 14)},
	{Position(32260, 32697, 14), Position(32272, 32705, 14)},
	{Position(32176, 32493, 15), Position(32186, 32502, 15)},
	{Position(32341, 32577, 15), Position(32347, 32586, 15)},
	{Position(32220, 32643, 15), Position(32223, 32652, 15)},
}

if not SPIKE_LOWER_HOTTEST_POOL then
	SPIKE_LOWER_HOTTEST_POOL = math.random(#hot_lava_pools)
end

local spikeTasksThermometer = Action()
function spikeTasksThermometer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local status = player:getStorageValue(SPIKE_LOWER_LAVA_MAIN)

	if isInArray({-1, 1}, status) then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	if player:getPosition():isInRange(hot_lava_pools[SPIKE_LOWER_HOTTEST_POOL][1], hot_lava_pools[SPIKE_LOWER_HOTTEST_POOL][2]) then
		item:remove()
		player:getPosition():sendMagicEffect(16)
		player:setStorageValue(SPIKE_LOWER_LAVA_MAIN, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Whew! That was that hot, it melted the thermometer! At least you've found the hot spot!")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This is not the hot spot!')
	end
	return true
end

spikeTasksThermometer:id(21556)
spikeTasksThermometer:register()