local setting = {
	{storage = 10017, destination = Position(32360, 31781, 9)},
	{storage = 10018, destination = Position(32369, 32242, 6)},
	{storage = 10019, destination = Position(32958, 32077, 5)},
	{storage = 10020, destination = Position(32681, 31686, 2)},
	{storage = 10021, destination = Position(32646, 31925, 11)},
	{storage = 10022, destination = Position(33230, 32392, 5)},
	{storage = 10023, destination = Position(33130, 32815, 4)},
	{storage = 10024, destination = Position(33266, 31835, 9)},
	{storage = 10025, destination = Position(32337, 32837, 8)},
	{storage = 10026, destination = Position(32628, 32743, 4)},
	{storage = 10027, destination = Position(32213, 31132, 8)},
	{storage = 10028, destination = Position(32786, 31245, 5)},
	{storage = 10029, destination = Position(33594, 31899, 4)}
}

local shrineExit = MoveEvent()

function shrineExit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	for i = 1, #setting do
		local teleport = setting[i]
		if player:getStorageValue(teleport.storage) >= 1 then
			player:teleportTo(teleport.destination)
			teleport.destination:sendMagicEffect(CONST_ME_TELEPORT)
			player:setStorageValue(teleport.storage, 0)
			return true
		end
	end

	player:teleportTo(player:getTown():getTemplePosition())
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

shrineExit:type("stepin")
shrineExit:aid(9117)
shrineExit:register()
