local destination = {
	[25020] = {position = Position(32320, 31137, 6)},
	[25021] = {position = Position(32359, 32807, 6)}
}

local carvingTeleportLibertyBay = MoveEvent()

function carvingTeleportLibertyBay.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local carvingTP = destination[item.uid]
	if not carvingTP then
		return
	end

	if player:getStorageValue(Storage.ExplorerSociety.TheIceMusic) >= 62
	and player:getStorageValue(Storage.ExplorerSociety.QuestLine) >= 62
	and player:removeItem(5022, 1) then
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(carvingTP.position)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:teleportTo(fromPosition)
	end
	return true
end

carvingTeleportLibertyBay:type("stepin")

for index, value in pairs(destination) do
	carvingTeleportLibertyBay:uid(index)
end

carvingTeleportLibertyBay:register()
