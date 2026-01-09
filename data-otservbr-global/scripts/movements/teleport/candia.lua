local config = {
	{ position = { x = 33338, y = 32125, z = 7 }, destination = { x = 33574, y = 32224, z = 7 } }, -- Candia > Feyrist
	{ position = { x = 33339, y = 32125, z = 7 }, destination = { x = 33575, y = 32224, z = 7 } }, -- Candia > Feyrist
	{ position = { x = 33574, y = 32222, z = 7 }, destination = { x = 33338, y = 32127, z = 7 } }, -- Feyrist > Candia
	{ position = { x = 33575, y = 32222, z = 7 }, destination = { x = 33339, y = 32127, z = 7 } }, -- Feyrist > Candia
}

local candia = MoveEvent()
function candia.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	for value in pairs(config) do
		if Position(config[value].position) == player:getPosition() then
			player:teleportTo(Position(config[value].destination))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

candia:type("stepin")
for value in pairs(config) do
	candia:position(config[value].position)
end
candia:register()
