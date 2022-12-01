local config = {
	[1] = {storage = Storage.FerumbrasAscension.Razzagorn},
	[2] = {storage = Storage.FerumbrasAscension.Ragiaz},
	[3] = {storage = Storage.FerumbrasAscension.Zamulosh},
	[4] = {storage = Storage.FerumbrasAscension.Mazoran},
	[5] = {storage = Storage.FerumbrasAscension.Tarbaz},
	[6] = {storage = Storage.FerumbrasAscension.Shulgrax},
	[7] = {storage = Storage.FerumbrasAscension.Plagirath}
}

local entrance = MoveEvent()

function entrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local complete = false
	for i = 1, #config do
		local storage = config[i].storage
		if player:getStorageValue(storage) ~= 1 then
			complete = false
		else
			complete = true
		end
	end
	if item:getActionId() == 24837 then
		if complete then
			player:teleportTo(Position(33275, 32390, 9))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		else
			player:teleportTo(Position(33275, 32390, 8))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	elseif item:getActionId() == 24838 then
		if player:getStorageValue(Storage.FerumbrasAscension.Access) < 1 then
			player:teleportTo(Position(33275, 32390, 8))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"This portal is not yet strong enough to breach the destination dimension.")
			return true
		end
		player:teleportTo(Position(33319, 32317, 13))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	return true
end

entrance:type("stepin")
entrance:aid(24837, 24838)
entrance:register()
