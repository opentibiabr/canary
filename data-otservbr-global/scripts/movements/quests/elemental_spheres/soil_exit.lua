local setting = {
	{storage = 10130, toPosition = Position(33264, 31835, 10)}, --EK
	{storage = 10131, toPosition = Position(33272, 31835, 10)}, --RP
	{storage = 10132, toPosition = Position(33268, 31840, 10)}, --ED
	{storage = 10133, toPosition = Position(33268, 31831, 10)} -- SORC
}

local soilExit = MoveEvent()

function soilExit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	for i = 1, #setting do
		local config = setting[i]
		if player:getStorageValue(config.storage) >= 1 then
			player:teleportTo(config.toPosition)
			config.toPosition:sendMagicEffect(CONST_ME_TELEPORT)
			player:setStorageValue(config.storage, 0)
			return true
		end
	end

	player:teleportTo(player:getTown():getTemplePosition())
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

soilExit:type("stepin")
soilExit:aid(24545)
soilExit:register()
