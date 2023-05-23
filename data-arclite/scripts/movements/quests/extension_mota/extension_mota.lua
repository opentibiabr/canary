local destination = {
	[64015] = {toPosition = Position(33246, 32099, 8)}, --Entrance
	[64016] = {toPosition = Position(33246, 32108, 8)} --Exit
}

local extensionMota = MoveEvent()

function extensionMota.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local teleport = destination[item.actionid]
	if not teleport then
		return
	end
	player:teleportTo(teleport.toPosition)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

extensionMota:type("stepin")

for index, value in pairs(destination) do
	extensionMota:aid(index)
end

extensionMota:register()
