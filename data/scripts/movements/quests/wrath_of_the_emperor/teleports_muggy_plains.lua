local setting = {
	[12380] = {storageKey = Storage.WrathoftheEmperor.Questline, toPosition = {Position(33138, 31248, 6), Position(33211, 31065, 9)}},
	[12381] = {storageKey = Storage.WrathoftheEmperor.Questline, toPosition = {Position(33211, 31065, 9), Position(33138, 31248, 6)}}
}

local teleportsMuggyPlains = MoveEvent()

function teleportsMuggyPlains.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetTile = config[item.actionid]
	if not targetTile then
		return true
	end

	local hasStorageValue = player:getStorageValue(targetTile.storageKey) >= 5
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(targetTile.toPosition[hasStorageValue and 1 or 2])
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	if not hasStorageValue then
		player:say('This portal is not activated, you need done some missions.', TALKTYPE_MONSTER_SAY)
	end

	return true
end

teleportsMuggyPlains:type("stepin")

for index, value in pairs(setting) do
	teleportsMuggyPlains:aid(index)
end

teleportsMuggyPlains:register()
