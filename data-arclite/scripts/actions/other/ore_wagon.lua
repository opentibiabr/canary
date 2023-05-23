local config = {
	[1042]  = {destination = Position(32527, 31842, 9)},
	[1043]  = {destination = Position(32559, 31852, 7)},
	[1044]  = {destination = Position(32498, 31828, 9)},
	[1045]  = {destination = Position(32517, 31806, 9)},
	[1046]  = {destination = Position(32517, 31830, 9)},
	[1047]  = {destination = Position(32490, 31810, 9)},
	[1048]  = {destination = Position(32494, 31831, 9)},
	[1049]  = {destination = Position(32514, 31805, 9)},
	[1050]  = {destination = Position(32497, 31805, 9)},
	[1051]  = {destination = Position(32518, 31827, 9)}
}

local oreWagon = Action()

function oreWagon.onUse(player, item, position, fromPosition)
	local teleport = config[item.uid]
	if not teleport then
		return true
	end

	player:teleportTo(teleport.destination)
	teleport.destination:sendMagicEffect(10)
	return true
end

for index, value in pairs(config) do
	oreWagon:uid(index)
end

oreWagon:register()
