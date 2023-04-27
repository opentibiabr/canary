local positions = {
	{slabPos = {x = 33484, y = 31435, z = 8}, tpPos = {x = 33483, y = 31452, z = 9}},
	{slabPos = {x = 33481, y = 31452, z = 9}, tpPos = {x = 33486, y = 31435, z = 8}},
	
	{slabPos = {x = 33558, y = 31467, z = 9}, tpPos = {x = 33573, y = 31467, z = 9}},
	{slabPos = {x = 33570, y = 31467, z = 9}, tpPos = {x = 33555, y = 31467, z = 9}},
	
	{slabPos = {x = 33549, y = 31440, z = 9}, tpPos = {x = 33537, y = 31440, z = 9}},
	{slabPos = {x = 33539, y = 31440, z = 9}, tpPos = {x = 33550, y = 31439, z = 9}},
	
	{slabPos = {x = 33540, y = 31411, z = 9}, tpPos = {x = 33528, y = 31410, z = 9}},
	{slabPos = {x = 33531, y = 31410, z = 9}, tpPos = {x = 33541, y = 31412, z = 9}},
	
	{slabPos = {x = 33535, y = 31444, z = 8}, tpPos = {x = 33546, y = 31444, z = 8}},
	{slabPos = {x = 33544, y = 31444, z = 8}, tpPos = {x = 33533, y = 31444, z = 8}},
	
	{slabPos = {x = 33572, y = 31459, z = 8}, tpPos = {x = 33572, y = 31461, z = 8}},
	{slabPos = {x = 31904, y = 32346, z = 9}, tpPos = {x = 31904, y = 32348, z = 9}},
}

local slab = MoveEvent()

function slab.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	local newPos
	for _, info in pairs(positions) do
		if Position(info.slabPos) == position then
			newPos = Position(info.tpPos)
			break
		end
	end
	if newPos then
		player:teleportTo(newPos)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		newPos:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

slab:type("stepin")

slab:id(32627)

slab:register()
