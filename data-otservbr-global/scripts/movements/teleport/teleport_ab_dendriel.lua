local setting = {
	[9700] = Position(32667, 31681, 6),
	[9701] = Position(32726, 31666, 6),
	[9702] = Position(32674, 31617, 6),
	[9703] = Position(32664, 31679, 6),
	[9704] = Position(32658, 31688, 8),
	[9705] = Position(32655, 31688, 6)
}

local teleportAbDendriel = MoveEvent()

function teleportAbDendriel.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local toPosition = setting[item.actionid]
	if not toPosition then
		return true
	end

	player:teleportTo(toPosition)
	toPosition:sendMagicEffect(CONST_ME_POFF)
	return true
end

teleportAbDendriel:type("stepin")

for index, value in pairs(setting) do
	teleportAbDendriel:aid(index)
end

teleportAbDendriel:register()
