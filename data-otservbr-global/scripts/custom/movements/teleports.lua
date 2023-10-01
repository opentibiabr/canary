local setting = {
	[14515] = Position(31912, 32354, 8),
	[14546] = Position(33802, 32701, 8),
	[14547] = Position(33803, 32702, 7),
	[14548] = Position(33803, 32702, 7),
	[14549] = Position(33805, 32699, 8),
}

local teleportsoul = MoveEvent()

function teleportsoul.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local toPosition = setting[item.actionid]
	if not toPosition then
		return true
	end

	player:teleportTo(toPosition)
	toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
	return true
end

teleportsoul:type("stepin")

for index, value in pairs(setting) do
	teleportsoul:aid(index)
end

teleportsoul:register()
