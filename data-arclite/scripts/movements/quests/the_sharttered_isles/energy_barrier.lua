local energyWall = {
	{x = 32091, y = 32575, z = 8},
	{x = 32091, y = 32576, z = 8},
	{x = 32091, y = 32577, z = 8}
}
local energyBarrier = MoveEvent()

function energyBarrier.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if player:getStorageValue(Storage.TheShatteredIsles.TheCounterspell) ~= 4 then
		position:sendMagicEffect(CONST_ME_ENERGYHIT)
		position.x = position.x + 2
		player:teleportTo(position)
		return true
	end
	return true
end

for a = 1, #energyWall do
	energyBarrier:position(energyWall[a])
end
energyBarrier:register()
