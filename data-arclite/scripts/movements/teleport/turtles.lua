local setting = {
	[3206] = Position(32359, 32901, 7),
	[3207] = Position(32340, 32538, 7),
	[3208] = Position(32472, 32869, 7),
	[3209] = Position(32415, 32916, 7),
	[3210] = Position(32490, 32979, 7),
	[3211] = Position(32440, 32971, 7),
	[3212] = Position(32527, 32951, 7),
	[3213] = Position(32523, 32923, 7)
}

local turtles = MoveEvent()

function turtles.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.TheShatteredIsles.AccessToLagunaIsland) ~= 1 and item.uid == 3206 then
		local accessPosition = Position(32340, 32540, 7)
		player:teleportTo(accessPosition)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		accessPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local toPosition = setting[item.uid]
	if not toPosition then
		return true
	end

	player:teleportTo(toPosition)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

turtles:type("stepin")

for index, value in pairs(setting) do
	turtles:uid(index)
end

turtles:register()
