local setting = {
	[23698] = {
		storage = GlobalStorage.InServiceOfYalahar.WarGolemsMachine2,
		destination = Position(32869, 31312, 11)
	},
	[23699] = {
		storage = GlobalStorage.InServiceOfYalahar.WarGolemsMachine1,
		destination = Position(32881, 31312, 11)
	},
	[23702] = {
		destination = Position(32876, 31321, 10)
	},
	[23703] = {
		destination = Position(32875, 31321, 10)
	}
}

local yalaharMachineWarGolems = MoveEvent()

function yalaharMachineWarGolems.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local machine = setting[item.actionid]
	if not machine then
		return true
	end

	if machine.storage and Game.getStorageValue(machine.storage) ~= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The machines are not activated.")
		player:teleportTo(Position(32875, 31321, 10))
		position:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	player:teleportTo(machine.destination)
	position:sendMagicEffect(CONST_ME_ENERGYHIT)
	machine.destination:sendMagicEffect(CONST_ME_ENERGYHIT)
	return true
end

yalaharMachineWarGolems:type("stepin")

for index, value in pairs(setting) do
	yalaharMachineWarGolems:aid(index)
end

yalaharMachineWarGolems:register()
