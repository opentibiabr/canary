local above = {[32021] = 5062}
local outside = {[5062] = 32021}

-- onStepIn
local gaffirwall = MoveEvent()

function gaffirwall.onStepIn(creature, item, position, fromPosition)
	if not above[item.itemid] then
		return true
	end

	local player = creature:getPlayer()
	if not player or player:isInGhostMode() then
		return true
	end
	item:transform(above[item.itemid])
end

gaffirwall:type("stepin")

for index, value in pairs(above) do
	gaffirwall:id(index)
end
gaffirwall:register()

gaffirwall = MoveEvent()

function gaffirwall.onStepOut(creature, item, position, fromPosition)
	if not outside[item.itemid] then
		return false
	end

	local player = creature:getPlayer()
	if not player or player:isInGhostMode() then
		return true
	end

	item:transform(outside[item.itemid])
	player:setSpecialContainersAvailable(false, false)
	return true
end

gaffirwall:type("stepout")
for index, value in pairs(outside) do
	gaffirwall:id(index)
end
gaffirwall:register()
