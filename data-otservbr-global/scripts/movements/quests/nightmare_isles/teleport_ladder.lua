local setting = {
	[64103] = Position(33475, 32641, 10),
	[64104] = Position(33473, 32647, 9),
	[64105] = Position(33463, 32585, 8),
	[64106] = Position(33457, 32580, 8),
	[64107] = Position(33422, 32582, 8),
	[64108] = Position(33430, 32600, 10),
	[64109] = Position(33420, 32604, 10),
	[64120] = Position(33446, 32616, 11),
	[64121] = Position(33460, 32632, 10),
	[64122] = Position(33429, 32626, 10),
	[64123] = Position(33425, 32633, 8),
	[64124] = Position(33435, 32631, 8),
	[64125] = Position(33478, 32621, 10),
	[64126] = Position(33484, 32629, 8),
	[64127] = Position(33452, 32617, 11),
	[64128] = Position(33419, 32589, 10)
}

local teleportLadder = MoveEvent()

function teleportLadder.onStepIn(creature, item, position, fromPosition)
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

	local targetPosition = setting[item.actionid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	targetPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

teleportLadder:type("stepin")

for index, value in pairs(setting) do
	teleportLadder:aid(index)
end

teleportLadder:register()
