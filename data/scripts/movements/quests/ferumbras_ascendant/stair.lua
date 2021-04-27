local config = {
	[1] = {storage = Storage.FerumbrasAscension.Razzagorn},
	[2] = {storage = Storage.FerumbrasAscension.Ragiaz},
	[3] = {storage = Storage.FerumbrasAscension.Zamulosh},
	[4] = {storage = Storage.FerumbrasAscension.Mazoran},
	[5] = {storage = Storage.FerumbrasAscension.Tarbaz},
	[6] = {storage = Storage.FerumbrasAscension.Shulgrax},
	[7] = {storage = Storage.FerumbrasAscension.Plagirath}
}

local stair = MoveEvent()

function stair.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if item:getId() == 24813 then
		local complete = false
		for i = 1, #config do
			local storage = config[i].storage
			if player:getStorageValue(storage) ~= 1 then
				complete = false
			else
				complete = true
			end
		end
		if complete then
			player:teleportTo(Position(33271, 32396, 9))
		else
			player:teleportTo(Position(33271, 32396, 8))
		end
		player:setDirection(SOUTH)
	elseif item:getId() == 24812 then
		player:teleportTo(Position(33271, 32394, 7))
		player:setDirection(NORTH)
	end
	return true
end

stair:type("stepin")
stair:id(24812, 24813)
stair:register()
