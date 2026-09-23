local teleport = WorldBehavior("world.player_teleport", 1)

local function transfer(context, player)
	local destination = context:relation("destination"):getPosition()
	if not destination then
		return false
	end
	player:teleportTo(destination)
	player:getPosition():sendMagicEffect(context:parameter("effect"))
	return true
end

function teleport.onStepIn(context, creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return context:parameter("nonPlayerResult")
	end
	return transfer(context, player)
end

function teleport.onUse(context, player, item, fromPosition, target, toPosition, isHotkey)
	return transfer(context, player)
end

teleport:register()
