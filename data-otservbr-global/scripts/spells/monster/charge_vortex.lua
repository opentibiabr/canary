local positions = {
	Position(32264, 31253, 14),
	Position(32269, 31258, 14),
	Position(32275, 31255, 14),
	Position(32280, 31253, 14),
	Position(32271, 31248, 14),
	Position(32264, 31245, 14),
	Position(32270, 31240, 14),
	Position(32269, 31253, 14),
	Position(32275, 31245, 14),
	Position(32276, 31250, 14),
	Position(32266, 31249, 14),
}

local function createVortex()
	local tile = Tile(positions[math.random(#positions)])
	if tile then
		local ground = tile:getGround()
		if ground then
			ground:transform(22894)
			addEvent(function(positionInAddEvent)
				local tile = Tile(positionInAddEvent)
				if tile then
					local ground = tile:getGround()
					if ground then
						ground:transform(23049)
					end
				end
			end, 10 * 1000, tile:getPosition()) -- 10 seconds
		end
	end
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	createVortex()
end

spell:name("charge vortex")
spell:words("###451")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
