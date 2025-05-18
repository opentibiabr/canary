local config = {
	[1] = { storage = Storage.Quest.U10_90.FerumbrasAscension.Razzagorn },
	[2] = { storage = Storage.Quest.U10_90.FerumbrasAscension.Ragiaz },
	[3] = { storage = Storage.Quest.U10_90.FerumbrasAscension.Zamulosh },
	[4] = { storage = Storage.Quest.U10_90.FerumbrasAscension.Mazoran },
	[5] = { storage = Storage.Quest.U10_90.FerumbrasAscension.Tarbaz },
	[6] = { storage = Storage.Quest.U10_90.FerumbrasAscension.Shulgrax },
	[7] = { storage = Storage.Quest.U10_90.FerumbrasAscension.Plagirath },
}

local stair = MoveEvent()

function stair.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if item:getId() == 22157 then
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
	elseif item:getId() == 22156 then
		player:teleportTo(Position(33271, 32394, 7))
		player:setDirection(NORTH)
	end
	return true
end

stair:type("stepin")
stair:id(22156, 22157)
stair:register()
