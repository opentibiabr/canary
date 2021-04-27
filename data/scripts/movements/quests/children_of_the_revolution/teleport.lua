local config = {
	[3167] = {
		storage = Storage.ChildrenoftheRevolution.Questline,
		teleportToPosition = {Position(33257, 31116, 8), Position(33356, 31126, 7)}},
	[3168] = {
		storage = Storage.ChildrenoftheRevolution.Questline,
		teleportToPosition = {Position(33356, 31125, 7), Position(33356, 31125, 7)}}
}

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetTile = config[item.uid]
	if not targetTile then
		return true
	end

	local hasStorageValue = player:getStorageValue(targetTile.storage) >= 19
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(targetTile.teleportToPosition[hasStorageValue and 1 or 2])
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

teleport:type("stepin")

for index, value in pairs(config) do
	teleport:uid(index)
end

teleport:register()
