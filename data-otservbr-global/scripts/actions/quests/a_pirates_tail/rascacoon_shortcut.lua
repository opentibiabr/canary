local config = {
	{position = {x = 32941, y = 32030, z = 7}, destination = {x = 33774, y = 31347, z = 7}},
	{position = {x = 33774, y = 31348, z = 7}, destination = {x = 32941, y = 32031, z = 7}},
}

local rascacoonShortcut = Action()
function rascacoonShortcut.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getLevel() < 200 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need at least level 200 to enter.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end
	for value in pairs(config) do
		if Position(config[value].position) == item:getPosition() then
			player:teleportTo(Position(config[value].destination))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

for value in pairs(config) do
	rascacoonShortcut:position(config[value].position)
end
rascacoonShortcut:register()
