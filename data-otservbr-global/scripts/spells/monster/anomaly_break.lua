local function anomalyBreak(pos)
	local upConer = {x = pos.x - 1, y = pos.y - 1, z = pos.z} -- upLeftCorner
	local downConer = {x = pos.x + 1, y = pos.y + 1, z = pos.z} -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
			for k= upConer.z, downConer.z do
				local room = {x=i, y=j, z=k}
				local tile = Tile(room)
				if tile then
					if tile:getItemById(2130) then
						tile:getItemById(2130):remove()
						Position(room):sendMagicEffect(3)
					elseif tile:getItemById(2129) then
						tile:getItemById(2129):remove()
						Position(room):sendMagicEffect(3)
					end
				end
			end
		end
	end
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local pos = creature:getPosition()
	anomalyBreak(pos)
end

spell:name("anomaly break")
spell:words("###452")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()