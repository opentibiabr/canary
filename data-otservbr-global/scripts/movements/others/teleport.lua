-- Table Path: data/startup/tables/teleport.lua
local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local setting = TeleportUnique[item.uid]
	if setting then
		player:teleportTo(setting.destination)
		player:getPosition():sendMagicEffect(setting.effect)
	end
	return true
end

for uniqueRange = 38001, 40000 do
	teleport:uid(uniqueRange)
end

teleport:register()
