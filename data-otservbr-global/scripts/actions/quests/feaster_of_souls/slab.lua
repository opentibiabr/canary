local config = {
	{position = {x = 33484, y = 31435, z = 8}, destination = {x = 33483, y = 31452, z = 9}},
	{position = {x = 33481, y = 31452, z = 9}, destination = {x = 33486, y = 31435, z = 8}},
	{position = {x = 33558, y = 31467, z = 9}, destination = {x = 33573, y = 31467, z = 9}},
	{position = {x = 33570, y = 31467, z = 9}, destination = {x = 33555, y = 31467, z = 9}},
	{position = {x = 33549, y = 31440, z = 9}, destination = {x = 33537, y = 31440, z = 9}},
	{position = {x = 33539, y = 31440, z = 9}, destination = {x = 33550, y = 31439, z = 9}},
	{position = {x = 33540, y = 31411, z = 9}, destination = {x = 33528, y = 31410, z = 9}},
	{position = {x = 33531, y = 31410, z = 9}, destination = {x = 33541, y = 31412, z = 9}},
	{position = {x = 33535, y = 31444, z = 8}, destination = {x = 33546, y = 31444, z = 8}},
	{position = {x = 33544, y = 31444, z = 8}, destination = {x = 33533, y = 31444, z = 8}}
}

local slab = MoveEvent()
function slab.onStepIn(creature, item, position, fromPosition)
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

slab:type("stepin")
for value in pairs(config) do
	slab:position(config[value].position)
end
slab:register()