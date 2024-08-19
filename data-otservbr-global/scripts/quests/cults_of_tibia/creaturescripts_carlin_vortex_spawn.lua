local vortexCarlin = CreatureEvent("CarlinVortexDeath")
function vortexCarlin.onDeath(creature)
	local corpsePosition = creature:getPosition()
	local rand = math.random(32414, 32415)
	Game.createItem(rand, 1, corpsePosition):setActionId(5580)
	addEvent(function()
		local teleport = Tile(corpsePosition):getItemById(rand)
		if teleport then
			teleport:remove(1)
		end
	end, (1 * 60 * 1000), rand, 1, corpsePosition)
	return true
end

vortexCarlin:register()
